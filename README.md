
Pages-Rev
-----

Simple web resources revision tool.

### Usage

```
npm i --save-dev pages-rev
```

```coffee
rev = require 'pages-rev'

rev.run
  base: "#{__dirname}/example/"
  dest: "#{__dirname}/dist/"
  ignoreDirs: ['node_modules']
  entries: ['index.html', 'ejs/index/ejs']
  prefix: '/' # or cdn url
```

### Options

* `base`(required)

Base path, usually where `index.html` is, or the directory corresponds the domain.
Uses absolute path.

* `dest`(required)

The directory to write revisioned files. Uses absolute path.

* `ignoreDirs`

Folders not needed to scan. Without `/`s.

* `entries`(required)

Files to start. Usually `index.html` or templates that can be viewed with URLs.

* `prefix`(required)

URL prefix to the domain. May be `/`, `/x/y` or CDN urls. Ends with '/'.

### Assumptions

This plugin has these assumptions:

* Resources are wrapped inside: `""`, `''`, or `()`
* Resource names do not contains `\`
* Path `base` corresponds to the domain(or directory of `index.html`)
* Files with same extname as files in `entries` are not renamed

### License

MIT
