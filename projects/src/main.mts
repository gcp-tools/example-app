import { App } from 'cdktf'
import * as projects from '@gcp-tools/cdktf/stacks/projects'
import { envVars } from '@gcp-tools/cdktf/utils'

const projectConfig = {
  bucket: envVars.GCP_TOOLS_TERRAFORM_REMOTE_STATE_BUCKET_ID,
  environment: envVars.GCP_TOOLS_ENVIRONMENT,
  region: envVars.GCP_TOOLS_REGION,
  apis: [],
  billingAccount: envVars.GCP_TOOLS_BILLING_ACCOUNT,
  orgId: envVars.GCP_TOOLS_ORG_ID,
  owners: envVars.GCP_TOOLS_OWNER_EMAILS,
}

const app = new App()

new projects.HostProjectStack(app, projectConfig)
new projects.DbProjectStack(app, projectConfig)
new projects.AppProjectStack(app, projectConfig)

app.synth()

