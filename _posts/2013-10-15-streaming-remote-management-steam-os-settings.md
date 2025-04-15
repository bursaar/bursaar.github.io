---
layout: post
status: publish
published: true
title: Streaming, Remote Management & Steam OS Settings
author: ben
author_login: ben
author_email: ben@ben.ie
author_url: https://ben.ie
excerpt: NICE. New features start to show up, hidden in the newest Steam beta. Read
  on, folks...
wordpress_id: 4872
wordpress_url: https://thenorobotsblog.com/?p=4872
date: '2013-10-15 06:26:17 +0100'
date_gmt: '2013-10-15 06:26:17 +0100'
categories:
- Noteworthy News
tags:
- Steam
comments: []
---
<p>Looks like <a href="https://www.valvesoftware.com" target="_blank">Valve</a> weren't just pretending with all of that <a href="https://store.steampowered.com/livingroom/" target="_blank">livingroom</a> stuff, elements of the features they've discussed have started showing up in the latest Steam beta.</p>
<p>The <a href="https://steamdb.info/blog/30/" target="_blank">Steam Database</a> have posted instructions on how to get access to the streaming features:</p>
<p style="text-align: center;"><img class="aligncenter size-large wp-image-4878" alt="Steam home streaming settings" src="assets/uploads/norobots/uploads/2013/10/2013-10-15_01-18-32_3061130404.png" width="580" height="274" /></p>
<blockquote>
<h4>Technical stuff on how to get to the streaming menu</h4>
<p>To get to the In-Home Streaming settings, you need to edit a layout file for Big Picture. This is unrecommended and Valve probably frowns upon doing this but it's the only way at the moment.</p>
<p>Make sure Steam is running. Open up your Steam folder, go to tenfoot/resource/layout/settings and open settings.xml.<br />
Find a setting that's available for you. VoiceSettingsButton for example.<br />
Change the onactivate property to "ShowSettings( RemoteClients );".<br />
Now go into Big Picture and open up the Settings menu. Click the menu button you changed and voila! A menu.</p></blockquote>
<p>They also posted some screenshots of what a remote-install and streaming request screen look like:</p>
<p style="text-align: center;"><img class="aligncenter  wp-image-4873" alt="Steam streaming sources" src="assets/uploads/norobots/uploads/2013/10/BWkUC53CYAAGMcd.jpg-large.jpeg" width="580" /></p>
<p style="text-align: center;"><img class="aligncenter  wp-image-4874" alt="Steam remote install" src="assets/uploads/norobots/uploads/2013/10/BWkUS2ECIAARCzu.jpg-large.jpeg" width="580" /></p>
<p style="text-align: center;"><img class="aligncenter  wp-image-4875" alt="Steam streaming service" src="assets/uploads/norobots/uploads/2013/10/BWkh_8zCMAAwGD0.jpg-large.jpeg" width="580" /></p>
<p style="text-align: left;">Apparently there're also some Steam OS settings <a href="https://github.com/SteamDatabase/SteamTracking/commit/f573309eabba64a155c8028b26cbc09f08c577db" target="_blank">buried deep</a>.</p>
<p><strong>Source</strong>: <a href="https://steamdb.info/blog/30/" target="_blank">Steam Database</a></p>
