# encrypts strings using supplied encryption settings
class Encrypt
  # encrypts a string with openssl
  def self.openssl(settings)
    require 'openssl'

    # setup the encryption parameters
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    cipher.key = settings[:key]
    cipher.iv = settings[:nonce]
    cipher.auth_data = settings.key?(:pw) ? settings[:pw] : ''

    # output the encrypted file and associated tag
    if settings[:ui] == :cli
      # output to file
      File.write('encrypted.txt', cipher.update(settings[:file]) + cipher.final)
      File.write('tag.txt', cipher.auth_tag)
      puts 'Your encrypted.txt and associated tag.txt for this encryption have been generated in your current directory.'
    elsif settings[:ui] == :api
      # output to array
      [cipher.update(settings[:file]) + cipher.final, cipher.auth_tag]
    end
  end

  # encrypts a string with gpgme
  def self.gpgme(settings)
    require 'gpgme'

    # setup the encryption parameters
    crypto = GPGME::Crypto.new(armor: true, pinentry_mode: GPGME::PINENTRY_MODE_LOOPBACK)

    # output the encrypted file and associated tag
    if settings[:ui] == :cli
      # output to file
      File.write('encrypted.txt', crypto.encrypt(settings[:file], symmetric: true, password: settings[:password]).read)
      puts 'Your encrypted.txt for this encryption have been generated in your current directory.'
    elsif settings[:ui] == :api
      # output to string
      crypto.encrypt(settings[:file], symmetric: true, password: settings[:password]).read
    end
  end
end
