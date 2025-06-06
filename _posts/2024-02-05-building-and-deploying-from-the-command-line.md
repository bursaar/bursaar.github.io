---
layout: post
status: publish
published: true
title: "Building and deploying from the command line!"
author: ben
author_login: ben
author_email: ben@ben.ie
author_url: http://now.ben.ie
excerpt: I've been working on a little one-liner tool to build, publish and commit
  changes after an impromptu dev session.
wordpress_id: 157
wordpress_url: https://now.ben.ie/?p=157
date: '2024-02-05 15:48:27 +0000'
date_gmt: '2024-02-05 15:48:27 +0000'
categories:
- Process
- Tools
- Game Development
tags:
- Tips
- GameDev
- Bash
- Automation
- Itch
- Build &amp; Release
- The Bacon Game
- Godot
comments: []
---
<p><!-- wp:paragraph --></p>
<p>I'm learning my way around Godot at the moment for personal projects and have already been using <a href="https://now.ben.ie/2023/09/03/deploying-builds-to-steam-deck/" data-type="post" data-id="102">Itch to deploy builds to my Steam Deck</a> and to share builds with collaborators. </p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>Since my pockets of hobbyist dev time are few and of unpredictable (normally short) length, I've been gradually evolving a script recently that I'm using to generate builds from the command line and push them to Itch, so wrapping up after a quick dev session is just a one-line command I can call and walk away from, safe in the knowledge that my work will:</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:list {"ordered":true} --></p>
<ol><!-- wp:list-item --></p>
<li>Get built for MacOS and Windows</li>
<p><!-- /wp:list-item --></p>
<p><!-- wp:list-item --></p>
<li>Pushed to Itch</li>
<p><!-- /wp:list-item --></p>
<p><!-- wp:list-item --></p>
<li>All changes will be wrapped up and pushed to the git repo with a tag matching the version number</li>
<p><!-- /wp:list-item --></ol>
<p><!-- /wp:list --></p>
<p><!-- wp:paragraph --></p>
<p>This is the current version of the script:</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:code --></p>
<pre class="wp-block-code"><code>#!/bin/bash

# Use command substitution to get the input string
input_string=$(cat project.godot | grep "version=\"")

# Use grep with a basic regular expression to extract the version
version=$(echo "$input_string" | grep -o 'version="&#91;0-9.]*"')

# Remove the leading 'version="' and trailing '"'
version=${version#version=\"}
version=${version%\"}

echo "Building $version"

git add -A
git commit -m "Cleanup commit before build and publish of $version"

git tag -a v$version -m "Publishing $version to Itch.io."

# The folders need to exist already
mkdir -p Build/Windows
mkdir -p Build/MacOS

godot-mono --export-debug "Windows Desktop" Build/Windows/The\ Bacon\ Game.exe
godot-mono --export-debug "macOS" Build/MacOS/The\ Bacon\ Game.zip

echo "Publishing $version"

butler push Build/MacOS bursaar/the-bacon-game:osx-universal --userversion $version
butler push Build/Windows bursaar/the-bacon-game:win-universal --userversion $version

echo "Finished publishing $version"

git push origin --tags</code></pre>
<p><!-- /wp:code --></p>
<p><!-- wp:paragraph --></p>
<p>Feel free to borrow and extend for your own purposes.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>If you read it through you'll see that it has two things to be aware of:</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:list {"ordered":true} --></p>
<ol><!-- wp:list-item --></p>
<li>It has hardcoded values for this project. That's fine for now, but wouldn't it be nice if it could pull all the data it needed from <code>project.godot</code>?</li>
<p><!-- /wp:list-item --></p>
<p><!-- wp:list-item --></p>
<li>You need to increment the version manually in <code>project.godot</code>.</li>
<p><!-- /wp:list-item --></ol>
<p><!-- /wp:list --></p>
<p><!-- wp:paragraph --></p>
<p>While the above script works and I'm still using it, I'm also working on a successor which pulls all of its info from <code>project.godot</code> and will even increment the version number for you. This means that I can drop this script into any project I'm working on and have it set up the project's metadata for me to fill in, and bingo-bango, I can push as I please. </p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>If you're looking for a handy script, then you can stop here, copy and paste what I have above (don't forget to run <code>chmod +x</code> on it before you try to run it!) and change the hardcoded values. If you're interested in what may come next, read on!</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:heading --></p>
<h2 class="wp-block-heading">Build &amp; Publish 2.0</h2>
<p><!-- /wp:heading --></p>
<p><!-- wp:paragraph --></p>
<p>This is functionally the same – a one-line CLI call that will build all available platforms and publish them to the correct project on Itch.io. I have a slightly janky version of this working at the moment. It's nifty BUT it does require a bit of setup; namely:</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:list {"ordered":true} --></p>
<ol><!-- wp:list-item --></p>
<li>Adding properties to the project settings</li>
<p><!-- /wp:list-item --></p>
<p><!-- wp:list-item --></p>
<li>Setting up Export options (if you haven't already)</li>
<p><!-- /wp:list-item --></p>
<p><!-- wp:list-item --></p>
<li>Adding those Export options to the build script</li>
<p><!-- /wp:list-item --></ol>
<p><!-- /wp:list --></p>
<p><!-- wp:paragraph --></p>
<p>Something I hadn't realised about Itch.io is that you can easily add fields and values to its <code>project.godot</code> file so you can layer in your own project metadata. To do this, enable Advanced Settings, write a path for the field, select a type and click Add.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:image {"id":168,"sizeSlug":"large","linkDestination":"none"} --></p>
<figure class="wp-block-image size-large"><img src="assets/uploads/now.ben.ie/2024/02/Screenshot-2024-02-05-at-15.28.22.png" alt="" class="wp-image-168"/><br />
<figcaption class="wp-element-caption">Adding Itch details for a future version of the script that will pull all details from the <code>project.godot</code> file.</figcaption>
</figure>
<p><!-- /wp:image --></p>
<p><!-- wp:paragraph --></p>
<p>The above new fields look like this in the <code>project.godot</code> file:</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:code --></p>
<pre class="wp-block-code"><code>&#91;Distribution]

Itch/User="bursaar"
Itch/ProjectSlug="the-bacon-game"
Itch/sku={
"Windows Desktop": "win-universal",
"macOS": "osx-universal"
}</code></pre>
<p><!-- /wp:code --></p>
<p><!-- wp:paragraph --></p>
<p>As part of the mapping, I currently need to link the export path to the "sku" on Itch.io. At some point I'd like to make this less direct and just map the Export option to the sku.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:image {"id":169,"sizeSlug":"large","linkDestination":"none"} --></p>
<figure class="wp-block-image size-large"><img src="assets/uploads/now.ben.ie/2024/02/Screenshot-2024-02-05-at-15.28.51.png" alt="" class="wp-image-169"/></figure>
<p><!-- /wp:image --></p>
<p><!-- wp:paragraph --></p>
<p>Incidentally, the above info looks like this in <code>project.godot</code>:</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:code --></p>
<pre class="wp-block-code"><code>export/itch/sku={
"Build/MacOS": "osx-universal",
"Build/Windows": "win-universal"
}</code></pre>
<p><!-- /wp:code --></p>
<p><!-- wp:paragraph --></p>
<p>I will keep ferreting away on this; I'd like the script to auto-add the missing fields when run for the first time on a fresh project, and to have cleaner mapping between Export options and skus on Itch.io.</p>
<p><!-- /wp:paragraph --></p>
