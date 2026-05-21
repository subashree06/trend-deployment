# ============================================================
# Dockerfile – Trend App
# Serves the pre-built dist/ folder using 'serve' on port 3000
# ============================================================

FROM node:18-alpine

WORKDIR /app

# Install 'serve' to host static files
RUN npm install -g serve

# Copy the pre-built dist folder
COPY dist ./dist

EXPOSE 3000

# Serve dist on port 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
