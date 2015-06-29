class php (
  $php_package_name = $::php::params::php_package_name,
  $php_apc_package_name = $::php::params::php_apc_package_name,
  $common_package_name = $::php::params::common_package_name,
  $cli_package_name = $::php::params::cli_package_name,
  $cli_inifile = $::php::params::cli_inifile,
  $php_conf_dir = $::php::params::php_conf_dir,
  $fpm_package_name = $::php::params::fpm_package_name,
  $fpm_service_name = $::php::params::fpm_service_name,
  $fpm_service_restart = $::php::params::fpm_service_restart,
  $fpm_pool_dir = $::php::params::fpm_pool_dir,
  $fpm_conf_dir = $::php::params::fpm_conf_dir,
  $fpm_error_log = $::php::params::fpm_error_log,
  $fpm_pid = $::php::params::fpm_pid,
  $httpd_package_name = $::php::params::httpd_package_name,
  $httpd_service_name = $::php::params::httpd_service_name,
  $httpd_conf_dir = $::php::params::httpd_conf_dir,
  $install_cli = $::php::params::install_cli,
  $install_fpm_daemon = $::php::params::install_fpm_daemon
) inherits php::params {

  validate_bool($install_cli)
  validate_bool($install_fpm_daemon)

  anchor { 'php::begin':
    before => Class['::php::packages']
  }

  class {'::php::packages':}
  if $install_cli {
    class {'::php::cli':
      before => Anchor['php::end']
    }  
  }

  if $install_fpm_daemon {
    class {'::php::fpm::daemon':
      before => Anchor['php::end']
    }
  }

  anchor { 'php::end':
    require => Class['::php::packages']
  }
}
