import sys
import re
import os

if len(sys.argv) < 2:
	print("Usage: python %s <GFF3 file>", sys.argv[0])
	print("  <GFF3 file>: path to the GFF3 file to be converted")
	print("  output: <GFF3 file>.geneType.txt and <GFF3 file>.colors.txt")
	print("  - <GFF3 file>.geneType.txt: <gene/transcript ID> <gene_biotype>")
	print("  - <GFF3 file>.colors.txt:   <gene/transcript ID> <RGB code>")
	sys.exit(1)

# Define the input GFF3 file path
gff3_file = sys.argv[1]

# Define the output file path
# Get the base filename without the extension
base_filename = os.path.splitext(gff3_file)[0]

# Replace the file extension
geneType = base_filename + ".geneType.txt"
colors = base_filename + ".colors.txt"
names = base_filename + ".geneNames.txt"

# Color codes
col_protein_coding = "25\t25\t112" # midnight blue
col_pseudogene = "65\t105\t225" # royal blue
col_rna = "50\t205\t50" # lime green
col_else = "128\t128\t128" # gray

with open(colors, 'w') as color_file:
    pass

# Function to take gene_biotype as input, write output to colors.txt
def write_rgb_codes(id, gene_biotype):

	# Open the colors.txt file for writing
	with open(colors, "a") as color_file:
		
		# Check the gene_biotype and write the corresponding RGB code
		if gene_biotype == "protein_coding":
			color_file.write(f"{id}\t{col_protein_coding}\n")
		elif gene_biotype.endswith("pseudogene"):
			color_file.write(f"{id}\t{col_pseudogene}\n")
		elif gene_biotype.endswith("RNA"):
			color_file.write(f"{id}\t{col_rna}\n")
		else: # gray
			color_file.write(f"{id}\t{col_else}\n")
			SystemError(f"Unknown gene_biotype: {gene_biotype=}")

# Open the input GFF3 file for reading
with open(gff3_file, "r") as file, open(geneType, "w") as gene_type_out, open(names, "w") as gene_names_out:
	# Iterate over each line in the input file
	for line in file:
		# Skip comment lines
		if line.startswith("#"):
			continue
		# Split the line into fields
		fields = line.strip().split("\t")
		
		# Extract the feature type
		feature_type = fields[2]
		
		# Extract the attributes field
		attributes = fields[8]
		
		# Extract gene_biotype from gene feature
		if feature_type == "gene":

			gene_biotype_match = re.search(r"gene_biotype=([^;]+)", attributes)
			if gene_biotype_match:
				gene_biotype = gene_biotype_match.group(1)
			else:
				gene_biotype = ""
			id_match = re.search(r"ID=([^;]+)", attributes)
			if id_match:
				id = id_match.group(1)
			else:
				id = ""
			
			gene_type_out.write(f"{id}\t{gene_biotype}\n")
			write_rgb_codes(id, gene_biotype)

			# Extract gene name from gene feature
			gene_name_match = re.search(r"gene_name=([^;]+)", attributes)
			if gene_name_match:
				gene_name = gene_name_match.group(1)
			else:
				gene_name = ""

			# Extract gene synonyms from gene feature
			# Duplicate gene_name to match the 3 column requirements
			# if not, genePredToBigGenePred gets confused
			gene_synonyms_match = re.search(r"gene_synonym=([^;]+)", attributes)
			if gene_synonyms_match:
				gene_synonyms = gene_synonyms_match.group(1)
				gene_names_out.write(f"{id}\t{gene_name}\t{gene_synonyms}\n")
			else:
				gene_synonyms = ""
				gene_names_out.write(f"{id}\t{gene_name}\t{gene_name}\n")
			
			

		# Extract ID from transcript feature
		# Duplicate gene_name to match the 3 column requirements
		# if not, genePredToBigGenePred gets confused
		elif feature_type == "transcript":
			id_match = re.search(r"ID=([^;]+)", attributes)
			has_transcript = True
			if id_match:
				id = id_match.group(1)
			else:
				id = ""

			# Write the transcript ID and gene_biotype to the output file
			gene_type_out.write(f"{id}\t{gene_biotype}\n")
			write_rgb_codes(id, gene_biotype)

			# Extract gene from transcript feature
			gene_name_match = re.search(r"gene=([^;]+)", attributes)
			if gene_name_match:
				parent_name = gene_name_match.group(1)
			else:
				parent_name = ""
			
			if gene_name == parent_name and gene_synonyms != "":
				gene_names_out.write(f"{id}\t{parent_name}\t{gene_synonyms}\n")
			else:
				gene_names_out.write(f"{id}\t{parent_name}\t{parent_name}\n")

