import { App } from 'cdktf'
import * as stacks from './stacks/index.mjs'

const app = new App()

new stacks.SchedulerStack(app, {})

app.synth()
