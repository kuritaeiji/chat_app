Vagrant.configure("2") do |config|
  config.vm.box = 'bento/ubuntu-18.04'

  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.network 'forwarded_port', guest: 3035, host: 3035
  config.vm.network 'forwarded_port', guest: 587,  host: 587
  config.vm.synced_folder '.', '/home/vagrant/rails_vue'
end