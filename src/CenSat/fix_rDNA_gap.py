import sys

# Removes "ct" sandwidtched between rDNA - ct - GAP - ct rDNA
def read_bed(input_file):
	rDNAbeforeGap = []
	gapLine = ''
	rDNAline = ''
	ctLine = ''

	hadRDNA = False
	hadCT = False
	hadGap = False

	if input_file == '-':
		f_in = sys.stdin
	else:
		f_in = open(input_file, 'r')
	
	for line in f_in:
		cols = line.strip().split('\t')

		# check for rDNA in col 4, keep the line
		if cols[3] == 'rDNA':
			if hadRDNA == False and hadCT == False and hadGap == False:
				hadRDNA = True
				rDNAline = line.strip()
				rDNAbeforeGap = cols
				continue
			elif hadRDNA == False and hadCT == True and hadGap == True:
				# T: skip ct, fix the rDNA start pos
				hadGap = False
				hadCT = False
				rDNAline = line.strip()
				rDNAbeforeGap = cols
				#sys.stderr.write('rDNA after GAP and ct: ' + line)
				print(rDNAbeforeGap[0], gapEnd, *rDNAbeforeGap[2:6], gapEnd, *rDNAbeforeGap[7:9], sep='\t')
				ctLine = ''
				rDNAline = ''
				continue
			else:
				if hadRDNA == True:
					hadRDNA = False
					print(rDNAline)
					rDNAline = ''
				if hadCT == True:
					hadCT = False
					print(ctLine)
					ctLine = ''
				print(line.strip())
				continue

		if cols[3] == 'ct':
			# check if the next is ct, keep the line
			if hadCT == False:
				hadCT = True
				if hadRDNA == True and hadGap == False:
					ctLine = line.strip()
				elif hadRDNA == False and hadGap == True:
					# skip ct, fix the prev rDNA END pos
					#sys.stderr.write('keeping ct after GAP: ' + line)
					ctLine = line.strip()
				else:
					print(line.strip())
					hadCT = False
				continue
			# if ctLine is next, but we already had a ct, release the rDNA and ct

		# Handle GAPs
		if cols[3] == 'GAP':
			gapLine = line.strip()
			# if we had rDNA and ct,
			if hadRDNA == True and hadCT == True:
				hadRDNA = False
				hadCT = False
				# and the gap is 1 Mbp, merge ct into rDNA (current gaps in censat v1.0 are a bit longer than 1 Mbp)
				if int(cols[2]) - int(cols[1]) >= 1000000:
					# T: keep the gap start and end
					gapStart = cols[1]
					gapEnd = cols[2]
					hadGap = True
					print(*rDNAbeforeGap[:2], gapStart, *rDNAbeforeGap[3:7], gapStart, rDNAbeforeGap[8], sep='\t')
					print(gapLine)
				# False alarm - print rDNA, ct, and gap. Clear flags.
				else:
					# F: Was a regular rDNA and ct, but not flanking rDNA GAP
					print(rDNAline)
					print(ctLine)
					print(gapLine)
					hadGap = False
				rDNAline = ''
				ctLine = ''
				gapLine = ''
				continue
			# regular gap, print it
			else:
				if int(cols[2]) - int(cols[1]) >= 1000000:
					gapStart = cols[1]
					gapEnd = cols[2]
					hadGap = True
				if hadRDNA == True: # but not hadCT
					hadRDNA = False
					if rDNAline != '': print(rDNAline)
					rDNAline = ''
				if hadCT == True: # but not hadRDNA
					hadCT = False
					if ctLine != '': print(ctLine)
					ctLine = ''
				print(gapLine)
				gapLine = ''
				continue

		# something else, reset the flags and continue printing
		else:
			# had both rDNA and ct: print both
			if hadRDNA == True and hadCT == True:
				if rDNAline != '': print(rDNAline)
				if ctLine != '' : print(ctLine)
				rDNAline = ''
				ctLine = ''
			# had gap and ct: print ct
			if hadGap == True and hadCT == True:
				if ctLine != '' : print(ctLine)
				ctLine = ''
			if rDNAline != '': print(rDNAline)
			rDNAline = ''
			hadRDNA = False
			hadGap = False
			hadCT = False
			print(line.strip())

	if input_file != '-':
		f_in.close()

sys.stderr.write('Replace rDNA - ct - GAP to rDNA - GAP, GAP - ct - rDNA to GAP - rDNA')
if sys.argv[1] == '-':
	sys.stderr.write('  Reading from stdin ... ')
	read_bed(sys.stdin)
else:
	sys.stderr.write('  Reading from ' + sys.argv[0] + ' ... ')
	read_bed(sys.argv[1])
sys.stderr.write('Done!\n')