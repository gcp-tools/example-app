import * as projects from '@gcp-tools/cdktf/stacks/projects'
import { App } from 'cdktf'

const app = new App()

new projects.HostProjectStack(app)
new projects.DataProjectStack(app, {
  apis: ['compute', 'firestore'],
})
new projects.AppProjectStack(app)

app.synth()
