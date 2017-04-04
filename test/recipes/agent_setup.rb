# # encoding: utf-8

# Inspec test for recipe pkf-splunk::agent_setup

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

#Check if Splunk is running correctly
describe processes 'splunkd' do
  its('states') { should eq ['Sl'] }
  its('users') { should eq ['splunk0+'] }
end

#Ensure setupfiles are removed
describe file '/agents/splunkforwarder_6-5-2.tgz' do
  it { should_not exist }
end

#Verify Splunk is enabled in systemd
describe command ('systemctl is-enabled splunk') do
  its ('stdout') { should eq "enabled\n" }
end
