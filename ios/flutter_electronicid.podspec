#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_electronicid.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_electronicid'
  s.version          = '1.3.0'
  s.summary          = 'A Flutter Plugin that integrates the Native Android and iOS SDKs of Electronic ID, an Identity Verification Provider.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/Mietz-GmbH/flutter_electronicid'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mietz GmbH' => 'info@mietz.app' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.dependency 'VideoIDSDK', '1.2.0'
  s.ios.deployment_target = '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
