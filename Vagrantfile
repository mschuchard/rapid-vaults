# RapidVaults: testing gem build, install, and execution
Vagrant.configure(2) do |config|
  config.vm.box = 'debian/bullseye64'

  config.vm.provision 'shell', inline: <<-SHELL
    cd /vagrant
    apt-get install -y ruby-dev gcc libgpgme-dev make pkg-config
    gem build rapid-vaults.gemspec
    gem install --no-document rapid-vaults*.gem
    rm -f rapid-vaults*.gem
    cd /home/vagrant
    /usr/local/bin/rapid-vaults -g -o .
    /usr/local/bin/rapid-vaults -e -k key.txt -n nonce.txt -p password -o . /vagrant/spec/fixtures/file.yaml
    /usr/local/bin/rapid-vaults -d -k key.txt -n nonce.txt -t tag.txt -p password -o . encrypted.txt
  SHELL
end
