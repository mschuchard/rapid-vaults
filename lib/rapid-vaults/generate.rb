# generates files necessary for encryption and decryption
class Generate
  # generates a key and nonce
  def self.openssl(settings)
    require 'openssl'

    # setup parameters
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt

    if settings[:ui] == :cli
      # output to file
      File.write('key.txt', cipher.random_key)
      File.write('nonce.txt', cipher.random_iv)
      puts 'Your key.txt and nonce.txt have been generated in your current directory.'
    elsif settings[:ui] == :api
      # output to string
      [cipher.random_key, cipher.random_iv]
    end
  end

  # generates a private and public key
  def self.gpgme(settings)
    require 'gpgme'

    # ensure we have a place to store these output files
    raise 'Environment variable GNUPGHOME was not set.' unless ENV['GNUPGHOME']

    # create gpg keys
    GPGME::Ctx.new.generate_key(settings[:gpgparams], nil, nil)
    puts "Your GPG keys have been generated in #{ENV['GNUPGHOME']}." if settings[:ui] == :cli
  end
end
