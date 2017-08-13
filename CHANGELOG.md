# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [2.1.3] - 2017-08-13
- Fixed crash when the directory configured for the file loader has sub-directories

## [2.1.2] - 2017-07-06
- Loaders can now be configured and a single function, `Weave.configure()`, used to load.

## [2.1.1] - 2017-07-05
- Incorrect tag created. It's been deleted and 2.1.2 suceeds.

## [2.1.0] - 2017-06-29
- `handle_configuration/2` can now return a list of configurations to be set

## [2.0.0] - 2017-06-19
### BREAKING CHANGE
- All "keys" are now lower-cased before being passed to a handler. This means environment variables, such as `MY_APP_PASSWORD` will require a handler of `handle_configuration("password")`, rather than the old `handle_configuration("PASSWORD")`

### Added
- "Handler Free" configuration. Setting the contents of your environment variable, or file, to "{:auto, :app, :key, value}" will not require a `handle_configuration/2` definition in your handler.
- Improved the documentation
- Added typespec's
- Cleaned up ebert warnings
