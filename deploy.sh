#!/bin/bash
set -e

cd ..
rm -rf deploy && cp -r blog deploy
(cd deploy && git checkout deploy && pnpm i)
cp -r blog deploy/source
cd deploy && pnpm run server
