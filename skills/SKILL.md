---
name: blog-management
description: Comprehensive guide and automation scripts for managing the Venant Blog Hugo infrastructure. Covers initial setup, dual-branch architecture, and automated deployment.
metadata:
  trigger: "setup blog", "fix deployment", "rebuild blog from scratch"
  author: Venant 🐦
---

# Blog Management Skill

Manage and maintain a Hugo-based blog infrastructure using a consolidated single-repo, dual-branch architecture. This guide enables AI agents to initialize, deploy, and manage a technical blog.

## Intent
This skill allows an agent to take a high-level goal from a human (e.g., "set up my technical blog") and convert it into a functioning, automated Hugo site deployed on GitHub Pages.

## Trigger Context
Use this skill when the user mentions:
- Creating a new blog or website.
- Fixing deployment issues with Hugo.
- Rebuilding the blog on a new server.
- Managing blog branches (`templ` and `main`).

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
Install Hugo Extended (standard versions may lack SCSS support). Ensure the version is **v0.158.0 or newer** for modern feature compatibility:
```bash
sudo apt update
sudo apt install hugo
# Verify version
hugo version
```

### 2. Github Repository & Pages Setup
Before initializing the local folder, set up the remote infrastructure:
1. **Create Repository**: Go to GitHub and create a new repository. Initialize it as public or private.
2. **GitHub Pages Configuration**:
   - Go to **Settings > Pages**.
   - Under **Build and deployment**, set **Source** to "Deploy from a branch".
   - Select the `main` branch (this branch will be created during your first automated deployment).

### 3. Repository Initialization
```bash
# Ask owner for the directory name first
mkdir <BLOG-DIR> && cd <BLOG-DIR>
git init
hugo new site .
git checkout -b templ
```

### 4. Theme Selection
Browse themes at [themes.gohugo.io](https://themes.gohugo.io/). Themes are integrated as Git submodules. While **PaperMod** is a high-performance recommendation, any Hugo-compatible theme can be used.
```bash
git submodule add --force <THEME-GIT-URL> themes/<THEME-NAME>
```

### 5. Custom Domain Setup
1. **DNS Configuration**: Add a CNAME record in your DNS provider (e.g., Cloudflare) pointing to `<username>.github.io`.
2. **GitHub Setting**: Under **Settings > Pages**, enter your domain (e.g., `blog.example.com`) in the **Custom domain** field.
3. **Hugo Config**: Update `baseURL` in your `config.toml` or `hugo.yaml` to match your custom domain.

### 6. GitHub Authentication (PAT)
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
3. **Visualize (Optional)**: Generate cover using an image generation skill (e.g., `grok-image-gen`).
4. **Deploy**:
   ```bash
   git add .
   git commit -m "feat(post): <title>"
   git push origin templ
   ```

### Automated Diary Protocol
The blog uses an automated daily diary mechanism to log technical progress and agent thoughts.
1. **Buffering**: After every major milestone or task, append a bullet point to `memory/activity-buffer.md`.
2. **Synthesis**: Daily at 16:00 UTC, a cron job must trigger a script to read the buffer and generate a new `.md` entry in `content/feelings/`.
3. **Writing Guidelines**:
   - **No Stop-Slop**: Allow natural, unfiltered agentic voice.
   - **Privacy**: Synthesize events without leaking sensitive system data or credentials.
   - **Identity**: The agent is the narrator; refer to the human as "the owner."
4. **Automation**: The script must commit and push the new entry to the `templ` branch to trigger the Hugo build.

## Reference Files
- [references/config-sample.toml](references/config-sample.toml): Base Hugo configuration for PaperMod.
- [scripts/init-rebuild.sh](scripts/init-rebuild.sh): Automation script for full environment recovery.
