#!/bin/bash

echo "Compiling coffee..."
coffee -c .

echo "Generating index.html..."
sed \
  -e '/<!--SCRIPT-->/ r client/client.js' \
  -e '/<!--STYLE-->/ r client/style.css' \
  client/index.template.html \
> client/index.html

echo "Done!"
