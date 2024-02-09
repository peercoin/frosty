pub use frost_secp256k1 as frost;
pub use frost_secp256k1::keys::dkg as dkg;
use rand::thread_rng;
use anyhow::{anyhow, Result};
use flutter_rust_bridge::{SyncReturn, RustOpaque, DartSafe};

// Common

fn in_to_ext_result<T: Sized + DartSafe>(
   internal: Result<T, frost::Error>
) -> Result<SyncReturn<RustOpaque<T>>> {
    Ok(SyncReturn(RustOpaque::new(internal?)))
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

type PublicCommitmentOpaque = RustOpaque<dkg::round1::Package>;
type DkgPartOneOpaque = (
    RustOpaque<dkg::round1::SecretPackage>,
    PublicCommitmentOpaque,
);
type DkgPartOneResult = Result<SyncReturn<DkgPartOneOpaque>>;

pub fn dkg_part_1(
    identifier: IdentifierOpaque,
    max_signers: u16,
    min_signers: u16,
) -> DkgPartOneResult {

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
) -> Result<SyncReturn<PublicCommitmentOpaque>> {
    Ok(SyncReturn(RustOpaque::new(
        dkg::round1::Package::deserialize(&bytes)?
    )))
}

pub fn public_commitment_to_bytes(
    commitment: PublicCommitmentOpaque
) -> Result<SyncReturn<Vec<u8>>> {
    Ok(SyncReturn(commitment.serialize()?))
}
