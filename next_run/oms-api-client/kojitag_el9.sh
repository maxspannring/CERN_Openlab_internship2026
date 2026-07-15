#!/bin/bash -x
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

echo "BUILDING RPMS..."
python3.12 setup.py bdist_rpm --python /usr/bin/python3.12 --build-requires python3.12,python3.12-setuptools --release 0.el9

#srcrpm=`ls rpmbuild/SRPMS/oms-portal-gui-*.src.rpm`
pkg="python3.12-omsapi"
srcrpm=`ls -t dist/${pkg}-*.src.rpm | head -1`
rpmname=`/usr/bin/python3.12 -c "import os,sys; p = sys.argv[1].split('/')[-1]; print(p[:p.find('.src.rpm')])" $srcrpm`

echo "RUNNING WITH KOJI USER ${KOJICI_USER}"
echo ${KOJICI_PWD} | kinit ${KOJICI_USER}@CERN.CH


if [ -z $1 ]; then
  echo "Koji pre-add package to testing: $srcrpm"
  koji add-pkg --owner=${KOJICI_USER} cmsoms9el-testing ${pkg}
  echo "Koji build source rpm: $srcrpm"
  koji build --wait cmsoms9el $srcrpm
  echo "Koji pre-add package to qa: $srcrpm"
  koji add-pkg --owner=${KOJICI_USER} cmsoms9el-qa ${pkg}
  koji tag cmsoms9el-qa $rpmname
  echo "Koji pre-add package to production: $srcrpm"
  koji add-pkg --owner=${KOJICI_USER} cmsoms9el-stable ${pkg}
  koji tag --wait cmsoms9el-stable $rpmname
else
  echo "Koji SCRATCH build"
  #koji build --scratch --wait cmsoms8el $srcrpm
fi
