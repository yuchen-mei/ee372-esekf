import sys

def encloses (obs, pin):
  return float(pin[0]) >= float(obs[0]) and float(pin[1]) >= float(obs[1]) and float(pin[2]) <= float(obs[2]) and float(pin[3]) <= float(obs[3])

input_filename = sys.argv[1]
output_filename = sys.argv[2]
print('Parsing LEF file: ', input_filename)
f = open(input_filename, 'r')

start_vdd = 0
end_vdd = 0
start_gnd = 0
end_gnd = 0

start_obs = 0
start_obs_metal3 = 0
end_obs_metal3 = 0

line_start_vdd = 0
line_end_vdd = 0
line_start_gnd = 0
line_end_gnd = 0
line_start_obs_metal3 = 0
line_end_obs_metal3 = 0

vdd_pins = []
gnd_pins = []
obs_metal3 = []

# First make a list of vdd pins, gnd pins, and metal3 obstructions
line_number = 0
for line in f:
  line_number = line_number + 1
  words = line.split()
  if len(words) >= 2:
    if words[0] == 'PIN' and words[1] == 'vdd':
      print('Start vdd')
      start_vdd = 1
      line_start_vdd = line_number
    if words[0] == 'END' and words[1] == 'vdd':
      print('End vdd')
      end_vdd = 1
      line_end_vdd = line_number
    if start_vdd == 1 and end_vdd == 0:
      if words[0] == 'RECT':
        vdd_pins.append((words[1], words[2], words[3], words[4]))

    if words[0] == 'PIN' and words[1] == 'gnd':
      print('Start gnd')
      start_gnd = 1
      line_start_gnd = line_number
    if words[0] == 'END' and words[1] == 'gnd':
      print('End gnd')
      end_gnd = 1
      line_end_gnd = line_number
    if start_gnd == 1 and end_gnd == 0:
      if words[0] == 'RECT':
        gnd_pins.append((words[1], words[2], words[3], words[4]))

  if words[0] == 'OBS':
    print('Start obs')
    start_obs = 1

  if start_obs:
    if len(words) >= 2:
      if words[0] == 'LAYER' and words[1] == 'metal3':
        print('Start obs metal3')
        start_obs_metal3 = 1
        line_start_obs_metal3 = line_number
        
    if len(words) >= 2:
      if words[0] == 'LAYER' and words[1] == 'metal4':
        print('End obs metal3')
        end_obs_metal3 = 1
        line_end_obs_metal3 = line_number
      
    if start_obs_metal3 == 1 and end_obs_metal3 == 0:
      if words[0] == 'RECT':
        obs_metal3.append((words[1], words[2], words[3], words[4]))

f.close()

#print vdd_pins
#print gnd_pins
#print obs_metal3
print('# Original vdd pins = ', len(vdd_pins))
print('# Original gnd pins = ', len(gnd_pins))
print('# Original metal3 obstructions = ', len(obs_metal3))

# The obstruction list seems to have some repeated elements! 
# First uniquify all lists 

vdd_pins_unq = list(set(vdd_pins))
gnd_pins_unq = list(set(gnd_pins))
obs_metal3_unq = list(set(obs_metal3))
print('# Uniquified vdd pins = ', len(vdd_pins_unq))
print('# Uniquified gnd pins = ', len(gnd_pins_unq))
print('# Uniquified metal3 obstructions = ', len(obs_metal3_unq))

# Then for each vdd pin and gnd pin, find the enclosing obstruction,
# delete it from the obstruction, and replace it into pin list

new_vdd_pins = []
for pin in vdd_pins_unq:
  for obs in obs_metal3_unq:
    if encloses(obs, pin):
      #print('obs', obs)
      #print('pin', pin)
      new_vdd_pins.append(obs)
      #break

obs_minus_vdd = list(set(obs_metal3_unq) - set(new_vdd_pins))

new_gnd_pins = []
for pin in gnd_pins_unq:
  for obs in obs_minus_vdd:
    if encloses(obs, pin):
      new_gnd_pins.append(obs)
      #break

obs_minus_vdd_gnd = list(set(obs_minus_vdd) - set(new_gnd_pins))

print('# New vdd pins = ', len(new_vdd_pins))
print('# Obstructions after removing vdd pins = ', len(obs_minus_vdd))
print('# New gnd pins = ', len(new_gnd_pins))
print('# Obstructions after removing vdd and gnd pins = ', len(obs_minus_vdd_gnd))

# Now generate the new LEF file with these revised pins and obstructions

print('Line start vdd = ', line_start_vdd)
print('Line end vdd = ', line_end_vdd)
print('Line start gnd = ', line_start_gnd)
print('Line end gnd = ', line_end_gnd)
print('Line start obs metal3 = ', line_start_obs_metal3)
print('Line end obs metal3 = ', line_end_obs_metal3)

print('Writing LEF file: ', output_filename)
f = open(input_filename, 'r')
g = open(output_filename, 'w')
for i in range(line_start_vdd + 4): # Write upto vdd PORT
  g.write(f.readline())
for pin in new_vdd_pins:
  g.write('         LAYER metal3 ;\n')
  g.write('         RECT  ' + pin[0] + ' ' + pin[1] + ' ' + pin[2] + ' ' + pin[3] + ' ;\n')
for i in range(len(vdd_pins)*2):
  f.readline()
for i in range(7):
  g.write(f.readline())
for pin in new_gnd_pins:
  g.write('         LAYER metal3 ;\n')
  g.write('         RECT  ' + pin[0] + ' ' + pin[1] + ' ' + pin[2] + ' ' + pin[3] + ' ;\n')
for i in range(len(gnd_pins)*2):
  f.readline()
for i in range(line_start_obs_metal3 - line_end_gnd + 2):
  g.write(f.readline())
for obs in obs_minus_vdd_gnd:
  g.write('      RECT  ' + obs[0] + ' ' + obs[1] + ' ' + obs[2] + ' ' + obs[3] + ' ;\n')
for i in range(len(obs_metal3)):
  f.readline()
for line in f:
  g.write(line)
f.close()
g.close()
