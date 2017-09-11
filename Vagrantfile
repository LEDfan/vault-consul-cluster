# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.3"

  config.puppet_install.puppet_version = "3.8.7"

  # if ARGV.include? '--provision-with'
    config.vm.provision "shell", path: "hosts.conf.sh"
  # end

  config.vm.define "consul01" do |consul01|
    consul01.vm.network "private_network", ip: "172.16.25.2"
    consul01.vm.hostname = "consul01.vault-cluster.net"

    consul01.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.options = ['--verbose --parser=future']
      puppet.manifest_file = "consul01.pp"
      puppet.hiera_config_path = "hiera.yaml"
    end
  end

  config.vm.define "consul02" do |consul01|
    consul01.vm.network "private_network", ip: "172.16.25.3"
    consul01.vm.hostname = "consul02.vault-cluster.net"
    consul01.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.options = ['--verbose --parser=future']
      puppet.manifest_file = "consul02.pp"
      puppet.hiera_config_path = "hiera.yaml"
    end
  end

  config.vm.define "consul03" do |consul01|
    consul01.vm.network "private_network", ip: "172.16.25.4"
    consul01.vm.hostname = "consul03.vault-cluster.net"
    consul01.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.options = ['--verbose --parser=future']
      puppet.manifest_file = "consul03.pp"
      puppet.hiera_config_path = "hiera.yaml"
    end
  end

  config.vm.define "vault01" do |consul01|
    consul01.vm.network "private_network", ip: "172.16.25.5"
    consul01.vm.hostname = "vault01.vault-cluster.net"
    consul01.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.options = ['--verbose --parser=future']
      puppet.manifest_file = "vault01.pp"
      puppet.hiera_config_path = "hiera.yaml"
    end
  end

  config.vm.define "vault02" do |consul01|
    consul01.vm.network "private_network", ip: "172.16.25.6"
    consul01.vm.hostname = "vault02.vault-cluster.net"
    consul01.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.options = ['--verbose --parser=future']
      puppet.manifest_file = "vault02.pp"
      puppet.hiera_config_path = "hiera.yaml"
    end
  end

  config.vm.define "bind01" do |consul01|
    consul01.vm.network "private_network", ip: "172.16.25.10"
    consul01.vm.hostname = "bind01.vault-cluster.net"
    consul01.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.options = ['--verbose --parser=future']
      puppet.manifest_file = "bind01.pp"
      puppet.hiera_config_path = "hiera.yaml"
    end
  end


#  config.vm.provision :puppet do |puppet|
#    puppet.module_path = "../modules"
#    puppet.manifests_path = "manifests"
#    puppet.options = ['--verbose']
#    puppet.manifest_file = "default.pp"
#    puppet.hiera_config_path = "hiera.yaml"
#  end

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end

end
