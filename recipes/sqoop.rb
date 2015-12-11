def role?(role_name)
  Mapr.role? node, role_name
end

if role?('sqoop')
  log "Installing sqoop on #{Mapr.hostalias(node)}"
  package 'sqoop' do
    version node['mapr']['versions']['sqoop']
  end
end
