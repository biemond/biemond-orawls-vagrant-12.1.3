#
#
#
class orautils(
  $os_oracle_home            = $orautils::params::osOracleHome,
  $ora_inventory             = $orautils::params::oraInventory,
  $os_domain_type            = $orautils::params::osDomainType,
  $os_log_folder             = $orautils::params::osLogFolder,
  $os_download_folder        = $orautils::params::osDownloadFolder,
  $os_mdw_home               = $orautils::params::osMdwHome,
  $os_wl_home                = $orautils::params::osWlHome,
  $ora_user                  = $orautils::params::oraUser,
  $ora_group                 = $orautils::params::oraGroup,
  $os_domain                 = $orautils::params::osDomain,
  $os_domain_path            = $orautils::params::osDomainPath,
  $node_mgr_path             = $orautils::params::nodeMgrPath,
  $node_mgr_port             = $orautils::params::nodeMgrPort,
  $node_mgr_address          = $orautils::params::nodeMgrAddress,
  $wls_user                  = $orautils::params::wlsUser,
  $wls_password              = $orautils::params::wlsPassword,
  $wls_adminserver           = $orautils::params::wlsAdminServer,
  $jsse_enabled              = $orautils::params::jsseEnabled,
  $custom_trust              = false,
  $trust_keystore_file       = undef,
  $trust_keystore_passphrase = undef,
) inherits orautils::params
{

  case $::kernel {
    'Linux', 'SunOS': {

    $mode             = '0775'

    $shell            = $orautils::params::shell
    $userHome         = $orautils::params::userHome
    $oraInstHome      = $orautils::params::oraInstHome

    if $custom_trust == true {
      $trust_env = "-Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=${trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=${trust_keystore_passphrase}"
    } else {
      $trust_env = ''
    }

    if ! defined(File['/opt/scripts']) {
      file { '/opt/scripts':
        ensure  => directory,
        recurse => false,
        replace => false,
        owner   => $ora_user,
        group   => $ora_group,
        mode    => $mode,
      }
    }

    if ! defined(File['/opt/scripts/wls']) {
      file { '/opt/scripts/wls':
        ensure  => directory,
        recurse => false,
        replace => false,
        owner   => $ora_user,
        group   => $ora_group,
        mode    => $mode,
        require => File['/opt/scripts'],
      }
    }

    file { 'showStatus.sh':
      ensure  => present,
      path    => '/opt/scripts/wls/showStatus.sh',
      content => regsubst(template('orautils/wls/showStatus.sh.erb'), '\r\n', "\n", 'EMG'),
      # content => template('orautils/wls/showStatus.sh.erb'),
      owner   => $ora_user,
      group   => $ora_group,
      mode    => $mode,
      require => File['/opt/scripts/wls'],
    }

    file { 'stopNodeManager.sh':
      ensure  => present,
      path    => '/opt/scripts/wls/stopNodeManager.sh',
      content => regsubst(template('orautils/wls/stopNodeManager.sh.erb'), '\r\n', "\n", 'EMG'),
      # content => template('orautils/wls/stopNodeManager.sh.erb'),
      owner   => $ora_user,
      group   => $ora_group,
      mode    => $mode,
      require => File['/opt/scripts/wls'],
    }

    file { 'cleanOracleEnvironment.sh':
      ensure  => present,
      path    => '/opt/scripts/wls/cleanOracleEnvironment.sh',
      content => regsubst(template('orautils/cleanOracleEnvironment.sh.erb'), '\r\n', "\n", 'EMG'),
      # content => template('orautils/cleanOracleEnvironment.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0770',
      require => File['/opt/scripts/wls'],
    }

    file { 'startNodeManager.sh':
      ensure  => present,
      path    => '/opt/scripts/wls/startNodeManager.sh',
      content => regsubst(template('orautils/startNodeManager.sh.erb'), '\r\n', "\n", 'EMG'),
      # content => template('orautils/startNodeManager.sh.erb'),
      owner   => $ora_user,
      group   => $ora_group,
      mode    => $mode,
      require => File['/opt/scripts/wls'],
    }

    file { 'startWeblogicAdmin.sh':
      ensure  => present,
      path    => '/opt/scripts/wls/startWeblogicAdmin.sh',
      content => regsubst(template('orautils/startWeblogicAdmin.sh.erb'), '\r\n', "\n", 'EMG'),
      # content => template('orautils/startWeblogicAdmin.sh.erb'),
      owner   => $ora_user,
      group   => $ora_group,
      mode    => $mode,
      require => File['/opt/scripts/wls'],
    }

    file { 'stopWeblogicAdmin.sh':
      ensure  => present,
      path    => '/opt/scripts/wls/stopWeblogicAdmin.sh',
      content => regsubst(template('orautils/stopWeblogicAdmin.sh.erb'), '\r\n', "\n", 'EMG'),
      # content => template('orautils/stopWeblogicAdmin.sh.erb'),
      owner   => $ora_user,
      group   => $ora_group,
      mode    => $mode,
      require => File['/opt/scripts/wls'],
    }

    }
    default: {
      notify{'This operating system is not supported':}
    }
  }
}
