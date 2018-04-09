require 'openssl'

# encrypts strings using supplied encryption settings
class Encrypt
  # encrypts a string with openssl
  def self.openssl(settings)
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
end
