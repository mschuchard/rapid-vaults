# mymodule/lib/puppet/functions/ssl_encrypt.rb
Puppet::Functions.create_function(:'ssl_encrypt') do
  # Encrypts a file with OpenSSL.
  # @param [String] file The file to encrypt.
  # @param [String] key The key file to use for encryption.
  # @param [String] nonce The nonce file to use for encryption.
  # @optional_param [String] password_file The optional password file to use for encryption.
  # @return [Hash] Returns a hash. First key-value is the encrypted contents and the second is the tag.
  # @example Encrypting a file.
  # ssl_encrypt('/path/to/data.txt', '/path/to/cert.key', '/path/to/nonce.txt', '/path/to/password.txt') => { encrypted_contents => 'asdfnlm34kl5m3lasdf34324fdnfsd', tag => 'fwr32r2ewf' }
  dispatch :ssl_encrypt do
    required_param 'String', :file
    required_param 'String', :key
    required_param 'String', :nonce
    optional_param 'String', :password_file
    return_type 'Hash'
  end

  def ssl_encrypt(file, key, nonce, password_file = nil)
    begin
      require 'rapid-vaults'
    rescue LoadError
      raise 'Rapid Vaults is required to be installed on the puppet master to use this custom function!'
    end

    hash = {}
    if password_file.nil?
      hash[:encrypted_contents], hash[:tag] = RapidVaults::API.main(action: :encrypt, file: file, key: key, nonce: nonce)
    else
      hash[:encrypted_contents], hash[:tag] = RapidVaults::API.main(action: :encrypt, file: file, key: key, nonce: nonce, pw: File.read(password_file))
    end
    hash
  end
end
