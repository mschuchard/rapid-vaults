# Rapid Vaults
Currently in beta and can be used without expectation of support.

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

#### Generate Key and Nonce
`rapid-vaults -g`

#### Encrypt File with SSL

`rapid-vaults -e -k cert.key -n nonce.txt unencrypted.txt`

#### Decrypt a File with SSL

`rapid-vaults -d -k cert.key -n nonce.txt -t tag.txt encrypted.txt`

### API

#### Generate Key and Nonce

```ruby
require 'rapid-vaults'

options = {}
options[:action] = :generate
key, nonce = RapidVaults::API.main(options)
```

#### Encrypt with SSL

```ruby
require 'rapid-vaults'

options = {}
options[:action] = :encrypt
options[:file] = '/path/to/data.txt'
options[:key] = '/path/to/cert.key'
options[:nonce] = '/path/to/nonce.txt'
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
decrypted_contents = RapidVaults::API.main(options)
```

## Contributing
Code should pass all spec tests. New features should involve new spec tests. Adherence to Rubocop and Reek is expected where not overly onerous or where the check is of dubious cost/benefit.

A [Dockerfile](Dockerfile) is provided for easy rake testing. A [Vagrantfile](Vagrantfile) is provided for easy gem building, installation, and post-installation testing.
