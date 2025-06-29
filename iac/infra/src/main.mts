import * as infra from '@gcp-tools/cdktf/stacks/infrastructure'
import { App } from 'cdktf'

const app = new App()

const networkStack = new infra.NetworkInfraStack(app, {
  subnetworkCidr: '10.1.0.0/20',
  connectorCidr: '10.8.0.0/28',
  scaling: {
    type: 'INSTANCES',
    data: {
      minInstances: 2, // todo - modify this for dev/prod etc
      maxInstances: 3, // todo - modify this for dev/prod etc
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
