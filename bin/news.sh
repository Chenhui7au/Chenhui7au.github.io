#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: ./bin/news.sh \"News Title\""
  exit 1
fi

title="$*"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

slug="$(printf "%s" "$title" | iconv -t ascii//TRANSLIT 2>/dev/null || printf "%s" "$title")"
slug="$(printf "%s" "$slug" | tr '[:upper:]' '[:lower:]')"
slug="$(printf "%s" "$slug" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"

if [[ -z "$slug" ]]; then
  slug="news"
fi

file_date="$(date +"%Y-%m-%d")"
news_datetime="$(date +"%Y-%m-%d %H:%M:%S %z")"

news_path="_news/${file_date}-${slug}.md"
index=2
while [[ -f "$news_path" ]]; do
  news_path="_news/${file_date}-${slug}-${index}.md"
  index=$((index + 1))
done

cat > "$news_path" <<EOF
---
layout: post
date: $news_datetime
inline: true
related_posts: false
---

$title

EOF

echo "Created $news_path"
