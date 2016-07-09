#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

case node['elasticsearch']['install_flavor']
when "src"
  # src
  remote_file "/usr/local/src/#{node['elasticsearch']['src']['file']}" do
    owner "root"
    group "root"
    mode 00644
    source "#{node['elasticsearch']['src']['url']}"
  end
  
  bash "setup elasticsearch" do
    user "root"
    group "root"
    cwd "/usr/local/src"
    code <<-EOC
      rm -rf elasticsearch-#{node['elasticsearch']['version']}
      gzip -dc #{node['elasticsearch']['src']['file']} | tar xf -
      rm -rf #{node['elasticsearch']['root_dir']}/elasticsearch-#{node['elasticsearch']['version']}
      mv elasticsearch-#{node['elasticsearch']['version']} #{node['elasticsearch']['root_dir']}
      cd #{node['elasticsearch']['root_dir']}
      ln -sf elasticsearch-#{node['elasticsearch']['version']} elasticsearch
    EOC
    creates "#{node['elasticsearch']['root_dir']}/elasticsearch-#{node['elasticsearch']['version']}/bin/elasticsearch"
  end
when "rpm"
  # rpm
  remote_file "/usr/local/src/#{node['elasticsearch']['rpm']['file']}" do
    owner "root"
    group "root"
    mode 00644
    source "#{node['elasticsearch']['rpm']['url']}"
  end

  package "elasticsearch" do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/usr/local/src/#{node['elasticsearch']['rpm']['file']}"
  end

  %w(
    elasticsearch.yml
    logging.yml
  ).each do |t|
    template "/etc/elasticsearch/#{t}" do
      owner "root"
      group "root"
      mode 00644
      notifies :restart, "service[elasticsearch]"
    end
  end

  template "/etc/sysconfig/elasticsearch" do
    owner "root"
    group "root"
    mode 00644
    source "elasticsearch.sysconfig.erb"
    notifies :restart, "service[elasticsearch]"
  end

  service "elasticsearch" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
  end
end

