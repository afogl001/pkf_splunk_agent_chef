#
# Cookbook Name:: pkf-splunk
# Recipe:: host_setup
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

#Set directory for Splunk service account
directory "#{node['splunk']['directory']}/splunkforwarder" do
  owner "#{node['splunk']['user']}"
  group "#{node['splunk']['group']}"
  mode '0755'
  recursive true
  action :nothing
end

#Create group for Splunk service account
group 'splgroup'

#Create Splunk service account
user "#{node['splunk']['user']}" do
  group "#{node['splunk']['group']}"
  home "#{node['splunk']['directory']}/splunkforwarder"
  system true
  shell '/bin/bash'
  notifies :create, "directory[#{node['splunk']['directory']}/splunkforwarder]", :immediate
end

#Disable THP
systemd_unit 'disable_thp.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Disable Transparent Huge Pages (THP)

  [Service]
  Type=simple
  ExecStart=/bin/sh -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled && echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag"

  [Install]
  WantedBy=multi-user.target
  EOU
  action [ :create, :enable, :start ]
end

#Configure ulimits for Splunk service account
limits_config "#{node['splunk']['user']}" do
  limits [
    { domain: "#{node['splunk']['user']}", type: 'hard', item: 'nproc', value: 16000 },
    { domain: "#{node['splunk']['user']}", type: 'hard', item: 'sigpending', value: 16000 },
    { domain: "#{node['splunk']['user']}", type: 'soft', item: 'sigpending', value: 16000 },
    { domain: "#{node['splunk']['user']}", type: 'hard', item: 'nofile', value: 64000 },
  ]
end
