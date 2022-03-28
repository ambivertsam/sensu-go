['epel-release', 'erlang' ,'redis', 'rabbitmq-server', 'sensu-go-backed', 'sensu-go-cli' ,'sensu-go-agent'].each do |pkg|
  describe package(pkg) do
    it {should be_installed}
  end
end
