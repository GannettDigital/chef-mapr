mapr_installation Cookbook.
==========================
This cookbook automates the installation of a MapR cluster.  Currently, this cookbook supports has only been tested on CentOS, but should work fine on Redhat as well

This cookbook will automate the steps outlined in the 'Preparing your nodes' section of the MapR documention, located at http://doc.mapr.com/display/MapR/Preparing+Each+Node, with the exception of verifying OS, mememory, etc.  This cookbook assumes that you have verified that the HW meets the requirements outline in the aforementioned link.

Note that this cookbook disables both selinux and iptables.  A list of MapR ports is available at http://doc.mapr.com/display/MapR/Ports+Used+by+MapR .

This cookbook will also automate the installation of a MapR Yarn cluster.


--------- install_mapr_chef.sh usage -----------------

NOTE:  The attached shell script automates the following steps:
  1.  Creates a log dir, ~/mapr_install_logs (if not already done)
  2.  Moves any previous run logs to ~/mapr_install_logs/bak
  3.  runs ssh <node_name> chef-client >><logdir_n_file> (and waits for complettion)
  4.  Prompts users to apply license, which can be done via the GUI (instructions will be provided during walk through), and waits for confirmation.
  5.  Shuts down mapr-warden services and reboots all nodes, to allow automount to be enabled on the cluster.
  6.  Restarts all mapr-wardens once more to ensure clean service state for all mapr services. 

The only manual step for this script is updating the 'nodes' value at the top of the script to match the FQDN of the nodes to be included in the MapR cluster.  
---------end  install_mapr_chef.sh usage -------------

Requirements
------------
This cookbook requires the ntp cookbook located at https://supermarket.chef.io/cookbooks/ntp.

This cookbook also comes with a wrapper script, called 'install_mapr_chef.sh'.
This cookbook will install all SW dependencies for MapR, so nothing to do there.

Attributes
----------
There are a number of configurable attributes, all located in attributes/default.rb.  The most significant ones (as well as the ones users MUST configure) as listed here.

The below are hashed password values for both root and the mapr_user, which defaults to mapr.  Generally, users leave mapr as the default user.  'openssl passwd -1' should be used to alter the below as this README will not include the values of the below..  

```ruby
default[:mapr][:password] = "$1$x4GGdWjX$5IZsb6wdcgGjzdSKK6yd6/"
default[:root][:password] = "$1$PvTToSKD$CDPWULL69FK00rQy7R6Rt."
```

The below is a list of all of the nodes that will be part of the cluster.  The below is an example of nodes located in EC2.  NOTE:  You MUST use FQDN for this list and all other values in attributes.

```ruby
default[:mapr][:cluster_nodes] = [
  "ip-172-16-5-225.ec2.internal",           
  "ip-172-16-5-16.ec2.internal",
  "ip-172-16-5-176.ec2.internal",
  "ip-172-16-5-108.ec2.internal",
  "ip-172-16-5-37.ec2.internal",
  "ip-172-16-5-79.ec2.internal"
]
```

****NOTE:  There is a similar list located in the attached shell script, 'mapr_install_chef.sh', which will need to be configured as well.



Total node count to be installed:

```ruby
default[:mapr][:node_count] = "6"

default[:mapr][:cldb] = [
  "ip-172-16-5-16.ec2.internal",
  "ip-172-16-5-176.ec2.internal"
]
default[:mapr][:zk] = [
  "ip-172-16-5-108.ec2.internal",
  "ip-172-16-5-37.ec2.internal",
  "ip-172-16-5-79.ec2.internal"
]
default[:mapr][:rm] = ["ip-172-16-5-225.ec2.internal","ip-172-16-5-16.ec2.internal"]
default[:mapr][:hs] = "ip-172-16-5-225.ec2.internal"
default[:mapr][:ws] = ["ip-172-16-5-225.ec2.internal","ip-172-16-5-16.ec2.internal"]
```

The name you would like for your cluster and the version to install.  4.0.2 is the current GA level, so shouldn't need to be changed.

```ruby
default[:mapr][:clustername] = "chef_test_cluster"
default[:mapr][:version] = "4.0.2"
```

The disks MapR should use for installation.  These MUST be raw, unformatted drives.  A list can be confirmed w/ lsblk.

```ruby
default[:mapr][:node][:disks] = "/dev/xvdf,/dev/xvdg"
```

Java version to be installed as well as home directory for setting environment and mapr-specific environment variables.

```ruby
default[:java][:version] = "java-1.7.0-openjdk-devel"
default[:java][:home] = "/usr/lib/jvm/jre-1.7.0-openjdk.x86_64"
```

Usage
-----
#### mapr_installation::default

Assuming the above is configure, just include `mapr_installation` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mapr_installation]"
  ]
}
```


Contributing
------------

License and Authors
-------------------
