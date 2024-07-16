import { readFileSync, writeFileSync } from 'node:fs'

const packageJSON = JSON.parse(readFileSync('package.json', 'utf8'))

packageJSON.devDependencies = undefined
packageJSON['lint-staged'] = undefined
packageJSON.scripts.build = undefined
packageJSON.scripts.postbuild = undefined

packageJSON.main = './handler.mjs'

writeFileSync(
  './dist/package.json',
  JSON.stringify(packageJSON, null, 2),
);
