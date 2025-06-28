import * as infra from '@gcp-tools/cdktf/stacks/infrastructure'
import { App } from 'cdktf'

const app = new App()

new infra.NetworkInfraStack(app, {
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
new infra.IamInfraStack(app, {})
new infra.FirestoreInfraStack(app, {})

app.synth()
