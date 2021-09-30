require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/encrypt'

describe Encrypt do
  context '.openssl' do
    # circumvent ruby > 2.3 and 2.2 issues with proper byte size interpretation
    require 'securerandom'
    key = SecureRandom.random_bytes(32).strip
    nonce = SecureRandom.random_bytes(12).strip

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

  # travis ci cannot support non-interactive gpg encryption
  unless File.directory?('/home/travis')
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
end
