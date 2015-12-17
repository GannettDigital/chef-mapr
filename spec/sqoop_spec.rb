# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

context 'sqoop options undefined' do
  describe 'mapr_installation::sqoop' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5'
                              ).converge('mapr_installation::sqoop')
    }

    before do
      stub_data_bag_item('mapr', 'sqoop').and_raise(
        Net::HTTPServerException.new("Not Found", 404)
      )
    end

    it 'should install the sqoop package' do
      expect(chef_run).to install_package(
                            'mapr-sqoop'
                          ).with(
                            version: '1.4.4.201411051136-1'
                          )
    end
  end
end

context 'sqoop options defined, databag is not' do
  describe 'mapr_installation::sqoop' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5'
                              ) do |node|
        node.set['mapr']['jobs']['userStore'] = {
          'entities' => {
            'userStore_L1' => {
              'sqoop_data_bag' => 'userStore',
              'sqoop_options' => [
                  'import',
                  '',
                  '--connect',
                  'jdbc:sqlserver://example.com;databaseName=foo',
                  '--password-file',
                  '/opt/mapr/jobs/userStore/conf/sqoop_userStore.password'
                ]
            }
          }
        }
      end.converge('mapr_installation::sqoop')
    }

    before do
      stub_data_bag_item('mapr', 'sqoop').and_raise(
        Net::HTTPServerException.new("Not Found", 404)
      )
    end

    it 'should install the sqoop package' do
      expect(chef_run).to install_package(
                            'mapr-sqoop'
                          ).with(
                            version: '1.4.4.201411051136-1'
                          )
    end

    it 'should create an option file' do
      expect(chef_run).to create_file(
        '/opt/mapr/jobs/userStore/conf/sqoop_userStore_L1.options'
      ).with(
                             owner: 'mapr',
                             group: 'mapr',
                             mode: '444',
                             content: %{import

--connect
jdbc:sqlserver://example.com;databaseName=foo
--password-file
/opt/mapr/jobs/userStore/conf/sqoop_userStore.password
}
                          )
    end
  end
end

context 'sqoop options defined' do
  describe 'mapr_installation::sqoop' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5'
                              ) do |node|
        node.set['mapr']['jobs']['userStore'] = {
          'entities' => {
            'userStore_L1' => {
              'sqoop_data_bag' => 'userStore',
              'sqoop_options' => [
                  'import',
                  '',
                  '--connect',
                  'jdbc:sqlserver://example.com;databaseName=foo',
                  '--password-file',
                  '/opt/mapr/jobs/userStore/conf/sqoop_userStore.password'
                ]
            }
          }
        }
      end.converge('mapr_installation::sqoop')
    }

    before do
      stub_data_bag_item('mapr', 'sqoop').and_return(
        {
          'userStore' => {
            'password' => 'dummyPassword'
          }
        }
      )
    end

    it 'should install the sqoop package' do
      expect(chef_run).to install_package(
                            'mapr-sqoop'
                          ).with(
                            version: '1.4.4.201411051136-1'
                          )
    end

    it 'should create an option file' do
      expect(chef_run).to create_file(
        '/opt/mapr/jobs/userStore/conf/sqoop_userStore_L1.options'
      ).with(
                             owner: 'mapr',
                             group: 'mapr',
                             mode: '444',
                             content: %{import

--connect
jdbc:sqlserver://example.com;databaseName=foo
--password-file
/opt/mapr/jobs/userStore/conf/sqoop_userStore.password
}
                          )
    end

    it 'should create a password file' do
      expect(chef_run).to create_file(
          '/opt/mapr/jobs/userStore/conf/sqoop_userStore.password'
      ).with(
                            owner: 'mapr',
                            group: 'mapr',
                            mode: '440',
                            content: 'dummyPassword'
                          )
    end
  end
end
