##############################################################################
#  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler
##############################################################################

from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("-clocks", dest="clocks", help="List of clock names, separated by spaces", required=True, type=str, nargs="+")
parser.add_argument("-scanrate", dest="scanrate", help="Scan rate in epics syntax (e.g. \"1 second\"), default is 1 second", required=False, type=str, default="1 second")
parser.add_argument("-outpath", dest="outpath", help="Output Path", required=True, type=str)
parser.add_argument("-outname", dest="outname", help="Output File Name", required=True, type=str)
args = parser.parse_args()

OUTPUT_FILE_PATH = args.outpath + "/" + args.outname + ".template"

def ClockRecName(clock : str):
    return "$(DEV):$(SYS)-CLK-MEAS-{}".format(clock)


#Read template
with open("TemplateInput/CLOCK_MEASURE.tpl", "r") as f:
    content = f.read()

#Add scan rate
content = content.replace("<SCAN_RATE>", args.scanrate)

#Add first clock name entry
content = content.replace("<NAME0>", ClockRecName(args.clocks[0]))

#Add clock records
clock_rec = []
for i, clock in enumerate(args.clocks):
    fields = [  '   field(DTYP, "regDev")',
                '   field(INP,  "@$(BASE):$(CLKMEAS)+0x{:02x} T=uint32")'.format(i*4),
                '   field(LINR, "SLOPE")',
                '   field(ESLO, "1e-6")',
                '   field(PREC, "3")',
                '   field(EGU,  "MHz")']
    if i < len(args.clocks)-1:
        fields.append('   field(FLNK, "{}")'.format(ClockRecName(args.clocks[i+1])))

    allParts = ['record (ai,"{}"){{'.format(ClockRecName(clock))]
    allParts.extend(fields)
    allParts.append("}")
    txt = "\n".join(allParts)
    clock_rec.append(txt)
content = content.replace("<CLOCK_RECORDS>", "\n\n".join(clock_rec))

#Write templat file
with open(OUTPUT_FILE_PATH, "w+") as f:
    f.write(content)


