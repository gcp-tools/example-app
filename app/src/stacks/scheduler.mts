import { functions } from '@gcp-tools/cdktf/constructs'
import { AppStack } from '@gcp-tools/cdktf/stacks/app'
import { App } from 'cdktf'

export class SchedulerStack extends AppStack {
  constructor(scope: App) {
    super(scope, 'scheduler')

    new functions.HttpConstruct(this, 'scheduler-api', {
      buildConfig: {},
      serviceConfig: {},
    })
  }
}
