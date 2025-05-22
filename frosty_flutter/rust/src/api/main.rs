use frost_secp256k1_tr::keys::Tweak;
pub use frost_secp256k1_tr as frost;
pub use frost_core;
pub use frost_secp256k1_tr::keys::dkg as dkg;
use rand::thread_rng;
use anyhow::{anyhow, Result};
use crate::frb_generated::{RustOpaque, RustAutoOpaque};
use std::collections::BTreeMap;
use flutter_rust_bridge::frb;
use aes_gcm::{
    aead::{Aead, AeadCore, KeyInit, OsRng},
    Aes256Gcm, Key,
};

// Common

fn from_bytes<T: Sized, DFunc, SFunc>(
    bytes: Vec<u8>,
    deserialize: DFunc,
    serialize: SFunc,
    obj_name: &str
) -> Result<T>
where
    DFunc: FnOnce(&[u8]) -> Result<T, frost::Error>,
    SFunc: FnOnce(&T) -> Result<Vec<u8>, frost::Error> {

    let obj = deserialize(&bytes)
        .map_err(|_| anyhow!("Could not deserialize {}", obj_name))?;
    let expected_bytes = serialize(&obj)
        .map_err(|_| anyhow!("Could not serialize {}", obj_name))?;

    if bytes != expected_bytes {
        return Err(anyhow!(
            "{} bytes do not serialise into the same bytes", obj_name
        ));
    }

    Ok(obj)

}

fn vec_to_array<const N: usize, T>(
    vec: Vec<T>,
    name: &str
) -> Result<[T; N]> {
    <[T; N]>::try_from(vec)
    .map_err(|_| anyhow!("{} should have {} bytes", name, N))
}

fn vector_to_signing_share(
    vec: Vec<u8>
) -> Result<frost::keys::SigningShare> {
    frost::keys::SigningShare::deserialize(vec.as_slice())
        .map_err(|_| anyhow!("Could not deserialize private share"))
}

fn construct_signing_package(
    nonce_commitments: Vec<IdentifierAndSigningCommitment>,
    message: Vec<u8>,
) -> frost::SigningPackage {
    frost::SigningPackage::new(
        nonce_commitments.into_iter().map(
            |v| (
                v.identifier.blocking_read().0.clone(),
                (*v.commitment).clone()
            )
        ).collect(),
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
        dkg::part1(
            identifier.0.clone(),
            max_signers,
            min_signers,
            &mut rng,
        )
        .map(|result| (
            DkgRound1SecretOpaque(result.0),
            DkgPublicCommitmentOpaque(result.1)
        ))?
    )

}

#[frb(sync)]
pub fn public_commitment_from_bytes(
    bytes: Vec<u8>
) -> Result<DkgPublicCommitmentOpaque> {
    Ok(DkgPublicCommitmentOpaque(
        from_bytes(
            bytes,
            |b| dkg::round1::Package::deserialize(&b),
            |obj| obj.serialize(),
            "Public commitment"
        )?
    ))
}

#[frb(sync)]
pub fn public_commitment_to_bytes(
    commitment: &DkgPublicCommitmentOpaque
) -> Result<Vec<u8>> {
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
            commitment: RustAutoOpaque::new(commitment.clone())
        }
    }
}

#[frb(opaque)]
pub struct DkgRound2SecretOpaque(dkg::round2::SecretPackage);
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
    pub fn from_refs(
        identifier: &IdentifierOpaque,
        secret: &DkgShareToGiveOpaque,
    ) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            secret: RustAutoOpaque::new(secret.clone())
        }
    }
}

#[frb(non_opaque)]
pub enum DkgRound2Error {
    General { message: String },
    InvalidProofOfKnowledge {
        culprit: RustAutoOpaque<IdentifierOpaque>
    },
}

type DkgRound2Data = (DkgRound2SecretOpaque, Vec<DkgRound2IdentifierAndShare>);

#[frb(sync)]
pub fn dkg_part_2(
    round_1_secret: &DkgRound1SecretOpaque,
    round_1_commitments: Vec<DkgCommitmentForIdentifier>,
) -> Result<DkgRound2Data, DkgRound2Error> {

    // Convert vector into hashmap
    let commitment_map = round_1_commitments.into_iter().map(
        |v| (
            v.identifier.blocking_read().0.clone(),
            v.commitment.blocking_read().0.clone(),
        )
    ).collect();

    let result = dkg::part2(
        round_1_secret.0.clone(),
        &commitment_map
    ).map_err(
        |e| match e {
            frost::Error::InvalidProofOfKnowledge {
                culprit: identifier
            } => DkgRound2Error::InvalidProofOfKnowledge {
                culprit: RustAutoOpaque::new(IdentifierOpaque(identifier))
            },
            _ => DkgRound2Error::General {
                message: e.to_string()
            }
        }
    )?;

    // Convert result to DkgPart2Result
    Ok(
        (
            DkgRound2SecretOpaque(result.0),
            result.1.into_iter().map(
                |v| DkgRound2IdentifierAndShare {
                    identifier: RustAutoOpaque::new(IdentifierOpaque(v.0)),
                    secret: RustAutoOpaque::new(DkgShareToGiveOpaque(v.1))
                }
            ).collect()
        )
    )

}

#[frb(sync)]
pub fn share_to_give_from_bytes(
    bytes: Vec<u8>
) -> Result<DkgShareToGiveOpaque> {
    Ok(DkgShareToGiveOpaque(
        from_bytes(
            bytes,
            |b| dkg::round2::Package::deserialize(&b),
            |obj| obj.serialize(),
            "Share to give"
        )?
    ))
}

#[frb(sync)]
pub fn share_to_give_to_bytes(
    share: &DkgShareToGiveOpaque
) -> Result<Vec<u8>> {
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
    pub fn from_ref(
        identifier: &IdentifierOpaque,
        public_share: Vec<u8>,
    ) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            public_share
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

    let commitment_map = round_1_commitments.into_iter().map(
        |v| (
            v.identifier.blocking_read().0.clone(),
            v.commitment.blocking_read().0.clone()
        )
    ).collect();

    let secrets_map = round_2_shares.into_iter().map(
        |v| (
            v.identifier.blocking_read().0.clone(),
            v.secret.blocking_read().0.clone()
        )
    ).collect();

    let result = dkg::part3(
        &round_2_secret.0,
        &commitment_map,
        &secrets_map,
    )?;

    Ok(
        DkgRound3Data {
            identifier: RustAutoOpaque::new(IdentifierOpaque(*result.0.identifier())),
            // Get private share as scalar
            private_share: result.0.signing_share().serialize(),
            // Get the group public key
            group_pk: result.1.verifying_key().serialize()?,
            // Collect all the identifier public key shares into a vector
            public_key_shares: result.1.verifying_shares().into_iter().map(
                |v| -> Result<IdentifierAndPublicShare> {
                    Ok(
                        IdentifierAndPublicShare {
                            identifier: RustAutoOpaque::new(
                                IdentifierOpaque(*v.0)
                            ),
                            public_share: v.1.serialize()?
                        }
                    )
                }
            ).collect::<Result<Vec<_>>>()?,
            threshold: *result.0.min_signers(),
        }
    )

}

// Sign Part 1: Nonce generation

type SigningNoncesOpaque = RustOpaque<frost::round1::SigningNonces>;
type SigningCommitmentOpaque = RustOpaque<frost::round1::SigningCommitments>;
type SignPart1Result = Result<(SigningNoncesOpaque, SigningCommitmentOpaque)>;

#[frb(sync)]
pub fn sign_part_1(
    private_share: Vec<u8>
) -> SignPart1Result {

    let mut rng = thread_rng();

    let (nonces, commitment) = frost::round1::commit(
        &vector_to_signing_share(private_share)?,
        &mut rng,
    );

    Ok((RustOpaque::new(nonces), RustOpaque::new(commitment)))

}

#[frb(sync)]
pub fn signing_nonces_from_bytes(
    bytes: Vec<u8>
) -> Result<SigningNoncesOpaque> {
    Ok(RustOpaque::new(
        from_bytes(
            bytes,
            |b| frost::round1::SigningNonces::deserialize(&b),
            |obj| obj.serialize(),
            "Signing nonces"
        )?
    ))
}

#[frb(sync)]
pub fn signing_nonces_to_bytes(
    nonces: &SigningNoncesOpaque
) -> Result<Vec<u8>> {
    Ok(nonces.serialize()?)
}

#[frb(sync)]
pub fn signing_commitment_from_bytes(
    bytes: Vec<u8>
) -> Result<SigningCommitmentOpaque> {
    Ok(RustOpaque::new(
        from_bytes(
            bytes,
            |b| frost::round1::SigningCommitments::deserialize(&b),
            |obj| obj.serialize(),
            "Signing commitment"
        )?
    ))
}

#[frb(sync)]
pub fn signing_commitment_to_bytes(
    commitment: &SigningCommitmentOpaque
) -> Result<Vec<u8>> {
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
    pub fn from_refs(
        identifier: &IdentifierOpaque,
        commitment: &SigningCommitmentOpaque,
    ) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            commitment: commitment.clone()
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

    Ok(SignatureShareOpaque(
        match merkle_root {
            None => frost::round2::sign(
                &signing_package,
                &signing_nonces,
                &key_package,
            ),
            Some(root) => frost::round2::sign_with_tweak(
                &signing_package,
                &signing_nonces,
                &key_package,
                Some(root.as_slice()),
            )
        }?
    ))

}

#[frb(sync)]
pub fn signature_share_from_bytes(
    bytes: Vec<u8>
) -> Result<SignatureShareOpaque> {
    Ok(
        SignatureShareOpaque(
            frost::round2::SignatureShare::deserialize(bytes.as_slice())?
        )
    )
}

#[frb(sync)]
pub fn signature_share_to_bytes(
    share: &SignatureShareOpaque
) -> Vec<u8> {
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

        verifying_share = tweaked_keys.verifying_shares().first_key_value()
            .ok_or(anyhow!("Lost verifying key"))?.1.clone();
        group_verifying_key = tweaked_keys.verifying_key().clone();

    }

    frost_core::verify_signature_share(
        identifier.0.clone(),
        &verifying_share,
        &share.0,
        &signing_package,
        &group_verifying_key,
    ).map_err(|e| anyhow!(e.to_string()))

}

// Final aggregation

#[frb(non_opaque)]
pub struct IdentifierAndSignatureShare {
    pub identifier: RustAutoOpaque<IdentifierOpaque>,
    pub share: RustAutoOpaque<SignatureShareOpaque>,
}

impl IdentifierAndSignatureShare {
    #[frb(sync)]
    pub fn from_refs(
        identifier: &IdentifierOpaque,
        share: &SignatureShareOpaque,
    ) -> Self {
        Self {
            identifier: RustAutoOpaque::new(identifier.clone()),
            share: RustAutoOpaque::new(share.clone())
        }
    }
}

#[frb(non_opaque)]
pub enum SignAggregationError {
    General { message: String },
    InvalidSignShare { culprit: RustAutoOpaque<IdentifierOpaque> },
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
    let group_verifying_key = vector_to_group_key(group_pk)
        .map_err(|e| SignAggregationError::General { message: e.to_string() })?;

    let pubkey_package = frost::keys::PublicKeyPackage::new(
        public_shares.into_iter().try_fold(
            BTreeMap::new(),
            |mut acc, v|
            -> Result<BTreeMap<frost::Identifier, frost::keys::VerifyingShare>> {
                acc.insert(
                    v.identifier.blocking_read().0.clone(),
                    vector_to_verifying_share(v.public_share)?,
                );
                Ok(acc)
            }
        ).map_err(|e| SignAggregationError::General { message: e.to_string() })?,
        group_verifying_key,
    );

    let mapped_shares = shares.into_iter().map(
        |v| (v.identifier.blocking_read().0, v.share.blocking_read().0.clone())
    ).collect();

    let signature = match merkle_root {
        None => frost::aggregate(
            &signing_package,
            &mapped_shares,
            &pubkey_package,
        ),
        Some(root) => frost::aggregate_with_tweak(
            &signing_package,
            &mapped_shares,
            &pubkey_package,
            Some(root.as_slice()),
        ),
    }.map_err(
        |e| match e {
            frost::Error::InvalidSignatureShare {
                culprit : identifier
            } => SignAggregationError::InvalidSignShare {
                culprit: RustAutoOpaque::new(IdentifierOpaque(identifier))
            },
            _ => SignAggregationError::General {
                message: e.to_string()
            }
        }
    )?;

    let bytes = signature.serialize()
        .map_err(|e| SignAggregationError::General { message: e.to_string() })?;

    Ok(bytes.to_vec())

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
pub fn aes_gcm_encrypt(
    key: Vec<u8>,
    plaintext: Vec<u8>,
) -> Result<AesGcmCiphertext> { // Result<AesGcmCiphertext> {

    let cipher = get_cipher(key)?;
    let nonce = Aes256Gcm::generate_nonce(&mut OsRng);
    let data = cipher.encrypt(&nonce, plaintext.as_slice())
        .map_err(|_| anyhow!("could not encrypt data"))?;

    Ok(AesGcmCiphertext { data, nonce: nonce.as_slice().into() })

}

#[frb(sync)]
pub fn aes_gcm_decrypt(
    key: Vec<u8>,
    ciphertext: AesGcmCiphertext,
) -> Result<Vec<u8>> {

    let cipher = get_cipher(key)?;
    Ok(
        cipher.decrypt(
            ciphertext.nonce.as_slice().try_into()?,
            ciphertext.data.as_slice(),
        )
        .map_err(|_| anyhow!("Could not decrypt data"))?
    )

}
