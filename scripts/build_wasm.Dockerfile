FROM frosty_build_common

# Add target for wasm
RUN rustup target add wasm32-unknown-unknown
