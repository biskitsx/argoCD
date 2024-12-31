#!/bin/bash

set -e

new_version=$1
echo "Upgrading to version $new_version"

# Simnulate relase of the new docker images
docker tag nginx:1.23.3 ksuphaky/nginx:$new_version
# Push the new image to the registry
docker push ksuphaky/nginx:$new_version
# Create a temporary directory
tmp_dir=$(mktemp -d)
echo "Created temporary directory $tmp_dir"

# clone the repository 
git clone https://github.com/biskitsx/minikube.git $tmp_dir

# Change the version in the deployment file
# sed -i '' -e "s/ksuphaky\/nginx:.*/ksuphaky\/nginx:$new_version/g" $tmp_dir/1-example/deployment.yaml
sed -i '' -e "s/ksuphaky\/nginx:.*/ksuphaky\/nginx:$new_version/g" $tmp_dir/1-example/deployment.yaml


cd $tmp_dir
# Commit the changes
git add 1-example/deployment.yaml
git commit -m "Upgrade to version $new_version"
git push origin main
rm -rf $tmp_dir