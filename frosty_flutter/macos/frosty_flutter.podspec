#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint frosty_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'frosty_flutter'
  s.module_name      = 'frosty_rust'
  s.version          = '1.1.0'
  s.summary          = 'Rust compilation for frosty_flutter'
  s.description      = <<-DESC
The native Rust code compiled for frosty_flutter
                       DESC
  s.homepage         = 'http://peercoin.net'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Peercoin Developers'

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'

  s.script_phase = {
    :name => 'Build Rust library',
    # First argument is relative path to the `rust` folder, second is name of rust library
    :script => 'PRODUCT_NAME=frosty_flutter sh "$PODS_TARGET_SRCROOT/../cargokit/build_pod.sh" ../rust frosty_rust',
    :execution_position => :before_compile,
    :input_files => ['${BUILT_PRODUCTS_DIR}/cargokit_phony'],
    # Let XCode know that the static library referenced in -force_load below is
    # created by this build step.
    :output_files => ["${BUILT_PRODUCTS_DIR}/libfrosty_rust.a"],
  }
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    # Flutter.framework does not contain a i386 slice.
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-force_load ${BUILT_PRODUCTS_DIR}/libfrosty_rust.a',
  }
end
