# decrypts strings using supplied decryption settings
class Decrypt
  # decrypts a string with openssl
  def self.openssl(settings)
    require 'openssl'

    # setup the decryption parameters
    decipher = OpenSSL::Cipher.new('aes-256-gcm').decrypt
    decipher.key = settings[:key]
    decipher.iv = settings[:nonce]
    decipher.auth_tag = settings[:tag]
    decipher.auth_data = settings.key?(:pw) ? settings[:pw] : ''

    # output the decryption
    case settings[:ui]
    when :cli
      # output to file
      File.write("#{settings[:outdir]}decrypted.txt", decipher.update(settings[:file]) + decipher.final)
      puts "Your decrypted.txt has been written out to #{settings[:outdir]}."
    when :api
      # output to string
      decipher.update(settings[:file]) + decipher.final
    end
  end

  # decrypts a string with gpgme
  def self.gpgme(settings)
    require 'gpgme'

    # check if GPGHOME env was set
    puts "Environment variable 'GNUPGHOME' was not set. Files in #{Dir.home}/.gnupg will be used for authentication." unless ENV.fetch('GNUPGHOME', false)

    # setup the decryption parameters
    encrypted = GPGME::Data.new(settings[:file])
    crypto = GPGME::Crypto.new(armor: true, pinentry_mode: GPGME::PINENTRY_MODE_LOOPBACK)

    # output the decryption
    case settings[:ui]
    when :cli
      # output to file
      File.write("#{settings[:outdir]}decrypted.txt", crypto.decrypt(encrypted, password: settings[:pw]).read)
      puts "Your decrypted.txt has been written out to #{settings[:outdir]}."
    when :api
      # output to string
      crypto.decrypt(encrypted, password: settings[:pw]).read
    end
  end
end
