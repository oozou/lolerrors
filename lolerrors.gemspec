$:.push File.expand_path("../lib", __FILE__)
require "lolerrors/version"

Gem::Specification.new do |s|
  s.name          = 'lolerrors'
  s.version       = Lolerrors::VERSION
  s.platform      = Gem::Platform::RUBY
  s.date          = '2014-11-05'
  s.summary       = 'Capture animation of your funny reaction to rails app errors'
  s.description   = <<-EOF
  lolerrors take a videosnap shot with your webcam
  every time exception or error occurs. Then make animated GIF with the error message
  EOF
  s.authors       = ['Jeep Kiddee']
  s.email         = ['nutthawut.ki@gmail.com']
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/lolerrors'
  s.license       = 'MIT'

  s.required_ruby_version = '>= 1.9'
  s.requirements << 'imagemagick'
  s.requirements << 'ffmpeg'
  s.requirements << 'a webcam'
end
