
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
  base: __dirname
  from: 'example/'
  dest: 'dist/'
  ignoreDirs: ['node_modules']
  cdn: null
  entries: ['index.html', 'ejs/index/ejs']
```

### License

MIT
