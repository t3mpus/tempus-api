tempus
======

Track time effortlessly

Status
------
[![Build Status](https://travis-ci.org/t3mpus/tempus.png)](https://travis-ci.org/t3mpus/tempus)

Development
-----------

Please use [git-flow](https://github.com/nvie/gitflow) and follow
[this](http://nvie.com/posts/a-successful-git-branching-model/) for our
branching model. Using pull requests are nice too, but the name spacing
is where its at. If not using pull requests, **please update your branch
prefixes to include your username or identifier**. For example, my
feature branches have the prefix `wlaurance/feature/awesome-new-thing`.

###Code Style

2 space soft tabs for {coffee,java}script.

Other than that verbosely name vars and functions so others can tell
what they are for without too much effort.

###Tiers

* Development - Your local machine. Break stuff, only you care. (Don't
  merge bad code to development branch)

* Staging - Mostly liking on [heroku](http://staging.api.t3mp.us). This
  is where production level testing is run. Including the development
  test suite, production test suites, long running test suites(on the
  order of days) **TREAT Staging like you would production!!**

* Production - Not anywhere yet. Hopefully api.temp.us

####Tier Separation

Every tier will have its own environment. Meaning a local, staging, and
production Postgres entity and other resources. This seems obvious but
**never point staging code to production resources!!** Every tier should
live in its own capsule, free from side-effects from the other.

###SQL Migrations

One day, someone else I hire will read this. Yes we are still using SQL.
Don't freak out. We are using [db-migrate](https://github.com/kunklejr/node-db-migrate) and
@brianc's [node-postgres](https://github.com/brianc/node-postgres). It
is very important that you ensure your **migrations can run up and down!!**

Currently a migration strategy is only present for Development and
Staging.

###Credentials

Currently dev/staging/production credentials **are not** store in git. Keep it that way...
