$:.push File.expand_path("../lib", __FILE__)

require 'pippi/version'

Gem::Specification.new do |s|
  s.name = 'pippi'
  s.version = Pippi::VERSION
  s.authors = ["Tom Copeland"]
  s.email = ["tom@thomasleecopeland.com"]
  s.homepage = ""
  s.summary = "A Ruby runtime code analyzer"
  s.description = "A Ruby runtime code analyzer"
  s.rubyforge_project = "none"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files test/*`.split("\n")
  s.executables = "pippi"
  s.require_paths = ["lib"]
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'byebug'
  s.required_ruby_version = '>= 1.9.3'
end