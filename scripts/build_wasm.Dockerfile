FROM frosty_build_common

# Add target for wasm
RUN rustup target add wasm32-unknown-unknown

# Provide wasm-bindgen CLI for JS/WASM glue generation
RUN cargo install wasm-bindgen-cli --version 0.2.106
