pub use frost_secp256k1 as frost;
pub use frost_secp256k1::keys::dkg as dkg;
use rand::thread_rng;
use anyhow::{anyhow, Result};
use flutter_rust_bridge::{SyncReturn, RustOpaque, DartSafe};
use std::collections::HashMap;

// Common

fn in_to_ext_result<T: Sized + DartSafe>(
   internal: Result<T, frost::Error>
) -> Result<SyncReturn<RustOpaque<T>>> {
    Ok(SyncReturn(RustOpaque::new(internal?)))
}

fn from_bytes<T: Sized + DartSafe, DFunc, SFunc>(
    bytes: Vec<u8>,
    deserialize: DFunc,
    serialize: SFunc,
    obj_name: &str
) -> Result<SyncReturn<RustOpaque<T>>>
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

    Ok(SyncReturn(RustOpaque::new(obj)))

}

// Participant identifiers

type IdentifierOpaque = RustOpaque<frost::Identifier>;
type IdentifierResult = Result<SyncReturn<IdentifierOpaque>>;

pub fn identifier_from_string(s: String) -> IdentifierResult {
    in_to_ext_result(frost::Identifier::derive(s.as_bytes()))
}

pub fn identifier_from_u16(i: u16) -> IdentifierResult {
    in_to_ext_result(frost::Identifier::try_from(i))
}

pub fn identifier_from_bytes(bytes: Vec<u8>) -> IdentifierResult {

    let array = <[u8; 32]>::try_from(bytes)
        .map_err(|_| anyhow!("Identifier byte size should be 32"))?;

    in_to_ext_result(frost::Identifier::deserialize(&array))

}

pub fn identifier_to_bytes(identifier: IdentifierOpaque) -> SyncReturn<Vec<u8>> {
    SyncReturn(identifier.serialize().to_vec())
}

// DKG Part 1
// Generates a secret part and a public part. The public part is to be shared with
// all participants.

type DkgPublicCommitmentOpaque = RustOpaque<dkg::round1::Package>;
type DkgRound1SecretOpaque = RustOpaque<dkg::round1::SecretPackage>;
type DkgRound1Data = (DkgRound1SecretOpaque, DkgPublicCommitmentOpaque);
type DkgPart1Result = Result<SyncReturn<DkgRound1Data>>;

pub fn dkg_part_1(
    identifier: IdentifierOpaque,
    max_signers: u16,
    min_signers: u16,
) -> DkgPart1Result {

    let mut rng = thread_rng();

    Ok(SyncReturn(
        dkg::part1(
            *identifier,
            max_signers,
            min_signers,
            &mut rng,
        )
        .map(|result| (RustOpaque::new(result.0), RustOpaque::new(result.1)))?
    ))

}

pub fn public_commitment_from_bytes(
    bytes: Vec<u8>
) -> Result<SyncReturn<DkgPublicCommitmentOpaque>> {
    from_bytes(
        bytes,
        |b| dkg::round1::Package::deserialize(&b),
        |obj| obj.serialize(),
        "Public commitment"
    )
}

pub fn public_commitment_to_bytes(
    commitment: DkgPublicCommitmentOpaque
) -> Result<SyncReturn<Vec<u8>>> {
    Ok(SyncReturn(commitment.serialize()?))
}

// DKG Part 2

pub struct DkgCommitmentForIdentifier {
    pub identifier: IdentifierOpaque,
    pub commitment: RustOpaque<dkg::round1::Package>,
}

type DkgSharedSecretOpaque = RustOpaque<dkg::round2::Package>;

pub struct DkgRound2SecretToShare {
    pub identifier: IdentifierOpaque,
    pub secret: DkgSharedSecretOpaque,
}

type DkgRound2Data = (
    RustOpaque<dkg::round2::SecretPackage>,
    Vec<DkgRound2SecretToShare>
);
type DkgPart2Result = Result<SyncReturn<DkgRound2Data>>;

pub fn dkg_part_2(
    round_1_secret: DkgRound1SecretOpaque,
    round_1_commitments: Vec<DkgCommitmentForIdentifier>,
) -> DkgPart2Result {

    // Convert vector into hashmap
    let commitment_map: HashMap<frost::Identifier, dkg::round1::Package>
        = round_1_commitments.into_iter().map(
            |v| (*v.identifier, (*v.commitment).clone())
        ).collect();

    let result = dkg::part2((*round_1_secret).clone(), &commitment_map)?;

    // Convert result to DkgPart2Result
    Ok(SyncReturn(
        (
            RustOpaque::new(result.0),
            result.1.into_iter().map(
                |v| DkgRound2SecretToShare {
                    identifier: RustOpaque::new(v.0),
                    secret: RustOpaque::new(v.1)
                }
            ).collect()
        )
    ))

}

pub fn shared_secret_from_bytes(
    bytes: Vec<u8>
) -> Result<SyncReturn<DkgSharedSecretOpaque>> {
    from_bytes(
        bytes,
        |b| dkg::round2::Package::deserialize(&b),
        |obj| obj.serialize(),
        "Shared secret"
    )
}

pub fn shared_secret_to_bytes(
    secret: DkgSharedSecretOpaque
) -> Result<SyncReturn<Vec<u8>>> {
    Ok(SyncReturn(secret.serialize()?))
}
