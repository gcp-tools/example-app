import { functions } from '@gcp-tools/cdktf/constructs'
import { AppStack } from '@gcp-tools/cdktf/stacks/app'
import type { Construct } from 'constructs'

export class SchedulerStack extends AppStack {
  constructor(scope: Construct) {
    super(scope, 'scheduler')

    new functions.HttpConstruct(this, 'scheduler-api', {
      buildConfig: {},
      serviceConfig: {},
    })
  }
}
