## biemond-orawls-vagrant-12.1.3

The reference implementation of https://github.com/biemond/biemond-orawls
optimized for linux, Solaris and the use of Hiera

Should work for VMware and Virtualbox

### Details
- CentOS 6.6 Vagrant box
- Puppet 3.7.3
- Vagrant >= 1.6.5
- Oracle Virtualbox >= 4.3.20
- VMware fusion >= 6

creates a 12.1.3 WebLogic cluster ( admin, node1, node2 )

site.pp is located here:
https://github.com/biemond/biemond-orawls-vagrant-12.1.3/blob/master/puppet/manifests/site.pp

The used hiera files https://github.com/biemond/biemond-orawls-vagrant-12.1.3/tree/master/puppet/hieradata

Add the all the Oracle binaries to /software

edit Vagrantfile and update the software share
- admin.vm.synced_folder "/Users/edwin/software", "/software"
- node1.vm.synced_folder "/Users/edwin/software", "/software"
- node2.vm.synced_folder "/Users/edwin/software", "/software"


### Software
- jdk-7u55-linux-x64.tar.gz

weblogic 12.1.3  ( located under the software share )
- wls_121300.jar


### Startup the images

- vagrant up admin
- vagrant up node1
- vagrant up node2

