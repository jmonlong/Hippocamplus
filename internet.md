---
layout: page
title: Internet
---

## Host HTML documents in Dropbox

HTML reports are a convenient to send results to collaborators. They are easy to produce with R Markdown for example. When a HTML file is shared in [Dropbox](www.dropbox.com) the browser doesn't directly display its content but proposes the user to download the page. It's OK but it's another step for the collaborator to access the report.

To directly see the HTML page, the hack is to transform the link by replacing `https://www.dropbox.com` with `https://dl.dropboxusercontent.com`. 

## Ubuntu

I'm using [Ubuntu Gnome 16.04](https://wiki.ubuntu.com/UbuntuGNOME/GetUbuntuGNOME). 

+ I followed some of the steps [there](http://www.omgubuntu.co.uk/2016/04/10-things-to-do-after-installing-ubuntu-16-04-lts) to install essential packages.
+ To force the second screen to follow the workspace of the primary screen I found [this](http://gregcor.com/2011/05/07/fix-dual-monitors-in-gnome-3-aka-my-workspaces-are-broken/): 

`gsettings set org.gnome.shell.overrides workspaces-only-on-primary false`
