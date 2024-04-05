pub use frost_secp256k1_tr as frost;
pub use frost_secp256k1_tr::keys::dkg as dkg;
use rand::thread_rng;
use anyhow::{anyhow, Result};
use crate::frb_generated::{RustOpaque, MoiArcValue};
use std::collections::BTreeMap;
use flutter_rust_bridge::frb;

// Common

fn in_to_ext_result<T: Sized + MoiArcValue>(
   internal: Result<T, frost::Error>
) -> Result<RustOpaque<T>> {
    Ok(RustOpaque::new(internal?))
}

fn from_bytes<T: Sized + MoiArcValue, DFunc, SFunc>(
    bytes: Vec<u8>,
    deserialize: DFunc,
    serialize: SFunc,
    obj_name: &str
) -> Result<RustOpaque<T>>
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

    Ok(RustOpaque::new(obj))

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
    let array = vec_to_array::<32, u8>(vec, "Private share")?;
    frost::keys::SigningShare::deserialize(array)
        .map_err(|_| anyhow!("Could not deserialize private share"))
}

fn construct_signing_package(
    nonce_commitments: Vec<IdentifierAndSigningCommitment>,
    message: Vec<u8>,
    merkle_root: Option<Vec<u8>>,
) -> frost::SigningPackage {
    frost::SigningPackage::new(
        nonce_commitments.into_iter().map(
            |v| (*v.identifier, (*v.commitment).clone())
        ).collect(),
        frost::SigningTarget::new(
            &message,
            frost::SigningParameters { tapscript_merkle_root: merkle_root },
        )
    )
}

fn vector_to_group_key(vec: Vec<u8>) -> Result<frost::VerifyingKey> {
    let array = vec_to_array::<33, u8>(vec, "Group key")?;
    frost::VerifyingKey::deserialize(array)
        .map_err(|_| anyhow!("Could not deserialize group key"))
}

fn vector_to_verifying_share(vec: Vec<u8>) -> Result<frost::keys::VerifyingShare> {
    let array = vec_to_array::<33, u8>(vec, "Verifying share")?;
    frost::keys::VerifyingShare::deserialize(array)
        .map_err(|_| anyhow!("Could not deserialize verifying share"))
}

// Participant identifiers

type IdentifierOpaque = RustOpaque<frost::Identifier>;
type IdentifierResult = Result<IdentifierOpaque>;

#[frb(sync)]
pub fn identifier_from_string(s: String) -> IdentifierResult {
    in_to_ext_result(frost::Identifier::derive(s.as_bytes()))
}

#[frb(sync)]
pub fn identifier_from_u16(i: u16) -> IdentifierResult {
    in_to_ext_result(frost::Identifier::try_from(i))
}

#[frb(sync)]
pub fn identifier_from_bytes(bytes: Vec<u8>) -> IdentifierResult {
    let array = vec_to_array::<32, u8>(bytes, "Identifier")?;
    in_to_ext_result(frost::Identifier::deserialize(&array))
}

#[frb(sync)]
pub fn identifier_to_bytes(identifier: IdentifierOpaque) -> Vec<u8> {
    identifier.serialize().to_vec()
}

// DKG Part 1
// Generates a secret part and a public part. The public part is to be shared with
// all participants.

type DkgPublicCommitmentOpaque = RustOpaque<dkg::round1::Package>;
type DkgRound1SecretOpaque = RustOpaque<dkg::round1::SecretPackage>;
type DkgRound1Data = (DkgRound1SecretOpaque, DkgPublicCommitmentOpaque);
type DkgPart1Result = Result<DkgRound1Data>;

#[frb(sync)]
pub fn dkg_part_1(
    identifier: IdentifierOpaque,
    max_signers: u16,
    min_signers: u16,
) -> DkgPart1Result {

    let mut rng = thread_rng();

    Ok(
        dkg::part1(
            *identifier,
            max_signers,
            min_signers,
            &mut rng,
        )
        .map(|result| (RustOpaque::new(result.0), RustOpaque::new(result.1)))?
    )

}

#[frb(sync)]
pub fn public_commitment_from_bytes(
    bytes: Vec<u8>
) -> Result<DkgPublicCommitmentOpaque> {
    from_bytes(
        bytes,
        |b| dkg::round1::Package::deserialize(&b),
        |obj| obj.serialize(),
        "Public commitment"
    )
}

#[frb(sync)]
pub fn public_commitment_to_bytes(
    commitment: DkgPublicCommitmentOpaque
) -> Result<Vec<u8>> {
    Ok(commitment.serialize()?)
}

// DKG Part 2

pub struct DkgCommitmentForIdentifier {
    pub identifier: IdentifierOpaque,
    pub commitment: RustOpaque<dkg::round1::Package>,
}

type DkgRound2SecretOpaque = RustOpaque<dkg::round2::SecretPackage>;
type DkgShareToGiveOpaque = RustOpaque<dkg::round2::Package>;

pub struct DkgRound2IdentifierAndShare {
    pub identifier: IdentifierOpaque,
    pub secret: DkgShareToGiveOpaque,
}

pub enum DkgRound2Error {
    General { message: String },
    InvalidProofOfKnowledge { culprit: IdentifierOpaque },
}

type DkgRound2Data = (DkgRound2SecretOpaque, Vec<DkgRound2IdentifierAndShare>);

#[frb(sync)]
pub fn dkg_part_2(
    round_1_secret: DkgRound1SecretOpaque,
    round_1_commitments: Vec<DkgCommitmentForIdentifier>,
) -> Result<DkgRound2Data, DkgRound2Error> {

    // Convert vector into hashmap
    let commitment_map = round_1_commitments.into_iter().map(
        |v| (*v.identifier, (*v.commitment).clone())
    ).collect();

    let result = dkg::part2(
        (*round_1_secret).clone(),
        &commitment_map
    ).map_err(
        |e| match e {
            frost::Error::InvalidProofOfKnowledge {
                culprit: identifier
            } => DkgRound2Error::InvalidProofOfKnowledge {
                culprit: RustOpaque::new(identifier)
            },
            _ => DkgRound2Error::General {
                message: e.to_string()
            }
        }
    )?;

    // Convert result to DkgPart2Result
    Ok(
        (
            RustOpaque::new(result.0),
            result.1.into_iter().map(
                |v| DkgRound2IdentifierAndShare {
                    identifier: RustOpaque::new(v.0),
                    secret: RustOpaque::new(v.1)
                }
            ).collect()
        )
    )

}

#[frb(sync)]
pub fn share_to_give_from_bytes(
    bytes: Vec<u8>
) -> Result<DkgShareToGiveOpaque> {
    from_bytes(
        bytes,
        |b| dkg::round2::Package::deserialize(&b),
        |obj| obj.serialize(),
        "Share to give"
    )
}

#[frb(sync)]
pub fn share_to_give_to_bytes(
    share: DkgShareToGiveOpaque
) -> Result<Vec<u8>> {
    Ok(share.serialize()?)
}

// DKG Part 3

pub struct IdentifierAndPublicShare {
    pub identifier: IdentifierOpaque,
    pub public_share: Vec<u8>,
}
pub struct DkgRound3Data {
    pub identifier: IdentifierOpaque,
    pub private_share: Vec<u8>,
    pub group_pk: Vec<u8>,
    pub public_key_shares: Vec<IdentifierAndPublicShare>,
    pub threshold: u16,
}
type DkgPart3Result = Result<DkgRound3Data>;

#[frb(sync)]
pub fn dkg_part_3(
    round_2_secret: DkgRound2SecretOpaque,
    round_1_commitments: Vec<DkgCommitmentForIdentifier>,
    round_2_shares: Vec<DkgRound2IdentifierAndShare>,
) -> DkgPart3Result {

    // Convert vectors into hashmaps

    let commitment_map = round_1_commitments.into_iter().map(
        |v| (*v.identifier, (*v.commitment).clone())
    ).collect();

    let secrets_map = round_2_shares.into_iter().map(
        |v| (*v.identifier, (*v.secret).clone())
    ).collect();

    let result = dkg::part3(
        &round_2_secret,
        &commitment_map,
        &secrets_map,
    )?;

    Ok(
        DkgRound3Data {
            identifier: RustOpaque::new(*result.0.identifier()),
            // Get private share as scalar
            private_share: result.0.signing_share().serialize().to_vec(),
            // Get the group public key
            group_pk: result.1.verifying_key().serialize().to_vec(),
            // Collect all the identifier public key shares into a vector
            public_key_shares: result.1.verifying_shares().into_iter().map(
                |v| IdentifierAndPublicShare {
                    identifier: RustOpaque::new(*v.0),
                    public_share: v.1.serialize().to_vec(),
                }
            ).collect(),
            threshold: *result.0.min_signers(),
        }
    )

}

// Sign Part 1: Nonce generation

type SigningNonceOpaque = RustOpaque<frost::round1::SigningNonces>;
type SigningCommitmentOpaque = RustOpaque<frost::round1::SigningCommitments>;
type SignPart1Result = Result<(SigningNonceOpaque, SigningCommitmentOpaque)>;

#[frb(sync)]
pub fn sign_part_1(
    private_share: Vec<u8>
) -> SignPart1Result {

    let mut rng = thread_rng();

    let (nonce, commitment) = frost::round1::commit(
        &vector_to_signing_share(private_share)?,
        &mut rng,
    );

    Ok((RustOpaque::new(nonce), RustOpaque::new(commitment)))

}

#[frb(sync)]
pub fn signing_commitment_from_bytes(
    bytes: Vec<u8>
) -> Result<SigningCommitmentOpaque> {
    from_bytes(
        bytes,
        |b| frost::round1::SigningCommitments::deserialize(&b),
        |obj| obj.serialize(),
        "Signing commitment"
    )
}

#[frb(sync)]
pub fn signing_commitment_to_bytes(
    commitment: SigningCommitmentOpaque
) -> Result<Vec<u8>> {
    Ok(commitment.serialize()?)
}

// Sign Part 2: Generate signature share

pub struct IdentifierAndSigningCommitment {
    pub identifier: IdentifierOpaque,
    pub commitment: SigningCommitmentOpaque,
}

type SignatureShareOpaque = RustOpaque<frost::round2::SignatureShare>;
type SignPart2Result = Result<SignatureShareOpaque>;

#[frb(sync)]
pub fn sign_part_2(
    nonce_commitments: Vec<IdentifierAndSigningCommitment>,
    message: Vec<u8>,
    merkle_root: Option<Vec<u8>>,
    signing_nonce: SigningNonceOpaque,
    identifier: IdentifierOpaque,
    private_share: Vec<u8>,
    group_pk: Vec<u8>,
    threshold: u16,
) -> SignPart2Result {

    let signing_package = construct_signing_package(
        nonce_commitments, message, merkle_root,
    );
    let signing_share = vector_to_signing_share(private_share)?;
    let group_verifying_key = vector_to_group_key(group_pk)?;

    let key_package = frost::keys::KeyPackage::new(
        *identifier,
        signing_share,
        signing_share.try_into()?,
        group_verifying_key,
        threshold,
    );

    Ok(RustOpaque::new(
        frost::round2::sign(
            &signing_package,
            &signing_nonce,
            &key_package,
        )?
    ))

}

#[frb(sync)]
pub fn signature_share_from_bytes(
    bytes: Vec<u8>
) -> Result<SignatureShareOpaque> {
    let array = vec_to_array::<32, u8>(bytes, "Signature share")?;
    in_to_ext_result(frost::round2::SignatureShare::deserialize(array))
}

#[frb(sync)]
pub fn signature_share_to_bytes(
    share: SignatureShareOpaque
) -> Vec<u8> {
    share.serialize().to_vec()
}

// Final aggregation

pub struct IdentifierAndSignatureShare {
    pub identifier: IdentifierOpaque,
    pub share: SignatureShareOpaque,
}

pub enum SignAggregationError {
    General { message: String },
    InvalidSignShare { culprit: IdentifierOpaque },
}

#[frb(sync)]
pub fn aggregate_signature(
    nonce_commitments: Vec<IdentifierAndSigningCommitment>,
    message: Vec<u8>,
    merkle_root: Option<Vec<u8>>,
    shares: Vec<IdentifierAndSignatureShare>,
    group_pk: Vec<u8>,
    public_shares: Vec<IdentifierAndPublicShare>,
) -> Result<Vec<u8>, SignAggregationError> {

    let signing_package = construct_signing_package(
        nonce_commitments, message, merkle_root,
    );
    let group_verifying_key = vector_to_group_key(group_pk)
        .map_err(|e| SignAggregationError::General { message: e.to_string() })?;

    let pubkey_package = frost::keys::PublicKeyPackage::new(
        public_shares.into_iter().try_fold(
            BTreeMap::new(),
            |mut acc, v|
            -> Result<BTreeMap<frost::Identifier, frost::keys::VerifyingShare>> {
                acc.insert(
                    *v.identifier,
                    vector_to_verifying_share(v.public_share)?,
                );
                Ok(acc)
            }
        ).map_err(|e| SignAggregationError::General { message: e.to_string() })?,
        group_verifying_key,
    );

    let signature = frost::aggregate(
        &signing_package,
        &shares.into_iter().map(
            |v| (*v.identifier, (*v.share).clone())
        ).collect(),
        &pubkey_package,
    ).map_err(
        |e| match e {
            frost::Error::InvalidSignatureShare {
                culprit : identifier
            } => SignAggregationError::InvalidSignShare {
                culprit: RustOpaque::new(identifier)
            },
            _ => SignAggregationError::General {
                message: e.to_string()
            }
        }
    )?;

    // Serialise, removing the first byte of the point as Schnorr signatures in
    // Peercoin expect no odd/even bit.
    let bytes = signature.serialize()[1..].to_vec();

    Ok(bytes)

}
