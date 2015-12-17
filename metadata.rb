name             'mapr_installation'
maintainer       'Eric Moritz'
maintainer_email 'emoritz@gannett.com'
license          'All rights reserved'
description      'Installs/Configures mapr_installation'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.20'

depends 'chef-sugar'
depends 'firewall', '~> 2.3.0'
depends 'selinux'
depends 'ntp'
