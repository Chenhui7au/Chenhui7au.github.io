#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: ./bin/post.sh \"Post Title\""
  exit 1
fi

title="$*"

slug="$(printf "%s" "$title" | iconv -t ascii//TRANSLIT 2>/dev/null || printf "%s" "$title")"
slug="$(printf "%s" "$slug" | tr '[:upper:]' '[:lower:]')"
slug="$(printf "%s" "$slug" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"

if [[ -z "$slug" ]]; then
  slug="post"
fi

file_date="$(date +"%Y-%m-%d")"
post_datetime="$(date +"%Y-%m-%d %H:%M:%S %z")"

post_path="_posts/${file_date}-${slug}.md"
index=2
while [[ -f "$post_path" ]]; do
  post_path="_posts/${file_date}-${slug}-${index}.md"
  index=$((index + 1))
done

yaml_title="${title//\'/\'\'}"

cat > "$post_path" <<EOF
---
layout: post
title: '$yaml_title'
date: $post_datetime
description:
tags:
categories:
---

EOF

echo "Created $post_path"