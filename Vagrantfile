# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'mapr_installation'
  file_to_disk = "./node-1-disk.vdi"

  

  config.vm.provider "virtualbox" do | v |
    v.memory = 1024 * 4

    unless File.exist?(file_to_disk)
      v.customize ['createhd', '--filename', file_to_disk,
                   '--size', 500 * 1024]
    end

    v.customize [
      'storageattach', :id, '--storagectl', 'IDE Controller',
      '--port', 1, '--device', 0, '--type', 'hdd', '--medium',
      file_to_disk
    ]
  end

  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = 'latest'
  end

  config.vm.box = 'chef/centos-6.6'
  config.vm.network :private_network, ip: "10.1.1.10"
  config.vm.hostname = "node-1"
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "java" => {
        "version" => "java-1.8.0-openjdk-devel",
        "home" => "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.51-1.b16.el6_7.x86_64/"
      },
      "mapr" => {
        "cluster_node_ips" => ["10.1.1.10"],
        "node_count" => '1',
        "cldb_ips" => ["10.1.1.10"],
        "zk_ips" => ["10.1.1.10"],
        "rm_ips" => ["10.1.1.10"],
        "hs_ips" => "10.1.1.10",
        "ws_ips" => ["10.1.1.10"],

        "cluster_nodes" => ["node-1"],
        "cldb" => ["node-1"],
        "zk" => ["node-1"],
        "rm" => ["node-1"],
        "hs" => "node-1",
        "ws" => ["node-1"]

      }
    }

    chef.run_list = [
      'recipe[mapr_installation::default]'
    ]
  end
end
