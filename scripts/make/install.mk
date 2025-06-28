.PHONY: install install-service

## install~~ Install dependencies for all services, or a single service if service is set (polyglot, recursive)
install:
	@echo "[install.mk] Installing dependencies..."
	@if [ -n "$(service)" ]; then \
	  svc=./services/$(service); \
	  if [ -d "$$svc" ]; then \
	    echo "[install.mk] Installing only for service: $(service) ($$svc)"; \
	    $(MAKE) install-service SERVICE_DIR="$$svc" || exit 1; \
	  else \
	    echo "[install.mk] ERROR: Service directory '$$svc' does not exist."; \
	    exit 1; \
	  fi; \
	else \
		npm install --workspaces; \
    set -e; \
	  services=$$(find ./services -mindepth 1 -maxdepth 1 -type d); \
	  echo "[install.mk] Found services:"; \
	  echo "$$services" | sed 's/^/  - /'; \
	  for svc in $$services; do \
	    $(MAKE) install-service SERVICE_DIR="$$svc" || exit 1; \
	  done; \
	fi
	@echo "[install.mk] All dependencies installed successfully."

## install-service~~ Install dependencies for a single service (auto-detects language)
install-service:
	@svc="$(SERVICE_DIR)"; \
	echo "[install.mk] Installing dependencies in $$svc..."; \
	if [ -f "$$svc/package.json" ]; then \
	  echo "[install.mk] Running npm install in $$svc"; \
	  (cd "$$svc" && npm install) || (echo "[install.mk] npm install failed in $$svc" && exit 1); \
	elif [ -f "$$svc/requirements.txt" ]; then \
	  echo "[install.mk] Running pip install in $$svc"; \
	  (cd "$$svc" && pip install -r requirements.txt) || (echo "[install.mk] pip install failed in $$svc" && exit 1); \
	elif [ -f "$$svc/Cargo.toml" ]; then \
	  echo "[install.mk] Running cargo build in $$svc"; \
	  (cd "$$svc" && cargo build) || (echo "[install.mk] cargo build failed in $$svc" && exit 1); \
	else \
	  echo "[install.mk] No recognized install script or lockfile in $$svc, skipping."; \
	fi
