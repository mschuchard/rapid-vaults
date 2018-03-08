require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/encrypt'

describe Encrypt do
  after(:all) do
    %w[tag.txt encrypted.txt].each { |file| File.delete(file) }
  end

  context '.encrypt' do
    it 'outputs an encrypted file with the key and nonce from the cli' do
      Encrypt.main(ui: :cli, file: "foo: bar\n", key: '���b+����R�v�Í%("����=8o/���', nonce: 'Ëá!í^Uë^EÜ<83>oã^M')
      expect(File.file?('tag.txt')).to be true
      expect(File.file?('encrypted.txt')).to be true
    end
    it 'outputs an encrypted file with the key, nonce, and password from the cli' do
      Encrypt.main(ui: :cli, file: "foo: bar\n", key: '���b+����R�v�Í%("����=8o/���', nonce: 'Ëá!í^Uë^EÜ<83>oã^M', password: 'password')
      expect(File.file?('tag.txt')).to be true
      expect(File.file?('encrypted.txt')).to be true
    end
    it 'outputs an array of encrypted content and tag with the key and nonce from the api' do
      encrypt = Encrypt.main(ui: :api, file: "foo: bar\n", key: '���b+����R�v�Í%("����=8o/���', nonce: 'Ëá!í^Uë^EÜ<83>oã^M')
      expect(encrypt).to be_a(Array)
      expect(encrypt[0]).to be_a(String)
      expect(encrypt[1]).to be_a(String)
      expect(encrypt.length).to eq(2)
    end
  end
end
