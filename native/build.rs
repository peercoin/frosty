use lib_flutter_rust_bridge_codegen::codegen;
use lib_flutter_rust_bridge_codegen::codegen::Config;
use anyhow;

fn main() -> anyhow::Result<()> {
  // Tell Cargo that if the input Rust code changes, rerun this build script
  println!("cargo:rerun-if-changed=src/api");

  codegen::generate(
    Config::from_config_file("./flutter_rust_bridge.yaml")?.unwrap(),
    Default::default(),
  )

}
