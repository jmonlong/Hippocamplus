import glob
import argparse
from difflib import SequenceMatcher
import pickle
import os
from shutil import copyfile


parser = argparse.ArgumentParser(description='Sync PDF files between local and remote folders with file name matching.')
parser.add_argument('-local', dest='loc', help='Local folder with Mendeley PDFs', required=True)
parser.add_argument('-remote', dest='rem', help='Folder with annotated PDFs synced to remote location (e.g. Google Drive, Dropbox)', required=True)
parser.add_argument('-cache', dest='cache', help='Cache file', default='mendeleycache.pickle')
parser.add_argument('-dry', dest='dry', action='store_true', help='Dry run')
parser.add_argument('-lr', dest='lr', action='store_true', help='Only sync local -> remote')
parser.add_argument('-rl', dest='rl', action='store_true', help='Only sync remote -> local')

args = parser.parse_args()
if(args.lr and args.rl):
    print '-lr and -rl should be mutally exclusive. Assuming both ways are wanted...'
if(not args.lr and not args.rl):
    args.lr = True
    args.rl = True
    
# List files
locfiles = glob.glob(args.loc + '/*[Pp][Dd][Ff]')
locfiles = [str.replace(filen, args.loc + '/', '') for filen in locfiles]
remfiles = glob.glob(args.rem + '/*[Pp][Dd][Ff]')
remfiles = [str.replace(filen, args.rem + '/', '') for filen in remfiles]

# Load cache file
if(os.path.isfile(args.cache)):
    cache = pickle.load(open(args.cache, "rb"))
    print 'Cache loaded'
else:
    cache = {'oldfiles': [], 'rlpairs': {}}

if(args.lr):
    # Local to remote: copy new files only
    # Don't copy if exists or in cache
    # If name match and not in cache, put in cache
    print 'Check for new files in the local folder'
    for locf in locfiles:
        if(locf not in remfiles and locf not in cache['oldfiles']):
            filen = str.replace(locf, '..', '.')
            filen = str.replace(filen, '_', '')
            best = ''
            bestscore = 0
            for remf in remfiles:
                score = SequenceMatcher(None, remf.lower(), filen.lower()).ratio()
                if(score > bestscore):
                    bestscore = score
                    best = remf
            if(bestscore < .9):
                print 'New file?'
                print 'Local: ' + locf
                print 'Best remote: ' + best + '\n'
                if(not args.dry):
                    copyfile(args.loc + '/' + locf, args.rem + '/' + locf)
                    cache['oldfiles'].append(locf)
            else:
                cache['oldfiles'].append(locf)

if(args.rl):
    print 'Check for remote files to update locally'
    for remf in remfiles:
        if(remf in cache['rlpairs']):
            best = cache['rlpairs'][remf]
        else:
            filen = str.replace(remf, '..', '.')
            filen = str.replace(filen, '_', '')
            best = ''
            bestscore = 0
            for locf in locfiles:
                score = SequenceMatcher(None, locf, filen).ratio()
                if(score > bestscore):
                    bestscore = score
                    best = locf
            if(bestscore < .9):
                print '\n' + filen + ' not matched :('
                print 'Best match: ' + best + '\n'
                continue
            cache['rlpairs'][remf] = best
        # Get file sizes
        loc_size = os.path.getsize(args.loc + '/' + best)
        rem_size = os.path.getsize(args.rem + '/' + remf)
        # If different cp from remote to local
        if(loc_size != rem_size):
            if(args.dry):
                print 'Copy ' + remf + ' to ' + best
            else:
                copyfile(args.rem + '/' + remf, args.loc + '/' + best)


# Save cache
pickle.dump(cache, open(args.cache, "wb"))
print 'Cache saved'
