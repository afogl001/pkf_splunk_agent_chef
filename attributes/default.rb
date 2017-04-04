#Set Splunk service account user
default['splunk']['user'] = 'splunk001'
#Set Splunk service account group
default['splunk']['group'] = 'splgroup'
#Set Splunk insllation directory
default['splunk']['directory'] = '/agents'
#Set download location
default['splunk']['repository'] = 'http://192.168.2.22/splunk'
#Set Splunk download file
default['splunk']['installable'] = 'splunkforwarder_6-5-2.tgz'
#Set Deployment Client
default['splunk']['deploymentserver'] = '192.168.2.20:8089'
