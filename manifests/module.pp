# Define: php::module
#
# Manage optional PHP modules which are separately packaged.
# See also php::module:ini for optional configuration.
#
# Sample Usage :
#  php::module { [ 'ldap', 'mcrypt', 'xml' ]: }
#  php::module { 'odbc': ensure => absent }
#  php::module { 'pecl-apc': }
#
define php::module (
  $ensure = installed,
) {
  if !defined(Class['php']) {
    fail('You must include the php base class before using any php defined resources')
  }

  # Manage the incorrect named php-apc package under Debians
  if ($title == 'apc') {
    $package = $::php::php_apc_package_name
  } else {
    # Hack to get pkg prefixes to work, i.e. php56-mcrypt title
    $package = $title ? {
      /^php/  => $title,
      default => "${::php::php_package_name}-${title}"
    }
  }

  package { $package:
    ensure  => $ensure,
    require => Class['::php::packages'],
  }

  # Reload FPM if present
  if defined(Class['::php::fpm::daemon']) {
    Package[$package] ~> Service[$php::fpm_service_name]
  }

}

