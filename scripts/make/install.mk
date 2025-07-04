.PHONY: install install-service

## install~~ Install dependencies for all services and their components, or specific service/component if parameters are set
install:
	@# Special case: run npm install --workspaces first for root dependencies
	@if [ -z "$(service)" ] && [ -z "$(component)" ]; then \
	  echo "[install.mk] Installing root workspace dependencies..."; \
	  npm install --workspaces --if-present || echo "[install.mk] Warning: No workspaces found or workspace install failed, continuing..."; \
	fi
	bash scripts/make/traverse.sh install $(service) $(component)

## install-service~~ Install dependencies for a single service component (auto-detects language)
install-service:
	@svc="$(SERVICE_DIR)"; \
	echo "[install.mk] Installing dependencies in $$svc..."; \
	if [ -f "$$svc/package.json" ]; then \
	  echo "[install.mk] Running npm install in $$svc"; \
	  (cd "$$svc" && npm install --if-present) || (echo "[install.mk] npm install failed in $$svc" && exit 1); \
	elif [ -f "$$svc/requirements.txt" ]; then \
	  echo "[install.mk] Running pip install in $$svc"; \
	  (cd "$$svc" && pip install -r requirements.txt) || (echo "[install.mk] pip install failed in $$svc" && exit 1); \
	elif [ -f "$$svc/Cargo.toml" ]; then \
	  echo "[install.mk] Running cargo build in $$svc"; \
	  (cd "$$svc" && cargo build) || (echo "[install.mk] cargo build failed in $$svc" && exit 1); \
	else \
	  echo "[install.mk] No recognized install script or lockfile in $$svc, skipping."; \
	fi