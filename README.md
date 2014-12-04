lolerrors
=========

A ruby gem to record your facial expressions when app errors occur during development

Installation
------------

You’ll need `ImageMagick` and `FFmpeg` installed. If you use Homebrew, then it is as simple as:

```
brew install imagemagick
brew install ffmpeg
```

Install the gem by including it in the Gemfile in your app.

```
gem 'lolerrors', group: :development
```

Usage
-----

It will taking animated snapshots each time an app error occurs. Resulting animations will be output in `~/lolerrors`
