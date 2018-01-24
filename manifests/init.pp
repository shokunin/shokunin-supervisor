# Class: supervisor
# ===========================
#
# Full description of class supervisor here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'supervisor':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class supervisor {

  $pkg_setuptools = 'python-pip'
  $path_config    = '/etc/'

  package { $pkg_setuptools:
    ensure =>  installed,
  }

  package { 'supervisor':
    ensure   => '3.1.3',
    provider =>  'pip',
  }

  package { 'superlance':
    ensure   => 'installed',
    provider => 'pip',
    require  => Package['supervisor'],
  }

  file { '/var/log/supervisor':
    ensure  => directory,
    purge   => true,
    backup  => false,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require =>  Package['supervisor']
  }

  file { "${path_config}/supervisord.conf":
    ensure  => file,
    content => template('supervisor/supervisord.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['supervisor'],
    notify  => Service['supervisord'],
  }

  service { 'supervisord':
    ensure  => running,
    enable  => true,
    require =>  File["${path_config}/supervisord.conf"],
  }

}
