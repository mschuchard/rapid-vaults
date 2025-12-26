require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/encrypt'
require_relative '../../lib/rapid-vaults/decrypt'

describe Decrypt do
  after(:all) do
    %w[tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end

  context '.openssl' do
    require 'openssl'
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    key = cipher.random_key
    nonce = cipher.random_iv

    before(:all) do
      Encrypt.openssl(ui: :cli, file: "foo: bar\n", key: key, nonce: nonce, outdir: Dir.pwd)
    end

    it 'outputs a decrypted file with the key, nonce, and tag from the cli' do
      Decrypt.openssl(ui: :cli, file: File.read('encrypted.txt'), key: key, nonce: nonce, tag: File.read('tag.txt'), outdir: Dir.pwd)
      expect(File.file?('decrypted.txt')).to be true
      expect(File.read('decrypted.txt')).to eq("foo: bar\n")
    end
    it 'outputs decrypted content with the key, nonce, and tag from the api' do
      decrypt = Decrypt.openssl(ui: :api, file: File.read('encrypted.txt'), key: key, nonce: nonce, tag: File.read('tag.txt'), outdir: Dir.pwd)
      expect(decrypt).to be_a(String)
      expect(decrypt).to eq("foo: bar\n")
    end
  end

  context '.gpgme' do
    before(:all) do
      Encrypt.gpgme(ui: :cli, file: "foo: bar\n", key: '', pw: 'foo', outdir: Dir.pwd, force: true)
    end

    it 'outputs a decrypted file with the key from the cli' do
      Decrypt.gpgme(ui: :cli, file: File.read('encrypted.txt'), key: '', pw: 'foo', outdir: Dir.pwd, force: true)
      expect(File.file?('decrypted.txt')).to be true
      expect(File.read('decrypted.txt')).to eq("foo: bar\n")
    end
    it 'outputs decrypted content with the key from the api' do
      decrypt = Decrypt.gpgme(ui: :api, file: File.read('encrypted.txt'), key: '', pw: 'foo', outdir: Dir.pwd)
      expect(decrypt).to be_a(String)
      expect(decrypt).to eq("foo: bar\n")
    end
  end
end
