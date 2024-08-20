import sys

def split_chain_file(filename):
	with open(filename, 'r') as file:
		for line in file:
			parts = line.strip().split()

			# New chain block
			if len(parts) > 0 and parts[0] == 'chain':
				# Parse out tGenome and qGenome, replace tChr and qChr with the chromosome name
				tGenome = parts[2].split('#')[0]
				tChr = parts[2].split('#')[-1]  # Target name is at index 2			
				parts[2] = tChr # Replace the target name with the chromosome name
				qGenome = parts[7].split('#')[0]
				qHap = parts[7].split('#')[1]	# Query haplotype
				qChr = parts[7].split('#')[-1]  # Query name is at index 7
				parts[7] = qChr # Replace the query name with the chromosome name
				output_filename = "{}hap{}_to_{}.chain".format(qGenome, qHap, tGenome)
				output_file = open(output_filename, "a")
				# Write the replaced tChr and qChr instead for parts[2] and parts[7] for the header line
				output_file.write('\t'.join(parts) + '\n')

			# Write the rest of the lines to the output file
			else:
				output_file.write(line)


if __name__ == "__main__":
	filename = sys.argv[1]
	chains = split_chain_file(filename)