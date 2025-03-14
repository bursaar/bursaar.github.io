---
layout: post
status: publish
published: true
title: "Building and deploying from GitLab"
author: ben
author_login: ben
author_email: ben@ben.ie
author_url: http://now.ben.ie
wordpress_id: 202
wordpress_url: https://now.ben.ie/?p=202
date: '2024-08-16 09:18:26 +0100'
date_gmt: '2024-08-16 08:18:26 +0100'
categories:
- Updates
- Process
- Game Development
tags:
- Automation
- GitLab
- CI/CD
- Itch.io
- Butler
- Pipelines
- SemRel
- Godot
comments: []
---
And so can you! Too! The Even Better Edition.

I've [previously]({% post_url 2024-06-01-deploying-from-gitlab-and-so-can-you %}) shared a kind of ugly but effective `.gitlab-ci.yml` file that I've been using to automatically deploy builds, but it was incomplete, and didn't cover:
- Incrementing the version
- Building the thing

It was also really, super ugly.

Since <a href="/tags/godot">moving to Godot</a>, I've fallen in love with the idea of being able to build and run automated tests in Linux Docker containers. I tried this with a project I've been working on (and off and on again) for a while, called <a href="https://bursaar.itch.io/the-bacon-game">The Bacon Game</a>:</p>

<iframe frameborder="0" src="https://itch.io/embed/2154665?border_width=0" width="550" height="165"><a href="https://bursaar.itch.io/the-bacon-game">The Bacon Game by Ben Marquez Keenan</a></iframe>

I started this project in Unity, and then in Godot Mono, which is a version of Godot that supports C#. This worked great at first, but I found that the Mono version of Godot introduced tonnes of issues and hassles when trying to do automated building and testing. The containerised environment's setup was much more fragile and fiddly. Also, C# is owned by Microsoft, and if I'm going to go all hippy crunchy granola on this, then I may as well do it properly. So I took The Bacon Game and rewrote it in GD Script, Godot's purpose-built language, which was actually faster and more pleasant to do than I expected.</p>

Once I had it all running as it had before, but without C#, and had fixed a couple of bugs, I decided to dive back into the automation side, and found great <a href="https://gitlab.com/barichello/godot-ci">templates and examples created by the amazing Barichello</a>, the GitLab user who created the container images I'm using for this.

You'll need to get a few things together to use this, namely setting these up as environment variables in your GitLab's CI/CD settings under Variables:

- Itch username as `ITCHIO_USERNAME` (This can be set on the Group level, rather than Repo level, if you're working on more than one game)
- Itch.io Butler API key as `BUTLER_API_KEY` (ditto, this can be set on the Group level, but recommend only doing that if your group is private)
- Itch game's slug as `ITCHIO_GAME` (only really makes sense for this to be done on the repo itself)

```yaml
image: barichello/godot-ci:4.2.2

variables:
  EXPORT_NAME: the-bacon-game #my game's name – plug in your own, no spaces

stages:
  - test
  - release
  - import-assets
  - export-debug
  - export-release
  - deploy

analyse:
  # used to analyze git repository before the release
  stage: test
  image: registry.gitlab.com/juhani/go-semrel-gitlab:v0.21.1
  script:
    - release test-git
  allow_failure: false
  only:
    - merge_requests
    - main

release-version:
  # update changelog and create a tag
  stage: release
  image: registry.gitlab.com/juhani/go-semrel-gitlab:v0.21.1
  script:
    - release changelog
    - release next-version --allow-current > version.txt
    # - sh update_package.sh
    - release commit-and-tag --create-tag-pipeline CHANGELOG.md version.txt
  allow_failure: false
  only:
    - main


# Cache imported assets between runs
cache:
  key: import-assets
  paths:
    - .godot/imported/

import-assets:
  stage: import-assets
  script:
    - godot --headless --verbose --editor --quit

mac-debug:
  stage: export-debug
  script:
    - mkdir -v -p build/MacOS/debug
    - godot -v --headless --export-debug "macOS" ./build/MacOS/debug/$EXPORT_NAME.zip
  artifacts:
    name: $EXPORT_NAME-$CI_JOB_NAME
    paths:
      - build/MacOS/debug

windows-debug:
  stage: export-debug
  script:
    - mkdir -v -p build/Windows/debug
    - godot -v --headless --export-debug "Windows Desktop" ./build/Windows/debug/$EXPORT_NAME.exe
  artifacts:
    name: $EXPORT_NAME-$CI_JOB_NAME
    paths:
      - build/Windows/debug

linux-debug:
  stage: export-debug
  script:
    - mkdir -v -p build/Linux/debug
    - godot -v --headless --export-debug "Linux" ./build/Linux/debug/$EXPORT_NAME.x86_64
  artifacts:
    name: $EXPORT_NAME-$CI_JOB_NAME
    paths:
      - build/Linux/debug

mac-release:
  stage: export-release
  script:
    - mkdir -v -p build/MacOS/release
    - godot -v --headless --export-release "macOS" ./build/MacOS/release/$EXPORT_NAME.zip
  when: manual
  artifacts:
    name: $EXPORT_NAME-$CI_JOB_NAME
    paths:
      - build/MacOS/release
  dependencies:
    - mac-debug

windows-release:
  stage: export-release
  script:
    - mkdir -v -p build/Windows/release
    - godot -v --headless --export-release "Windows Desktop" ./build/Windows/release/$EXPORT_NAME.exe
  when: manual
  artifacts:
    name: $EXPORT_NAME-$CI_JOB_NAME
    paths:
      - build/Windows/release
  dependencies:
    - windows-debug

linux-release:
  stage: export-release
  script:
    - mkdir -v -p build/Linux/release
    - godot -v --headless --export-release "Linux" ./build/Linux/release/$EXPORT_NAME.x86_64
  when: manual
  artifacts:
    name: $EXPORT_NAME-$CI_JOB_NAME
    paths:
      - build/Linux/release
  dependencies:
    - linux-debug

# Itch.io Deploy
itchio:linux:
  stage: deploy
  when: manual
  script:
    - butler push ./build/Linux/release $ITCHIO_USERNAME/$ITCHIO_GAME:linux --userversion-file version.txt 
  dependencies:
    - linux-release

itchio:windows:
  stage: deploy
  when: manual
  script:
    - butler push ./build/Windows/release $ITCHIO_USERNAME/$ITCHIO_GAME:windows --userversion-file version.txt
  dependencies:
    - windows-release

itchio:mac:
  stage: deploy
  when: manual
  script:
    - butler push ./build/MacOS/release $ITCHIO_USERNAME/$ITCHIO_GAME:mac --userversion-file version.txt
  dependencies:
    - mac-release
```

A couple of other requirements, you'll need to add a `version.txt` that has your version in it. 

Worth noting that this version will not be reflected in your game's binary, this is only a repo/itch concept. I'd like to evolve this script to increment/inject the version to the project's settings in time. You'll also need to add a `CHANGELOG.md` file, that starts like this:

```
# CHANGELOG

<!--- next entry here -->
```

Last thing to note is that <a href="https://semantic-release.gitbook.io/semantic-release#commit-message-format">your commits will need to follow a specific format</a>. In time I've adjusted to following this approach on all my projects since it makes the commit history more useful, but some people may find it annoying.