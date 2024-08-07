Gem::Specification.new do |spec|
  spec.name          = 'rapid-vaults'
  spec.version       = '1.3.0'
  spec.authors       = ['Matt Schuchard']
  spec.description   = 'Ad-hoc encrypt and decrypt data behind multiple layers of protection via OpenSSL or GPG.'
  spec.summary       = 'Ad-hoc encrypt and decrypt data.'
  spec.homepage      = 'https://www.github.com/mschuchard/rapid-vaults'
  spec.license       = 'MIT'

  spec.files         = Dir['bin/**/*', 'lib/**/*', 'spec/**/*', 'CHANGELOG.md', 'LICENSE.md', 'README.md', 'rapid-vaults.gemspec']
  spec.executables   = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.require_paths = Dir['lib']

  spec.required_ruby_version = '>= 2.6.0'
  spec.add_dependency 'gpgme', '~> 2.0'
  spec.add_development_dependency 'grpc', '~> 1.0'
  spec.add_development_dependency 'grpc-tools', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'reek', '~> 6.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.0'
end
