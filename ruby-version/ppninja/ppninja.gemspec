# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ppninja/version'

Gem::Specification.new do |spec|
  spec.name          = "ppninja"
  spec.version       = Ppninja::VERSION
  spec.authors       = ["Yipeng Zhao"]
  spec.email         = ["daggerjames.zhao@gmail.com"]

  spec.summary       = %q{an api gem for ppj.io enterprise}
  spec.description   = %q{private gem}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "http"
  spec.add_runtime_dependency "activesupport", '>= 4.2', '< 5.0'

  spec.add_development_dependency "rspec-rails", '~> 3.5'
  spec.add_development_dependency "rails", ">= 4.2", '< 5.0'
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
