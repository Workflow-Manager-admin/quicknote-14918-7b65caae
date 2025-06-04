#!/bin/bash
cd /home/kavia/workspace/code-generation/quicknote-14918-7b65caae/quicknote_app
npx run lint
ESLINT_EXIT_CODE=$?
npm run build
BUILD_EXIT_CODE=$?
if [ $ESLINT_EXIT_CODE -ne 0 ] || [ $BUILD_EXIT_CODE -ne 0 ]; then
  exit 1
fi

