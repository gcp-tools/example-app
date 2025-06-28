import { App } from 'cdktf'
import { IngressStack } from './stacks/ingress/index.mjs'

const app = new App()

new IngressStack(app)

app.synth()
