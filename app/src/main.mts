import { App } from 'cdktf'
import * as stacks from './stacks/index.mjs'
import { envVars } from '@gcp-tools/cdktf/utils'

const appConfig = {
  bucket: envVars.GCP_TOOLS_TERRAFORM_REMOTE_STATE_BUCKET_ID,
  environment: envVars.GCP_TOOLS_ENVIRONMENT,
  region: envVars.GCP_TOOLS_REGION,
  user: envVars.GCP_TOOLS_USER,
  apis: [],
}

const app = new App()

new stacks.SchedulerStack(app, appConfig)

app.synth()
