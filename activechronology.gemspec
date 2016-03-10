# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_chronology/version'

Gem::Specification.new do |spec|
  spec.name          = "activechronology"
  spec.version       = ActiveChronology::VERSION
  spec.authors       = ["Kyle Edson", "Jon Evans"]
  spec.email         = ["jle@foraker.com"]

  spec.summary       = %q{Easily scope and order by timestamps in your ActiveRecord models.}
  spec.homepage      = "https://www.github.com/foraker/activechronology"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "rails", "> 3"
end
