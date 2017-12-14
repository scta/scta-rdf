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

  echo "removing $builddir/$buildname ..."
  rm -rf "$builddir/$buildname"
  echo "recreating $builddir/$buildname ..."
  if [[ $2 == "all" ]]
    then
      echo "canvas prebuild skipped. creating blank directory"
      mkdir "$builddir/$buildname"
    else
      echo "copying canvas prebuild"
      cp -R "$builddir/canvases-pre-build" "$builddir/$buildname"
  fi
  echo "all done"
fi
