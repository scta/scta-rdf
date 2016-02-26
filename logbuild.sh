#! /bin/bash

sourceversion="$( git describe --tags --always )"
echo "<http://scta.info/scta> <http://scta.info/property/build> '$sourceversion' ." > buildversion.ttl
