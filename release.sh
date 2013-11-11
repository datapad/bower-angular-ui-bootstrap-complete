#!/usr/bin/env bash
set -ue

rm -rf repo/
git clone https://github.com/angular-ui/bootstrap.git repo/ --branch gh-pages --depth 1

rm -rf package/
mkdir package/

cd package/

cp ../repo/ui-bootstrap-$1.js ui-bootstrap.js
cp ../repo/ui-bootstrap-$1.min.js ui-bootstrap.min.js
cp ../repo/ui-bootstrap-tpls-$1.js ui-bootstrap-tpls.js
cp ../repo/ui-bootstrap-tpls-$1.min.js ui-bootstrap-tpls.min.js

IFS=$'\n' LINES=($(find . -depth 1 | grep -v '\.min\.js$' | awk '{print "\"" $0 "\""}'))
MAIN=$(printf ", %s" "${LINES[@]}")
MAIN=${MAIN:1}

cat <<EOF > bower.json
{
  "name": "angular-ui-bootstrap-complete",
  "version": "$1",
  "description": "AngularJS UI Bootstrap with optional default template injection",
  "keywords": [
    "angular",
    "angular-ui-bootstrap",
    "angular-ui",
    "angularjs",
    "bootstrap",
    "template",
    "templates",
    "ui-bootstrap"
  ],
  "main": [ $MAIN ],
  "license": "MIT"
}
EOF

git init
git remote add origin https://github.com/datapad/bower-angular-ui-bootstrap-complete.git
git add -A
git commit -m "$1"
git tag "$1"
git push origin --tags -f
