import re
import argparse

parser = argparse.ArgumentParser(description='Check for problems in a LaTeX manuscript.')
parser.add_argument('-i', dest='tex', help='the input tex file', required=True)
parser.add_argument('-inrefs', dest='inrefs',
                    help='list non-fig/table internal refs', action='store_true')
parser.add_argument('-noacro', dest='noacro',
                    help='don\'t list acronyms', action='store_true')

args = parser.parse_args()

# Read bbl file and find all bib references
bbl = ''
for line in open(args.tex.rstrip('.tex') + '.bbl'):
    bbl += line.rstrip()
bibre = re.compile('\\\\bibitem\[[^\]]+\]{([^}]+)}')
bibres = bibre.findall(bbl)

# Regular expression to look for in the text
print 'Looking for missing citation, disordered multi-citations, duplicated labels, internals fig/table refs in incorrect order, acronyms in italic/serif or not, XX/??/REF.\n'
inputre = re.compile('\\\\input{([^}]+)}')
citere = re.compile('\\\\cite{([^}]+,?[^}]*)}')
acrore = re.compile('([A-Za-z0-9]*[A-Z]{2}[A-Za-z0-9]*)')
labre = re.compile('\\\\label{([^}]+)}')
inrefre = re.compile('\\\\(?:name)?ref{([^}]+)}')
missre = re.compile('(.{30}\?\?.{30})')
missre2 = re.compile('(.{30}XX.{30})')
missre3 = re.compile('(.{50}REF)')

# Read tex file
files = [args.tex]
cpt = 0
missingcites = []
ordercites = []
its = {}
sfs = {}
acros = {}
acrosfirst = []
labs = []
labsrep = {}
missings = []
inrefs = []
while cpt < len(files):
    print 'Reading ' + files[cpt] + '...'
    tex = ''
    incomments = False
    for line in open(files[cpt]):
        if line[:15] == '\\begin{comment}':
            incomments = True
        if line[0] != '%' and not incomments:
            tex += ' ' + line.rstrip()
        if line[:13] == '\\end{comment}':
            incomments = False
    # Citations
    citeres = citere.findall(tex)
    for cite in citeres:
        refs = cite.split(',')
        missing = False
        refs = [ref.rstrip().lstrip() for ref in refs]
        for ref in refs:
            if ref not in bibres:
                missing = True
                missingcites.append(files[cpt] + '\t' + ref)
        if(missing):
            continue
        refsO = sorted(refs, key=lambda k: bibres.index(k))
        citeO = ','.join(refsO)
        if cite != citeO:
            ordercites.append(files[cpt] + '\t' + citeO + ' instead of ' + cite)
    # Inputs
    inputs = inputre.findall(tex)
    inputs = [inp + '.tex' for inp in inputs]
    if len(inputs) > 0:
        files.extend(inputs)
    # Acronyms
    acrores = acrore.finditer(tex)
    for acro in acrores:
        if tex[(acro.start()-4):acro.start()] == '\it ' or tex[(acro.start()-4):acro.start()] == 'tit{':
            its[acro.group()] = True
        elif tex[(acro.start()-4):acro.start()] == '\sf ' or tex[(acro.start()-4):acro.start()] == 'tsf{':
            sfs[acro.group()] = True
        else:
            if tex[(acro.start()-6):acro.start()] != '\item[':
                if acro.group() not in acros:
                    acrosfirst.append(files[cpt] + '\t' + tex[(acro.start()-30):acro.start()] + acro.group())
                acros[acro.group()] = True
    # Labels
    labres = labre.findall(tex)
    if len(labres) > 0:
        labs.append([])
    for lab in labres:
        duplicated = False
        for labsf in labs:
            if lab in labsf:
                duplicated = True
        if duplicated:
            labsrep[lab] = True
        else:
            labs[len(labs)-1].append(lab)
    # Internal refs
    inrefres = inrefre.findall(tex)
    for inref in inrefres:
        if inref not in inrefs:
            inrefs.append(inref)
    # Missing
    missres = missre.findall(tex)
    for miss in missres:
        missings.append(files[cpt] + '\t' + miss)
    missres = missre2.findall(tex)
    for miss in missres:
        missings.append(files[cpt] + '\t' + miss)
    missres = missre3.findall(tex)
    for miss in missres:
        missings.append(files[cpt] + '\t' + miss)
    cpt += 1

# Check fig/table refs order
inreforder = []
inrefsec = []
# Figures
lab_curr = []
for lab in labs:
    lab_curr.append(0)
for inref in inrefs:
    if inref[:4] == 'fig:':
        # print str(labs.index(inref)) + ' ' + str(lab_curr) + ' ' + inref
        for ii in range(len(labs)):
            if inref not in labs[ii]:
                continue
            if labs[ii].index(inref) < lab_curr[ii]:
                inreforder.append(inref + ' too late.')
            lab_curr[ii] = labs[ii].index(inref)
    elif inref[:4] != 'tab:' and inref not in inrefsec:
        inrefsec.append(inref)
# Tables
lab_curr = []
for lab in labs:
    lab_curr.append(0)
for inref in inrefs:
    if inref[:4] == 'tab:':
        # print str(labs.index(inref)) + ' ' + str(lab_curr) + ' ' + inref
        for ii in range(len(labs)):
            if inref not in labs[ii]:
                continue
            if labs[ii].index(inref) < lab_curr[ii]:
                inreforder.append(inref + ' too late.')
            lab_curr[ii] = labs[ii].index(inref)

# Output
print ''
if len(missingcites) > 0:
    print 'Missing refs:\n\t' + '\n\t'.join(missingcites) + '\n'
if len(ordercites) > 0:
    print 'Refs to reorder:\n\t' + '\n\t'.join(ordercites) + '\n'
if len(labsrep) > 0:
    print 'Duplicated labels:\n\t' + ' '.join(labsrep.keys()) + '\n'
if len(inrefsec) > 0 and args.inrefs:
    print 'Non-fig/table internal refs:\n\t' + ' '.join(inrefsec) + '\n'
if len(inreforder) > 0:
    print 'Fig/table internal refs order:\n\t' + '\n\t'.join(inreforder) + '\n'
if len(missings) > 0:
    print '??/XX/REF:\n\t' + '\n\t'.join(missings) + '\n'
if not args.noacro:
    if len(its) > 0:
        print 'Acronyms in italic:\n\t' + ' '.join(its.keys()) + '\n'
    if len(sfs) > 0:
        print 'Acronyms in serif:\n\t' + ' '.join(sfs.keys()) + '\n'
    if len(acros) > 0:
        acros = sorted(acros.keys(), key=lambda k: len(k))
        print 'Acronyms not in italic nor serif: \n\t' + ' '.join(acros) + '\n'
    if len(acrosfirst) > 0:
        print 'First use of each acronym (not in italic nor serif): \n\t' + '\n\t'.join(acrosfirst) + '\n'
