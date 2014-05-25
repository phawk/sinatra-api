# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
HOME_PATH = "/home/vagrant/"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Define the base vm image
  config.vm.box = "phawk/ubuntu-precise-ruby-21"

  # Forwards web traffic to host machine
  config.vm.network :forwarded_port, host: 5050, guest: 5050

  # Sync ssh keys and git config
  # config.ssh.forward_agent = true
  config.vm.synced_folder "~/.dotfiles/", "#{HOME_PATH}.dotfiles"

  # Provision the base image with ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/site.yml"
    ansible.sudo = true
    ansible.skip_tags = ["postgresql", "ruby"]
  end

end
