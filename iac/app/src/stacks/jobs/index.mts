import { cloudrun } from '@gcp-tools/cdktf/constructs'
import { AppStack } from '@gcp-tools/cdktf/stacks/app'
import { envConfig } from '@gcp-tools/cdktf/utils'
import { type App, TerraformOutput } from 'cdktf'

export class JobsStack extends AppStack {
  public readonly apiService: cloudrun.CloudRunServiceConstruct

  constructor(scope: App) {
    super(scope, 'jobs', {
      databases: ['firestore'],
    })

    this.apiService = new cloudrun.CloudRunServiceConstruct(
      this,
      'api',
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

    new TerraformOutput(this, 'api-service-uri', {
      description: 'The name of the Cloud Run service.',
      value: this.apiService.service.uri,
    })

    new TerraformOutput(this, 'api-service-name', {
      description: 'The URI of the API service.',
      value: this.apiService.service.name,
    })

    new TerraformOutput(this, 'api-service-location', {
      description: 'The location of the API service.',
      value: this.apiService.service.location,
    })

    new TerraformOutput(this, 'api-service-project', {
      description: 'The project of the API service.',
      value: this.apiService.service.project,
    })
  }
}
