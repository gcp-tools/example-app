import { App } from 'cdktf'

import * as infra from '@gcp-tools/cdktf/stacks/infrastructure'

const infraConfig = {}

const app = new App()

new infra.NetworkStack(app, infraConfig)
new infra.SqlStack(app, infraConfig)
new infra.IamStack(app, infraConfig)

app.synth()


