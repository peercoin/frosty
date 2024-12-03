FROM frosty_build_common

# Download & install Android NDK

ENV ANDROID_NDK_HOME=/android-ndk
ENV PATH=${PATH}:${ANDROID_NDK_HOME}
ARG NDK_SHORT_NAME=android-ndk-r27
ARG NDK_NAME=${NDK_SHORT_NAME}-linux
ARG NDK_SHA1=5e5cd517bdb98d7e0faf2c494a3041291e71bdcc

# Download
RUN curl --proto '=https' -sSf -O https://dl.google.com/android/repository/$NDK_NAME.zip

# Check sha1sum, unzip and move to final location
RUN apt-get install -y unzip
RUN sha1sum $NDK_NAME.zip | grep $NDK_SHA1 \
  && unzip -q $NDK_NAME.zip && mv $NDK_SHORT_NAME $ANDROID_NDK_HOME

# Ensure Rust/Cargo is up-to-date
# Update RUST_VER if a higher version is required and the cache must be
# invalidated
ARG RUST_VER=1.83.0
RUN rustup update stable

# Set up cargo-ndk
RUN cargo install cargo-ndk

# Add targets for android
RUN rustup target add aarch64-linux-android armv7-linux-androideabi

# Add build directory for output
RUN mkdir /build/jniLibs
