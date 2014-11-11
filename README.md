_howistart.org_
===============

Haskell/[Snap](http://snapframework.com/) web publication.


Usage
-----

### Deploying with [Halcyon](http://halcyon.sh/)

With Halcyon installed:

```
$ halcyon deploy https://github.com/mietek/howistart.org#halcyon
$ cd $HALCYON_DIR/app
$ PORT=8080 howistart
```

- [Learn more](http://halcyon.sh/examples/#howistart.org)


### Deploying with [Haskell on Heroku](http://haskellonheroku.com/)

Ready to deploy to Heroku in two clicks.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/mietek/howistart.org/tree/halcyon/)

Alternatively, with Heroku Toolbelt installed:

```
$ git clone https://github.com/mietek/howistart.org -b halcyon
$ cd howistart.org
$ heroku create -b https://github.com/mietek/haskell-on-heroku -s cedar-14
$ git push heroku master
$ heroku ps:scale web=1
$ heroku open
```

- [Deploy to Heroku](https://heroku.com/deploy?template=https://github.com/mietek/howistart.org/tree/halcyon/)
- [Learn more](http://haskellonheroku.com/examples/#howistart.org)


About
-----

Made by [Tristan Sloughter](https://github.com/howistart/howistart.org/).  Published under the [GNU GPL](https://github.com/mietek/howistart.org/blob/halcyon/LICENSE).

Deployment by [Miëtek Bak](http://mietek.io/).
