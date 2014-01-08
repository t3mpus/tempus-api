#!/bin/bash
npm install
npm rebuild
./db-migrate -e travis up
TRAVIS_DB_URL=postgres://postgres@127.0.0.1/tempus_dev npm test
