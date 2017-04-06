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

arquivo = ARGV[0]
numero = ARGV[1]

csv_text = File.read(arquivo)
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
   linha =  row.to_s
   linha = linha.split(';')
   if(linha[3].match(numero)) # Busca as linhas que possuem o parâmetro
      if(linha[6].downcase.match(/local|locais/))     #1 - Ligacoes locais
         if(linha[6].downcase.match(/fixo/))
            #FAZ O QUE TEM QUE FAZER PARA FIXO
         else
            #FAZ O QUE TEM QUE FAZER PARA CELULAR
         end
      elsif(linha[6].downcase.match(/ld|distância|distancia/))
         if(linha[6].downcase.match(/fixo/))
            #FAZ O QUE TEM QUE FAZER PARA FIXO
         else
            #FAZ O QUE TEM QUE FAZER PARA CELULAR
         end
      elsif(linha[6].downcase.match(/torpedo/))
         print(linha[3]," ",linha[6],"\n")
      elsif(linha[6].downcase.match(/fast/))
         #FAZ O QUE TEM QUE FAZER COM INTERNET
      end
   end
end
