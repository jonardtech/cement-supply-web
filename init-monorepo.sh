#!/bin/bash

# Exit on any error
set -e

echo "🚀 Starting JCIL Cement Supply Web Platform Monorepo Initialization..."

# Step 1: Clean up any existing partial setup
echo "🧹 Cleaning up existing files..."
rm -rf apps packages node_modules .turbo
rm -f package.json package-lock.json turbo.json

# Step 2: Initialize Turborepo
echo "📦 Initializing Turborepo..."
npx create-turbo@latest . --skip-install << EOF
.
npm
EOF

# Step 3: Remove default Turborepo apps
echo "🗑️  Removing default Turborepo apps..."
rm -rf apps/docs apps/web packages/ui packages/eslint-config packages/typescript-config

# Step 4: Create JCIL-specific structure
echo "📁 Creating JCIL folder structure..."
mkdir -p apps/api apps/web packages/shared/src

# Step 5: Initialize NestJS Backend
echo "🔧 Initializing NestJS Backend (apps/api)..."
cd apps/api
npx @nestjs/cli new . --package-manager npm --skip-git --skip-install
cd ../..

# Step 6: Initialize Next.js Frontend
echo "🎨 Initializing Next.js Frontend (apps/web)..."
cd apps/web
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-npm --skip-install
cd ../..

# Step 7: Configure Shared Package
echo "📚 Configuring Shared Package (packages/shared)..."
cd packages/shared

# Create package.json
cat > package.json << 'EOF'
{
  "name": "@jcil/shared",
  "version": "1.0.0",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
EOF

# Create tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# Create index.ts
cat > src/index.ts << 'EOF'
export const JCIL_VERSION = "1.0.0";
export const API_VERSION = "v1";
EOF

cd ../..

# Step 8: Configure Turborepo
echo "⚙️  Configuring Turborepo..."
cat > turbo.json << 'EOF'
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "!.next/cache/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "test": {
      "dependsOn": ["^build"]
    }
  }
}
EOF

# Step 9: Configure Root package.json
echo "📋 Configuring Root package.json..."
cat > package.json << 'EOF'
{
  "name": "cement-supply-web",
  "version": "1.0.0",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "turbo run dev",
    "build": "turbo run build",
    "lint": "turbo run lint",
    "test": "turbo run test",
    "dev:api": "turbo run dev --filter=@jcil/api",
    "dev:web": "turbo run dev --filter=@jcil/web",
    "build:api": "turbo run build --filter=@jcil/api",
    "build:web": "turbo run build --filter=@jcil/web"
  },
  "devDependencies": {
    "turbo": "^2.0.0"
  }
}
EOF

# Step 10: Update apps/api package.json
echo "🔗 Linking apps/api to shared package..."
cd apps/api
npm pkg set name="@jcil/api"
npm pkg set dependencies.@jcil/shared="*"
cd ../..

# Step 11: Update apps/web package.json
echo "🔗 Linking apps/web to shared package..."
cd apps/web
npm pkg set name="@jcil/web"
npm pkg set dependencies.@jcil/shared="*"
cd ../..

# Step 12: Create comprehensive .gitignore
echo "🚫 Creating .gitignore..."
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
*/node_modules/
**/node_modules/

# Turbo
.turbo/

# Next.js
apps/web/.next/
apps/web/out/
apps/web/dist/

# NestJS
apps/api/dist/
apps/api/node_modules/

# Shared package
packages/shared/dist/
packages/shared/node_modules/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
apps/api/.env
apps/web/.env

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov
.nyc_output

# Build outputs
build/
dist/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# OS
Thumbs.db
.DS_Store

# Testing
.jest/
*.test.js.snap
*.test.ts.snap

# Misc
.cache/
.temp/
.tmp/
*.tsbuildinfo

# Database (if using local SQLite for testing)
*.db
*.sqlite
*.sqlite3

# Uploaded files (if storing locally during dev)
uploads/
EOF

# Step 13: Install all dependencies
echo "📥 Installing dependencies..."
npm install

# Step 14: Build shared package first
echo "🔨 Building shared package..."
cd packages/shared
npm run build
cd ../..

# Step 15: Test the setup
echo "✅ Testing the setup..."
echo "Running build command..."
npm run build

echo ""
echo "🎉 Monorepo initialization complete!"
echo ""
echo "📊 Your structure:"
echo "  cement-supply-web/"
echo "  ├── apps/"
echo "  │   ├── api/          # NestJS Backend"
echo "  │   └── web/          # Next.js Frontend"
echo "  ├── packages/"
echo "  │   └── shared/       # Shared TypeScript types"
echo "  ├── turbo.json"
echo "  └── package.json"
echo ""
echo "🚀 Next steps:"
echo "  1. Review the .gitignore file"
echo "  2. Run: git add ."
echo "  3. Run: git commit -m 'Initialize Turborepo monorepo'"
echo "  4. Run: git push origin main"
echo ""
echo "🔧 To start development:"
echo "  npm run dev          # Start both API and Web"
echo "  npm run dev:api      # Start only API"
echo "  npm run dev:web      # Start only Web"