# Stage 1: Build the app
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy app source code
COPY . .

# Build the app
RUN npm run build

# Stage 2: Serve the app
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy built assets from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./

# Install only production dependencies
RUN npm install

# Expose the Next.js default port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
