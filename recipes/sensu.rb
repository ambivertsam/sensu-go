
package node['monitor']['ep'] do
  action :install
end

package node['monitor']['er'] do
  action :install
end

package node['monitor']['rd'] do
  action :install
end

service node['monitor']['rd'] do
  action [:enable, :start]
end
 
package node['monitor']['rabbit'] do
  action :install
end

service node['monitor']['rabbit'] do
  action [:enable, :start]
end

bash "installing sensu backend" do
  code <<-EOH
    cd /home/vagrant
    curl -s https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh | sudo bash
    touch a.txt
  EOH
  not_if{ ::File.exist? '/home/vagrant/a.txt' }
end

package 'sensu-go-backend' do
  action :install
end

bash "configuration file" do
  code <<-EOH
    curl -Lk https://docs.sensu.io/sensu-go/latest/files/backend.yml -o /etc/sensu/backend.yml
  EOH
  not_if{ ::File.exist? '/etc/sensu/backend.yml' }
end

service 'sensu-backend' do
  action [:enable, :start]
end

bash 'setting admin and password' do
  code <<-EOH
    export SENSU_BACKEND_CLUSTER_ADMIN_USERNAME=sensu
    export SENSU_BACKEND_CLUSTER_ADMIN_PASSWORD=sensu
    /usr/sbin/sensu-backend init
    cd /home/vagrant
    touch b
  EOH
  not_if{ ::File.exist? '/home/vagrant/b' }
end

bash "installing sensuctl" do
  code <<-EOH
    cd /home/vagrant
    curl https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh | sudo bash
    touch c.txt
  EOH
  not_if{ ::File.exist? '/home/vagrant/c.txt' }
end

package'sensu-go-cli' do
  action :install
end

bash "configuring file" do
  code <<-EOH
    sensuctl configure -n \
    --username 'sensu' \
    --password 'sensu' \
    --namespace default \
    --url 'http://192.168.56.65:8080'
    touch d.txt
  EOH
  not_if{ ::File.exist? '/home/vagrant/d.txt' }
end


bash "installing sensu agent" do
  code <<-EOH
    cd /home/vagrant
    curl -s https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh | sudo bash
    touch e.txt
  EOH
  not_if{ ::File.exist? '/home/vagrant/e.txt' }
end

package 'sensu-go-agent' do
  action :install
end

bash "configuration file" do
  code <<-EOH
    curl -Lk https://docs.sensu.io/sensu-go/latest/files/agent.yml -o /etc/sensu/agent.yml
  EOH
  not_if{ ::File.exist? '/etc/sensu/agent.yml' }
end

service 'sensu-agent' do
  action [:enable, :start]
end

