import * as infra from '@gcp-tools/cdktf/stacks/infrastructure'
import { envConfig } from '@gcp-tools/cdktf/utils'
import { App } from 'cdktf'

const app = new App()

const isProd = envConfig.environment === 'prod'

const minThroughput = isProd ? 600 : 200
const maxThroughput = isProd ? 1200 : 300

const networkStack = new infra.NetworkInfraStack(app, {
  subnetworkCidr: '10.1.0.0/20',
  connectorCidr: '10.8.0.0/28',
  scaling: {
    type: 'THROUGHPUT',
    data: {
      minThroughput,
      maxThroughput,
    },
  },
})

// new infra.SqlStack(app, {})
const iamStack = new infra.IamInfraStack(app, {})
iamStack.addDependency(networkStack)

const firestoreStack = new infra.FirestoreInfraStack(app, {})
firestoreStack.addDependency(networkStack)
firestoreStack.addDependency(iamStack)

app.synth()
