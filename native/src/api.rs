pub use frost_secp256k1 as frost;
use anyhow::{anyhow, Result};
use flutter_rust_bridge::{SyncReturn, RustOpaque, DartSafe};

fn in_to_ext_result<T: Sized + DartSafe>(
   internal: Result<T, frost::Error>
) -> Result<SyncReturn<RustOpaque<T>>> {
    Ok(SyncReturn(RustOpaque::new(internal?)))
}

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
