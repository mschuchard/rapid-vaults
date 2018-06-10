# mymodule/lib/puppet/functions/ssl_decrypt.rb
Puppet::Functions.create_function(:'ssl_decrypt') do
  # Decrypts a file with OpenSSL.
  # @param [String] file The file to decrypt.
  # @param [String] key The key file to use for decryption.
  # @param [String] nonce The nonce file to use for decryption.
  # @param [String] tag The tag file to use for decryption.
  # @param [String] password_file The optional password file to use for decryption.
  # @return [String] Returns a string of decrypted contents.
  # @example Decrypting a file.
  # ssl_decrypt('/path/to/encrypted_data.txt', '/path/to/cert.key', '/path/to/nonce.txt', '/path/to/tag.txt', '/path/to/password.txt') => 'decrypted'
  dispatch :ssl_decrypt do
    required_param 'String', :file
    required_param 'String', :key
    required_param 'String', :nonce
    required_param 'String', :tag
    optional_param 'String', :password_file
    return_type 'String'
  end

  def ssl_decrypt(file, key, nonce, tag, password_file = nil)
    begin
      require 'rapid-vaults'
    rescue LoadError
      raise 'Rapid Vaults is required to be installed on the puppet master to use this custom function!'
    end

    if password_file.nil?
      RapidVaults::API.main(action: :decrypt, file: file, key: key, nonce: nonce, tag: tag)
    else
      RapidVaults::API.main(action: :encrypt, file: file, key: key, nonce: nonce, tag: tag, pw: File.read(password_file))
    end
  end
end
