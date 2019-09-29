# reduceBib.py reduces a .bib file to speed up its use by Pandoc
# Copyright (C) 2018  Jean Monlong

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import argparse
import re
# import glob

parser = argparse.ArgumentParser(description='Reduce a .bib file.')
parser.add_argument('-b', dest='bib', default="static/library.bib",
                    help='the original bib file')
parser.add_argument('-o', dest='out', default="static/library-small.bib",
                    help='the new bib file')
parser.add_argument('-a', dest='nauths', type=int, default=5,
                    help='the maximum number of authors. Default: 5.')
parser.add_argument('-f', dest='fields',
                    default='author,title,doi,journal,year,url',
                    help='the BibTeX fields to keep (comma separated). '
                    'Default: "author,title,doi,journal,year,url"')
parser.add_argument('mds', nargs='+',
                    help='the markdown files to scan')

args = parser.parse_args()
keepinfo = args.fields.split(',')
tagre = re.compile(' *([a-z]+).*=.*')
citere = re.compile('.*{([^,]+),')

print "Original bib file: \t" + args.bib
print "Output file: \t" + args.out
print "BibTeX fields: \t" + args.fields
print "Max # authors: \t" + str(args.nauths)


class Citation:
    '''A citation.'''
    def __init__(self, line):
        line = line.strip()
        m = citere.match(line)
        self.ref = m.group(1)
        self.info = [line]
        self.tagidx = {}

    def addInfo(self, line):
        line = line.rstrip(",")
        m = tagre.match(line)
        if(m is None):
            return(False)
        if(m.group(1) in keepinfo):
            self.tagidx[m.group(1)] = len(self.info)
            self.info.append(line)

    def shortenAuthors(self, nb_auth_max=5):
        if 'author' in self.tagidx:
            auth_idx = self.tagidx['author']
            auths = self.info[auth_idx]
            auths = auths.split(' and ')
            if len(auths) > nb_auth_max:
                auths = auths[:(nb_auth_max-1)] + ['...'] + [auths[-1]]
                self.info[auth_idx] = ' and '.join(auths)

    def write(self, fileCon):
        for ii in range(len(self.info)-1):
            line = self.info[ii]
            line = line.strip()
            line = line.rstrip("\n")
            line = line.rstrip(',')
            fileCon.write(line)
            fileCon.write(",\n")
        line = self.info[len(self.info)-1]
        line = line.strip()
        line = line.rstrip("\n")
        line = line.rstrip(',')
        fileCon.write(line)
        fileCon.write("\n}\n")


class CitationList:
    '''A list of citations.'''
    def __init__(self):
        self.cits = []

    def parseCit(self, line, fileCon):
        while(line.find('@') == -1):
            line = fileCon.next()
        cit = Citation(line)
        for line in fileCon:
            if(line.find('@') == 0):
                cit.shortenAuthors(nb_auth_max=args.nauths)
                self.cits.append(cit)
                return line
            cit.addInfo(line)
        cit.shortenAuthors(nb_auth_max=args.nauths)
        self.cits.append(cit)
        return False

    def parseBib(self, filename):
        ffile = open(filename)
        line = self.parseCit(ffile.next(), ffile)
        while(line):
            line = self.parseCit(line, ffile)
        ffile.close()

    def writeCitations(self, outBib, citToWrite):
        # Print missing refs
        cits = [cit.ref for cit in self.cits]
        for cit in citToWrite:
            if cit not in cits:
                print 'Missing ref: ' + cit
        outCon = open(outBib, 'w')
        for cit in self.cits:
            if cit.ref in citToWrite:
                cit.write(outCon)
        outCon.close()


# Read bibtex file
bl = CitationList()
bl.parseBib(args.bib)

# Read all md files and find references
mdre = re.compile('@([a-zA-Z0-9\-]+)')
cits = {}
for ff in args.mds:
    ffile = open(ff)
    for line in ffile:
        citline = mdre.findall(line)
        citlineU = []
        for tt in citline:
            citlineU.extend(tt.split())
        if(len(citlineU) > 0):
            for cl in citlineU:
                if(cl not in cits):
                    cits[cl] = True

# Write output bibbtex
bl.writeCitations(args.out, cits.keys())
