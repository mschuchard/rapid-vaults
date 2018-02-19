require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/encrypt'
require_relative '../../lib/rapid-vaults/decrypt'

describe Decrypt do
  before(:all) do
    Encrypt.main(ui: :cli, file: "foo: bar\n", key: '���b+����R�v�Í%("����=8o/���', nonce: 'Ëá!í^Uë^EÜ<83>oã^M')
  end

  after(:all) do
    %w[tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end

  context '.decrypt' do
    it 'outputs a decrypted file with the key, nonce, and tag from the cli' do
      Decrypt.main(ui: :cli, file: File.read('encrypted.txt'), key: '���b+����R�v�Í%("����=8o/���', nonce: 'Ëá!í^Uë^EÜ<83>oã^M', tag: File.read('tag.txt'))
      expect(File.file?('decrypted.txt')).to be true
      expect(File.read('decrypted.txt')).to eq("foo: bar\n")
    end
    it 'outputs decrypted content with the key, nonce, and tag from the api' do
      decrypt = Decrypt.main(ui: :api, file: File.read('encrypted.txt'), key: '���b+����R�v�Í%("����=8o/���', nonce: 'Ëá!í^Uë^EÜ<83>oã^M', tag: File.read('tag.txt'))
      expect(decrypt).to be_a(String)
      expect(decrypt).to eq("foo: bar\n")
    end
    it 'raises an error for an invalid tag size' do
      expect { Decrypt.main(file: File.read('encrypted.txt'), key: '���b+����R�v�Í%("����=8o/���', nonce: 'Ëá!í^Uë^EÜ<83>oã^M', tag: "�a����e�O_H|�\n") }.to raise_error('Tag is not 16 bytes.')
    end
  end
end
