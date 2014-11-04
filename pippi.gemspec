$:.push File.expand_path('../lib', __FILE__)

require 'pippi/version'

Gem::Specification.new do |s|
  s.name = 'pippi'
  s.version = Pippi::VERSION
  s.authors = ['Tom Copeland']
  s.email = ['tom@thomasleecopeland.com']
  s.homepage = 'https://github.com/tcopeland/pippi'
  s.summary = 'A Ruby runtime code analyzer'
  s.description = 'Pippi is a utility for locating suboptimal Ruby class API usage.'
  s.license = 'MIT'
  s.rubyforge_project = 'none'
  s.files = Dir['lib/**/*', '*\.md', 'doc/**/*']
  s.bindir = 'bin'
  s.executables = 'pippi'
  s.require_paths = ['lib']
  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'byebug', '~> 2.7'
  s.required_ruby_version = '>= 2.0.0'
end
