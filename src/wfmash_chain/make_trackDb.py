#!/bin/python3

import re

def replace_variables_in_template(templateFile, replacements, out_file):
    with open(templateFile, 'r') as file:
        template = file.read()

    for key, value in replacements.items():
        template = re.sub(r'\$\{' + key + r'\}', value, template)

    # print(template + "\n")
    with open(out_file, 'a') as fileOut:
        fileOut.writelines(template + "\n\n")

sp=["mGorGor1", "mPanPan1", "mPanTro3", "mPonAbe1", "mPonPyg2", "mSymSyn1"]
sn=["Gorilla_gorilla", "Pan_paniscus", "Pan_troglodytes", "Pongo_abelii", "Pongo_pygmaeus", "Symphalangus_syndactylus"]
#sp=["mGorGor1"]
#sn=["Gorilla_gorilla"]
haps_1=["mat", "pat"]
haps_2=["hap1", "hap2"]

hprc=["HG002", "HG00438", "HG005", "HG00621", "HG00673", "HG00733", "HG00735", "HG00741", "HG01071", "HG01106", "HG01109", "HG01123", "HG01175", "HG01243", "HG01258", "HG01358", "HG01361", "HG01891", "HG01928", "HG01952", "HG01978", "HG02055", "HG02080", "HG02109", "HG02145", "HG02148", "HG02257", "HG02486", "HG02559", "HG02572", "HG02622", "HG02630", "HG02717", "HG02723", "HG02818", "HG02886", "HG03098", "HG03453", "HG03486", "HG03492", "HG03516", "HG03540", "HG03579", "NA18906", "NA19240", "NA20129", "NA21309"]
#hprc=["NA21309"]

'''
# HPRCy1 to CHM13v2.0
k=131 # Reserved for HPRCy1
print("##  HPRCy1  ##")
for i in range(len(hprc)):
	for j in range(2):
		replacements = {
			'hprc': hprc[i],
			'hap': haps_2[j],
            'ref': "CHM13v2.0",
			'priority': str(k)
			# Add more if needed
		}
		replace_variables_in_template('trackTemplate_hprc_to_chm13.txt', replacements, "HPRCy1.CHM13.trackDb.txt")
		k += 1
'''

# HPRCy1 to Primates
for i in range(len(sp)):
	print("##\t" + sp[i] + "\t##")
	k=231 # Reserved for HPRCy1, begin for each sp

	for j in range(len(hprc)):
		for l in range(2):
			replacements = {
				'hprc': hprc[j],
				'hap': haps_2[l],
				'ref_sp': sp[i],
				'ref_sn': sn[i],
				'ver': "v2.0",
				'priority': str(k)
				# Add more if needed
			}
			replace_variables_in_template('trackTemplate_hprc_to_primates.txt', replacements, "HPRCy1." + sp[i] + ".trackDb.txt")
			k += 1

'''

for i in range(len(sp)):

	print("##\t" + sp[i] + " " + sp[i] + "\t##")
	replacements = {
		'ref_sp': sp[i],
		'ref_sn': sn[i]
		# Add more if needed
	}
	replace_variables_in_template('trackTemplate_human_to_primates.txt', replacements)

	for j in range(2):
		for hap in haps_1 :
			# print(sp, hap)
			replacements = {
				'ref_sp': sp[i],
				'ref_sn': sn[i],
				'sp': sp[j],
				'sn': sn[j],
				'hap': hap
				# Add more if needed
			}
			replace_variables_in_template('trackTemplate_primates_to_primates.txt', replacements)

	for j in range(2, 6):
		for hap in haps_2 :
			replacements = {
				'ref_sp': sp[i],
				'ref_sn': sn[i],
				'sp': sp[j],
				'sn': sn[j],
				'hap': hap
				# Add more if needed
			}
			replace_variables_in_template('trackTemplate_primates_to_primates.txt', replacements)

print("##\tCHM13\t##")
for j in range(2):
	for hap in haps_1 :
		# print(sp, hap)
		replacements = {
			'ref_sp': sp[i],
			'ref_sn': sn[i],
			'sp': sp[j],
			'sn': sn[j],
			'hap': hap
			# Add more if needed
		}
		replace_variables_in_template('trackTemplate_primates_to_chm13.txt', replacements)

for j in range(2, 6):
	for hap in haps_2 :
		replacements = {
			'ref_sp': sp[i],
			'ref_sn': sn[i],
			'sp': sp[j],
			'sn': sn[j],
			'hap': hap
			# Add more if needed
		}
		replace_variables_in_template('trackTemplate_primates_to_chm13.txt', replacements)

print("##\tHG002\t##")
for j in range(2):
	for hap in haps_1 :
		# print(sp, hap)
		replacements = {
			'ref_sp': sp[i],
			'ref_sn': sn[i],
			'sp': sp[j],
			'sn': sn[j],
			'hap': hap
			# Add more if needed
		}
		replace_variables_in_template('trackTemplate_primates_to_hg002.txt', replacements)

for j in range(2, 6):
	for hap in haps_2 :
		replacements = {
			'ref_sp': sp[i],
			'ref_sn': sn[i],
			'sp': sp[j],
			'sn': sn[j],
			'hap': hap
			# Add more if needed
		}
		replace_variables_in_template('trackTemplate_primates_to_hg002.txt', replacements)

'''