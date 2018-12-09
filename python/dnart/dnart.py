import argparse
import math


def createPath1(xpos, ypos, gt, leftoright=True, width=1):
    '''Creates the SVG for the three-fork path.'''
    midlen = 10
    signlong = ''
    signshort = '-'
    signdir = ''
    if gt == 1:
        midlen = 24
    if gt == 2:
        signlong = '-'
        signshort = ''
    if(not leftoright):
        signdir = '-'
    # Middle
    path = '<path d="M ' + str(xpos) + ' ' + str(ypos)
    path += ' l ' + str(signdir) + str(midlen)
    path += ' 0" stroke="black" fill="none" stroke-width="' + str(width) + '"/>\n'
    # Long
    if gt != 1:
        path += '<path d="M ' + str(xpos) + ' ' + str(ypos)
        path += ' l ' + str(signdir) + '2 0 c ' + str(signdir) + '5,0 '
        path += str(signdir) + '5,' + str(signshort) + '6 ' + str(signdir)
        path += '10,' + str(signshort) + '6 ' + str(signdir) + '5,0 '
        path += str(signdir) + '5,' + str(signlong) + '6 ' + str(signdir)
        path += '10,' + str(signlong) + '6 l ' + str(signdir)
        path += '2 0" stroke="black" fill="none" stroke-width="' + str(width) + '"/>\n'
    # Short
    path += '<path d="M ' + str(xpos) + ' ' + str(ypos)
    path += ' c ' + str(signdir) + '5,0 ' + str(signdir) + '5,'
    path += str(signlong) + '3 ' + str(signdir) + '8,'
    path += str(signlong) + '5" stroke="black" fill="none" stroke-width="' + str(width) + '"/>\n'
    if gt == 1:
        path += '<path d="M ' + str(xpos) + ' ' + str(ypos)
        path += ' c ' + str(signdir) + '5,0 ' + str(signdir) + '5,'
        path += str(signshort) + '3 ' + str(signdir) + '8,'
        path += str(signshort) + '5" stroke="black" fill="none" stroke-width="'
        path += str(width) + '"/>\n'
    return path


def createLink1(xpos, ypos, leftoright=True, width=1):
    '''Creates the SVG for the "go-to-line".'''
    signdir = '-'
    if leftoright:
        signdir = ''
    # Middle
    path = '<path d="M ' + str(xpos) + ' ' + str(ypos)
    # path += ' l 0 -14'
    # path += '" stroke="black" fill="none"/>\n'
    path += ' c ' + str(signdir) + '10,0 ' + str(signdir) + '10,-14 0,-14'
    path += '" stroke="black" fill="none" stroke-width="' + str(width) + '"/>\n'
    return path


def createPack1(xpos, ypos, leftoright=True, width=1):
    '''Creates the SVG for packed SNPs (square).'''
    signdir = '-'
    if leftoright:
        signdir = ''
    # Middle
    path = '<path d="M ' + str(xpos) + ' ' + str(ypos)
    path += ' l ' + str(signdir)
    path += '24 0" stroke="black" fill="none" stroke-width="' + str(width) + '"/>\n'
    # Rect
    xpos += -6
    if leftoright:
        xpos += 12
    path += '<rect x="' + str(xpos) + '" y="' + str(ypos-3)
    path += '" width="' + str(signdir) + '6" height="6"'
    path += ' stroke="black" fill="black" stroke-width="' + str(width) + '"/>\n'
    return path


def createPath2(xpos, ypos, gt, leftoright=True):
    '''Creates the SVG for the three-fork path.'''
    signdir = ''
    if(not leftoright):
        signdir = '-'
    # Left part
    path = '<path d="M ' + str(xpos) + ' ' + str(ypos)
    path += ' l ' + str(signdir) + '6 0" stroke="black" '
    path += 'fill="none" stroke-width="11"/>\n'
    # Right part
    xxpos = xpos + int(signdir + '18')
    path += '<path d="M ' + str(xxpos) + ' ' + str(ypos)
    path += ' l ' + str(signdir) + '6 0" stroke="black" '
    path += 'fill="none" stroke-width="11"/>\n'
    l0 = l1 = l2 = 10
    w0 = w1 = w2 = 3
    y0 = y2 = 4
    y1 = 0
    if gt == 0:
        l0 = 12
    if gt == 1:
        l1 = 12
    if gt == 2:
        l2 = 12
    # 0 path
    xxpos = xpos + int(signdir + '6')
    path += '<path d="M ' + str(xxpos) + ' ' + str(ypos-y0)
    path += ' l ' + str(signdir) + str(l0) + ' 0" stroke="black"'
    path += ' fill="none" stroke-width="' + str(w0) + '"/>\n'
    # 1 path
    path += '<path d="M ' + str(xxpos) + ' ' + str(ypos+y1)
    path += ' l ' + str(signdir) + str(l1) + ' 0" stroke="black"'
    path += ' fill="none" stroke-width="' + str(w1) + '"/>\n'
    # 2 path
    path += '<path d="M ' + str(xxpos) + ' ' + str(ypos+y2)
    path += ' l ' + str(signdir) + str(l2) + ' 0" stroke="black"'
    path += ' fill="none" stroke-width="' + str(w2) + '"/>\n'
    return path


def createLink2(xpos, ypos, leftoright=True,):
    '''Creates the SVG for the "go-to-line".'''
    if leftoright:
        xpos += 3
    else:
        xpos += -3
    path = '<path d="M ' + str(xpos) + ' ' + str(ypos+5.5)
    path += ' l 0 -25" stroke="black"'
    path += ' fill="none" stroke-width="6"/>\n'
    return path


def createPack2(xpos, ypos, leftoright=True):
    '''Creates the SVG for packed SNPs (square).'''
    signdir = ''
    if(not leftoright):
        signdir = '-'
    # Left part
    path = '<path d="M ' + str(xpos) + ' ' + str(ypos)
    path += ' l ' + str(signdir) + '24 0" stroke="black" '
    path += 'fill="none" stroke-width="12"/>\n'
    return path


def createPath3(xpos, ypos, gt, leftoright=True):
    '''Creates the SVG for the three-fork path.'''
    signdir = ''
    if(not leftoright):
        signdir = '-'
    path = ''
    if gt == 2:
        path = '<path d="M ' + str(xpos) + ' ' + str(ypos)
        path += ' l ' + str(signdir) + '10 0" stroke="black" '
        path += 'fill="none" stroke-width="20"/>\n'
    if gt == 1:
        path = '<path d="M ' + str(xpos) + ' ' + str(ypos+5)
        path += ' l ' + str(signdir) + '10 0" stroke="black" '
        path += 'fill="none" stroke-width="10"/>\n'
    return path

def createPath4(xpos, ypos, gt, leftoright=True):
    '''Creates the SVG for the three-fork path.'''
    signdir = ''
    if(not leftoright):
        signdir = '-'
    path = ''
    if gt == 2:
        path = '<circle cx="' + str(xpos) + '" cy="' + str(ypos)
        path += '" r="4" fill="black"/>\n'
    if gt == 1:
        path = '<circle cx="' + str(xpos) + '" cy="' + str(ypos)
        path += '" r="2" fill="black"/>\n'
    return path


def createPack4(xpos, ypos, leftoright=True, width=1):
    '''Creates the SVG for packed SNPs (square).'''
    signdir = '-'
    if leftoright:
        signdir = ''
    path = '<rect x="' + str(xpos-3) + '" y="' + str(ypos-3)
    path += '" width="' + str(signdir) + '6" height="6"'
    path += ' stroke="black" fill="black" stroke-width="' + str(width) + '"/>\n'
    return path


def createPath(xpos, ypos, gt, leftoright=True, width=10, style=1):
    if style == 1:
        return createPath1(xpos, ypos, gt, leftoright, width)
    if style == 2:
        return createPath2(xpos, ypos, gt, leftoright)
    if style == 3:
        return createPath3(xpos, ypos, gt, leftoright)
    if style == 4:
        return createPath4(xpos, ypos, gt, leftoright)


def createLink(xpos, ypos, leftoright=True, width=1, style=1):
    if style == 1:
        return createLink1(xpos, ypos, leftoright, width)
    if style == 2:
        return createLink2(xpos, ypos, leftoright)
    if style > 2:
        return ''


def createPack(xpos, ypos, leftoright=True, width=1, style=1):
    if style == 1:
        return createPack1(xpos, ypos, leftoright, width)
    if style == 2:
        return createPack2(xpos, ypos, leftoright)
    if style == 3:
        return ''
    if style == 4:
        return createPack4(xpos, ypos, leftoright, width)


parser = argparse.ArgumentParser(description='Generate image from DNA results (4 styles).')
parser.add_argument('-i', dest='inf', help='the input file')
parser.add_argument('-o', dest='outf', default='out.svg', help='the output svg file')
parser.add_argument('-a', dest='aspect', default='1', help='the aspect ratio desired (either ratio or WxH)')
parser.add_argument('-w', dest='width', default=1, type=int, help='the width of lines.')
parser.add_argument('-u', dest='unpack', default=100, type=int,
                    help='the number of unpacked SNPs. -1: no packing')
parser.add_argument('-p', dest='pack', default=5000, type=int,
                    help='the number of packed SNPs.')
parser.add_argument('-s', dest='style', default=1, type=int,
                    help='the style.')
args = parser.parse_args()

# Format ratio
if('x' in args.aspect):
    ratio = args.aspect.split('x')
    args.aspect = float(ratio[0])/float(ratio[1])
else:
    args.aspect = float(args.aspect)

# Read file once to estimate nb of SNPs, rows, etc
inf = open(args.inf)
nbsnps = 0
skipping = False
cpt_skipped = 0
cpt_unpacked = 0
logprob = 0.
logprob_total = 0.
for line in inf:
    line = line.rstrip('\n').split('\t')
    gt = int(line[1])
    prob = float(line[2])
    if(prob == 0):  # Not in database ?
        prob = 0.5
    probgt = (1 - prob) * (1 - prob)
    if(gt == 1):
        probgt = 2 * prob * (1 - prob)
    if(gt == 2):
        probgt = prob * prob
    if(args.unpack > 0):
        if(skipping):
            logprob_total += math.log10(probgt)
            if(cpt_skipped < args.pack):
                cpt_skipped += 1
                continue
            else:
                skipping = False
                nbsnps += 1
        else:
            logprob_total += math.log10(probgt)
            logprob += math.log10(probgt)
            if(cpt_unpacked == args.unpack):
                skipping = True
                cpt_unpacked = 0
                cpt_skipped = 1
            else:
                nbsnps += 1
                cpt_unpacked += 1
    else:
        nbsnps += 1
inf.close()
print 'Prob of the ' + str(nbsnps) + ' unpacked SNPs: 1/10^' + str(-int(logprob))
print 'Prob of all SNPs: 1/10^' + str(-int(logprob_total))

# Choose nb of SNPs per column and compute image width/height
offset = 20
wf = 24
hf = 14
if args.style == 3:
    wf = 10
    hf = 20
if args.style == 4:
    wf = 40
    hf = 40
# a=w/h; w=wf*ncol; h=hf*(N/ncol)
# a*(hf*N/ncol)=wf*ncol
# a*N*hf/wf=ncol*ncol
# sqrt(a*N*hf/wf) = ncol
ncol = math.floor(math.sqrt(args.aspect*nbsnps*float(hf)/wf))+1
width = math.ceil(ncol * wf + offset)
nrow = nbsnps / ncol
height = math.ceil(nrow * hf + offset)
print 'Width x height: ' + str(int(width)) + 'x' + str(int(height))

# Init position
colcurr = 0
rowcurr = 0
xpos = offset/2
ypos = offset/2
ltr = True

# Start SVG
outf = open(args.outf, 'w')
svg = '<svg width="' + str(width) + '" height="'
svg += str(height) + '" xmlns="http://www.w3.org/2000/svg">\n'
outf.write(svg)

# Loop over SNPs
skipping = False
cpt_skipped = 0
cpt_unpacked = 0
inf = open(args.inf)
for line in inf:
    write = 1
    if(args.unpack > 0):
        if(skipping):
            if(cpt_skipped < args.pack):
                cpt_skipped += 1
                write = 0
            else:
                skipping = False
                write = 2
        else:
            if(cpt_unpacked == args.unpack):
                skipping = True
                cpt_unpacked = 0
                cpt_skipped = 1
                write = 0
            else:
                cpt_unpacked += 1
    if(write > 0):
        line = line.rstrip('\n').split('\t')
        if(colcurr < ncol):
            colcurr += 1
        else:
            ypos += hf
            colcurr = 1
            rowcurr += 1
            # Add link
            outf.write(createLink(xpos, ypos, ltr, args.width, args.style))
        path = ''
        ltr = rowcurr % 2 == 0
        if(write == 1):
            gt = int(line[1])
            # If reference allele is rare, reverse GT
            if(float(line[2]) < .5):
                gt = 2 - gt
            path = createPath(xpos, ypos, gt, ltr, args.width, args.style)
        else:
            path = createPack(xpos, ypos, ltr, args.width, args.style)
        outf.write(path)
        if(ltr):
            xpos += wf
        else:
            xpos -= wf
inf.close()

# Close SVG
outf.write('</svg>\n')
outf.close()
inf.close()
