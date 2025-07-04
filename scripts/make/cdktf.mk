syn%: ##   synth ~ synthesises the terraform configuration for the given workspace
syn%: ##         ~ runs the workspace `npm run cdk:synth` script
synth:
	@npm run synth \
  --workspace ./${workspace}


dif%: ##   diff ~ diffs the terraform configuration for the given workspace and stack
dif%: ##         ~ runs the workspace `npm run cdk:diff` script
diff: export STACK = ${stack}
diff:
	@npm run diff \
  --workspace ./${workspace}


dep%: ##   deploy ~ deploys the terraform configuration for the given workspace and stack
dep%: ##         ~ runs the workspace `npm run cdk:deploy` script
deploy: export STACK = ${stack}
deploy:
	@npm run deploy \
  --workspace ./${workspace}


are.you.sur%: ##   are_you_sure ~ destroys the terraform configuration for the given workspace and stack
are.you.sur%: ##         ~ runs the workspace `npm run cdk:destroy` script
are.you.sure: export STACK = ${stack}
are.you.sure:
	@npm run destroy \
  --workspace ./${workspace}

help_linebreak: ##     ~~ 