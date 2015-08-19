## biemond-orawls-vagrant-12.1.3

The puppet 4.2 reference implementation of https://github.com/biemond/biemond-orawls

optimized for linux, Solaris and the use of Hiera

Should work for VMware and Virtualbox

### Details
- CentOS 7.0 Vagrant box
- Puppet 4.2.1
- Vagrant >= 1.7.4
- Oracle Virtualbox >= 5.0
- VMware fusion >= 6

creates a 12.1.3 WebLogic cluster ( admin, node1, node2 )

site.pp is located here:
https://github.com/biemond/biemond-orawls-vagrant-12.1.3/blob/master/puppet/manifests/site.pp

The used hiera files https://github.com/biemond/biemond-orawls-vagrant-12.1.3/tree/master/puppet/hieradata

Add the all the Oracle binaries to /software

edit Vagrantfile and update the software share
- admin.vm.synced_folder "software", "/software"
- node1.vm.synced_folder "software", "/software"
- node2.vm.synced_folder "software", "/software"

### Software
- Weblogic 12.1.3 [fmw_12.1.3.0.0_wls.jar](http://www.oracle.com/technetwork/middleware/fusion-middleware/downloads/index.html)
- JDK 8 [jdk-8u45-linux-x64.tar.gz](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- JCE Policy 8 [jce_policy-8.zip](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html)

### Startup the images

- vagrant up admin
- vagrant up node1
- vagrant up node2

### manual startup puppet

- vagrant ssh admin
- sudo -i
- /opt/puppetlabs/bin/puppet apply --verbose --report --trace /vagrant/puppet/manifests/development/site.pp
