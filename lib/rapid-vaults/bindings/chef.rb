require 'rapid-vaults'

# returns key, nonce
def ssl_generate
  options = { action: :generate }
  RapidVaults::API.main(options)
end

# returns encrypted_contents, tag
def ssl_encrypt
  options = {
    action: :encrypt,
    file: '/path/to/data.txt',
    key: '/path/to/key.txt',
    nonce: '/path/to/nonce.txt',
    pw: File.read('/path/to/password.txt') # optional
  }
  RapidVaults::API.main(options)
end

# returns decrypted_contents
def ssl_decrypt
  options = {
    action: :decrypt,
    file: '/path/to/encrypted_data.txt',
    key: '/path/to/key.txt',
    nonce: '/path/to/nonce.txt',
    tag: '/path/to/tag.txt',
    pw: File.read('/path/to/password.txt') # optional
  }
  RapidVaults::API.main(options)
end

# returns exit code on status of gnupg setup
def gpg_generate
  ENV['GNUPGHOME'] = '/home/alice/.gnupg'

  options = {
    action: :generate,
    algorithm: :gpgme,
    gpgparams: File.read('gpgparams.txt')
  }
  RapidVaults::API.main(options)
end

# returns encrypted_contents
def gpg_encrypt
  ENV['GNUPGHOME'] = '/home/bob/.gnupg'

  options = {
    action: :encrypt,
    algorithm: :gpgme,
    file: '/path/to/data.txt',
    pw: File.read('/path/to/password.txt')
  }
  RapidVaults::API.main(options)
end

# returns decrypted_contents
def gpg_decrypt
  ENV['GNUPGHOME'] = '/home/chris/.gnupg'

  options = {
    action: :decrypt,
    algorithm: :gpgme,
    file: '/path/to/encrypted_data.txt',
    pw: File.read('/path/to/password.txt')
  }
  RapidVaults::API.main(options)
end
