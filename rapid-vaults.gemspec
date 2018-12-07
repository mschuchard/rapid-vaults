Gem::Specification.new do |spec|
  spec.name          = 'rapid-vaults'
  spec.version       = '1.1.2'
  spec.authors       = ['Matt Schuchard']
  spec.description   = 'Ad-hoc encrypt and decrypt data behind multiple layers of protection via OpenSSL or GPG.'
  spec.summary       = 'Ad-hoc encrypt and decrypt data.'
  spec.homepage      = 'https://www.github.com/mschuchard/rapid-vaults'
  spec.license       = 'MIT'

  spec.files         = Dir['bin/**/*', 'lib/**/*', 'spec/**/*', 'README.md']
  spec.executables   = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = Dir['lib']

  spec.required_ruby_version = '>= 2.1.0'
  spec.add_dependency 'gpgme', '~> 2.0'
  spec.add_development_dependency 'grpc', '~> 1.0'
  spec.add_development_dependency 'grpc-tools', '~> 1.0'
  spec.add_development_dependency 'rake', '>= 9', '< 13'
  spec.add_development_dependency 'reek', '> 4.0', '< 6'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.51'
end
