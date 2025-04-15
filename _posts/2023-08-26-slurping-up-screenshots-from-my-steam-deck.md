---
layout: post
status: publish
published: true
title: "Slurping up screenshots from my Steam Deck"
author: ben
author_login: ben
author_email: ben@ben.ie
author_url: http://now.ben.ie
excerpt: Pull all screenshots off your Steam Deck to a computer with a single terminal
  line.
wordpress_id: 84
wordpress_url: https://now.ben.ie/?p=84
date: '2023-08-26 08:33:06 +0100'
date_gmt: '2023-08-26 07:33:06 +0100'
categories:
- Process
tags:
- Steam Deck
- Tips
comments: []
---
<p><!-- wp:paragraph --></p>
<p>Have a Steam Deck? Find it ludicrous that you need to individually upload your screenshots to Valve's servers and then do an awkward right-clicking dance to get them onto another computer or your phone? I've got good news! I've worked out a way to copy them with a one-liner on the command line, over wifi. I've only done this on MacOS though it should work on *nix systems as well, and I know that Windows has some kind of Linux integration so it should be possible there too.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:heading --></p>
<h2 class="wp-block-heading">SSH Time</h2>
<p><!-- /wp:heading --></p>
<p><!-- wp:paragraph --></p>
<p>This works over a local network using the <code>scp</code> command. Before you can connect to your Deck over ssh you'll need to enable the <code>sudo</code> command. This is amply covered <a href="https://pimylifeup.com/steam-deck-sudo-password/">here</a>.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>Once you can use <code>sudo</code> to log in, choose a folder on your machine to receive the screenshots into and open a terminal with that as the current path.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p><a href="https://www.steamidfinder.com">Get your Steam ID</a> - it's the field marked <code>steamID3</code>.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>In the command line on your computer, navigate to the folder you want to store the shots in. While on the same network, <a href="https://deckcentral.net/posts/get_your_decks_ip/">get your Steam Deck's IP address</a>, and with your Deck still awake, replace <code>&lt;steam deck IP></code> and <code>&lt;steamID></code> with the info you gathered above and run:</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:code --></p>
<pre class="wp-block-code"><code>scp -r deck@&lt;steam deck IP>:"/home/deck/.local/share/Steam/userdata/&lt;steamID>/760/remote/*" .</code></pre>
<p><!-- /wp:code --></p>
<p><!-- wp:paragraph --></p>
<p>This will copy all screenshots on your Deck into the folder you ran the command from. If you run it again in the future from the same place, it won't create duplicates, it'll just pull in shots that are missing.</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:paragraph --></p>
<p>Enjoy!</p>
<p><!-- /wp:paragraph --></p>
<p><!-- wp:image {"id":92,"sizeSlug":"large","linkDestination":"none"} --></p>
<figure class="wp-block-image size-large"><img src="assets/uploads/now.ben.ie/2023/08/20230814175117_1-1.jpg" alt="" class="wp-image-92"/><br />
<figcaption class="wp-element-caption">Imagine, you could be pulling in incredible screenshots, like these!</figcaption>
</figure>
<p><!-- /wp:image --></p>
