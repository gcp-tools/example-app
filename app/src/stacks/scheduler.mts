import { functions } from '@gcp-tools/cdktf/constructs'
import { AppStack } from '@gcp-tools/cdktf/stacks/app'
import type { Construct } from 'constructs'

type SchedulerStackConfig = {}

export class SchedulerStack extends AppStack<SchedulerStackConfig> {
  constructor(scope: Construct, config: SchedulerStackConfig) {
    super(scope, 'scheduler', config)

    new functions.HttpConstruct(this, 'scheduler-api', {
      buildConfig: {},
      serviceConfig: {},
    })
  }
}
