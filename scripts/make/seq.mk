to.dif%: ##   to.diff ~ diffs the terraform configuration for the given workspace and stack
to.dif%: ##         ~ runs the workspace `npm run cdk:diff` script
to.diff: export STACK = ${stack}
to.diff:
	@make build ${workspace} synth ${workspace} diff ${workspace}

to.dep%: ##   to.diff ~ diffs the terraform configuration for the given workspace and stack
to.dep%: ##         ~ runs the workspace `npm run cdk:diff` script
to.deploy: export STACK = ${stack}
to.deploy:
	@make build ${workspace} synth ${workspace} deploy ${workspace}

help_linebreak: ##     ~~
