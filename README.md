# Rapid Vaults
[![Build Status](https://travis-ci.org/mschuchard/rapid-vaults.svg?branch=master)](https://travis-ci.org/mschuchard/rapid-vaults)

- [Description](#description)
- [Usage](#usage)
  - [CLI](#cli)
  - [API](#api)
- [Contributing](#contributing)

## Description

Rapid Vaults is a gem that performs ad-hoc encryption and decryption of data behind multiple layers of protection via OpenSSL or GPG. It is lightweight and easy-to-use software to secure and retrieve your data with multiple layers of defense and verification.

### Comparative Software

Ansible-Vault is very similar to Rapid Vaults. Both are streamlined and easy to use ad-hoc encryption and decryption tools. The two primary differences are that Rapid Vaults has a Ruby API instead of a Python API and that Rapid Vaults offers additional verification and defense layers. The API can also be considered similar to the high level recipes provided by PyCA's Cryptography.

### Non-Comparative Software

Rapid Vaults is not similar to tools like RbNaCl or Hashicorp's Vault. RbNaCl offers advanced encryption techniques by providing bindings to libsodium. Rapid Vaults relies upon AES-256-GCM or GPG. Hashicorp's Vault is Enterprise level software with many powerful features and conveniences. Rapid Vaults is a lightweight and narrowly focused tool.

## Usage

### CLI

Note trailing information for each flag/argument for possible differences with utilizing GPG.

```
usage: rapid-vaults [options] file
        --gpg                        Use GNUPG/GPG instead of GNUTLS/OpenSSL for encryption/decryption.
    -g, --generate                   Generate a key and nonce for encryption and decryption (GPG: n/a).
    -e, --encrypt                    Encrypt a file using a key and nonce and generate a tag (GPG: key only).
    -d, --decrypt                    Decrypt a file using a key, nonce, and tag (GPG: key only).
    -k, --key key                    Key file to be used for encryption or decryption.
    -n, --nonce nonce                Nonce file to be used for encryption or decryption (GPG: n/a).
    -t, --tag tag                    Tag file to be used for decryption (GPG: n/a).
    -p, --password password          (optional) Password to be used for encryption or decryption (GPG: required).').
    -f, --file-password password.txt (optional) Text file containing a password to be used for encryption or decryption (GPG: required).').
    --gpgparams                      GPG Key params input file used during generation of keys.
```

#### Generate Key and Nonce
`rapid-vaults -g`

#### Encrypt File with SSL

`rapid-vaults -e -k cert.key -n nonce.txt -p secret unencrypted.txt`

#### Decrypt a File with SSL

`rapid-vaults -d -k cert.key -n nonce.txt -t tag.txt -p secret encrypted.txt`

#### Generate Key with GPG
This is the only situation where a `--gpgparams` flag and argument is required or utilized. The file provided as the argument should look like the following:

```
<GnupgKeyParms format="internal">
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: Joe Tester
Name-Comment: with stupid passphrase
Name-Email: joe@foo.bar
Expire-Date: 0
Passphrase: abc
</GnupgKeyParms>
```

The environment variable `GNUPGHOME` must be set in the shell prior to generating the keys (`export GNUPGHOME=`). This establishes the home directory for the keys and support files. This should normally be a `/user_home_dir/.gnupg`.

#### Encrypt File with GPG
Currently you set the path to the keys and other files via the environment variable `GNUPGHOME` prior to executing. Otherwise, the code will look in the default directory for the current user.

`rapid-vaults --gpg -e -p password unencrypted.txt`

#### Decrypt a File with GPG
Currently you set the path to the keys and other files via the environment variable `GNUPGHOME` prior to executing. Otherwise, the code will look in the default directory for the current user.

`rapid-vaults --gpg -d -p password encrypted.txt`

### API

#### Generate SSL Key and Nonce

```ruby
require 'rapid-vaults'

options = {}
options[:action] = :generate
key, nonce = RapidVaults::API.main(options)
File.write('key.txt', key)
File.write('nonce.txt', nonce)
```

#### Encrypt with SSL

```ruby
require 'rapid-vaults'

options = {}
options[:action] = :encrypt
options[:file] = '/path/to/data.txt'
options[:key] = '/path/to/cert.key'
options[:nonce] = '/path/to/nonce.txt'
options[:pw] = File.read('/path/to/password.txt') # optional
encrypted_contents, tag = RapidVaults::API.main(options)
```

#### Decrypt with SSL

```ruby
require 'rapid-vaults'

options = {}
options[:action] = :decrypt
options[:file] = '/path/to/data.txt'
options[:key] = '/path/to/cert.key'
options[:nonce] = '/path/to/nonce.txt'
options[:tag] = '/path/to/tag.txt'
options[:pw] = File.read('/path/to/password.txt') # optional
decrypted_contents = RapidVaults::API.main(options)
```

#### Generate GPG Keys
```ruby
require 'rapid-vaults'

ENV['GNUPGHOME'] = '/home/alice/.gnupg'

options = {}
options[:action] = :generate
options[:algorithm] = :gpgme
options[:gpgparams] = gpgparams: File.read('gpgparams.txt')
RapidVaults::API.main(options)
```

The `:gpgparams` string should look like the following:

```
<GnupgKeyParms format="internal">
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: Joe Tester
Name-Comment: with stupid passphrase
Name-Email: joe@foo.bar
Expire-Date: 0
Passphrase: abc
</GnupgKeyParms>
```

#### Encrypt with GPG

```ruby
require 'rapid-vaults'

ENV['GNUPGHOME'] = '/home/bob/.gnupg'

options = {}
options[:action] = :encrypt
options[:algorithm] = :gpgme
options[:file] = '/path/to/data.txt'
options[:pw] = File.read('/path/to/password.txt')
encrypted_contents = RapidVaults::API.main(options)
```

#### Decrypt with GPG

```ruby
require 'rapid-vaults'

ENV['GNUPGHOME'] = '/home/chris/.gnupg'

options = {}
options[:action] = :decrypt
options[:algorithm] = :gpgme
options[:file] = '/path/to/data.txt'
options[:pw] = File.read('/path/to/password.txt')
decrypted_contents = RapidVaults::API.main(options)
```

## Contributing
Code should pass all spec tests. New features should involve new spec tests. Adherence to Rubocop and Reek is expected where not overly onerous or where the check is of dubious cost/benefit.

A [Dockerfile](Dockerfile) is provided for easy rake testing. A [Vagrantfile](Vagrantfile) is provided for easy gem building, installation, and post-installation testing.
