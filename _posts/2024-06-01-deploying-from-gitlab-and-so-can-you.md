---
layout: post
status: publish
published: true
title: "Deploying from GitLab (and so can you)"
author: ben
author_login: ben
author_email: ben@ben.ie
author_url: http://now.ben.ie
excerpt: An example working GitLab CI pipeline script for deploying to Itch.io on
  push.
wordpress_id: 183
wordpress_url: https://now.ben.ie/?p=183
date: '2024-06-01 15:05:27 +0100'
date_gmt: '2024-06-01 14:05:27 +0100'
categories:
- Productivity
- Tools
- Game Development
tags:
- Automation
- GitLab
- CI/CD
comments: []
---
<p><!-- wp:paragraph --></p>
<p>I've been working on a couple of small projects, and for whatever reason, I just <strong>love</strong> automating the building and deployment of my work. That kind of automation always feels like such a huge productivity multiplier when I'm working on my own or in a tiny team.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>To that end, I've been working on putting the Butler deploy step into a <code>.gitlab-ci.yml</code> file so that I can publish work without needing to worry about my local environment setup.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>First of all, here's the file I'm using on a project called "Wrecked" (more on that in another post):</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:code --></p>
<pre class="wp-block-code"><code>stages:
  - deploy

variables:
  ITCH_IO_USER: "bursaar"
  ITCH_IO_GAME: "wrecked"
  ITCH_IO_CHANNEL: "html"
  WATCH_PATH: "output/Wrecked"
  BUTLER_VERSION: 15.0.0

before_script:
  - |
    echo "Downloading Butler..."
    curl -L -o butler.zip https://broth.itch.ovh/butler/linux-amd64/${BUTLER_VERSION}/butler.zip
    unzip butler.zip -d butler
    chmod +x butler/butler
    mv butler/butler /usr/local/bin/butler
    butler -V
    if &#91; $? -ne 0 ]; then
      echo "Failed to install Butler"
      exit 1
    fi

deploy:
  stage: deploy
  script:
    - |
      if git diff --name-only $CI_COMMIT_BEFORE_SHA $CI_COMMIT_SHA | grep -q "^$WATCH_PATH"; then
        echo "Changes detected in $WATCH_PATH, deploying to itch.io..."
        butler push $WATCH_PATH $ITCH_IO_USER/$ITCH_IO_GAME:$ITCH_IO_CHANNEL--userversion `date +%Y%m%d%H%M%S`
      else
        echo "No changes detected in $WATCH_PATH, skipping deployment."
      fi
  only:
    - main  # Deploy only on changes to the main branch</code></pre>
<p><!-- /wp:code --></p>
<p><!-- wp:paragraph --></p>
<p>For this to work, you will need to set a <code>BUTLER_API_KEY</code> environment variable, which is tied to your user account on Itch.io and can be applied on a per-project or per-group basis. I recommend masking this and making it only available on protected branches, so that way it won't show up in your logs.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>You can copy this into your repo now and give it a shot, just changing the project and user names. If you find it useful, spot a bug or make an improvement, please let me know!</p>
<p><!-- /wp:paragraph --></p>
