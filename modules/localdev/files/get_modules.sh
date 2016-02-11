#!/bin/bash

set -e 

pushd /opt/sw/jboss/gsaconfig/standardconfig/latest/modules
tar cf temp.tar *
rm -rf oracle org com gov javax
svn co https://svnedge.techflow.com/svn/AASBSrba/Prototypes/JBoss6/modules/trunk .
tar xf temp.tar
rm temp.tar
popd
