---
layout: post
status: publish
published: true
title: Creating a Developer Console in Twine
author:
  display_name: Ben
  login: ben
  email: ben@ben.ie
  url: https://ben.ie
author_login: ben
author_email: ben@ben.ie
author_url: https://ben.ie
excerpt: Some coding and designing tips for working with Twine. Very simple, very
  effective.
wordpress_id: 5048
wordpress_url: https://thenorobotsblog.com/?p=5048
date: '2013-11-29 12:20:32 +0000'
date_gmt: '2013-11-29 11:20:32 +0000'
categories:
- Comedy
- Interactive Fiction
- I Try My Best
tags:
- I Try My Best
comments: []
---
<p>It feels a little gauche to be delivering pro tips for game development when I'm a neophyte, but I've come across a helpful approach that I'll be revisiting for the foreseeable future, and I'd like to share it.</p>
<p><img class="alignnone size-full wp-image-5049 aligncenter" alt="I Try My Best - Twine Dev Console" src="https://thenorobotsblog.com/wp-content/uploads/2013/11/Screen-Shot-2013-11-29-at-10.38.06.png" width="152" height="149" /></p>
<p>When you start a story, tweaking variables and passages is fairly straightforward, but as it becomes both longer and more complex, it gets awkward and difficult, really slowing you down. The feedback loop becomes over-extended and it affects both productivity and creativity (though there's nothing wrong with a *little* bit of space between actions).</p>
<p>To smooth the way a little bit, and to make keeping track of variables easier, I realised that it should be possible to silently call two passages that would make tweaking easier.</p>
<p>The first one is the <strong>Master Variable List</strong>. This is a list of every variable, set to its default initialised state. When I was writing the game as part of a recent game jam, I would instantiate as I went, but this is messy and undesirable for a few reasons. It especially makes tweaking and debugging agonisingly difficult as the game starts to sprawl.</p>
<p>Instead, I've created a master list of all of the variables used in the game and have them listed in a passage called the Master Variable List, it looks something like this:</p>
<pre style="padding-left: 30px;">- Tweak this for different outcomes.
Confidence: &lt;&lt;set $confidence = 20&gt;&gt;</pre>
<pre style="padding-left: 30px;">- This first comes into play in [[Out1]].
Orientation: &lt;&lt;set $pref = straight&gt;&gt;</pre>
<pre style="padding-left: 30px;">- Woman is changed to Lady in [[Intro3]]
Gender: &lt;&lt;set $sex = man&gt;&gt;</pre>
<pre style="padding-left: 30px;">- This is used to limit the cycles of the mirror shot.
Disgust: &lt;&lt;set $disgust = 6&gt;&gt;

etc.</pre>
<p>This is called just once, silently, in the <strong>Start</strong> passage with the &lt;&lt;silently&gt;&gt; tags.</p>
<pre style="padding-left: 30px;">&lt;&lt;silently&gt;&gt;
&lt;&lt;display 'Master Variable List'&gt;&gt;
&lt;&lt;endsilently&gt;&gt;</pre>
<p>This isn't really a performance issue, I've never heard of a Twine game being so complex that it significantly taxed the system it was running on, but it's definitely a development performance issue. Every single variable is available in one passage I keep open as I write. If I need to add a new variable I instantiate in that passage with a note on its usage. It's changed how I write, and the next time I start a story from scratch, I'll be doing it this way.</p>
<p>The other big change to my working method is the <strong>Developer Menu</strong>. Every now and then, I'll take a bunch of the newest variables added to the Master Variable List and copy and paste them into the Developer Menu, but this time instead of instantiating, the variables are displayed and a text box is offered to allow alteration.</p>
<p>Before going any further, I should say that I haven't got the tweaking side of this menu working yet, so that may not be practical, but at the very least it would make debugging much, much easier if you could see a readout of all of your variables as you played to track how they're being changed by your decisions and the actions of the game itself.</p>
<p>With that proviso, I alter the pasted variable declarations from something like this:</p>
<pre style="padding-left: 30px;">- Tweak this for different outcomes.
Confidence: &lt;&lt;set $confidence = 20&gt;&gt;</pre>
<p>To this:</p>
<pre style="padding-left: 30px;">- Tweak this for different outcomes (Integer).
Confidence: &lt;&lt;print $confidence&gt;&gt;
Set to: &lt;&lt;textinput $confidence&gt;&gt;</pre>
<p>That's pretty much it! To make switching it on and off easier, I have a passage called <strong>Developer Visibility</strong> that silently calls the Developer Console:</p>
<pre style="padding-left: 30px;">&lt;&lt;silently&gt;&gt;
&lt;&lt;display 'Developer Console'&gt;&gt;
&lt;&lt;endsilently&gt;&gt;</pre>
<p>Then you just need to paste this into every passage:</p>
<pre style="padding-left: 30px;">&lt;&lt;display 'Developer Visibility'&gt;&gt;</pre>
<p>This does nothing at first since you're calling an ostensibly empty passage, but if you decide you want to play with the console switched on, you just go to the Developer Visibility passage and remove the  &lt;&lt;silently&gt;&gt;&lt;&lt;endsilently&gt;&gt; tags. Your console should be visible on every page after that. Put the tags back and it disappears again.</p>
