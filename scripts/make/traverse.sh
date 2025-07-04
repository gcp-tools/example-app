#!/bin/bash
set -e

ACTION="$1"
SERVICE="$2"
COMPONENT="$3"

if [ -n "$SERVICE" ]; then
  if [ -n "$COMPONENT" ]; then
    # Specific service component
    SVC="./services/$SERVICE/$COMPONENT"
    if [ -d "$SVC" ]; then
      echo "[traverse.sh] $ACTION only for service component: $SERVICE/$COMPONENT ($SVC)"
      make "$ACTION-service" SERVICE_DIR="$SVC"
    else
      echo "[traverse.sh] ERROR: Service component directory '$SVC' does not exist."
      exit 1
    fi
  else
    # All components of a specific service
    SVC="./services/$SERVICE"
    if [ -d "$SVC" ]; then
      echo "[traverse.sh] $ACTION all components for service: $SERVICE ($SVC)"
      COMPONENTS=$(find "$SVC" -mindepth 1 -maxdepth 1 -type d)
      if [ -z "$COMPONENTS" ]; then
        echo "[traverse.sh] No components found in $SVC, $ACTION service directly"
        make "$ACTION-service" SERVICE_DIR="$SVC"
      else
        echo "[traverse.sh] Found components:"
        echo "$COMPONENTS" | sed 's/^/  - /'
        for comp in $COMPONENTS; do
          make "$ACTION-service" SERVICE_DIR="$comp"
        done
      fi
    else
      echo "[traverse.sh] ERROR: Service directory '$SVC' does not exist."
      exit 1
    fi
  fi
else
  # All services and their components
  SERVICES=$(find ./services -mindepth 1 -maxdepth 1 -type d)
  echo "[traverse.sh] Found services:"
  echo "$SERVICES" | sed 's/^/  - /'
  for svc in $SERVICES; do
    echo "[traverse.sh] Processing service: $svc"
    COMPONENTS=$(find "$svc" -mindepth 1 -maxdepth 1 -type d)
    if [ -z "$COMPONENTS" ]; then
      echo "[traverse.sh] No components found in $svc, $ACTION service directly"
      make "$ACTION-service" SERVICE_DIR="$svc"
    else
      echo "[traverse.sh] Found components in $svc:"
      echo "$COMPONENTS" | sed 's/^/    - /'
      for comp in $COMPONENTS; do
        make "$ACTION-service" SERVICE_DIR="$comp"
      done
    fi
  done
fi

echo "[traverse.sh] All services $ACTION successfully."
