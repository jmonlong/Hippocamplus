To update a local folder (`-local`) and a folder synced to the remote location (`-remote`) like Google Drive.

```sh
python updateMendeley.py -local PATH/TO/MendeleyDesktop -remote PATH/TO/GoogleDrive/ArticlesPDF
```

*I tend to do a dry run first using `-dry`.*

Usage:

```txt
usage: updateMendeley.py [-h] -local LOC -remote REM [-cache CACHE] [-dry]
                         [-lr] [-rl]

Sync PDF files between local and remote folders with file name matching.

optional arguments:
  -h, --help    show this help message and exit
  -local LOC    Local folder with Mendeley PDFs
  -remote REM   Folder with annotated PDFs synced to remote location (e.g.
                Google Drive, Dropbox)
  -cache CACHE  Cache file
  -dry          Dry run
  -lr           Only sync local -> remote
  -rl           Only sync remote -> local
```
