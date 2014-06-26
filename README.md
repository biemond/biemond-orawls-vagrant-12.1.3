#biemond-orawls-vagrant-12.1.3

The reference implementation of https://github.com/biemond/biemond-orawls  
optimized for linux, Solaris and the use of Hiera

##Also support many native puppet WebLogic types like 
- wls_machine
- wls_server
- wls_cluster 
- and many others

##Details
- CentOS 6.5 vagrant box
- Puppet 3.5.0
- Vagrant >= 1.41
- Oracle Virtualbox >= 4.3.6 

creates a 12.1.3 WebLogic cluster ( admin, node1, node2 )

site.pp is located here:  
https://github.com/biemond/biemond-orawls-vagrant-12.1.3/blob/master/puppet/manifests/site.pp  

The used hiera files https://github.com/biemond/biemond-orawls-vagrant-12.1.3/tree/master/puppet/hieradata

Add the all the Oracle binaries to /software

edit Vagrantfile and update the software share
- admin.vm.synced_folder "/Users/edwin/software", "/software"
- node1.vm.synced_folder "/Users/edwin/software", "/software"
- node2.vm.synced_folder "/Users/edwin/software", "/software"


##used the following software ( located under the software share )
- jdk-7u51-linux-x64.tar.gz

weblogic 12.1.3  ( located under the software share )
- fmw_12.1.3.0.0_wls.jar

##Using the following facts ( VagrantFile )

- environment => "development"
- vm_type     => "vagrant"

##Startup the images

###admin server  
vagrant up admin

###node1  
vagrant up node1

###node2  
vagrant up node2

