use crate::frb_generated::{RustAutoOpaque, RustOpaque};
use aes_gcm::{
    aead::{Aead, AeadCore, KeyInit, OsRng},
    Aes256Gcm, Key,
};
use anyhow::{anyhow, Result};
use flutter_rust_bridge::frb;
pub use frost_core;
use frost_core::Group;
pub use frost_secp256k1_tr as frost;
pub use frost_secp256k1_tr::keys::dkg;
use frost_secp256k1_tr::keys::Tweak;
use rand::thread_rng;
use std::collections::BTreeMap;
use zeroize::{Zeroize, Zeroizing};

// Common

fn from_bytes<T: Sized, DFunc, SFunc>(
    bytes: Vec<u8>,
    deserialize: DFunc,
    serialize: SFunc,
    obj_name: &str,
) -> Result<T>
where
    DFunc: FnOnce(&[u8]) -> Result<T, frost::Error>,
    SFunc: FnOnce(&T) -> Result<Vec<u8>, frost::Error>,
{
    // Importing a secret also creates temporary plaintext buffers in Rust.
    let bytes = Zeroizing::new(bytes);
    let obj = deserialize(&bytes).map_err(|_| anyhow!("Could not deserialize {}", obj_name))?;
    let expected_bytes =
        Zeroizing::new(serialize(&obj).map_err(|_| anyhow!("Could not serialize {}", obj_name))?);

    if bytes.as_slice() != expected_bytes.as_slice() {
        return Err(anyhow!(
            "{} bytes do not serialise into the same bytes",
            obj_name
        ));
    }

    Ok(obj)
}

fn vec_to_array<const N: usize, T>(vec: Vec<T>, name: &str) -> Result<[T; N]> {
    <[T; N]>::try_from(vec).map_err(|_| anyhow!("{} should have {} bytes", name, N))
}

fn vector_to_signing_share(vec: Vec<u8>) -> Result<frost::keys::SigningShare> {
    frost::keys::SigningShare::deserialize(vec.as_slice())
        .map_err(|_| anyhow!("Could not deserialize private share"))
}

fn construct_signing_package(
    nonce_commitments: Vec<IdentifierAndSigningCommitment>,
    message: Vec<u8>,
) -> frost::SigningPackage {
    frost::SigningPackage::new(
        nonce_commitments
            .into_iter()
            .map(|v| {
                (
                    v.identifier.blocking_read().0.clone(),
                    (*v.commitment).clone(),
                )
            })
            .collect(),
        &message,
    )
}

fn vector_to_group_key(vec: Vec<u8>) -> Result<frost::VerifyingKey> {
    frost::VerifyingKey::deserialize(vec.as_slice())
        .map_err(|_| anyhow!("Could not deserialize group key"))
}

fn vector_to_verifying_share(vec: Vec<u8>) -> Result<frost::keys::VerifyingShare> {
    frost::keys::VerifyingShare::deserialize(vec.as_slice())
        .map_err(|_| anyhow!("Could not deserialize verifying share"))
}

// Participant identifiers

#[frb(opaque)]
#[derive(Clone, Copy)]
pub struct IdentifierOpaque(frost::Identifier);
type IdentifierResult = Result<IdentifierOpaque>;

#[frb(sync)]
pub fn identifier_from_string(s: String) -> IdentifierResult {
    Ok(IdentifierOpaque(frost::Identifier::derive(s.as_bytes())?))
}

#[frb(sync)]
pub fn identifier_from_u16(i: u16) -> IdentifierResult {
    Ok(IdentifierOpaque(frost::Identifier::try_from(i)?))
}

#[frb(sync)]
pub fn identifier_from_bytes(bytes: Vec<u8>) -> IdentifierResult {
    let array = vec_to_array::<32, u8>(bytes, "Identifier")?;
    Ok(IdentifierOpaque(frost::Identifier::deserialize(&array)?))
}

#[frb(sync)]
pub fn identifier_to_bytes(identifier: &IdentifierOpaque) -> Vec<u8> {
    identifier.0.serialize().to_vec()
}

// DKG Part 1
// Generates a secret part and a public part. The public part is to be shared with
// all participants.

#[frb(opaque)]
#[derive(Clone)]
pub struct DkgPublicCommitmentOpaque(dkg::round1::Package);
#[frb(opaque)]
pub struct DkgRound1SecretOpaque(dkg::round1::SecretPackage);

impl Drop for DkgRound1SecretOpaque {
    fn drop(&mut self) {
        self.0.zeroize();
    }
}

fn validate_dkg_parameters(
    commitment: &frost::keys::VerifiableSecretSharingCommitment,
    min_signers: u16,
    max_signers: u16,
) -> Result<()> {
    if min_signers < 2 || max_signers < min_signers {
        return Err(anyhow!("Invalid DKG signer counts"));
    }
    if commitment.coefficients().len() != usize::from(min_signers) {
        return Err(anyhow!("DKG commitment count does not match threshold"));
    }
    Ok(())
}

type DkgRound1Data = (DkgRound1SecretOpaque, DkgPublicCommitmentOpaque);
type DkgPart1Result = Result<DkgRound1Data>;

#[frb(sync)]
pub fn dkg_part_1(
    identifier: &IdentifierOpaque,
    max_signers: u16,
    min_signers: u16,
) -> DkgPart1Result {
    let mut rng = thread_rng();

    Ok(
        dkg::part1(identifier.0.clone(), max_signers, min_signers, &mut rng).map(|result| {
            (
                DkgRound1SecretOpaque(result.0),
                DkgPublicCommitmentOpaque(result.1),
            )
        })?,
    )
}

#[frb(sync)]
pub fn dkg_round_1_secret_from_bytes(bytes: Vec<u8>) -> Result<DkgRound1SecretOpaque> {
    let secret = from_bytes(
        bytes,
        |bytes| dkg::round1::SecretPackage::deserialize(bytes).map(DkgRound1SecretOpaque),
        |secret| secret.0.serialize(),
        "Round-one DKG secret",
    )?;
    validate_dkg_parameters(
        secret.0.commitment(),
        *secret.0.min_signers(),
        *secret.0.max_signers(),
    )?;
    let coefficients = Zeroizing::new(secret.0.coefficients());
    let commitments = secret.0.commitment().coefficients();
    if coefficients.len() != commitments.len() {
        return Err(anyhow!("DKG coefficient count does not match threshold"));
    }
    for (coefficient, commitment) in coefficients.iter().zip(commitments) {
        if frost::Secp256K1Group::generator() * coefficient != commitment.value() {
            return Err(anyhow!("DKG coefficient does not match its commitment"));
        }
    }
    Ok(secret)
}

#[frb(sync)]
pub fn dkg_round_1_secret_to_bytes(secret: &DkgRound1SecretOpaque) -> Result<Vec<u8>> {
    Ok(secret.0.serialize()?)
}

#[frb(sync)]
pub fn public_commitment_from_bytes(bytes: Vec<u8>) -> Result<DkgPublicCommitmentOpaque> {
    Ok(DkgPublicCommitmentOpaque(from_bytes(
        bytes,
        |b| dkg::round1::Package::deserialize(&b),
        |obj| obj.serialize(),
        "Public commitment",
    )?))
}

#[frb(sync)]
pub fn public_commitment_to_bytes(commitment: &DkgPublicCommitmentOpaque) -> Result<Vec<u8>> {
    Ok(commitment.0.serialize()?)
}

// DKG Part 2

#[frb(non_opaque)]
pub struct DkgCommitmentForIdentifier {
    pub identifier: RustAutoOpaque<IdentifierOpaque>,
    pub commitment: RustAutoOpaque<DkgPublicCommitmentOpaque>,
}

impl DkgCommitmentForIdentifier {
    #[frb(sync)]
    pub fn from_refs(
        identifier: &IdentifierOpaque,
        commitment: &DkgPublicCommitmentOpaque,
    ) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            commitment: RustAutoOpaque::new(commitment.clone()),
        }
    }
}

#[frb(opaque)]
pub struct DkgRound2SecretOpaque(dkg::round2::SecretPackage);

impl Drop for DkgRound2SecretOpaque {
    fn drop(&mut self) {
        self.0.zeroize();
    }
}

#[frb(sync)]
pub fn dkg_round_2_secret_from_bytes(bytes: Vec<u8>) -> Result<DkgRound2SecretOpaque> {
    let secret = from_bytes(
        bytes,
        |bytes| dkg::round2::SecretPackage::deserialize(bytes).map(DkgRound2SecretOpaque),
        |secret| secret.0.serialize(),
        "Round-two DKG secret",
    )?;
    validate_dkg_parameters(
        secret.0.commitment(),
        *secret.0.min_signers(),
        *secret.0.max_signers(),
    )?;
    frost::keys::SecretShare::new(
        *secret.0.identifier(),
        frost::keys::SigningShare::new(secret.0.secret_share()),
        secret.0.commitment().clone(),
    )
    .verify()
    .map_err(|_| anyhow!("DKG secret share does not match its commitment"))?;
    Ok(secret)
}

#[frb(sync)]
pub fn dkg_round_2_secret_to_bytes(secret: &DkgRound2SecretOpaque) -> Result<Vec<u8>> {
    Ok(secret.0.serialize()?)
}

#[frb(opaque)]
#[derive(Clone)]
pub struct DkgShareToGiveOpaque(dkg::round2::Package);

#[frb(non_opaque)]
pub struct DkgRound2IdentifierAndShare {
    pub identifier: RustAutoOpaque<IdentifierOpaque>,
    pub secret: RustAutoOpaque<DkgShareToGiveOpaque>,
}

impl DkgRound2IdentifierAndShare {
    #[frb(sync)]
    pub fn from_refs(identifier: &IdentifierOpaque, secret: &DkgShareToGiveOpaque) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            secret: RustAutoOpaque::new(secret.clone()),
        }
    }
}

#[frb(non_opaque)]
pub enum DkgRound2Error {
    General {
        message: String,
    },
    InvalidProofOfKnowledge {
        culprit: RustAutoOpaque<IdentifierOpaque>,
    },
}

type DkgRound2Data = (DkgRound2SecretOpaque, Vec<DkgRound2IdentifierAndShare>);

#[frb(sync)]
pub fn dkg_part_2(
    round_1_secret: &DkgRound1SecretOpaque,
    round_1_commitments: Vec<DkgCommitmentForIdentifier>,
) -> Result<DkgRound2Data, DkgRound2Error> {
    // Convert vector into hashmap
    let commitment_map = round_1_commitments
        .into_iter()
        .map(|v| {
            (
                v.identifier.blocking_read().0.clone(),
                v.commitment.blocking_read().0.clone(),
            )
        })
        .collect();

    let result = dkg::part2(round_1_secret.0.clone(), &commitment_map).map_err(|e| match e {
        frost::Error::InvalidProofOfKnowledge {
            culprit: identifier,
        } => DkgRound2Error::InvalidProofOfKnowledge {
            culprit: RustAutoOpaque::new(IdentifierOpaque(identifier)),
        },
        _ => DkgRound2Error::General {
            message: e.to_string(),
        },
    })?;

    // Convert result to DkgPart2Result
    Ok((
        DkgRound2SecretOpaque(result.0),
        result
            .1
            .into_iter()
            .map(|v| DkgRound2IdentifierAndShare {
                identifier: RustAutoOpaque::new(IdentifierOpaque(v.0)),
                secret: RustAutoOpaque::new(DkgShareToGiveOpaque(v.1)),
            })
            .collect(),
    ))
}

#[frb(sync)]
pub fn share_to_give_from_bytes(bytes: Vec<u8>) -> Result<DkgShareToGiveOpaque> {
    Ok(DkgShareToGiveOpaque(from_bytes(
        bytes,
        |b| dkg::round2::Package::deserialize(&b),
        |obj| obj.serialize(),
        "Share to give",
    )?))
}

#[frb(sync)]
pub fn share_to_give_to_bytes(share: &DkgShareToGiveOpaque) -> Result<Vec<u8>> {
    Ok(share.0.serialize()?)
}

// DKG Part 3

#[derive(Clone)]
#[frb(non_opaque)]
pub struct IdentifierAndPublicShare {
    pub identifier: RustAutoOpaque<IdentifierOpaque>,
    pub public_share: Vec<u8>,
}

impl IdentifierAndPublicShare {
    #[frb(sync)]
    pub fn from_ref(identifier: &IdentifierOpaque, public_share: Vec<u8>) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            public_share,
        }
    }
}

pub struct DkgRound3Data {
    pub identifier: RustAutoOpaque<IdentifierOpaque>,
    pub private_share: Vec<u8>,
    pub group_pk: Vec<u8>,
    pub public_key_shares: Vec<IdentifierAndPublicShare>,
    pub threshold: u16,
}
type DkgPart3Result = Result<DkgRound3Data>;

#[frb(sync)]
pub fn dkg_part_3(
    round_2_secret: &DkgRound2SecretOpaque,
    round_1_commitments: Vec<DkgCommitmentForIdentifier>,
    round_2_shares: Vec<DkgRound2IdentifierAndShare>,
) -> DkgPart3Result {
    // Convert vectors into hashmaps

    let commitment_map = round_1_commitments
        .into_iter()
        .map(|v| {
            (
                v.identifier.blocking_read().0.clone(),
                v.commitment.blocking_read().0.clone(),
            )
        })
        .collect();

    let secrets_map = round_2_shares
        .into_iter()
        .map(|v| {
            (
                v.identifier.blocking_read().0.clone(),
                v.secret.blocking_read().0.clone(),
            )
        })
        .collect();

    let result = dkg::part3(&round_2_secret.0, &commitment_map, &secrets_map)?;

    let verifying_share = frost::keys::VerifyingShare::from(*result.0.signing_share());
    if result.1.verifying_shares().get(result.0.identifier()) != Some(&verifying_share) {
        return Err(anyhow!("DKG private share does not match its public share"));
    }

    Ok(DkgRound3Data {
        identifier: RustAutoOpaque::new(IdentifierOpaque(*result.0.identifier())),
        // Get private share as scalar
        private_share: result.0.signing_share().serialize(),
        // Get the group public key
        group_pk: result.1.verifying_key().serialize()?,
        // Collect all the identifier public key shares into a vector
        public_key_shares: result
            .1
            .verifying_shares()
            .into_iter()
            .map(|v| -> Result<IdentifierAndPublicShare> {
                Ok(IdentifierAndPublicShare {
                    identifier: RustAutoOpaque::new(IdentifierOpaque(*v.0)),
                    public_share: v.1.serialize()?,
                })
            })
            .collect::<Result<Vec<_>>>()?,
        threshold: *result.0.min_signers(),
    })
}

// Sign Part 1: Nonce generation

type SigningNoncesOpaque = RustOpaque<frost::round1::SigningNonces>;
type SigningCommitmentOpaque = RustOpaque<frost::round1::SigningCommitments>;
type SignPart1Result = Result<(SigningNoncesOpaque, SigningCommitmentOpaque)>;

#[frb(sync)]
pub fn sign_part_1(private_share: Vec<u8>) -> SignPart1Result {
    let mut rng = thread_rng();

    let (nonces, commitment) =
        frost::round1::commit(&vector_to_signing_share(private_share)?, &mut rng);

    Ok((RustOpaque::new(nonces), RustOpaque::new(commitment)))
}

#[frb(sync)]
pub fn signing_nonces_from_bytes(bytes: Vec<u8>) -> Result<SigningNoncesOpaque> {
    Ok(RustOpaque::new(from_bytes(
        bytes,
        |b| frost::round1::SigningNonces::deserialize(&b),
        |obj| obj.serialize(),
        "Signing nonces",
    )?))
}

#[frb(sync)]
pub fn signing_nonces_to_bytes(nonces: &SigningNoncesOpaque) -> Result<Vec<u8>> {
    Ok(nonces.serialize()?)
}

#[frb(sync)]
pub fn signing_commitment_from_bytes(bytes: Vec<u8>) -> Result<SigningCommitmentOpaque> {
    Ok(RustOpaque::new(from_bytes(
        bytes,
        |b| frost::round1::SigningCommitments::deserialize(&b),
        |obj| obj.serialize(),
        "Signing commitment",
    )?))
}

#[frb(sync)]
pub fn signing_commitment_to_bytes(commitment: &SigningCommitmentOpaque) -> Result<Vec<u8>> {
    Ok(commitment.serialize()?)
}

// Sign Part 2: Generate signature share

#[frb(non_opaque)]
pub struct IdentifierAndSigningCommitment {
    pub identifier: RustAutoOpaque<IdentifierOpaque>,
    pub commitment: SigningCommitmentOpaque,
}

impl IdentifierAndSigningCommitment {
    #[frb(sync)]
    pub fn from_refs(identifier: &IdentifierOpaque, commitment: &SigningCommitmentOpaque) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            commitment: commitment.clone(),
        }
    }
}

#[frb(opaque)]
#[derive(Clone)]
pub struct SignatureShareOpaque(frost::round2::SignatureShare);

type SignPart2Result = Result<SignatureShareOpaque>;

#[frb(sync)]
pub fn sign_part_2(
    nonces_commitments: Vec<IdentifierAndSigningCommitment>,
    message: Vec<u8>,
    merkle_root: Option<Vec<u8>>,
    signing_nonces: &SigningNoncesOpaque,
    identifier: &IdentifierOpaque,
    private_share: Vec<u8>,
    group_pk: Vec<u8>,
    threshold: u16,
) -> SignPart2Result {
    let signing_package = construct_signing_package(nonces_commitments, message);
    let signing_share = vector_to_signing_share(private_share)?;
    let group_verifying_key = vector_to_group_key(group_pk)?;

    let key_package = frost::keys::KeyPackage::new(
        identifier.0.clone(),
        signing_share,
        signing_share.try_into()?,
        group_verifying_key,
        threshold,
    );

    Ok(SignatureShareOpaque(match merkle_root {
        None => frost::round2::sign(&signing_package, &signing_nonces, &key_package),
        Some(root) => frost::round2::sign_with_tweak(
            &signing_package,
            &signing_nonces,
            &key_package,
            Some(root.as_slice()),
        ),
    }?))
}

#[frb(sync)]
pub fn signature_share_from_bytes(bytes: Vec<u8>) -> Result<SignatureShareOpaque> {
    Ok(SignatureShareOpaque(
        frost::round2::SignatureShare::deserialize(bytes.as_slice())?,
    ))
}

#[frb(sync)]
pub fn signature_share_to_bytes(share: &SignatureShareOpaque) -> Vec<u8> {
    share.0.serialize().to_vec()
}

// Signature share verification

#[frb(sync)]
pub fn verify_signature_share(
    nonces_commitments: Vec<IdentifierAndSigningCommitment>,
    message: Vec<u8>,
    merkle_root: Option<Vec<u8>>,
    identifier: &IdentifierOpaque,
    share: &SignatureShareOpaque,
    public_share: Vec<u8>,
    group_pk: Vec<u8>,
) -> Result<()> {
    let signing_package = construct_signing_package(nonces_commitments, message);

    // Mutable for if a tweak is required
    let mut verifying_share = vector_to_verifying_share(public_share)?;
    let mut group_verifying_key = vector_to_group_key(group_pk)?;

    // Introduce tweak here as library doesn't have verify_signature_share_with_tweak
    // Tweak by using a PublicKeyPackage with only the wanted key
    if merkle_root.is_some() {
        let pubkey_package = frost::keys::PublicKeyPackage::new(
            BTreeMap::from([(identifier.0.clone(), verifying_share.clone())]),
            group_verifying_key,
        );

        let tweaked_keys = pubkey_package.tweak(merkle_root);

        verifying_share = tweaked_keys
            .verifying_shares()
            .first_key_value()
            .ok_or(anyhow!("Lost verifying key"))?
            .1
            .clone();
        group_verifying_key = tweaked_keys.verifying_key().clone();
    }

    frost_core::verify_signature_share(
        identifier.0.clone(),
        &verifying_share,
        &share.0,
        &signing_package,
        &group_verifying_key,
    )
    .map_err(|e| anyhow!(e.to_string()))
}

// Final aggregation

#[frb(non_opaque)]
pub struct IdentifierAndSignatureShare {
    pub identifier: RustAutoOpaque<IdentifierOpaque>,
    pub share: RustAutoOpaque<SignatureShareOpaque>,
}

impl IdentifierAndSignatureShare {
    #[frb(sync)]
    pub fn from_refs(identifier: &IdentifierOpaque, share: &SignatureShareOpaque) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            share: RustAutoOpaque::new(share.clone()),
        }
    }
}

#[frb(non_opaque)]
pub enum SignAggregationError {
    General {
        message: String,
    },
    InvalidSignShare {
        culprit: RustAutoOpaque<IdentifierOpaque>,
    },
}

#[frb(sync)]
pub fn aggregate_signature(
    nonces_commitments: Vec<IdentifierAndSigningCommitment>,
    message: Vec<u8>,
    merkle_root: Option<Vec<u8>>,
    shares: Vec<IdentifierAndSignatureShare>,
    group_pk: Vec<u8>,
    public_shares: Vec<IdentifierAndPublicShare>,
) -> Result<Vec<u8>, SignAggregationError> {
    let signing_package = construct_signing_package(nonces_commitments, message);
    let group_verifying_key =
        vector_to_group_key(group_pk).map_err(|e| SignAggregationError::General {
            message: e.to_string(),
        })?;

    let pubkey_package = frost::keys::PublicKeyPackage::new(
        public_shares
            .into_iter()
            .try_fold(
                BTreeMap::new(),
                |mut acc, v| -> Result<BTreeMap<frost::Identifier, frost::keys::VerifyingShare>> {
                    acc.insert(
                        v.identifier.blocking_read().0.clone(),
                        vector_to_verifying_share(v.public_share)?,
                    );
                    Ok(acc)
                },
            )
            .map_err(|e| SignAggregationError::General {
                message: e.to_string(),
            })?,
        group_verifying_key,
    );

    let mapped_shares = shares
        .into_iter()
        .map(|v| {
            (
                v.identifier.blocking_read().0,
                v.share.blocking_read().0.clone(),
            )
        })
        .collect();

    let signature = match merkle_root {
        None => frost::aggregate(&signing_package, &mapped_shares, &pubkey_package),
        Some(root) => frost::aggregate_with_tweak(
            &signing_package,
            &mapped_shares,
            &pubkey_package,
            Some(root.as_slice()),
        ),
    }
    .map_err(|e| match e {
        frost::Error::InvalidSignatureShare {
            culprit: identifier,
        } => SignAggregationError::InvalidSignShare {
            culprit: RustAutoOpaque::new(IdentifierOpaque(identifier)),
        },
        _ => SignAggregationError::General {
            message: e.to_string(),
        },
    })?;

    let bytes = signature
        .serialize()
        .map_err(|e| SignAggregationError::General {
            message: e.to_string(),
        })?;

    Ok(bytes.to_vec())
}

// Construction of private key for FROST key

#[frb(non_opaque)]
pub struct IdentifierAndPrivateShare {
    pub identifier: RustAutoOpaque<IdentifierOpaque>,
    pub private_share: Vec<u8>,
}

#[frb(sync)]
pub fn construct_private_key(
    private_shares: Vec<IdentifierAndPrivateShare>,
    group_pk: Vec<u8>,
    threshold: u16,
) -> Result<Vec<u8>> {
    let casted_threshold = threshold as usize;

    if private_shares.len() != casted_threshold {
        return Err(anyhow!("Require threshold shares to construct private key"));
    }

    let group_verifying_key = vector_to_group_key(group_pk)?;

    let packages = (0..casted_threshold)
        .map(|i| {
            let signing_share = vector_to_signing_share(private_shares[i].private_share.clone())?;
            Ok(frost::keys::KeyPackage::new(
                private_shares[i].identifier.blocking_read().0,
                signing_share,
                signing_share.try_into()?,
                group_verifying_key,
                threshold,
            ))
        })
        .collect::<Result<Vec<_>>>()?;

    Ok(frost::keys::reconstruct(&packages)?.serialize())
}

// AES-GCM

#[frb(non_opaque)]
pub struct AesGcmCiphertext {
    pub data: Vec<u8>,
    pub nonce: Vec<u8>,
}

fn get_cipher(key: Vec<u8>) -> Result<Aes256Gcm> {
    let key: &Key<Aes256Gcm> = key.as_slice().try_into()?;
    Ok(Aes256Gcm::new(&key))
}

#[frb(sync)]
pub fn aes_gcm_encrypt(key: Vec<u8>, plaintext: Vec<u8>) -> Result<AesGcmCiphertext> {
    // Result<AesGcmCiphertext> {

    let cipher = get_cipher(key)?;
    let nonce = Aes256Gcm::generate_nonce(&mut OsRng);
    let data = cipher
        .encrypt(&nonce, plaintext.as_slice())
        .map_err(|_| anyhow!("could not encrypt data"))?;

    Ok(AesGcmCiphertext {
        data,
        nonce: nonce.as_slice().into(),
    })
}

#[frb(sync)]
pub fn aes_gcm_decrypt(key: Vec<u8>, ciphertext: AesGcmCiphertext) -> Result<Vec<u8>> {
    let cipher = get_cipher(key)?;
    Ok(cipher
        .decrypt(
            ciphertext.nonce.as_slice().try_into()?,
            ciphertext.data.as_slice(),
        )
        .map_err(|_| anyhow!("Could not decrypt data"))?)
}

#[cfg(test)]
mod tests {
    use super::*;
    use frost_core::Field;

    fn round1_secret(min_signers: u16, max_signers: u16) -> dkg::round1::SecretPackage {
        dkg::part1(
            frost::Identifier::try_from(1).unwrap(),
            max_signers,
            min_signers,
            thread_rng(),
        )
        .unwrap()
        .0
    }

    fn round2_secret() -> dkg::round2::SecretPackage {
        let secret = round1_secret(2, 3);
        let commitments = (2..=3)
            .map(|i| {
                let id = frost::Identifier::try_from(i).unwrap();
                (id, dkg::part1(id, 3, 2, thread_rng()).unwrap().1)
            })
            .collect();
        dkg::part2(secret, &commitments).unwrap().0
    }

    #[test]
    fn valid_dkg_secrets_round_trip() {
        for (min_signers, max_signers) in [(2, 2), (3, 5)] {
            let secret = round1_secret(min_signers, max_signers);
            let restored = dkg_round_1_secret_from_bytes(secret.serialize().unwrap()).unwrap();
            assert_eq!(secret, restored.0);
        }
        let secret = round2_secret();
        let restored = dkg_round_2_secret_from_bytes(secret.serialize().unwrap()).unwrap();
        assert_eq!(secret, restored.0);
    }

    #[test]
    fn restored_dkg_secrets_reject_invalid_signer_and_commitment_counts() {
        let first = round1_secret(2, 3);
        let second = round2_secret();
        for (min_signers, max_signers) in [(0, 0), (1, 3), (2, 0), (4, 3), (3, 3)] {
            let invalid = dkg::round1::SecretPackage::new(
                *first.identifier(),
                first.coefficients(),
                first.commitment().clone(),
                min_signers,
                max_signers,
            );
            assert!(dkg_round_1_secret_from_bytes(invalid.serialize().unwrap()).is_err());
            let invalid = dkg::round2::SecretPackage::new(
                *second.identifier(),
                second.commitment().clone(),
                second.secret_share(),
                min_signers,
                max_signers,
            );
            assert!(dkg_round_2_secret_from_bytes(invalid.serialize().unwrap()).is_err());
        }
    }

    #[test]
    fn restored_round1_secret_rejects_missing_or_inconsistent_coefficients() {
        let secret = round1_secret(2, 3);
        let mut changed = secret.coefficients();
        changed[0] += frost::Secp256K1ScalarField::one();
        for coefficients in [vec![], vec![secret.coefficients()[0]], changed] {
            let invalid = dkg::round1::SecretPackage::new(
                *secret.identifier(),
                coefficients,
                secret.commitment().clone(),
                *secret.min_signers(),
                *secret.max_signers(),
            );
            assert!(dkg_round_1_secret_from_bytes(invalid.serialize().unwrap()).is_err());
        }
    }

    #[test]
    fn restored_round2_secret_rejects_inconsistent_share_or_identifier() {
        let secret = round2_secret();
        let other_id = frost::Identifier::try_from(2).unwrap();
        for (id, share) in [
            (
                *secret.identifier(),
                secret.secret_share() + frost::Secp256K1ScalarField::one(),
            ),
            (other_id, secret.secret_share()),
        ] {
            let invalid = dkg::round2::SecretPackage::new(
                id,
                secret.commitment().clone(),
                share,
                *secret.min_signers(),
                *secret.max_signers(),
            );
            assert!(dkg_round_2_secret_from_bytes(invalid.serialize().unwrap()).is_err());
        }
    }

    #[test]
    fn finalization_rejects_private_share_that_does_not_match_public_share() {
        let ids: Vec<_> = (1..=3)
            .map(|i| IdentifierOpaque(frost::Identifier::try_from(i).unwrap()))
            .collect();
        let first: Vec<_> = ids.iter().map(|id| dkg_part_1(id, 3, 2).unwrap()).collect();
        let second: Vec<_> = first
            .iter()
            .enumerate()
            .map(|(i, (secret, _))| {
                let commitments = first
                    .iter()
                    .enumerate()
                    .filter(|(j, _)| i != *j)
                    .map(|(j, (_, public))| DkgCommitmentForIdentifier::from_refs(&ids[j], public))
                    .collect();
                dkg_part_2(secret, commitments).ok().unwrap()
            })
            .collect();
        let secret = &second[0].0 .0;
        // Bypass import validation to exercise the independent final-result check.
        let invalid = DkgRound2SecretOpaque(dkg::round2::SecretPackage::new(
            *secret.identifier(),
            secret.commitment().clone(),
            secret.secret_share() + frost::Secp256K1ScalarField::one(),
            *secret.min_signers(),
            *secret.max_signers(),
        ));
        let commitments = (1..3)
            .map(|i| DkgCommitmentForIdentifier::from_refs(&ids[i], &first[i].1))
            .collect();
        let shares = (1..3)
            .map(|i| {
                let share = second[i]
                    .1
                    .iter()
                    .find(|s| s.identifier.blocking_read().0 == ids[0].0)
                    .unwrap();
                DkgRound2IdentifierAndShare::from_refs(&ids[i], &share.secret.blocking_read())
            })
            .collect();
        let error = dkg_part_3(&invalid, commitments, shares).err().unwrap();
        assert_eq!(
            error.to_string(),
            "DKG private share does not match its public share"
        );
    }
}
