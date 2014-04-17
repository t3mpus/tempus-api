#!/bin/bash
curl staging.api.t3mp.us -s > /dev/null
TIMEOUT=3000 TEMPUS_HOST=staging.api.t3mp.us PORT=80 npm test
