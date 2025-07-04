.PHONY: build build-service

## build~~ Build all services and their components, or specific service/component if parameters are set
build:
	bash scripts/make/traverse.sh build $(service) $(component)

## build-service~~ Build a single service component (auto-detects language)
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
