## How I Start

This site is for [howistart.org](http://www.howistart.org). It is built using the [Haskell](http://www.haskell.org) web framework [Snap](http://snapframework.com/) and deployed to [Heroku](http://heroku.com) using [Haskell on Heroku](https://github.com/mietek/haskell-on-heroku).

### Building

The posts are stored in a [submodule](https://github.com/howistart/howistart.git) so use `--recursive` when cloning this repo.

```shell
$ git clone --recursive https://github.com/howistart/howistart.org.git
$ cabal sandbox init
$ cabal install --only-dependencies
$ cabal build
$ PORT=8080 cabal run
Preprocessing executable 'howistart' for howistart-0.1...
Initializing app @ /
Initializing heist @ /
...loaded 9 templates from howistart.org/snaplets/heist/templates

Listening on http://0.0.0.0:8080/
[28/Jun/2014:19:38:24 -0500] Server.httpServe: START, binding to [http://0.0.0.0:8080/]
```

### Deploying to Heroku

```shell
$ heroku create -b https://github.com/mietek/haskell-on-heroku.git
$ git push heroku master
```

This push is expected to fail. But now we can prepare the dependencies:

```shell
$ heroku run --size=PX prepare
```

And now push again with a change or use rebuild:

```shell
$ heroku plugins:install https://github.com/heroku/heroku-repo.git
$ heroku repo:rebuild
$ heroku ps:scale web=1
```

And finally open:

```shell
$ heroku open
```
