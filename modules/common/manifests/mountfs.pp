define common::mountfs (
    
      $mount_dir,
      $mount_options_uid,
      $samba_share,
  
){

# Install CIFS user file - setup a user for accessing the share
# Need pass parmeters for cifspw template
   file { "/etc/cifspw_${samba_share}":
       ensure => 'present',
       content => epp('common/cifspw.epp',
                     { 'cifs_user' => 'fsuser',
                       'cifs_pwd'  => 'password',
                     }),
       owner  => 'root',
       group  => 'root',
       mode   => '0600',
   }
   
   
# Create file system root - for the mount point 
   file { $mount_dir :
       ensure => 'directory',
       owner  => 'root',
       group  => 'root',
       mode   => '0755',
   }


#the string after the "/" in "//fileserver.ftftech.com/" should
# correspond to the samba share created on the fileserver
  mount { $mount_dir :
        device  => "//fileserver.ftfapp.net/${samba_share}",
        fstype  => 'cifs',
        ensure  => 'mounted',
        options => "uid=${mount_options_uid},gid=nobody,domain=CIFSGROUP,credentials=/etc/cifspw_${samba_share},iocharset=utf8,file_mode=0644,dir_mode=0755,_netdev,soft",
        dump => '0',
        pass => '0',
        atboot => true,
        
  }




}
