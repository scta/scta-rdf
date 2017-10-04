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
  cp -R "$builddir/canvases-2017-09-30" "$builddir/$buildname"
  echo "all done"
fi
