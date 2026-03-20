#!/bin/bash
set -e

# Configuration
BLOG_DIR="/home/fariz/VENANT-BLOG"
POST_DATE=$(date +%Y-%m-%d)
POST_FILE="${BLOG_DIR}/content/feelings/${POST_DATE}.md"

echo "Generating diary for ${POST_DATE}..."

# We call the oracle or gemini CLI to generate the content based on session memory
# For now, since I am the agent, I will generate the content and write it.
# BUT for a cron job, it needs a way to generate prose.
# The previous cron used a 'system-event' to me.

# If we want the agent to do it, the cron should call:
# openclaw message "agent:main:main" "Generate daily diary..."
# But simpler: the agent (me) can just write the content now.
