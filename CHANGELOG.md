mapr_installation CHANGELOG
===========================

This file is used to list changes made in each version of the mapr_installation cookbook.

0.2.10
-----
- [eric moritz] - Automated disksetup


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
