def role?(role_name)
  Mapr.role? node, role_name
end

# returns a password, maybe
def get_entity_password(data_bag_key, data_bag_data)
  entity_data_bag_data = data_bag_data[data_bag_key]
  entity_data_bag_data['password'] if entity_data_bag_data &&
                                      entity_data_bag_data['password']
end

if role?('sqoop')
  log "Installing sqoop on #{Mapr.hostalias(node)}"
  package 'mapr-sqoop' do
    version node['mapr']['versions']['sqoop']
  end

  if node['mapr']['jobs']
    sqoop_data_bag = begin
                       data_bag_item('mapr', 'sqoop')
                     rescue Net::HTTPServerException
                       {}
                     end
    node['mapr']['jobs'].each do |job_name, job_data|
      job_data['entities'].each do |entity_name, entity_data|
        options_content = entity_data['sqoop_options'].join("\n") + "\n"
        entity_sqoop_data_bag_key = entity_data['sqoop_data_bag']
        entity_password = get_entity_password(
          entity_data['sqoop_data_bag'],
          sqoop_data_bag
        )
        entity_conf_dir = "/opt/mapr/jobs/#{job_name}/conf"

        directory entity_conf_dir do
          owner 'mapr'
          group 'mapr'
          mode '777'
          recursive true
        end

        file "#{entity_conf_dir}/sqoop_#{entity_name}.options" do
          content options_content
          owner 'mapr'
          group 'mapr'
          mode '444'
        end

        file "#{entity_conf_dir}/sqoop_#{entity_sqoop_data_bag_key}.password" do
          content entity_password
          owner 'mapr'
          group 'mapr'
          mode '440'
        end if entity_password
      end
    end
  end
end
