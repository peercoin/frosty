FROM debian:bookworm

# Update system and install dependencies
RUN apt-get update -y && apt-get upgrade -y \
  && apt-get install -y curl gcc-aarch64-linux-gnu build-essential gcc

# Ensure Rust/Cargo is up-to-date
# Update RUST_VER if a higher version is required and the cache must be
# invalidated. Using `rustup update stable` can fail, so best to install from
# scratch
ARG RUST_VER=1.85.1

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Build library for targets in container
WORKDIR /build
# The dockerignore file doesn't copy the build.rs file so bindings are not
# generated
COPY native /build
