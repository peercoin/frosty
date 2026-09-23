FROM debian:bookworm

ARG RUST_VERSION=1.98.0
ARG WASM_BINDGEN_VERSION=0.2.106

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain "$RUST_VERSION"

ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUSTUP_TOOLCHAIN="$RUST_VERSION"

RUN rustup target add wasm32-unknown-unknown \
    && cargo install wasm-bindgen-cli \
        --version "$WASM_BINDGEN_VERSION" \
        --locked

WORKDIR /build
COPY frosty/rust/ ./

RUN cargo build --release --locked --target wasm32-unknown-unknown \
    && mkdir /wasm \
    && wasm-bindgen \
        --target no-modules \
        --out-name frosty_rust \
        --out-dir /wasm \
        target/wasm32-unknown-unknown/release/frosty_rust.wasm

CMD ["sh", "-c", "cp /wasm/frosty_rust.js /wasm/frosty_rust_bg.wasm /output/"]
