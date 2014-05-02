# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth/deezer/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-deezer"
  s.version     = Omniauth::Deezer::VERSION
  s.authors     = ["Geoffroy Montel"]
  s.email       = ["coder@minizza.com"]
  s.homepage    = "https://github.com/geoffroymontel/omniauth-deezer"
  s.summary     = %q{Deezer strategy for Omniauth 1.0}
  s.description = %q{Deezer strategy for Omniauth 1.0}

  s.rubyforge_project = "omniauth-deezer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency 'omniauth', '>= 1.1.0'
  s.add_runtime_dependency 'faraday'
  
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
