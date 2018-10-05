#!/bin/bash
set -e # exit with nonzero exit code if anything fails

# squash messages
git config --global push.default matching

# prepare respec build

# clear the respec directory
rm -rf respec || exit 0;

# get existing gh-pages
#git clone -b develop "https://github.com/w3c/respec.git"
git clone -b develop "https://github.com/openactive/respec.git"

cd respec
#reset to version that was working?
#git reset --hard 250324c3b256e2b9055d2fd239a3c32c260e2bf6

npm install

cd ..

# clear and re-create the out directory
rm -rf out || exit 0;
mkdir out;

# go to the out directory and create a *new* Git repo
cd out
git init

# inside this git repo we'll pretend to be a new user
git config user.name "Travis CI"
git config user.email "travis@openactive.org"

# compile using respec2html (handling each version separately)
function respec2html {
  rm $2
  echo Running respec2html Nightmare for $1 $2
  DEBUG=nightmare xvfb-run --server-args="-screen 0 1024x768x24" node respec/tools/respec2html.js --haltonerror --src $1 --out $2
  {
  if [ ! -f $2 ]; then
      echo "respect2html Nightmare failed to generate index.html for $3"
      exit 2
  fi
  }
}

echo Copying static files
cp -r ../1.0 .
cp -r ../1.1 .
cp -r ../Latest .
cp -r ../EditorsDraft .
cp -r ../Latest/* .

cd ..

respec2html "file://$PWD/EditorsDraft/index.html" "$PWD/out/EditorsDraft/index.html" "EditorsDraft"
respec2html "file://$PWD/1.0/index.html" "$PWD/out/1.0/index.html" "1.0"
respec2html "file://$PWD/1.1/index.html" "$PWD/out/1.1/index.html" "1.1"
respec2html "file://$PWD/Latest/index.html" "$PWD/out/Latest/index.html" "Latest"
cp "$PWD/out/Latest/index.html" out/index.html

cd out

# The first and only commit to this new Git repo contains all the
# files present with the commit message "Deploy to GitHub Pages".
git add .
git commit -m "Deploy to GitHub Pages - Static"

# Force push from the current repo's master branch to the remote
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.) We redirect any output to
# /dev/null to hide any sensitive credential data that might otherwise be exposed.
# FIXME should be authorised via key
git push --force "https://${GH_TOKEN}@${GH_REF}" master:gh-pages

cd ..
