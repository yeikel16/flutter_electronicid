# Release Guide

- Update the version in:
  - [./CHANGELOG.md](./CHANGELOG.md)
  - [./pubspec.yaml](./pubspec.yaml)
  - [./ios/flutter_electronicid.podspec](./ios/flutter_electronicid.podspec)
  - [./example/pubspec.lock](./example/pubspec.lock)
  - [./example/ios/Podfile.lock](./example/ios/Podfile.lock)
- Create a git tag with the new version name: `git tag v1.1.0`.
- Run `dart pub publish --dry-run` to check for any errors.
- Create a new release on GitHub:
  - Select the newly created tag
  - Generate release notes
  - Publish release
