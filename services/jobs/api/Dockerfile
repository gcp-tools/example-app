# --- Build Stage ---
# Use the official Node.js 22 slim image for the build environment
FROM node:22-slim AS builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Copy the rest of the application source code
COPY . .

# Install all dependencies, including devDependencies for building
RUN npm ci

# Build the TypeScript code
RUN npm run build

# --- Production Stage ---
# Use a clean, slim Node.js image for the production environment
FROM node:22-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy the compiled code from the builder stage
COPY --from=builder /usr/src/app/dist ./dist

# The main command to run when the container starts
CMD [ "node", "dist/handler.mjs" ]
