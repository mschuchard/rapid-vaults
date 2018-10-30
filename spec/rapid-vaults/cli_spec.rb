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
    it 'correctly parses the arguments for puppet bindings' do
      expect(RapidVaults::CLI.parse(%w[-b puppet -o .])).to eq(ui: :cli, action: :binding, binding: :puppet, outdir: '.')
    end
    it 'raises an error for a nonexistent password file' do
      expect { RapidVaults::CLI.parse(%w[-f /nopasswordhere]) }.to raise_error('Password file /nopasswordhere is not an existing file!')
    end
    it 'raises an error for a nonexistent gpg parameters file' do
      expect { RapidVaults::CLI.parse(%w[--gpgparams /foo/bar]) }.to raise_error('GPG Parameters file /foo/bar is not an existing file!')
    end
    it 'raises an error for a nonexistent output directory' do
      expect { RapidVaults::CLI.parse(%w[-o /foo/bar/baz]) }.to raise_error('The output directory /foo/bar/baz does not exist or is not a directory!')
    end
  end
end
