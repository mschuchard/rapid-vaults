require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/encrypt'
require_relative '../../lib/rapid-vaults/decrypt'

describe Decrypt do
  context '.openssl' do
    require 'openssl'
    require 'securerandom'
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    key = cipher.random_key
    nonce = cipher.random_iv

    before(:all) do
      Encrypt.openssl(ui: :cli, file: "foo: bar\n", key: key, nonce: nonce)
    end

    after(:all) do
      %w[tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
    end

    it 'outputs a decrypted file with the key, nonce, and tag from the cli' do
      Decrypt.openssl(ui: :cli, file: File.read('encrypted.txt'), key: key, nonce: nonce, tag: File.read('tag.txt'))
      expect(File.file?('decrypted.txt')).to be true
      expect(File.read('decrypted.txt')).to eq("foo: bar\n")
    end
    it 'outputs decrypted content with the key, nonce, and tag from the api' do
      decrypt = Decrypt.openssl(ui: :api, file: File.read('encrypted.txt'), key: key, nonce: nonce, tag: File.read('tag.txt'))
      expect(decrypt).to be_a(String)
      expect(decrypt).to eq("foo: bar\n")
    end
    it 'raises an error for an invalid tag size' do
      expect { Decrypt.openssl(file: File.read('encrypted.txt'), key: key, nonce: nonce, tag: SecureRandom.random_bytes(24).strip) }.to raise_error('Tag is not 16 bytes.')
    end
    it 'raises an error for an invalid key size' do
      expect { Decrypt.openssl(key: SecureRandom.random_bytes(64).strip) }.to raise_error('The key is not a valid 32 byte key.')
    end
    it 'raises an error for an invalid nonce size' do
      expect { Decrypt.openssl(key: key, nonce: SecureRandom.random_bytes(24).strip) }.to raise_error('The nonce is not a valid 12 byte nonce.')
    end
    it 'raises an error for corrupted encrypted file content' do
      expect { Decrypt.openssl(file: SecureRandom.random_bytes(16).strip, key: key, nonce: nonce) }.to raise_error('The encrypted data is not a valid multiple of 9 bytes.')
    end
  end

  # travis ci cannot support non-interactive gpg encryption
  unless ENV['TRAVIS'] == 'true'
    context '.gpgme' do
      before(:all) do
        Encrypt.gpgme(ui: :cli, file: "foo: bar\n", key: '', pw: 'foo')
      end

      after(:all) do
        %w[encrypted.txt decrypted.txt].each { |file| File.delete(file) }
      end

      it 'outputs a decrypted file with the key from the cli' do
        Decrypt.gpgme(ui: :cli, file: File.read('encrypted.txt'), key: '', pw: 'foo')
        expect(File.file?('decrypted.txt')).to be true
        expect(File.read('decrypted.txt')).to eq("foo: bar\n")
      end
      it 'outputs decrypted content with the key from the api' do
        decrypt = Decrypt.gpgme(ui: :api, file: File.read('encrypted.txt'), key: '', pw: 'foo')
        expect(decrypt).to be_a(String)
        expect(decrypt).to eq("foo: bar\n")
      end
    end
  end
end
