require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/cli'

describe RapidVaults::CLI do
  context '.parse' do
    it 'correctly parses the arguments for gpg' do
      expect(RapidVaults::CLI.parse(%w[--gpg])).to eq(algorithm: :gpgme, ui: :cli)
    end
    it 'correctly parses the user arguments for encrypt' do
      expect(RapidVaults::CLI.parse(%w[-e -k key.txt -n nonce.txt -p secret file.txt])).to eq(ui: :cli, action: :encrypt, key: 'key.txt', nonce: 'nonce.txt', pw: 'secret')
    end
    it 'correctly parses the arguments for decrypt' do
      expect(RapidVaults::CLI.parse(%w[-d -k key.txt -n nonce.txt -t tag.txt -p secret file.txt])).to eq(ui: :cli, action: :decrypt, key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt', pw: 'secret')
    end
    it 'correctly parses the arguments for openssl generate' do
      expect(RapidVaults::CLI.parse(%w[-g -o .])).to eq(ui: :cli, action: :generate, outdir: '.')
    end
    it 'correctly parses the arguments for gpg generate' do
      expect(RapidVaults::CLI.parse(%W[--gpg -g --gpgparams #{fixtures_dir}/file.yaml])).to eq(algorithm: :gpgme, ui: :cli, action: :generate, gpgparams: "foo: bar\n")
    end
    it 'correctly parses the arguments for puppet integrations' do
      expect(RapidVaults::CLI.parse(%w[--puppet -o .])).to eq(ui: :cli, action: :integrate, integrate: :puppet, outdir: '.')
    end
    it 'raises an error for a nonexistent gpg parameters file' do
      expect { RapidVaults::CLI.parse(%w[--gpg -g --gpgparams /foo/bar]) }.to raise_error('GPG Parameters file /foo/bar is not an existing file!')
    end
  end
end
