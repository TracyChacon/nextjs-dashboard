# --- STAGE 1: Dependency Installation & Local CLI Setup (Build Stage) ---
FROM node:24-slim AS base 
# Install pnpm globally (required for running pnpm commands)
RUN npm install -g pnpm

# Set the working directory to the project root
WORKDIR /usr/src/app

# Copy dependency files
COPY package.json pnpm-lock.yaml ./

# Install all dependencies, including the locally installed Gemini CLI
RUN pnpm install

# Test the local CLI installation (optional, good for verification)
RUN pnpm exec gemini --version

# --- STAGE 2: Final Image (Production Stage) ---
FROM node:24-slim AS final 

# Install pnpm globally again in the final image
RUN npm install -g pnpm

# Set the same working directory
WORKDIR /usr/src/app

# Copy only the installed dependencies and the local CLI from the build stage
COPY --from=base /usr/src/app/node_modules ./node_modules
COPY --from=base /usr/src/app/package.json .
COPY --from=base /usr/src/app/pnpm-lock.yaml .

# Copy the rest of the application code
COPY . .

# Expose the port Next.js runs on
EXPOSE 3000

# Set environment variable 
ENV NODE_ENV development

# Command to start the application (using pnpm)
CMD ["pnpm", "dev"]