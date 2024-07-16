import { App } from 'cdktf'

import * as infra from '@gcp-tools/cdktf/stacks/infrastructure'
import { envVars } from '@gcp-tools/cdktf/utils'

const infraConfig = {
  bucket: envVars.GCP_TOOLS_TERRAFORM_REMOTE_STATE_BUCKET_ID,
  environment: envVars.GCP_TOOLS_ENVIRONMENT,
  region: envVars.GCP_TOOLS_REGION,
}

const app = new App()

new infra.NetworkStack(app, infraConfig)
new infra.SqlStack(app, infraConfig)
new infra.IamStack(app, infraConfig)

app.synth()
