require 'csv'

#!/usr/bin/env ruby
#
# example_basic.rb:: Basic implement the extraction of items from invoice files in .txt format.
#
# Author:  Guilherme Zabot
# Time-stamp: <2017-04-05 14:17:20 anupam>
# Copyright (C) 2017 Guilherme Zabot <zabot.gui@gmail.com>
#
#
#                                        +-------------+
#                                       |     ROOT     |
#                                       +------+------+
#                                              |
#              +------------------------+------+--------------+----------------------+
#             |                        |                      \                       \
#    +--------+--------+      +--------+--------+     +--------+--------+     +--------+--------+
#    | Ligações Locais |      |   Ligações LD   |     |       SMS       |     |     Internet    |
#    +--------+-------+       +--------+-------+      +--------+-------+      +--------+-------+
#         |      \                 |      \
#        |        \               |        \
#   +---+---+  +---+---+     +---+---+  +---+---+
#   |Celular|  |  Fixo |     |Celular|  |  Fixo |
#   +------+   +------+      +------+   +------+

# ...Parameters used to read the gem
arquivo = ARGV[0]
numero = ARGV[1]

# ...Array to store information
local_fixo = Array.new     # Used to store Local P/ Fixos
local_celular = Array.new  # Used to store Local P/ Celular
ld_fixo = Array.new        # Used to store Longa Distancia P/ Fixo
ld_celular = Array.new     # Used to store Longa Distancia P/ Celular
torpedos = 0               # Used to store SMS
internet = 0               # Used to store Internet

# ...Function used to transform string in seconds
def ReturnSeconds(value)
   result = value.split(/m|s/)
   result = result[0].to_i*60 + result[1].to_i
   return result
end

# ...Performs the reading of the file
csv_text = File.read(arquivo)
csv = CSV.parse(csv_text, :headers => true)

# ...Travels all the lines of the file, separating them by (;)
csv.each do |row|
   line =  row.to_s
   line = line.split(';')
   if(line[3].match(numero)) # ...Searches for rows that have the parameter
      if(line[6].downcase.match(/local|locais/))     # ...1 - Ligacoes locais
         if(line[6].downcase.match(/fixo/))          # ...1.1 - Ligacoes P/ Fixos
            local_fixo.push(ReturnSeconds(line[13]))
         else                                         # ...1.2 - Ligacoes P/ Celular (Padrao)
            local_celular.push(ReturnSeconds(line[13]))
         end
      elsif(line[6].downcase.match(/ld|distância|distancia/)) # ...2 - Ligacoes LD
         if(line[6].downcase.match(/fixo/))                   # ...2.1 - Ligacoes P/ Fixos
            ld_fixo.push(ReturnSeconds(line[13]))
         else                                                  # ...2.2 - Ligacoes P/ Celular (Padrao)
            ld_celular.push(ReturnSeconds(line[13]))
         end
      elsif(line[6].downcase.match(/torpedo/))                # ...3 - SMS (Torpedos)
          torpedos += 1
      elsif(line[6].downcase.match(/fast/))                   # ...4 - Internet (Fast)
         fast = lines[i][14].split(/ /)
         fast = fast[0].to_i
         internet += fast * lines[i][13].to_i
      end
   end
end

# ...Representation of result
local_celular = local_celular.inject(0,:+)
local_fixo = local_fixo.inject(0,:+)
ld_celular = ld_celular.inject(0,:+)
ld_fixo = ld_fixo.inject(0,:+)

print("1 - Ligações Locais:\n")
print("  1.1 - Para Celular: ",local_celular/60,"m",local_celular%60,"s\n")
print("  1.2 - Para Fixo   : ",local_fixo/60,"m",local_fixo%60,"s\n")
print("  TOTAL             : ",(local_celular+local_fixo)/60,"m",(local_celular+local_fixo)%60,"s\n\n")

print("2 - Ligações Longa Distância:\n")
print("  2.1 - Para Celular: ",ld_celular/60,"m",ld_celular%60,"s\n")
print("  2.2 - Para Fixo   : ",ld_fixo/60,"m",ld_fixo%60,"s\n")
print("  TOTAL             : ",(ld_celular+ld_fixo)/60,"m",(ld_celular+ld_fixo)%60,"s\n\n")

print("2 - Torpedos (SMS):\n")
print("  TOTAL (un)       : ",torpedos,"\n\n")

print("3 - Internet :\n")
print("  TOTAL (bytes)    : ",internet,"\n\n")
