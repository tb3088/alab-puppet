define common::ebsvolume(

    $mount_dir,
	  $mount_user,
	  $mount_user_group,
	  $mount_dir_mode,
	  $init_device,
	  $vol_name,
	  $vol_group,
	  $device_nm,
	  $dir_tree,

){

	  file { $mount_dir :
	       ensure => 'directory',
	       owner  => $mount_user,
	       group  => $mount_user_group,
	       mode   => $mount_dir_mode,
	  }


	  if ( $init_device == true ) {

	      # TODO: pass pv as an array e.g.  ['/dev/xvdb', '/dev/xvdc', '/dev/xvdd', '/dev/xvde']
	      # Need to test any impact of the above on the mount
	        lvm::volume { $vol_name :
	          ensure => present,
	          vg     => $vol_group,
	          pv     => $device_nm,
	          fstype => 'ext4',
	        }

	        mount { $mount_dir :
	              device  => "/dev/${vol_group}/${vol_name}",
	              fstype  => 'ext4',
	              ensure  => 'mounted',
	              options => 'defaults,nofail',
	              dump => '0',
	              pass => '2',
	              require => Lvm::Volume[ $vol_name ],
	        }

	        if !empty($dir_tree) {

		        file { $dir_tree :
		             ensure => 'directory',
		             owner  => $mount_user,
		             group  => $mount_user_group,
		             mode   => $mount_dir_mode,
		             require => Mount[ $mount_dir ],
		        }

	        }

	  } else {
	        #this will address the scenario if an existing EBS device with data on it is attached, and does not need formatting
	        mount { $mount_dir :
	              device  => "/dev/${vol_group}/${vol_name}",
	              fstype  => 'ext4',
	              ensure  => 'mounted',
	              options => 'defaults,nofail',
	              dump => '0',
	              pass => '2',
	              require => File[ $mount_dir ],
	        }
	  }


}
