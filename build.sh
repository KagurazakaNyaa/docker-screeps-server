version=$(curl https://raw.githubusercontent.com/screeps/screeps/master/package.json | jq -r .version)
currentversion=$(cat currentversion)
echo $version > currentversion
if [[ "$currentversion" == "$version" ]]; then
    exit
fi
if [[ "$1" == "ptr" ]]; then
	version=ptr
fi
sed -i 's/^ENV SCREEPS_VERSION.*$/ENV SCREEPS_VERSION '$version'/i' Dockerfile
date > timestamp
git config user.name github-actions
git config user.email github-actions@github.com
git add timestamp
git add currentversion
git commit -a -m "Auto Update to screeps "$version
git tag -f $version
if [[ "$version" != "ptr" ]]; then
	git tag -f latest
fi
git push
git push origin --tags -f
