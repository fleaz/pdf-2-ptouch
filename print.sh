#! /usr/bin/env nix-shell
#! nix-shell -i bash -p poppler_utils ghostscript python310Packages.brother-ql imagemagick
set -eu

ORIGINAL=$1
COUNT=$2 #TODO: könnte man bestimmt auch aus dem PDF bestimmen
TMP_DIR=$(mktemp -d)

cp "$1" $TMP_DIR/original.pdf

cd $TMP_DIR

#split
for((i=1; i<=COUNT; i++)); do
    echo "Extracting page $i"
    pdfseparate -f $i -l $i original.pdf $i.pdf
    convert -density 300 $i.pdf $i.png
    sudo brother_ql -b pyusb -m QL-650TD -p usb://0x04f9:0x201b  print --label 62 $i.png
done
 
cd -
rm -rf $TMP_DIR
