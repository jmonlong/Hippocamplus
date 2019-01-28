#### To prepare real data
## Download dbSNP
wget ftp://ftp.ncbi.nlm.nih.gov/snp/pre_build152/organisms/human_9606_b150_GRCh37p13/VCF/common_all_20170710.vcf.gz
## Format and annotate SNP frequencies
python formatVcf.py -v dnaresults.vcf.gz -f common_all_20170710.vcf.gz

#### Fake data for examples
Rscript sim.R 500000

## Blackboard background - Style fork/branches
## https://pixabay.com/en/background-texture-board-blackboard-3176447/
RES="5184x3456"
python dnart.py -i dnatree.tsv -o chalk.svg -a $RES -u 200 -p 10000
convert -background none -density 200 -resize $RES chalk.svg chalk.png
### GIMP
# 1. Open background-3176447.jpg and chalk.png
# 1. Match chalk to background:
#     1. Make sure the layers have the same size: Layer to Image size
#     1. Displace the chalk layer: Filter -> Map -> Displace (X/Y displacement: 5)
# 1. Switch black to white: Colors -> Invert
# 1. Distort a bit more the chalk: Filter -> Distort -> Ripple (Amplitude: 1; Period: 100)
# 1. Add random noise for a more chalk-like texture: Filter -> Noise -> Slur
# 1. Make the chalk stand out more: Filter -> Light and Shadow -> Drop Shadow (Offset X/Y: 5)
# 1. Add something in foreground, e.g. drawing, formula, number, name

## Portrait background - Style tiles
## https://pixabay.com/en/kid-soap-bubbles-child-fun-1241817/
RES='4379x3283'
python dnart.py -i dnatree.tsv -o tiles.svg -a $RES -u 200 -p 20000 -s 2
convert -background none -density 200 -resize $RES tiles.svg tiles.png
### GIMP
# 1. Open tree-247122.jpg and tiles.png
# 1. Select tiles contour: Right-click on tile layer -> Alpha to Selection
# 1. Mask background with selection: Right-click on background layer -> Add Layer Mask -> Selection
# 1. Add white background: Right-click on Layer -> New Layer -> White
# 1. Add shadow: Select tiles -> Filters -> Light and Shadow -> Drop Shadow (Offset X/Y: 4; Blur radius: 5)
# 1. Eventually reorder layers to have background, then shadow, then white layer.

## Big Bang background - Style square noise
## https://pixabay.com/en/astronomy-explosion-big-bang-pop-3101270/
RES='4961x3508'
python dnart.py -i dnatree.tsv -o squares.svg -a $RES -u 200 -p 1000 -s 3
convert -background none -density 100 -resize $RES squares.svg squares.png
### GIMP
# 1. Open astronomy-3101270.jpg and squares.png
# 1. Change opacity of the image layer to 90%
# 1. Place the squares below.
# 1. Add a new white layer at the bottom.

## Style "stars"
RES="3000x3000"
python dnart.py -i dnatree.tsv -o stars.svg -a $RES -u 200 -p 10000 -s 4
convert -background white -density 100 -resize $RES stars.svg stars.jpg
### GIMP
# 1. Open stars.jpg
# 1. White stars on black background: Colors -> Invert
# 1. Jiggle: Filters -> Distorts -> Ripple (Vertical; Period: 100; Amplitude: 10)
# 1. Jiggle: Filters -> Distorts -> Ripple (Horizontal; Period: 100; Amplitude: 10)
# 1. Star effect: Filters -> Light and Shadows -> Sparkle (Background color; Spike angle: -1; Luminosity threshold: 0.007; Flare intensity: 0.15; Spike length: 10; Spike points: 3; Spike density: 0.40)
# 1. Add cloud: Filters -> Render -> Fog (Color: black; Turbulence: 10; Opacity: 80)
# 1. Add fog: Filters -> Render -> Fog (Color: light grey; Turbulence: 1, Opacity: 10)
# 1. Order layers as clouds, then fog, then stars.
# 1. Add something in foreground. E.g. galaxy cloud, black hole, spaceship, astronaut.
