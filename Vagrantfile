Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.ssh.forward_agent = true


# Variables
INSTANCE_NAME_PREFIX = "k8sv4"
NUM_INSTANCES = 5
KUBE_MASTER_INSTANCES = 2
INVENTORY_FOLDER = "inventory/sample"
ETCD_INSTANCES ||= NUM_INSTANCES
host_vars = {}


# пути к плейбукам
  require 'fileutils'
  PLAYBOOK_PHASE_PATH   = File.join(File.dirname(__FILE__), "ping.yml")




# делаем симлинк с group_vars ансибля в папку вагранта куда он по умолчанию создает файл инвентаря
  require 'fileutils'
  VAGRANT_ANSIBLE   = File.join(File.dirname(__FILE__), ".vagrant", "provisioners", "ansible")
  VAGRANT_INVENTORY = File.join(VAGRANT_ANSIBLE,"inventory")
if ! File.directory?(VAGRANT_INVENTORY)
  FileUtils.mkdir_p(VAGRANT_ANSIBLE)
  FileUtils.ln_s(File.absolute_path(INVENTORY_FOLDER), VAGRANT_INVENTORY)
end






(1..NUM_INSTANCES).each do |i|
  config.vm.define "#{INSTANCE_NAME_PREFIX}-#{i}" do |node|
    node.vm.box_download_insecure = true
    node.vm.box = "hashicorp/bionic64"
    node.vm.network "private_network", ip: "192.168.56.#{i+2}"
    node.vm.hostname = "#{INSTANCE_NAME_PREFIX}-#{i}"
       node.vm.provider "virtualbox" do |v|
         v.name = "#{INSTANCE_NAME_PREFIX}-#{i}"
         v.memory = 1550
         v.cpus = 2
         v.customize ["modifyvm", :id, "--vram", "8"] # ubuntu defaults to 256 MB which is a waste of precious RAM
         v.customize ["modifyvm", :id, "--audio", "none"]
       end


   vm_name="#{INSTANCE_NAME_PREFIX}-#{i}"

   host_vars[vm_name] = {
       "ip" => "192.168.56.#{i+2}",
       "access_ip" => "192.168.56.#{i+2}"
   }



    # Only execute the Ansible provisioner once, when all the machines are up and ready.
    if i == NUM_INSTANCES
       node.vm.provision "ping", type: "ansible" do |ansible|
          ansible.playbook = "#{PLAYBOOK_PHASE_PATH}"
          ansible.become = true
          ansible.limit = "all,localhost"
          ansible.host_key_checking = false
          ansible.host_vars = host_vars
          ansible.raw_arguments = ["--forks=#{NUM_INSTANCES}", "--flush-cache", "-e ansible_ssh_user=vagrant"]
          ansible.groups = {
            "etcd" => ["#{INSTANCE_NAME_PREFIX}-[1:#{ETCD_INSTANCES}]"],
            "kube_control_plane" => ["#{INSTANCE_NAME_PREFIX}-[1:#{KUBE_MASTER_INSTANCES}]"],
            "kube_node" => ["#{INSTANCE_NAME_PREFIX}-[1:#{NUM_INSTANCES}]"],
            "k8s_cluster:children" => ["kube_control_plane", "kube_node"],
          }
        end
     end




  end



end




end
