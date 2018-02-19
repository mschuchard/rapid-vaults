require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/encrypt'

describe Encrypt do
  after(:all) do
    %w[tag.txt encrypted.txt].each { |file| File.delete(file) }
  end

  context '.encrypt' do
    it 'outputs an encrypted file with the key and nonce from the cli' do
      RapidVaults.instance_variable_set(:@settings, ui: :cli, file: "foo: bar\n", key: '%+�R`��Znv���[�Sz�(�C`��m�', nonce: 'y�[�H���K��')
      Encrypt.main
      expect(File.file?('tag.txt')).to be true
      expect(File.file?('encrypted.txt')).to be true
    end
    it 'outputs an array of encrypted content and tag with the key and nonce from the api' do
      RapidVaults.instance_variable_set(:@settings, ui: :api, file: "foo: bar\n", key: '%+�R`��Znv���[�Sz�(�C`��m�', nonce: 'y�[�H���K��')
      expect(Encrypt.main).to be_a(Array)
      expect(Encrypt.main[0]).to be_a(String)
      expect(Encrypt.main[1]).to be_a(String)
      expect(Encrypt.main.length).to eq(2)
    end
  end
end
