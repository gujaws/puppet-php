class php::packages {
  package { $::php::common_package_name: 
    ensure => $::php::ensure
  }
}
