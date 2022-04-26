# Rapid Vaults
[![Build Status](https://travis-ci.org/mschuchard/rapid-vaults.svg?branch=master)](https://travis-ci.org/mschuchard/rapid-vaults)
[![CircleCI](https://circleci.com/gh/mschuchard/rapid-vaults.svg?style=svg)](https://circleci.com/gh/mschuchard/rapid-vaults)

- [Description](#description)
- [Usage](#usage)
  - [CLI](#cli)
  - [API](#api)
  - [gRPC](#grpc)
  - [Docker](#docker)
  - [Ansible](#ansible)
  - [Puppet](#puppet)
  - [Chef](#chef)
- [Contributing](#contributing)

## Description

Rapid Vaults is a gem that performs ad-hoc encryption and decryption of data behind multiple layers of protection via OpenSSL or GPG. It is lightweight and easy-to-use software to secure and retrieve your data with multiple layers of defense and verification.

### Comparative Software

Ansible-Vault is very similar to Rapid Vaults. Both are streamlined and easy to use ad-hoc encryption and decryption tools. The two primary differences are that Rapid Vaults has a Ruby API instead of a Python API and that Rapid Vaults offers additional verification and defense layers. The API can also be considered similar to the high level recipes provided by PyCA's Cryptography.

### Non-Comparative Software

Rapid Vaults is not similar to tools like RbNaCl or Hashicorp's Vault. RbNaCl offers advanced encryption techniques by providing bindings to libsodium. Rapid Vaults relies upon AES-256-GCM (OpenSSL) or GPG's algorithms (RSA, SHA-512, etc.). Hashicorp's Vault is Enterprise level software with many powerful features and conveniences. Rapid Vaults is a lightweight and narrowly focused tool. However, Rapid Vaults can be considered algorithmically very similar to Vault's Transit secret engine.

## Usage

### CLI

Note trailing information for each flag/argument for possible differences with utilizing GPG.

```
usage: rapid-vaults [options] file
        --gpg                        Use GNUPG/GPG instead of GNUTLS/OpenSSL for encryption/decryption.
    -g, --generate                   Generate a key and nonce for encryption and decryption (GPG: keys only).
    -e, --encrypt                    Encrypt a file using a key and nonce and generate a tag (GPG: key and pw only).
    -d, --decrypt                    Decrypt a file using a key, nonce, and tag (GPG: key and pw only).
    -k, --key key                    Key file to be used for encryption or decryption. (GPG: use GNUPGHOME)
    -n, --nonce nonce                Nonce file to be used for encryption or decryption (GPG: n/a).
    -t, --tag tag                    Tag file to be used for decryption (GPG: n/a).
    -p, --password password          (optional) Password to be used for encryption or decryption (GPG: required).
    -f, --file-password password.txt (optional) Text file containing a password to be used for encryption or decryption (GPG: required).
    -b, --binding binding            Output files to support bindings for other software languages.
    --gpgparams                      GPG Key params input file used during generation of keys.
    -o --outdir                      Optional output directory for generated files (default: pwd). (GPG: optional)
```

#### Generate Key and Nonce with SSL
`rapid-vaults -g`

#### Encrypt File with SSL

`rapid-vaults -e -k cert.key -n nonce.txt -p secret -o /output/dir unencrypted.txt`

#### Decrypt a File with SSL

`rapid-vaults -d -k cert.key -n nonce.txt -t tag.txt -p secret -o /output/dir encrypted.txt`

#### Generate Keys with GPG
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

`rapid-vaults --gpg -e -p password -o /output/dir unencrypted.txt`

#### Decrypt a File with GPG
Currently you set the path to the keys and other files via the environment variable `GNUPGHOME` prior to executing. Otherwise, the code will look in the default directory for the current user.

`rapid-vaults --gpg -d -p password -o /output/dir encrypted.txt`

#### Output a Binding

`rapid-vaults -b puppet -o /output/dir`  
`rapid-vaults -b chef -o /path/to/outdir`

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
options[:file] = '/path/to/encrypted_data.txt'
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
options[:gpgparams] = File.read('gpgparams.txt')
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

ENV['GNUPGHOME'] = '/home/bob/.gnupg' # optional

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

ENV['GNUPGHOME'] = '/home/chris/.gnupg' # optional

options = {}
options[:action] = :decrypt
options[:algorithm] = :gpgme
options[:file] = '/path/to/encrypted_data.txt'
options[:pw] = File.read('/path/to/password.txt')
decrypted_contents = RapidVaults::API.main(options)
```

### Docker

A supported [Docker image](https://hub.docker.com/r/matthewschuchard/rapid-vaults) of Rapid-Vaults is now available from the public Docker Hub registry. Please consult the repository documentation for further usage information.

### gRPC

forthcoming

### Ansible

forthcoming

### Puppet

Puppet bindings are presented as a 2x2 matrix of custom functions for encryption/decryption and SSL/GPG. The custom functions require a non-obsolete version of Puppet. Documentation pertaining to their usage is done via Puppet Strings within the functions. It is highly recommended to wrap the output of the decryption functions within a `Sensitive` data type so that decrypted secrets are not shown in logs.

### Chef

Chef can access Rapid Vaults directly through the native Ruby API. Therefore, the Chef bindings are presented as example methods for doing so.

## Contributing
Code should pass all spec tests. New features should involve new spec tests. Adherence to Rubocop and Reek is expected where not overly onerous or where the check is of dubious cost/benefit.

A [Dockerfile](Dockerfile) is provided for easy rake testing. A [Vagrantfile](Vagrantfile) is provided for easy gem building, installation, and post-installation testing.

Please consult the GitHub Project for the current development roadmap.
