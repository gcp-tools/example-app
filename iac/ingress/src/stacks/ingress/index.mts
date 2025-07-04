import { join } from 'node:path'
import { cloudRunServiceIamMember as CloudRunIam } from '@cdktf/provider-google'
import { ApiGatewayConstruct } from '@gcp-tools/cdktf/constructs'
import { IngressStack as BaseIngressStack } from '@gcp-tools/cdktf/stacks/ingress'
import { envConfig } from '@gcp-tools/cdktf/utils'
import { type App, DataTerraformRemoteStateGcs } from 'cdktf'

export class IngressStack extends BaseIngressStack {
  public readonly jobsAppRemoteState: DataTerraformRemoteStateGcs

  constructor(scope: App) {
    super(scope, 'ingress', { user: envConfig.user })

    this.jobsAppRemoteState = new DataTerraformRemoteStateGcs(
      this,
      this.id('remote', 'state', 'jobs'),
      {
        bucket: envConfig.bucket,
        prefix: this.remotePrefix('app', 'jobs'),
      },
    )

    const apiUri = this.jobsAppRemoteState.getString('api-service-uri')
    const apiServiceName = this.jobsAppRemoteState.getString('api-service-name')
    const apiServiceLocation =
      this.jobsAppRemoteState.getString('api-service-location')
    const apiServiceProject =
      this.jobsAppRemoteState.getString('api-service-project')

    new ApiGatewayConstruct(this, 'core-api', {
      region: envConfig.regions[0],
      displayName: 'liplan-api-gateway',
      openApiTemplatePath: join(
        process.cwd(),
        '..',
        '..',
        'api-gateway-config/openapi.yaml.tpl',
      ),
      cloudRunServices: [
        {
          key: 'JOBS_BACKEND_URI',
          name: apiServiceName,
          uri: apiUri,
        },
      ],
    })

    new CloudRunIam.CloudRunServiceIamMember(this, 'ingress-sa-invoker', {
      service: apiServiceName,
      location: apiServiceLocation,
      project: apiServiceProject,
      role: 'roles/run.invoker',
      member: `serviceAccount:${this.stackServiceAccount.email}`,
      provider: this.googleProvider,
    })
  }
}
