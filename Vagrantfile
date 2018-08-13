# RapidVaults: testing gem build, install, and execution
Vagrant.configure(2) do |config|
  config.vm.box = 'opensuse/openSUSE-42.2-x86_64'

  config.vm.provision 'shell', inline: <<-SHELL
    cd /vagrant
    zypper --non-interactive install ruby2.1-devel
    gem build rapid-vaults.gemspec
    gem install --no-document rapid-vaults*.gem
    rm -f rapid-vaults*.gem
    cd /home/vagrant
    /usr/bin/rapid-vaults.ruby2.1 -g -o .
    /usr/bin/rapid-vaults.ruby2.1 -e -k key.txt -n nonce.txt -p password -o . /vagrant/spec/fixtures/file.yaml
    /usr/bin/rapid-vaults.ruby2.1 -d -k key.txt -n nonce.txt -t tag.txt -p password -o . encrypted.txt
  SHELL
end
