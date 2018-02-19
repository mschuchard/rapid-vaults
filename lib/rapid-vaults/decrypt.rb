require 'openssl'

class Decrypt
  # decrypts a string
  def self.main(settings)
    # check tag size
    raise 'Tag is not 16 bytes.' unless settings[:tag].bytesize == 16

    # setup the decryption parameters
    decipher = OpenSSL::Cipher.new('aes-256-gcm').decrypt
    decipher.key = settings[:key]
    decipher.iv = settings[:nonce]
    decipher.auth_tag = settings[:tag]
    decipher.auth_data = ''

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
end
