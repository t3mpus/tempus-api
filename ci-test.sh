#!/bin/bash
npm install
npm rebuild
./db-migrate -e travis up
npm test
