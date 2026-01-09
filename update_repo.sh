#!/bin/bash

# Script to regenerate Cydia repository metadata

echo "Generating Packages..."
dpkg-scanpackages -m ./debs > Packages

echo "Patching Packages file..."
sed -i '' 's/yousefzx9900\.github\.io\/repo-dist/Yousef-Dev921.github.io\/repo/g' Packages
sed -i '' 's/yousefzx9900\.github\.io\/repo/Yousef-Dev921.github.io\/repo/g' Packages

echo "Compressing Packages..."
rm -f Packages.bz2 Packages.gz Packages.xz
bzip2 -k Packages
gzip -k Packages
xz -k Packages

echo "Generating Release..."
cat > Release <<EOF
Origin: OS Tweaks
Label: OS Tweaks
Suite: stable
Version: 1.0
Codename: ios
Architectures: iphoneos-arm64
Components: main
Description: OS Tweaks Repository
Icon: https://Yousef-Dev921.github.io/repo/CydiaIcon.png
EOF

# Append hashes and sizes to Release
echo "MD5Sum:" >> Release
for file in Packages Packages.gz Packages.bz2 Packages.xz; do
    echo " $(md5 -q $file) $(stat -f%z $file) $file" >> Release
done

echo "SHA1:" >> Release
for file in Packages Packages.gz Packages.bz2 Packages.xz; do
    echo " $(shasum -a 1 $file | awk '{print $1}') $(stat -f%z $file) $file" >> Release
done

echo "SHA256:" >> Release
for file in Packages Packages.gz Packages.bz2 Packages.xz; do
    echo " $(shasum -a 256 $file | awk '{print $1}') $(stat -f%z $file) $file" >> Release
done

echo "Done! Repository updated."
