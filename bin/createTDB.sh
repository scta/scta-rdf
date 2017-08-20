# /bin/bash
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
elif [ -z "$1" ]
  then
    echo "No argument supplied"
else
  buildname=$1
  builddir="/Users/jcwitt/Projects/scta/scta-builds";

  echo "creating $builddir/$buildname ..."
  mkdir "$builddir/$buildname"
  echo "all done"
fi
