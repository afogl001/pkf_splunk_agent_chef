#
# Cookbook Name:: pkf-splunk
# Recipe:: agent_setup
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

#Downlaod Splunk installable
remote_file "#{node['splunk']['directory']}/#{node['splunk']['installable']}" do
  source "#{node['splunk']['repository']}/#{node['splunk']['installable']}"
  mode '0755'
  action :create
end

#Untar Splunk installable
execute 'Untar' do
  command "tar xzf #{node['splunk']['installable']}"
  cwd node['splunk']['directory']
  user "#{node['splunk']['user']}"
  not_if { File.exists?("#{node['splunk']['directory']}/splunkforwarder/bin/splunk") }
end

#Configure Splunk Deployment Server
template "#{node['splunk']['directory']}/splunkforwarder/etc/system/local/deploymentclient.conf" do
  source 'deploymentclient.conf.erb'
  owner "#{node['splunk']['user']}"
  group "#{node['splunk']['group']}"
  mode '0750'
end

##Initizlize Splunk
#execute 'SplunkStart' do
#  command 'splunkforwarder/bin/splunk start --accept-license'
#  cwd node['splunk']['directory']
#  user "#{node['splunk']['user']}"
#  notifies :delete, "remote_file[#{node['splunk']['directory']}/#{node['splunk']['installable']}]", :immediate
#  action :run
#end

#Configure Splunk to start on boot w/ systemd
systemd_unit 'splunk.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Splunk Universal Forwarder

  [Service]
  Type=forking
  RemainAfterExit=True
  User=#{node['splunk']['user']}
  ExecStart=#{node['splunk']['directory']}/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt
  ExecStop=#{node['splunk']['directory']}/splunkforwarder/bin/splunk stop
  ExecReload=#{node['splunk']['directory']}/splunkforwarder/bin/splunk restart

  [Install]
  WantedBy=multi-user.target
  EOU
  notifies :delete, "remote_file[#{node['splunk']['directory']}/#{node['splunk']['installable']}]", :immediate
  action [ :create, :enable, :start ]
end
