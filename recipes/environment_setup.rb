#
# Cookbook Name:: pkf-splunk
# Recipe:: environment_setup
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

#Configure /etc/hosts with hostnames
template '/etc/hosts' do
  source 'hosts.erb'
end
