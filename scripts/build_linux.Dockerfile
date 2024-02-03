FROM debian:bookworm

# Update system and install dependencies
RUN apt-get update -y && apt-get upgrade -y \
  && apt-get install -y curl gcc-aarch64-linux-gnu build-essential gcc

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add targets
RUN rustup target add x86_64-unknown-linux-gnu

# Build library for targets in container
WORKDIR /build
# The dockerignore file doesn't copy the build.rs file so bindings are not
# generated
COPY native /build
