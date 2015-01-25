
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
  prefix: '' # empty, '/' or cdn url
```

### License

MIT
