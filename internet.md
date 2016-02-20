---
layout: page
title: Internet
---

## Host HTML documents in Dropbox

HTML reports are a convenient to send results to collaborators. They are easy to produce with R Markdown for example. When a HTML file is shared in [Dropbox](www.dropbox.com) the browser doesn't directly display its content but proposes the user to download the page. It's OK but it's another step for the collaborator to access the report.

To directly see the HTML page, the hack is to transform the link by replacing `https://www.dropbox.com` with `https://dl.dropboxusercontent.com`. 
