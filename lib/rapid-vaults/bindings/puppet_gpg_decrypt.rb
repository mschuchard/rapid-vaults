# mymodule/lib/puppet/functions/gpg_decrypt.rb
Puppet::Functions.create_function(:gpg_decrypt) do
  # Decrypts a file with GnuPG.
  # @param [String] file The file to decrypt.
  # @param [String] gpghome The path to the GnuPG home directory containing the credentials.
  # @param [String] password_file The password file to use for decryption.
  # @return [String] Returns a string of decrypted contents.
  # @example Decrypting a file.
  # gpg_encrypt('/path/to/encrypted_data.txt', '/home/alice/.gnupg', '/path/to/password.txt') => 'decrypted'
  dispatch :gpg_decrypt do
    required_param 'String', :file
    required_param 'String', :gpghome
    required_param 'String', :password_file
    return_type 'String'
  end

  def gpg_decrypt(file, gpghome, password_file)
    begin
      require 'rapid-vaults'
    rescue LoadError
      raise 'Rapid Vaults is required to be installed on the puppet master to use this custom function!'
    end

    ENV['GNUPGHOME'] = gpghome

    RapidVaults::API.main(action: :decrypt, algorithm: :gpgme, file: file, pw: password_file)
  end
end
