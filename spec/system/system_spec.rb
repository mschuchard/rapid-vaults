require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/cli'
require_relative '../../lib/rapid-vaults/api'

describe RapidVaults do
  after(:all) do
    require 'fileutils'

    %w[key.txt nonce.txt tag.txt encrypted.txt decrypted.txt chef.rb puppet_gpg_decrypt.rb puppet_gpg_encrypt.rb puppet_ssl_decrypt.rb puppet_ssl_encrypt.rb].each { |file| File.delete(file) }
    unless ENV['TRAVIS'] == 'true' || ENV['CIRCLECI'] == 'true' || ENV['GITHUB_ACTIONS'] == 'true'
      %w[random_seed pubring.kbx trustdb.gpg pubring.kbx~].each { |file| File.delete(file) }
      %w[openpgp-revocs.d private-keys-v1.d].each { |dir| FileUtils.rm_r(dir) }
    end
  end

  context 'executed with openssl algorithm as a system from the CLI with settings and a file to be processed' do
    it 'generates key and nonce, encrypts a file, and then decrypts a file in order' do
      # generate and utilize files inside suitable directory
      Dir.chdir(fixtures_dir)

      # generate key and nonce
      RapidVaults::CLI.main(%w[-g])
      expect(File.file?('key.txt')).to be true
      expect(File.file?('nonce.txt')).to be true

      # generate encrypted file
      RapidVaults::CLI.main(%w[-e -k key.txt -n nonce.txt -p password file.yaml])
      expect(File.file?('tag.txt')).to be true
      expect(File.file?('encrypted.txt')).to be true

      # generate decrypted file
      RapidVaults::CLI.main(%w[-d -k key.txt -n nonce.txt -t tag.txt -p password encrypted.txt])
      expect(File.file?('decrypted.txt')).to be true
      expect(File.read('decrypted.txt')).to eq("foo: bar\n")
    end
  end

  context 'executed with openssl algorithm as a system from the API with settings and a file to be processed' do
    it 'generates key and nonce, encrypts a file, and then decrypts a file in order' do
      # generate and utilize files inside suitable directory
      Dir.chdir(fixtures_dir)

      # generate key and nonce
      RapidVaults::API.main(action: :generate)
      expect(File.file?('key.txt')).to be true
      expect(File.file?('nonce.txt')).to be true

      # generate encrypted file
      encrypt, tag = RapidVaults::API.main(action: :encrypt, file: 'file.yaml', key: 'key.txt', nonce: 'nonce.txt', pw: 'foo')
      expect(encrypt).to be_a(String)
      expect(tag).to be_a(String)

      # generate decrypted file
      File.write('encrypted.txt', encrypt)
      File.write('tag.txt', tag)
      decrypt = RapidVaults::API.main(action: :decrypt, file: 'encrypted.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt', pw: 'foo')
      expect(decrypt).to be_a(String)
      expect(decrypt).to eq("foo: bar\n")
    end
  end

  # all three ci cannot support end-to-end gpg generate/encrypt/decrypt
  unless ENV['TRAVIS'] == 'true' || ENV['CIRCLECI'] == 'true' || ENV['GITHUB_ACTIONS'] == 'true'
    context 'executed wtih gpg algorithm as a system from the CLI with settings and a file to be processed' do
      it 'encrypts a file and then decrypts a file in order' do
        ENV['GNUPGHOME'] = fixtures_dir

        # generate and utilize files inside suitable directory
        Dir.chdir(fixtures_dir)

        puts fixtures_dir

        # generate keys
        RapidVaults::CLI.main(%w[-g --gpg --gpgparams gpgparams.txt])
        %w[trustdb.gpg pubring.kbx pubring.kbx~].each { |file| expect(File.file?("#{fixtures_dir}/#{file}")).to be true }
        %w[openpgp-revocs.d private-keys-v1.d].each { |dir| expect(File.directory?("#{fixtures_dir}/#{dir}")).to be true }

        # generate encrypted file
        RapidVaults::CLI.main(%w[--gpg -e -p foo file.yaml])
        expect(File.file?('encrypted.txt')).to be true

        # generate decrypted file
        RapidVaults::CLI.main(%w[--gpg -d -p foo encrypted.txt])
        expect(File.file?('decrypted.txt')).to be true
        expect(File.read('decrypted.txt')).to eq("foo: bar\n")
      end
    end

    context 'executed with gpg algorithm as a system from the API with settings and a file to be processed' do
      it 'encrypts a file and then decrypts a file in order' do
        ENV['GNUPGHOME'] = fixtures_dir

        # generate and utilize files inside suitable directory
        Dir.chdir(fixtures_dir)

        # generate keys
        RapidVaults::API.main(action: :generate, algorithm: :gpgme, gpgparams: File.read('gpgparams.txt'))
        %w[trustdb.gpg pubring.kbx pubring.kbx~].each { |file| expect(File.file?("#{fixtures_dir}/#{file}")).to be true }
        %w[openpgp-revocs.d private-keys-v1.d].each { |dir| expect(File.directory?("#{fixtures_dir}/#{dir}")).to be true }

        # generate encrypted file
        encrypt = RapidVaults::API.main(algorithm: :gpgme, action: :encrypt, file: 'file.yaml', pw: 'password')
        expect(encrypt).to be_a(String)

        # generate decrypted file
        File.write('encrypted.txt', encrypt)
        decrypt = RapidVaults::API.main(algorithm: :gpgme, action: :decrypt, file: 'encrypted.txt', pw: 'password')
        expect(decrypt).to be_a(String)
        expect(decrypt).to eq("foo: bar\n")
      end
    end
  end

  context 'executed as a system to output bindings from the CLI' do
    it 'outputs the puppet and chef bindings' do
      # generate and utilize files inside suitable directory
      Dir.chdir(fixtures_dir)

      # generate bindings
      RapidVaults::CLI.main(%w[-b puppet])
      RapidVaults::CLI.main(%w[-b chef])

      %w[chef.rb puppet_gpg_decrypt.rb puppet_gpg_encrypt.rb puppet_ssl_decrypt.rb puppet_ssl_encrypt.rb].each { |file| expect(File.file?(file)).to be true }
    end
  end
end
