use lib_flutter_rust_bridge_codegen::{
  config_parse, frb_codegen, get_symbols_if_no_duplicates, RawOpts,
};

const RUST_INPUT: &str = "src/api.rs";
const DART_OUTPUT: &str = "../frosty/lib/src/rust_bindings/rust_ffi.g.dart";

fn main() {
  // Tell Cargo that if the input Rust code changes, rerun this build script
  println!("cargo:rerun-if-changed={}", RUST_INPUT);

  // Options for frb_codegen
  let raw_opts = RawOpts {
    rust_input: vec![RUST_INPUT.to_string()],
    dart_output: vec![DART_OUTPUT.to_string()],
    inline_rust: true,
    wasm: false,
    ..Default::default()
  };

  // Generate Rust & Dart ffi bridges
  let configs = config_parse(raw_opts);
  let all_symbols = get_symbols_if_no_duplicates(&configs).unwrap();
  for config in configs.iter() {
    frb_codegen(config, &all_symbols).unwrap();
  }

}
