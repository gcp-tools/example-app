import { App } from 'cdktf'

import * as infra from '@gcp-tools/cdktf/stacks/infrastructure'

const app = new App()

new infra.NetworkStack(app, {})
new infra.SqlStack(app, {})
new infra.IamStack(app, {})

app.synth()


