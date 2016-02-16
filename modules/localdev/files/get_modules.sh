#!/bin/bash

set -e 

echo
echo "Delete existing modules? (WARNING: if you have added or changed property files they will be deleted)"
read -p "Please press 'y' or 'n': " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Clear out existing modules:
  pushd /opt/sw/jboss/gsaconfig/standardconfig/latest/modules > /dev/null
  echo "Deleting existing modules from the server."
  rm -rf *
  popd   > /dev/null
fi

# Check out the Techflow modules:
if [ -d /opt/sw/jboss/src/jboss-modules ]; then
  pushd /opt/sw/jboss/src/jboss-modules > /dev/null
  echo "Updating modules from SVN."
  svn up
else
  mkdir -p /opt/sw/jboss/src/
  echo "Checkout out modules from SVN."
  svn co https://svnedge.techflow.com/svn/AASBSrba/Prototypes/JBoss6/modules/trunk /opt/sw/jboss/src/jboss-modules
  pushd /opt/sw/jboss/src/jboss-modules > /dev/null
fi

# Build the TF modules and copy them over.

echo "Building AASBS modules."
mvn clean package -DbuildNumber=LOCAL
echo "Copying GSA modules to the server."
cp -rp /opt/sw/jboss/gsainstall/6.4/standardconfig/modules /opt/sw/jboss/gsaconfig/standardconfig/latest

echo "Copying AASBS modules to the server."
cp target/jboss-modules-LOCAL-module-package.tgz /opt/sw/jboss/gsaconfig/standardconfig/latest/modules/
pushd /opt/sw/jboss/gsaconfig/standardconfig/latest/modules/ > /dev/null
echo "Unzipping AASBS modules on the server."
tar xzpf jboss-modules-LOCAL-module-package.tgz
rm jboss-modules-LOCAL-module-package.tgz
popd > /dev/null
popd > /dev/null

echo "All Done."
echo "Re-run this any time there are new module changes."
