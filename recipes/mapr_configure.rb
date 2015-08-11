log "\n=========== Start MapR mapr_configure.rb =============\n"


# Make sane list of appropriate nodes...might be a better way to do this...
cldb_nodes = node['mapr']['cldb_ips'].reject(&:empty?).join(',')
zk_nodes = node['mapr']['zk_ips'].reject(&:empty?).join(',')
rm_nodes = node['mapr']['rm_ips'].reject(&:empty?).join(',')



config_command = []
config_command << "#{node['mapr']['home']}/server/configure.sh"
config_command << "-C #{cldb_nodes}" unless cldb_nodes.empty?
config_command << "-Z #{zk_nodes}" unless zk_nodes.empty?
config_command << "-RM #{rm_nodes}" unless rm_nodes.empty?
config_command << "-HS #{node['mapr']['hs_ips']}"
# config_command << "-D #{node['mapr']['node']['disks']}"
config_command << "-N #{node['mapr']['clustername']}"
config_command << '-u mapr -g mapr'
config_command << '-no-autostart'
config_command << '-on-prompt-cont y'
config_command = config_command.join(' ')


# Run configure.sh to configure the nodes, do NOT bring the cluster up
execute 'Run configure.sh to configure cluster' do
  command config_command
  not_if { ::File.exist?("#{node['mapr']['home']}/conf/disktab") }
end
