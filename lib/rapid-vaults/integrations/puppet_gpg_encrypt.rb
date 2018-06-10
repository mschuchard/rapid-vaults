# mymodule/lib/puppet/functions/gpg_encrypt.rb
Puppet::Functions.create_function(:'gpg_encrypt') do
  # Encrypts a file with GnuPG.
  # @param [String] file The file to encrypt.
  # @param [String] gpghome The path to the GnuPG home directory containing the credentials.
  # @param [String] password_file The password file to use for encryption.
  # @return [String] Returns a string of encrypted contents.
  # @example Encrypting a file.
  # gpg_encrypt('/path/to/data.txt', '/home/alice/.gnupg', '/path/to/password.txt') => 'asdnlfi378rth43rt78h4t8b3v844b'
  dispatch :gpg_encrypt do
    required_param 'String', :file
    required_param 'String', :gpghome
    required_param 'String', :password_file
    return_type 'String'
  end

  def gpg_encrypt(file, gpghome, password_file)
    begin
      require 'rapid-vaults'
    rescue LoadError
      raise 'Rapid Vaults is required to be installed on the puppet master to use this custom function!'
    end

    ENV['GNUPGHOME'] = gpghome

    RapidVaults::API.main(action: :encrypt, algorithm: :gpgme, file: file, pw: password_file)
  end
end
