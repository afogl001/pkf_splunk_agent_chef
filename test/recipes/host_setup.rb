# # encoding: utf-8

# Inspec test for recipe pkf-splunk::host_setup

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

#Validate Splunk service account
describe user ('splunk001') do
  it { should exist }
  its('home') { should eq '/agents/splunkforwarder' }
  its('group') { should eq 'splgroup' }
end

#Validate THP is disabled
describe file '/sys/kernel/mm/transparent_hugepage/enabled' do
  its('content') { should match '\[never\]' }
end
describe file '/sys/kernel/mm/transparent_hugepage/defrag' do
  its('content') { should match '\[never\]' }
end

#Validate ulimits for Splunk service account
describe command ('su - splunk001 -c "ulimit -Ha"') do
  its ('stdout') { should include '(-i) 16000' }
  its ('stdout') { should include '(-u) 16000' }
  its ('stdout') { should include '(-n) 64000' }
end
