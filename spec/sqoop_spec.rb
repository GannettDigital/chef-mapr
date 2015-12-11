# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'mapr_installation::sqoop' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5').
      converge(described_recipe)
  }
  
  it 'should install the sqoop package' do
    expect(chef_run).to install_package(
                          "sqoop"
                        ).with(
                          version: "1.4.4.201411051136-1"
                        )
  end

end
