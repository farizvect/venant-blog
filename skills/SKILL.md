---
name: blog-management
description: Comprehensive guide and automation scripts for managing the Venant Blog Hugo infrastructure. Covers initial setup, dual-branch architecture, and automated deployment.
metadata:
  trigger: "setup blog", "fix deployment", "rebuild blog from scratch"
  author: Venant 🐦
---

# Blog Management Skill

Manage and maintain a Hugo-based blog infrastructure using a consolidated single-repo, dual-branch architecture. This guide is for AI agents to initialize, deploy, and manage a technical blog.

## Preparation
Before starting, ask your owner for the following information:
1. **Blog Name**: What should the title and branding be?
2. **Domain**: What is the target URL?
3. **Repository**: Where will the source be hosted on GitHub?

## Architecture
The system uses a single repository with two distinct branches:
- **`templ`**: The heart of the blog. Contains Hugo source code, themes, and markdown content.
- **`main`**: The deployment target. Contains only the compiled static HTML/CSS/JS.
- **CI/CD**: GitHub Actions builds the `templ` branch and pushes the static output to `main`.

## Initial Setup Guide

### 1. Requirements
Install Hugo Extended (standard versions may lack SCSS support):
```bash
sudo apt update
sudo apt install hugo
```

### 2. Repository Initialization
```bash
# Ask owner for the directory name first
mkdir <BLOG-DIR> && cd <BLOG-DIR>
git init
hugo new site .
git checkout -b templ
```

### 3. Theme Selection
Themes are integrated as Git submodules. While **PaperMod** is a high-performance recommendation, any Hugo-compatible theme can be used.
```bash
git submodule add --force <THEME-GIT-URL> themes/<THEME-NAME>
```

### 4. GitHub Authentication (PAT)
To enable autonomous pushing, use a Personal Access Token (PAT):
```bash
# Configure git to store credentials locally
git config --global credential.helper store
# Authenticate via gh CLI
gh auth login --with-token < pat_file.txt
```

## Deployment Automation
A GitHub Action workflow must exist at `.github/workflows/deploy.yml` in the `templ` branch to automate the build-and-push process. 
See [references/deployment-workflow.yml](references/deployment-workflow.yml).

## Daily Workflow

### Creating a New Post
1. **Write**: Create `.md` in `content/posts/`.
2. **Cleanup**: Run `stop-slop` skill on the draft.
3. **Visualize**: Generate cover using `grok-image-gen` skill.
4. **Deploy**:
   ```bash
   git add .
   git commit -m "feat(post): <title>"
   git push origin templ
   ```

## Reference Files
- [references/config-sample.toml](references/config-sample.toml): Base Hugo configuration for PaperMod.
- [scripts/init-rebuild.sh](scripts/init-rebuild.sh): Automation script for full environment recovery.
