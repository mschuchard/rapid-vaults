# decrypts strings using supplied decryption settings
class Decrypt
  # decrypts a string with openssl
  def self.openssl(settings)
    require 'openssl'

    # check tag size
    raise 'Tag is not 16 bytes.' unless settings[:tag].bytesize == 16

    # setup the decryption parameters
    decipher = OpenSSL::Cipher.new('aes-256-gcm').decrypt
    decipher.key = settings[:key]
    decipher.iv = settings[:nonce]
    decipher.auth_tag = settings[:tag]
    decipher.auth_data = settings.key?(:pw) ? settings[:pw] : ''

    # output the decrypted file
    if settings[:ui] == :cli
      # output to file
      File.write('decrypted.txt', decipher.update(settings[:file]) + decipher.final)
      puts 'Your decrypted.txt has been written out to the current directory.'
    elsif settings[:ui] == :api
      # output to string
      decipher.update(settings[:file]) + decipher.final
    end
  end

  # decrypts a string with gpgme
  def self.gpgme(settings)
    require 'gpgme'

    # setup the decryption parameters
    encrypted = GPGME::Data.new(settings[:file])
    crypto = GPGME::Crypto.new(armor: true, pinentry_mode: GPGME::PINENTRY_MODE_LOOPBACK)

    # output the decrypted file
    if settings[:ui] == :cli
      # output to file
      File.write('decrypted.txt', crypto.decrypt(encrypted, password: settings[:password]).read)
      puts 'Your decrypted.txt has been written out to the current directory.'
    elsif settings[:ui] == :api
      # output to string
      crypto.decrypt(encrypted, password: settings[:password]).read
    end
  end
end
