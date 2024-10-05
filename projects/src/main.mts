import { App } from 'cdktf'
import * as projects from '@gcp-tools/cdktf/stacks/projects'

const app = new App()

new projects.HostProjectStack(app)
new projects.DbProjectStack(app)
new projects.AppProjectStack(app)

app.synth()

