require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/encrypt'
require_relative '../../lib/rapid-vaults/decrypt'

describe Decrypt do
  before(:all) do
    RapidVaults.instance_variable_set(:@settings, ui: :cli, file: "foo: bar\n", key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n")
    Encrypt.main
  end

  after(:all) do
    %w[tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end

  context '.decrypt' do
    it 'outputs a decrypted file with the key, nonce, and tag from the cli' do
      RapidVaults.instance_variable_set(:@settings, ui: :cli, file: File.read('encrypted.txt'), key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n", tag: File.read('tag.txt'))
      Decrypt.main
      expect(File.file?('decrypted.txt')).to be true
      expect(File.read('decrypted.txt')).to eq("foo: bar\n")
    end
    it 'outputs decrypted content with the key, nonce, and tag from the api' do
      RapidVaults.instance_variable_set(:@settings, ui: :api, file: File.read('encrypted.txt'), key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n", tag: File.read('tag.txt'))
      expect(Decrypt.main).to be_a(String)
      expect(Decrypt.main).to eq("foo: bar\n")
    end
    it 'raises an error for an invalid tag size' do
      RapidVaults.instance_variable_set(:@settings, file: File.read('encrypted.txt'), key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n", tag: "�a����e�O_H|�\n")
      expect { Decrypt.main }.to raise_error('Tag is not 16 bytes.')
    end
  end
end
