# Structure for Enterprise Modules

The Enterprise Module will be loaded from `src/index.html`.

## Initial Setup:

* Install dependencies:
  `bower install`
  `npm install`

* Initialize your module against an existing Composer application:
  `https://composer2.<env>.com/modules/connect`

In case the configuration for your WS application has changed:
* Refresh `config/appgyver.json`:
  `steroids module refresh --envApiHost=https://env-api.<env>.com`

PLEASE NOTE:
===========
`steroids module init` and `steroids module refresh` must be run in the
root directory, ie. NOT in the directory "mobile" or "web"!


## Mobile Development

~~~
cd mobile
steroids update
steroids connect --watch ../src/
~~~


## Web Development
~~~
cd web
python -m SimpleHTTPServer 8888
~~~
