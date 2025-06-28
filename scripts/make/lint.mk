.PHONY: lint lint-service

## lint~~ Lint all services, or a single service if service is set (polyglot, recursive)
lint:
	@echo "[lint.mk] Linting services..."
	@if [ -n "$(service)" ]; then \
	  svc=./services/$(service); \
	  if [ -d "$$svc" ]; then \
	    echo "[lint.mk] Linting only for service: $(service) ($$svc)"; \
	    $(MAKE) lint-service SERVICE_DIR="$$svc" || exit 1; \
	  else \
	    echo "[lint.mk] ERROR: Service directory '$$svc' does not exist."; \
	    exit 1; \
	  fi; \
	else \
	  npm run lint --if-present --workspaces; \
    set -e; \
	  services=$$(find ./services -mindepth 1 -maxdepth 1 -type d); \
	  echo "[lint.mk] Found services:"; \
	  echo "$$services" | sed 's/^/  - /'; \
	  for svc in $$services; do \
	    $(MAKE) lint-service SERVICE_DIR="$$svc" || exit 1; \
	  done; \
	fi
	@echo "[lint.mk] All services linted successfully."

## lint-service~~ Lint a single service (auto-detects language)
lint-service:
	@svc="$(SERVICE_DIR)"; \
	echo "[lint.mk] Linting in $$svc..."; \
	if [ -f "$$svc/package.json" ]; then \
	  if [ -f "$$svc/package.json" ]; then \
	    echo "[lint.mk] Running lint check in $$svc"; \
	    (cd "$$svc" && npm run lint) || (echo "[lint.mk] lint check failed in $$svc" && exit 1); \
	  fi; \
	elif [ -f "$$svc/pyproject.toml" ] || [ -f "$$svc/requirements.txt" ]; then \
	  echo "[lint.mk] Running flake8 in $$svc"; \
	  (cd "$$svc" && flake8 .) || (echo "[lint.mk] flake8 failed in $$svc" && exit 1); \
	elif [ -f "$$svc/Cargo.toml" ]; then \
	  echo "[lint.mk] Running cargo clippy in $$svc"; \
	  (cd "$$svc" && cargo clippy --all-targets --all-features -- -D warnings) || (echo "[lint.mk] cargo clippy failed in $$svc" && exit 1); \
	else \
	  echo "[lint.mk] No recognized linter or manifest in $$svc, skipping."; \
	fi

