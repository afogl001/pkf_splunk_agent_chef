v0.5.0
  -Change from using systemd to Splunk's boot-start command coupled with splunk-launch parameters
v0.5.1
  -Remove systemd resource left in code by mistake
v0.6.0
  -Leverage "limits" cookbook instead of custom ulimit configurations
v0.7.0
  -Configure Splunk back as systmed service, removing v5 and v6 updates
v0.7.1
  -Fix missing systemd lines after merge conflict
v0.7.2
  -Removed empty "Description" option in systemd declaration
v0.8.0
  -Use "limits" recipe instead of setting them manually
