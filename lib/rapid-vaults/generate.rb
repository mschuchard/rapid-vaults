class Generate
  # generates a key and nonce
  def self.generate
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    File.write('key.txt', cipher.random_key)
    File.write('nonce.txt', cipher.random_iv)
    puts 'Your key.txt and nonce.txt have been generated in your current directory.'
  end
end
