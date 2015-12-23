# jdk7::config::javaexec
#
# unpack the java tar.gz
# set the default java links
# set this java as default
#
define jdk7::config::javaexec (
  $download_dir                = undef,
  $full_version                = undef,
  $java_homes_dir              = undef,
  $jdk_file                    = undef,
  $cryptography_extension_file = undef,
  $alternatives_priority       = undef,
  $user                        = undef,
  $group                       = undef,
  $default_links               = undef,
  $install_alternatives        = undef,
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
) {

  # check java install folder
  if ! defined(File['/usr/java']) {
    file { '/usr/java' :
      ensure  => directory,
      replace => false,
      owner   => $user,
      group   => $group,
      mode    => '0755',
    }
  }

  # check java homes folder
  if ! defined(File[$java_homes_dir]) {
    file { $java_homes_dir :
      ensure  => directory,
      replace => false,
      owner   => $user,
      group   => $group,
      mode    => '0755',
    }
  }

  $java_dir = "${java_homes_dir}/${full_version}"
  # extract gz file in /usr/java
  exec { "extract java ${full_version}":
    cwd       => $java_homes_dir,
    command   => "tar -xzf ${download_dir}/${jdk_file}",
    creates   => $java_dir,
    require   => File[$java_homes_dir],
    path      => $path,
    logoutput => true,
    user      => $user,
    group     => $group,
  }

  # extract gz file in /usr/java
  if ( $cryptography_extension_file != undef ) {
    $security_dir = "${java_dir}/jre/lib/security"
    $source_file = "${download_dir}/${cryptography_extension_file}"
    $done_file = "${security_dir}/.jce_installed"
    $jarfiles = "${security_dir} -mindepth 2 -name '*.jar'"
    $mv_cmd = "mv '{}' ${security_dir} ';'"
    if ( $cryptography_extension_file =~ /\.zip$/ ) {
      $extract_cmd = 'unzip'
    }
    elsif ( $cryptography_extension_file =~ /\.t(ar\.)?gz$/ ) {
      $extract_cmd = 'tar -zxf'
    }
    else {
      fail("Unknown file format: ${cryptography_extension_file}")
    }
    exec { "extract jce ${full_version}":
      cwd       => $security_dir,
      command   => "${extract_cmd} ${source_file}",
      creates   => $done_file,
      require   => [File[$java_homes_dir],Exec["extract java ${full_version}"]],
      before    => Exec["chown -R ${user}:${group} ${java_dir}"],
      path      => $path,
      logoutput => true,
      user      => $user,
      group     => $group,
    } ~>
    exec { "Move jce ${full_version} jar files to ${security_dir}":
      command     => "find ${jarfiles} -exec ${mv_cmd}",
      group       => $group,
      path        => $path,
      refreshonly => true,
      user        => $user,
    } ~>
    exec { "touch ${done_file}":
      command     => "touch ${done_file}",
      group       => $group,
      path        => $path,
      refreshonly => true,
      user        => $user,
    }
  }

  # set ownership
  $ls_cmd = "ls -al ${java_dir}/bin/java"
  $awk_cmd = "awk '{ print \$3 }'"
  exec { "chown -R ${user}:${group} ${java_dir}":
    unless    => "${ls_cmd} | ${awk_cmd} | grep ${user}",
    path      => $path,
    logoutput => true,
    user      => $user,
    group     => $group,
    require   => Exec["extract java ${full_version}"],
  }

  if ( $default_links ){
    # java link to latest
    file { '/usr/java/latest':
      ensure  => link,
      target  => $java_dir,
      require => Exec["extract java ${full_version}"],
      owner   => $user,
      group   => $group,
      mode    => '0755',
    }

    # java link to default
    file { '/usr/java/default':
      ensure  => link,
      target  => '/usr/java/latest',
      require => File['/usr/java/latest'],
      owner   => $user,
      group   => $group,
      mode    => '0755',
    }
  }

  $alternatives = [ 'java', 'javac', 'keytool']
  if ( $install_alternatives ){
    jdk7::config::alternatives{ $alternatives:
      java_home_dir => $java_homes_dir,
      full_version  => $full_version,
      priority      => $alternatives_priority,
      user          => $user,
      group         => $group,
    }
  }
}
