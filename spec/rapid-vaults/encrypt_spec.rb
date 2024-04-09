require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/encrypt'

describe Encrypt do
  context '.openssl' do
    require 'openssl'
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    key = cipher.random_key
    nonce = cipher.random_iv

    after(:all) do
      %w[tag.txt encrypted.txt].each { |file| File.delete(file) }
    end

    it 'outputs an encrypted file with the key and nonce from the cli' do
      Encrypt.openssl(ui: :cli, file: "foo: bar\n", key: key, nonce: nonce)
      expect(File.file?('tag.txt')).to be true
      expect(File.file?('encrypted.txt')).to be true
    end
    it 'outputs an encrypted file with the key, nonce, and password from the cli' do
      Encrypt.openssl(ui: :cli, file: "foo: bar\n", key: key, nonce: nonce, pw: 'password')
      expect(File.file?('tag.txt')).to be true
      expect(File.file?('encrypted.txt')).to be true
    end
    it 'outputs an array of encrypted content and tag with the key and nonce from the api' do
      encrypt = Encrypt.openssl(ui: :api, file: "foo: bar\n", key: key, nonce: nonce)
      expect(encrypt).to be_a(Array)
      expect(encrypt[0]).to be_a(String)
      expect(encrypt[1]).to be_a(String)
      expect(encrypt.length).to eq(2)
    end
  end

  context '.gpgme' do
    it 'outputs an encrypted file with the key from the cli' do
      Encrypt.gpgme(ui: :cli, file: "foo: bar\n", key: '', pw: 'foo')
      expect(File.file?('encrypted.txt')).to be true
    end
    it 'outputs a string of encrypted content with the key from the api' do
      encrypt = Encrypt.gpgme(ui: :api, file: "foo: bar\n", key: '', pw: 'foo')
      expect(encrypt).to be_a(String)
    end
  end
end
