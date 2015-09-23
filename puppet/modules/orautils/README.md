# Oracle WebLogic orautils puppet module
[![Build Status](https://travis-ci.org/biemond/biemond-orautils.png)](https://travis-ci.org/biemond/biemond-orautils)

usage:

change the params.pp class so the defaults match with your environment or add extra values based on the hostname

use:

    include orautils

or override the defaults which does not match with your environment and call the class orautils with the necessary parameters

osDomainTypeParam => soa|admin|web|oim

use:


    class{'orautils':
        os_oracle_home      => "/opt/oracle",
        ora_inventory       => "/opt/oracle/oraInventory",
        os_domain_type      => "soa",
        os_log_folder       => "/data/logs",
        os_download_folder  => "/data/install",
        os_mdw_home         => "/opt/oracle/wls/Middleware11gR1",
        os_wl_home          => "/opt/oracle/wls/Middleware11gR1/wlserver_10.3",
        ora_user            => "oracle",
        ora_group           => "dba",
        os_domain           => "osbSoaDomain",
        os_domain_path      => "/opt/oracle/wls/Middleware11gR1/user_projects/domains/osbSoaDomain",
        node_mgr_path       => "/opt/oracle/wls/Middleware11gR1/wlserver_10.3/server/bin",
        node_mgr_port       => 5556,
        node_mgr_address    => 'localhost',
        wls_user            => "weblogic",
        wls_password        => "weblogic1",
        wls_adminserver     => "AdminServer",
        jsse_enabled        => false,
    }

or with hiera  ( include orautils )

    orautils::os_oracle_home:      "/opt/oracle"
    orautils::ora_inventory:       "/opt/oracle/oraInventory"
    orautils::os_domain_type:      "admin"
    orautils::os_log_folder:       "/data/logs"
    orautils::os_download_folder:  "/data/install"
    orautils::os_mdw_home:         "/opt/oracle/wls/Middleware11gR1"
    orautils::os_wl_home:          "/opt/oracle/wls/Middleware11gR1/wlserver_10.3"
    orautils::ora_user:            "oracle"
    orautils::ora_group:           "dba"

    orautils::os_domain:           "Wls1036"
    orautils::os_domain_path:      "/opt/oracle/wlsdomains/domains/Wls1036"

    orautils::node_mgr_path:       "/opt/oracle/middleware11g/wlserver_10.3/server/bin"
    orautils::node_mgr_port:       5556
    orautils::node_mgr_address:    'localhost'

    orautils::wls_user:            "weblogic"
    orautils::wls_password:        "weblogic1"
    orautils::wls_adminserver:     "AdminServer"
    orautils::jsse_enabled:        true


install auto start script for the nodemanager of WebLogic ( 10.3, 11g, 12.1.1 ) or 12.1.2

only for WebLogic 12.1.2 and higher

    orautils::nodemanagerautostart{"autostart ${wlsDomainName}":
      version      => 1212,
      wl_home      => '/opt/oracle/middleware12c/wlserver',
      user         => 'oracle',
      domain       => 'Wls1212',
      domain_path  => '/opt/oracle/middleware12c/user_projects/domains/Wls1212'
    }

only for WebLogic 10 or 11g

    orautils::nodemanagerautostart{"autostart weblogic 11g":
      version     => 1111,
      wl_home     => "/opt/oracle/middleware11g/wlserver_10.3",
      user        => 'wls',
    }

or with JSSE and custom trust

    orautils::nodemanagerautostart{"autostart weblogic 11g":
      version                   => 1111,
      wl_home                   => "/opt/oracle/middleware11g/wlserver_10.3",
      user                      => 'oracle',
      jsse_enabled              => true,
      custom_trust              => true,
      trust_keystore_file       => '/vagrant/truststore.jks',
      trust_keystore_passphrase => 'XXX',
    }

## Add WebLogic scripts to /opt/scripts/wls

**cleanOracleEnvironment.sh**
Remove all Oracle WebLogic existence so you can deploy again
Actions
1. Remove domain pack files, ${osDownloadFolder}/domain_*.*
2. Remove mdwhome, $osOracleHome
3. Remove beahome list of user $oraUser
4. Remove /etc/oraInst.loc
5. Remove ${osDownloadFolder}/osb
6. Remove ${osDownloadFolder}/soa
7  Remove ${osDownloadFolder}/*.xml

**showStatus.sh**
1. Shows if the AdminServer, Soa and OSB server is running plus the PIDs
2. Shows if the NodeManager is running plus the PID

**startNodeManager.sh**
Starts the nodemanager

**stopNodeManager.sh**
Stops the nodemanager

**startWeblogicAdmin.sh**
1. Checks first if the nodemanager is running
2. Check if the AdminServer is already started
3. Start the WebLogic Adminserver from the nodemanager

**stopWeblogicAdmin.sh**
1. Checks first if the nodemanager is running
2. Check if the AdminServer is running
3. Stops the WebLogic Adminserver from the nodemanager
