# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [v3.1.1] - 2017-10-02
- Migrated project to GitLab (with repository mirroring to GitHub)

## [3.1.0] - 2017-09-18
- Allow handlers to return `:ok`
  - This is useful for  configuring the Logger at runtime, which you can't do with
    `Application.put_env/2`, instead you must `Logger.configure/1`

## [3.0.0] - 2017-09-08
### NEW MAJOR VERSION DUE TO BREAKING CHANGE / API
Sorry about this, but after you've seen the examples, I'm sure you'll agree this is a much nicer way to work with your configuration.

- No more `def handle_configuration/2` functions :tada:
  - Check the `/example` folder for an example of the new Weave module format
  - Configuration can be marked as `required: true`, which will cause an error if it's not satisfied

## [2.2.0] - 2017-08-18
- Ability to configure the file loader with multiple directories
  - `file_directories` has been added, expecting a list of directories. This should be considered the de-facto way to configure the file loader, with `:file_directory` being deprecated in 3.0

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
