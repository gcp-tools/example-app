.PHONY: build build-service

## build~~ Build all services, or a single service if service is set (polyglot, recursive)
build:
	@echo "[build.mk] Building services..."
	@if [ -n "$(service)" ]; then \
	  svc=./services/$(service); \
	  if [ -d "$$svc" ]; then \
	    echo "[build.mk] Building only for service: $(service) ($$svc)"; \
	    $(MAKE) build-service SERVICE_DIR="$$svc" || exit 1; \
	  else \
	    echo "[build.mk] ERROR: Service directory '$$svc' does not exist."; \
	    exit 1; \
	  fi; \
	else \
	  set -e; \
	  services=$$(find ./services -mindepth 1 -maxdepth 1 -type d); \
	  echo "[build.mk] Found services:"; \
	  echo "$$services" | sed 's/^/  - /'; \
	  for svc in $$services; do \
	    $(MAKE) build-service SERVICE_DIR="$$svc" || exit 1; \
	  done; \
	fi
	@echo "[build.mk] All services built successfully."

## build-service~~ Build a single service (auto-detects language)
build-service:
	@svc="$(SERVICE_DIR)"; \
	echo "[build.mk] Building in $$svc..."; \
	if [ -f "$$svc/package.json" ]; then \
	  if grep -q '"build"' "$$svc/package.json"; then \
	    echo "[build.mk] Running npm run build in $$svc"; \
	    (cd "$$svc" && npm run build) || (echo "[build.mk] npm run build failed in $$svc" && exit 1); \
	  else \
	    echo "[build.mk] No build script in $$svc/package.json, skipping."; \
	  fi; \
	elif [ -f "$$svc/setup.py" ]; then \
	  echo "[build.mk] Running python setup.py build in $$svc"; \
	  (cd "$$svc" && python setup.py build) || (echo "[build.mk] python build failed in $$svc" && exit 1); \
	elif [ -f "$$svc/Cargo.toml" ]; then \
	  echo "[build.mk] Running cargo build in $$svc"; \
	  (cd "$$svc" && cargo build) || (echo "[build.mk] cargo build failed in $$svc" && exit 1); \
	else \
	  echo "[build.mk] No recognized build script or manifest in $$svc, skipping."; \
	fi
