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

#Remove Splunk installable
remote_file "#{node['splunk']['directory']}/#{node['splunk']['installable']}" do
  action :delete
end

#Configure Splunk Deployment Server
template "#{node['splunk']['directory']}/splunkforwarder/etc/system/local/deploymentclient.conf" do
  source 'deploymentclient.conf.erb'
  owner "#{node['splunk']['user']}"
  group "#{node['splunk']['group']}"
  mode '0750'
end

#Configure Splunk to launch with FIPS, service account, and ignore SELinux
template "#{node['splunk']['directory']}/splunkforwarder/etc/splunk-launch.conf" do
  source 'splunk-launch.conf.erb'
  owner "#{node['splunk']['user']}"
  group "#{node['splunk']['group']}"
  mode '0750'
end

#Configure Splunk to start on boot w/ systemd
systemd_unit 'splunk.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Splunk Universal Forwarder service
  After=network.target
  Wants=network.target

  [Service]
  Type=forking
  RemainAfterExit=no
  Restart=always
  RestartSec=30s
  User=#{node['splunk']['user']}
  Group=#{node['splunk']['group']}
  ExecStart=#{node['splunk']['directory']}/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt
  ExecStop=#{node['splunk']['directory']}/splunkforwarder/bin/splunk stop
  ExecReload=#{node['splunk']['directory']}/splunkforwarder/bin/splunk restart

  [Install]
  WantedBy=multi-user.target
  EOU
  action [ :create, :enable, :start ]
end
