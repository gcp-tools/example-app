.PHONY: lint lint-service

## lint~~ Lint all services and their components, or specific service/component if parameters are set
lint:
	bash scripts/make/traverse.sh lint $(service) $(component)

## lint-service~~ Lint a single service component (auto-detects language)
lint-service:
	@svc="$(SERVICE_DIR)"; \
	echo "[lint.mk] Linting in $$svc..."; \
	if [ -f "$$svc/package.json" ]; then \
	  echo "[lint.mk] Running lint in $$svc"; \
	  (cd "$$svc" && npm run lint --if-present) || (echo "[lint.mk] lint failed in $$svc" && exit 1); \
	elif [ -f "$$svc/pyproject.toml" ] || [ -f "$$svc/requirements.txt" ]; then \
	  echo "[lint.mk] Running ruff in $$svc"; \
	  (cd "$$svc" && ruff check .) || (echo "[lint.mk] ruff failed in $$svc" && exit 1); \
	elif [ -f "$$svc/Cargo.toml" ]; then \
	  echo "[lint.mk] Running cargo clippy in $$svc"; \
	  (cd "$$svc" && cargo clippy) || (echo "[lint.mk] cargo clippy failed in $$svc" && exit 1); \
	else \
	  echo "[lint.mk] No recognized linter or manifest in $$svc, skipping."; \
	fi
