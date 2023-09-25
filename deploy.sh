#!/bin/bash
set -e

cd ..
(
    rm -rf deploy && cp -r blog deploy
    cd deploy && git checkout deploy
    cp -r blog deploy/source
    cd deploy && pnpm i && pnpm run server
)
