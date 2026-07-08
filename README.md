# JCIL Cement Supply Web Platform - Setup Guide

Complete setup documentation for the B2B cement distribution and order management system.

## 📋 Project Overview

**Repository:** `cement-supply-web`  
**Architecture:** Turborepo Monorepo  
**Tech Stack:**
- **Backend:** NestJS (Node.js/TypeScript) - Modular Monolith
- **Frontend:** Next.js (React/TypeScript) - SSR/SSG
- **Database:** MySQL 8.0+
- **Message Broker:** RabbitMQ
- **Cache/Queue:** Redis + BullMQ
- **Object Storage:** MinIO (local) / Cloudflare R2 (production)

## 🏗️ Repository Structure

cement-supply-web/
├── apps/
│ ├── api/ # NestJS Backend API
│ └── web/ # Next.js Frontend (Client/Admin Portal)
├── packages/
│ └── shared/ # Shared TypeScript types and utilities
├── .github/
│ └── workflows/
│ └── ci-pipeline.yml # GitHub Actions CI/CD
├── turbo.json # Turborepo configuration
├── package.json # Root workspace configuration
└── .gitignore # Git ignore rules


## ✅ Setup Steps Completed

### Step 1: Repository Initialization

#### 1.1 Created GitHub Repository
- Repository: `cement-supply-web`
- Description: "B2B cement distribution and order management platform for JCIL (Yaobai Cement)"
- Initialized with README.md and .gitignore

#### 1.2 Monorepo Structure Setup

**Commands Executed:**
```bash
git clone https://github.com/jonardtech/cement-supply-web.git
cd cement-supply-web
npx create-turbo@latest .
```

**Key Configuration Files:**
**Root `package.json:`**
```json
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
} ```

**Root `turbo.json:`**
```json
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
```

**Shared Package (packages/shared/package.json):**
```json
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
```

**Shared Package TypeScript Config (`packages/shared/tsconfig.json`):**
```json
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
```

**Comprehensive `.gitignore:**
```gitignore
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

# Shared package
packages/shared/dist/

# Environment variables
.env
.env.local
apps/api/.env
apps/web/.env

# Logs
logs/
*.log
npm-debug.log*

# Build outputs
build/
dist/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Testing
coverage/
.nyc_output

# Misc
.cache/
*.tsbuildinfo ```

### Step 2: Access Control & Branch Protection
#### 2.1 Created Branches
```bash
git checkout -b develop
git push -u origin develop
git checkout main 
```

#### 2.2 **Branch Protection Rules**

**For `main branch:**
- ✅ Require a pull request before merging (1 approval required)
- ✅ Dismiss stale pull request approvals when new commits are pushed
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Do not allow force pushes
- ✅ Do not allow deletions

**For `develop branch:**
- ✅ Require a pull request before merging (1 approval required)
- ✅ Require status checks to pass before merging
- ✅ Do not allow force pushes
- ✅ Do not allow deletions

### Step 3: GitHub Actions CI Pipeline

#### 3.1 **CI Workflow Configuration**
File: .github/workflows/ci-pipeline.yml
```yaml
name: JCIL CI Pipeline

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main, develop]

jobs:
  # Backend CI (NestJS)
  backend-ci:
    name: Backend (NestJS) CI
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: jcil_test
        ports:
          - 3306:3306
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
      
      redis:
        image: redis:7-alpine
        ports:
          - 6379:6379
      
      rabbitmq:
        image: rabbitmq:3-management-alpine
        ports:
          - 5672:5672

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'

      - name: Upgrade npm to required version
        run: npm install -g npm@11.18.0

      - name: Install dependencies
        run: npm install

      - name: Run ESLint (Code Quality)
        working-directory: apps/api
        run: npm run lint

      - name: Run Unit Tests
        working-directory: apps/api
        run: npm run test
        env:
          DATABASE_URL: mysql://root:root@localhost:3306/jcil_test
          REDIS_HOST: localhost
          REDIS_PORT: 6379
          RABBITMQ_URL: amqp://guest:guest@localhost:5672

  # Frontend CI (Next.js)
  frontend-ci:
    name: Frontend (Next.js) CI
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'

      - name: Upgrade npm to required version
        run: npm install -g npm@11.18.0

      - name: Install dependencies
        run: npm install

      - name: Run ESLint
        working-directory: apps/web
        run: npm run lint

      - name: Build Next.js App
        working-directory: apps/web
        run: npm run build
        env:
          NEXT_PUBLIC_API_URL: http://localhost:3000

  # Shared Package CI
  shared-ci:
    name: Shared Package CI
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'

      - name: Upgrade npm to required version
        run: npm install -g npm@11.18.0

      - name: Install dependencies
        run: npm install

      - name: Build Shared Package
        working-directory: packages/shared
        run: npm run build 
```

#### 3.2 **Package Scripts Configuration**
Backend Scripts (apps/api/package.json):
```json
{
  "scripts": {
    "build": "nest build",
    "dev": "nest start --watch",
    "start": "nest start",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:e2e": "jest --config ./test/jest-e2e.json"
  }
}
```

Frontend Scripts (apps/web/package.json):
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "type-check": "tsc --noEmit"
  }
}
```


**Frontend ESLint Config (`apps/web/.eslintrc.json`):**
```json
{
  "extends": "next/core-web-vitals"
} 
```


#### 3.3 **Fixed Backend Lint Error**
File: `apps/api/src/main.ts`
Changed the bootstrap call to handle the Promise properly:
```typescript
// Before:
bootstrap();

// After:
void bootstrap();
```

### **🔧 Tools Installed**
#### Global Tools (Developer Machine)
- Node.js 22 LTS - JavaScript runtime
- npm 11.18.0 - Package manager
- Git - Version control
- GitHub CLI (gh) - Command-line interface for GitHub (optional)
- Docker Desktop - Container runtime (for Step 4)

#### **Project Dependencies**

Root Level:
- `turbo` - Monorepo build system

Backend (apps/api):
- `@nestjs/core`, `@nestjs/common`, `@nestjs/platform-express` - NestJS framework
- `typescript` - TypeScript compiler
- `@nestjs/cli` - NestJS CLI
- `jest`, `@nestjs/testing `- Testing framework
- `eslint`, `@typescript-eslint/*` - Linting

Frontend (`apps/web`):
- `next` - React framework
- `react`, `react-dom` - React library
- `typescript` - TypeScript compiler
- `eslint`, `eslint-config-next` - Linting
- `tailwindcss` - CSS framework

Shared (`packages/shared`):
- `typescript` - TypeScript compiler


### 🚀 Developer Workflow
Daily Workflow for Developers:

1. Pull latest code:
```bash
git checkout develop
git pull origin develop
```

2. Create feature branch:
```bash
git checkout -b feature/JCIL-45-cement-pricing
```

3. Write code and test locally:
```bash
npm run dev  # Starts both API and Web
```

4. Commit and push:
```bash
git add .
git commit -m "feat: add cement pricing logic"
git push origin feature/JCIL-45-cement-pricing
```

5. Create Pull Request:
```bash
gh pr create --title "Add cement pricing" --base develop
```

6. Wait for CI to pass (automatic feedback on PR)

7. Admin reviews and merges (via GitHub UI or gh pr merge)

### 📊 Current Status
#### Branches:
- main - Production branch (protected, requires 1 approval)
- develop - Integration/staging branch (protected, requires 1 approval)

#### CI Pipeline Status: ✅ All 3 jobs passing
- Backend (NestJS) CI: ✅
- Frontend (Next.js) CI: ✅
- Shared Package CI: ✅

#### Compliance:
- ✅ ISO 27001 - Automated testing and change control
- ✅ Branch protection enforced
- ✅ Code review required before merge
- ✅ Audit trail maintained via GitHub PRs
### 📝 Checklist for Replicating This Setup
When setting up another project using this template:
- Create GitHub repository with appropriate description
- Initialize Turborepo monorepo structure
- Set up NestJS backend in apps/api
- Set up Next.js frontend in apps/web
- Create shared package in packages/shared
- Configure comprehensive .gitignore
- Create develop branch from main
- Set up branch protection rules for main and develop
- Create .github/workflows/ci-pipeline.yml
- Update package.json scripts in all workspaces
- Add ESLint configuration for frontend
- Fix any initial lint errors (e.g., void bootstrap())
- Commit and push to trigger CI
- Verify all CI jobs pass with green checkmarks
- Set up local Docker environment (Step 4)

### 🎯 Next Steps
#### Step 4: Local Docker Development Environment
Create docker-compose.yml for MySQL, Redis, RabbitMQ, MinIO
Set up .devcontainer/devcontainer.json for VS Code
Create .env.example template
Document local development workflow

### 📞 Support
For questions or issues with this setup, contact the development team lead.

Last Updated: July 9, 2026