#!/bin/bash
set -e # exit with nonzero exit code if anything fails

# squash messages
git config --global push.default matching

# prepare respec build
npm install

# clear and re-create the out directory
rm -rf out || exit 0;
mkdir out;

# go to the out directory and create a *new* Git repo
cd out
git init

# inside this git repo we'll pretend to be a new user
git config user.name "github-actions[bot]"
git config user.email "services@openactive.org"

# compile using respec2html (handling each version separately)
function respec2html {
  #rm $2 || exit 0;
  echo Running respec2html NightmareJS for $1 $2;
  node ./node_modules/respec/tools/respec2html.js --timeout 30000 --haltonerror --src $1 --out $2 -- --no-sandbox --disable-setuid-sandbox;
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
cp -r ../2.0 .
cp -r ../EditorsDraft .

# Remove edit versions
# rm **/edit.html

# Current latest version
cp -r ../2.0/* .

cd ..

# Regenerate file for EditorsDraft only
respec2html "file://$PWD/EditorsDraft/edit.html" "$PWD/out/EditorsDraft/index.html" "EditorsDraft"

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
