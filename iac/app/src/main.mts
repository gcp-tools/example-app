import { App } from 'cdktf'
import { JobsStack } from './stacks/jobs/index.mjs'

const app = new App()

new JobsStack(app)

app.synth()
