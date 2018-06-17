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

    # output the encryption and associated tag
    if settings[:ui] == :cli
      # output to file
      File.write("#{settings[:outdir]}encrypted.txt", cipher.update(settings[:file]) + cipher.final)
      File.write("#{settings[:outdir]}tag.txt", cipher.auth_tag)
      puts "Your encrypted.txt and associated tag.txt for this encryption have been generated in #{settings[:outdir]}."
    elsif settings[:ui] == :api
      # output to array
      [cipher.update(settings[:file]) + cipher.final, cipher.auth_tag]
    end
  end

  # encrypts a string with gpgme
  def self.gpgme(settings)
    require 'gpgme'

    # check if GPGHOME env was set
    puts "Environment variable 'GNUPGHOME' was not set. Files in #{ENV['HOME']}/.gnupg will be used for authentication." unless ENV['GNUPGHOME']

    # setup the encryption parameters
    crypto = GPGME::Crypto.new(armor: true, pinentry_mode: GPGME::PINENTRY_MODE_LOOPBACK)

    # output the encryption and associated tag
    if settings[:ui] == :cli
      # output to file
      File.write("#{settings[:outdir]}encrypted.txt", crypto.encrypt(settings[:file], symmetric: true, password: settings[:pw]).read)
      puts "Your encrypted.txt for this encryption have been generated in #{settings[:outdir]}."
    elsif settings[:ui] == :api
      # output to string
      crypto.encrypt(settings[:file], symmetric: true, password: settings[:pw]).read
    end
  end
end
