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

##Configure Splunk to launch with FIPS, service account, and ignore SELinux
#template "#{node['splunk']['directory']}/splunkforwarder/etc/splunk-launch.conf" do
#  source 'splunk-launch.conf.erb'
#  owner "#{node['splunk']['user']}"
#  group "#{node['splunk']['group']}"
#  mode '0750'
#end
############################START TEST CODE##########################
execute 'ulimit_paramUser' do
  command 'ulimit -Ha >> /tmp/ulimit_pram.txt'
  user "#{node['splunk']['user']}"
  action :run
end

execute 'ulimit_suUser' do
  command "su - #{node['splunk']['user']} -c 'ulimit -Ha >> /tmp/ulimit_su.txt'"
  action :run
end
##########################END TEST CODE#########################

#Initizlize Splunk
execute 'SplunkStart' do
  command '/agents/splunkforwarder/bin/splunk start --accept-license'
  #command "su - #{node['splunk']['user']} -c '/agents/splunkforwarder/bin/splunk start --accept-license'"
  cwd node['splunk']['directory']
  user "#{node['splunk']['user']}"
  notifies :delete, "remote_file[#{node['splunk']['directory']}/#{node['splunk']['installable']}]", :immediate
  action :run
end

#Configure Splunk to start on boot
execute 'SplunkBoot' do
  command 'splunkforwarder/bin/splunk enable boot-start'
  cwd node['splunk']['directory']
  action :run
end
