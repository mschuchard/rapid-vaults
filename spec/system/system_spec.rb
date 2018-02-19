require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/cli'
require_relative '../../lib/rapid-vaults/api'

describe RapidVaults do
  after(:all) do
    %w[key.txt nonce.txt tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end

  context 'executed as a system from the CLI with settings and a file to be processed' do
    it 'generates key and nonce, encrypts a file, and then decrypts a file in order' do
      # generate and utilize files inside suitable directory
      Dir.chdir(fixtures_dir)

      # generate key and nonce
      RapidVaults::CLI.main(%w[-g])
      expect(File.file?('key.txt')).to be true
      expect(File.file?('nonce.txt')).to be true

      # generate encrypted file
      RapidVaults::CLI.main(%w[-e -k key.txt -n nonce.txt file.yaml])
      expect(File.file?('tag.txt')).to be true
      expect(File.file?('encrypted.txt')).to be true

      # generate decrypted file
      RapidVaults::CLI.main(%w[-d -k key.txt -n nonce.txt -t tag.txt encrypted.txt])
      expect(File.file?('decrypted.txt')).to be true
      expect(File.read('decrypted.txt')).to eq("foo: bar\n")
    end
  end

  context 'executed as a system from the API with settings and a file to be processed' do
    it 'generates key and nonce, encrypts a file, and then decrypts a file in order' do
      # generate and utilize files inside suitable directory
      Dir.chdir(fixtures_dir)

      # generate key and nonce
      RapidVaults::API.main(action: :generate)
      expect(File.file?('key.txt')).to be true
      expect(File.file?('nonce.txt')).to be true

      # generate encrypted file
      encrypt, tag = RapidVaults::API.main(action: :encrypt, file: 'file.yaml', key: 'key.txt', nonce: 'nonce.txt')
      expect(encrypt).to be_a(String)
      expect(tag).to be_a(String)

      # generate decrypted file
      File.write('encrypted.txt', encrypt)
      File.write('tag.txt', tag)
      decrypt = RapidVaults::API.main(action: :decrypt, file: 'encrypted.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt')
      expect(decrypt).to eq("foo: bar\n")
    end
  end
end
