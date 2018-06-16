require 'rapid-vaults'

# returns key, nonce
def ssl_generate
  options = {}
  options[:action] = :generate
  RapidVaults::API.main(options)
end

# returns encrypted_contents, tag
def ssl_encrypt
  options = {}
  options[:action] = :encrypt
  options[:file] = '/path/to/data.txt'
  options[:key] = '/path/to/cert.key'
  options[:nonce] = '/path/to/nonce.txt'
  options[:pw] = File.read('/path/to/password.txt') # optional
  RapidVaults::API.main(options)
end

# returns decrypted_contents
def ssl_decrypt
  options = {}
  options[:action] = :decrypt
  options[:file] = '/path/to/encrypted_data.txt'
  options[:key] = '/path/to/cert.key'
  options[:nonce] = '/path/to/nonce.txt'
  options[:tag] = '/path/to/tag.txt'
  options[:pw] = File.read('/path/to/password.txt') # optional
  RapidVaults::API.main(options)
end

# returns exit code on status of gnupg setup
def gpg_generate
  ENV['GNUPGHOME'] = '/home/alice/.gnupg'

  options = {}
  options[:action] = :generate
  options[:algorithm] = :gpgme
  options[:gpgparams] = File.read('gpgparams.txt')
  RapidVaults::API.main(options)
end

# returns encrypted_contents
def gpg_encryot
  ENV['GNUPGHOME'] = '/home/bob/.gnupg'

  options = {}
  options[:action] = :encrypt
  options[:algorithm] = :gpgme
  options[:file] = '/path/to/data.txt'
  options[:pw] = File.read('/path/to/password.txt')
  RapidVaults::API.main(options)
end

# returns decrypted_contents
def gpg_decrypt
  ENV['GNUPGHOME'] = '/home/chris/.gnupg'

  options = {}
  options[:action] = :decrypt
  options[:algorithm] = :gpgme
  options[:file] = '/path/to/encrypted_data.txt'
  options[:pw] = File.read('/path/to/password.txt')
  RapidVaults::API.main(options)
end
