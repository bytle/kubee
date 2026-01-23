# Multi-stage build for Docusaurus with Caddy
#FROM node:20-alpine AS builder
# Set working directory
#WORKDIR /app
# Copy source code
#COPY . .
# Install dependencies
#RUN corepack enable
#RUN yarn install # --frozen-lockfile
#
## Build the static site
#RUN yarn build

# Production stage with Caddy
FROM caddy:2.8.4-alpine

ARG ORGANIZATION_NAME
ARG PROJECT_NAME
ARG VERSION

LABEL org.opencontainers.image.source=https://github.com/$ORGANIZATION_NAME/$PROJECT_NAME
LABEL org.opencontainers.image.description="Kubee Website"
LABEL org.opencontainers.image.title="$PROJECT_NAME"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.url=https://github.com/$ORGANIZATION_NAME/$PROJECT_NAME
LABEL org.opencontainers.image.documentation=https://github.com/$ORGANIZATION_NAME/$PROJECT_NAME
LABEL org.opencontainers.image.vendor="$PROJECT_NAME"
# LABEL org.opencontainers.image.authors="Your Name <email@example.com>"
# LABEL org.opencontainers.image.licenses=Apache2

#
COPY Caddyfile /etc/caddy/Caddyfile

# Copy built site from builder stage
# COPY --from=builder /app/dist /usr/share/caddy
COPY ./dist /usr/share/caddy

# Expose port 80
EXPOSE 80

# Caddy will automatically serve files from /usr/share/caddy
