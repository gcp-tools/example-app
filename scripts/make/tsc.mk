buil%: ##   build ~  compiles typescript for the given workspace
buil%: ##         ~  runs the workspace `npm run build` script
build:
	@npm run build \
  --workspace ./${workspace}

help_linebreak: ##     ~~
