mapr_installation CHANGELOG
===========================

This file is used to list changes made in each version of the mapr_installation cookbook.

0.3.22
-----
- [eric moritz] - DL-290 testing build

0.3.21
-----
- [eric moritz] - DL-290 turned off startup for edge nodes

0.3.20
-----
- [eric moritz] - DL-445 added sqoop options

0.3.19
-----
- [eric moritz] - DL-425 fixed the name of the sqoop package

0.3.18
-----
- [eric moritz] - DL-425 Forgot to include sqoop in default

0.3.17
-----
- [eric moritz] - DL-425 Added Sqoop1 support

0.3.16
-----
- [eric moritz] - DL-411 hardcoded the scalrizer ports for now

0.3.15
-----
- [eric moritz] - DL-411 added a firewall recipe

0.3.14
-----
- [eric moritz] - DL-60 fixed the java version to 1.7.0-79


0.3.13
-----
- [eric moritz] - DL-60 fixed the java version to 1.7.0-79

0.3.12
-----
- [eric moritz] - DL-60 fixed the java version to 1.7.0


0.3.11
-----
- [eric moritz] - DL-60 compensated for missing node['etc']['passwd'] keys


0.3.10
-----
- [hari rajaram] - DL-304 yarn configuration, added 1 more property for scheduler and made it configurable as attribute.

0.3.9
-----
- [eric moritz] - DL-60 integrated gdp-base-linux

0.3.8
-----
- [hari rajaram] - DL-304 yarn configuration changes for memory,cores,logs

0.3.7
-----
- [eric moritz] - DL-186 hardcoded the namenode hostname

0.3.6
-----
- [eric moritz] - DL-293 bumped default version to 4.1.x

0.3.3
-----
- [eric moritz] - made it so that MapR uses the hostalias as the node's domain

0.3.2
-----
- [eric moritz] - DL-221 fixed a deadlock issue with the zk wait

0.3.1
------
- [eric moritz] - DL-252 added version numbers to packages

0.3.0
-----
- [eric moritz] - deprecated the *_ips attributes, use DNS with the FQDNs
- [eric moritz] - added automatic disk discovery
- [eric moritz] - changed zk and CLDB sleeps to service up detection
- [eric moritz] - added testing
- [eric moritz] - utilized the standard users, sudo, ssh-keys cookbooks
- [eric moritz] - abstracted the service/node assignment code

0.2.10
-----
- [eric moritz] - Enabled HTTP for MCS

0.2.9
-----
- [daniel washko] - Fixing export of java_home to /etc/profile

0.2.8
-----
- [daniel washko] - Have to fix /tmp permissions after new storage is attached.

0.2.7
-----
- [daniel washko] - adjusting configure.sh script to remove disk section and add user and group information within configure recipe.
- [daniel washko] - Having selinux disabled in prereq recipe.

0.2.6
-----
- [daniel washko] - fixing maprcli command in default recipe

0.2.5
-----
- [daniel washko] - fixing configure command

0.2.4
-----
- [daniel washko] - putting configure command into an array and writing the command out with a join.

0.2.3
-----
- [daniel Washko] - Altering the way the mapr directory is created in the setenv recipe

0.2.2
-----
- [daniel washko] - Fixing tab issues in commands, replacing tabs with spaces. Creating the clustershell directory if it does not exist

0.2.1
-----
- [daniel washko] - removing spaces/tabs in yum mapr repo creation in validate hosts recipe.
0.2.0
-----
- [daniel washko] - alterations to cookbook to fit gdp requirements, primarily installation using ip addresses as opposed to fqdn.

0.1.0
-----
- [your_name] - Initial release of mapr_installation

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
