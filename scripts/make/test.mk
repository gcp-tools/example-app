.PHONY: test test-service

## test~~ Test all services and their components, or specific service/component if parameters are set
test:
	bash scripts/make/traverse.sh test $(service) $(component)

## test-service~~ Test a single service component (auto-detects language)
test-service:
	@svc="$(SERVICE_DIR)"; \
	echo "[test.mk] Testing in $$svc..."; \
	if [ -f "$$svc/package.json" ]; then \
	  echo "[test.mk] Running test in $$svc"; \
	  (cd "$$svc" && npm run test --if-present) || (echo "[test.mk] test failed in $$svc" && exit 1); \
	elif [ -f "$$svc/pyproject.toml" ] || [ -f "$$svc/requirements.txt" ]; then \
	  echo "[test.mk] Running pytest in $$svc"; \
	  (cd "$$svc" && pytest) || (echo "[test.mk] pytest failed in $$svc" && exit 1); \
	elif [ -f "$$svc/Cargo.toml" ]; then \
	  echo "[test.mk] Running cargo test in $$svc"; \
	  (cd "$$svc" && cargo test) || (echo "[test.mk] cargo test failed in $$svc" && exit 1); \
	else \
	  echo "[test.mk] No recognized test runner or manifest in $$svc, skipping."; \
	fi
