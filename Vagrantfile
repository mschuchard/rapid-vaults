# RapidVaults: testing gem build, install, and execution
Vagrant.configure(2) do |config|
  config.vm.box = 'opensuse/openSUSE-42.2-x86_64'

  config.vm.provision 'shell', inline: <<-SHELL
    cd /vagrant
    zypper install --non-interactive ruby2.1-devel -y
    gem build rapid-vaults.gemspec
    gem install --no-document rubocop -v 0.57.2
    gem install --no-document rapid-vaults*.gem
    rm -f rapid-vaults*.gem
  SHELL
end
