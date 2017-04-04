# # encoding: utf-8

# Inspec test for recipe pkf-splunk::environment_setup

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

#Check if /etc/hosts is configured correctly
describe file '/etc/hosts' do
  its('type') { should eq :file }
  its('content') { should match('192.168.2.20    mntr20') }
  its('content') { should match('192.168.2.22    auth22') }
  its('content') { should match('192.168.2.24    mntr24') }
end
