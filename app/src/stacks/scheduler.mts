import { functions } from '@gcp-tools/cdktf/constructs'
import { AppStack, type AppStackConfig } from '@gcp-tools/cdktf/stacks/app'
import type { Construct } from 'constructs'


export class SchedulerStack extends AppStack {
  constructor(scope: Construct, config: AppStackConfig) {
    super(scope, 'scheduler', config)

    new functions.HttpConstruct(this, 'scheduler-api', {
      buildConfig: {},
      serviceConfig: {},
    })
  }
}
