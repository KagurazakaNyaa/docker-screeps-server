git reset --hard HEAD
git clean -f -d
git pull
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
git add timestamp
git add currentversion
git config --global user.email i@kagurazakanyaa.com
git config --global user.name KagurazakaNyaa
git commit --no-gpg-sign -a -m "Auto Update to screeps "$version
git tag -f $version
if [[ "$version" != "ptr" ]]; then
	git tag -f latest
fi
git push origin master --tags --force
