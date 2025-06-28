.PHONY: test test-service

## test~~ Test all services, or a single service if service is set (polyglot, recursive)
test:
	@echo "[test.mk] Testing services..."
	@if [ -n "$(service)" ]; then \
	  svc=./services/$(service); \
	  if [ -d "$$svc" ]; then \
	    echo "[test.mk] Testing only for service: $(service) ($$svc)"; \
	    $(MAKE) test-service SERVICE_DIR="$$svc" || exit 1; \
	  else \
	    echo "[test.mk] ERROR: Service directory '$$svc' does not exist."; \
	    exit 1; \
	  fi; \
	else \
	  set -e; \
	  services=$$(find ./services -mindepth 1 -maxdepth 1 -type d); \
	  echo "[test.mk] Found services:"; \
	  echo "$$services" | sed 's/^/  - /'; \
	  for svc in $$services; do \
	    $(MAKE) test-service SERVICE_DIR="$$svc" || exit 1; \
	  done; \
	fi
	@echo "[test.mk] All services tested successfully."

## test-service~~ Test a single service (auto-detects language)
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
