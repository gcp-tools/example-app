import { App } from 'cdktf'
import { ApiStack } from './stacks/api/index.mjs'

const app = new App()

new ApiStack(app)

app.synth()
