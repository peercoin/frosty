FROM frosty_build_common

# Add target for linux
RUN rustup target add x86_64-unknown-linux-gnu
