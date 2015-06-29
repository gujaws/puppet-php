# Class: php::mod_php5
#
# Apache httpd PHP module. Requires the 'httpd' service and package to be
# declared somewhere, usually from the apache_httpd module.
#
# Sample Usage :
#  php::ini { '/etc/php-httpd.ini': }
#  class { 'php::mod_php5': inifile => '/etc/php-httpd.ini' }
#
class php::mod_php5 (
  $ensure             = 'installed',
  $inifile            = $::php::cli_inifile,
  $php_package_name   = $::php::php_package_name,
  $httpd_package_name = $::php::httpd_package_name,
  $httpd_service_name = $::php::httpd_service_name,
  $httpd_conf_dir     = $::php::httpd_conf_dir,
) inherits ::php {

  package { $php_package_name:
    ensure  => $ensure,
    require => File[$inifile],
    notify  => Service[$httpd_service_name],
  }

  # Custom httpd conf snippet
  file { "${httpd_conf_dir}/php.conf":
    content => template('php/httpd/php.conf.erb'),
    require => Package[$httpd_package_name],
    notify  => Service[$httpd_service_name],
  }

  # Notify the httpd service for any php.ini changes too
  File[$inifile] ~> Service[$httpd_service_name]

}

