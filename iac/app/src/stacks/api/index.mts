import { cloudrun } from '@gcp-tools/cdktf/constructs'
import { AppStack } from '@gcp-tools/cdktf/stacks/app'
import { envConfig } from '@gcp-tools/cdktf/utils'
import { type App, TerraformOutput } from 'cdktf'

export class ApiStack extends AppStack {
  public readonly apiService: cloudrun.CloudRunServiceConstruct

  constructor(scope: App) {
    super(scope, 'api', {
      databases: ['firestore'],
    })

    this.apiService = new cloudrun.CloudRunServiceConstruct(
      this,
      this.stackId,
      {
        region: envConfig.regions[0],
        buildConfig: {},
        serviceConfig: {
          environmentVariables: {
            FIRESTORE_PROJECT_ID: this.firestoreDatabaseProjectId,
            NODE_ENV: 'production',
          },
        },
      },
    )

    new TerraformOutput(this, 'service-uri', {
      description: 'The name of the Cloud Run service.',
      value: this.apiService.service.uri,
    })

    new TerraformOutput(this, 'service-name', {
      description: 'The URI of the API service.',
      value: this.apiService.service.name,
    })

    new TerraformOutput(this, 'service-location', {
      description: 'The location of the API service.',
      value: this.apiService.service.location,
    })

    new TerraformOutput(this, 'service-project', {
      description: 'The project of the API service.',
      value: this.apiService.service.project,
    })
  }
}
