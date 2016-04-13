# encoding: UTF-8
$KCODE = "UTF8" #encoding type do arquivo: utf-8 without boom
require 'jcode'
require 'rexml/document'

# Copyright by Paulo Borba, 2008
#
# Known issues: Access to subelements with // only works
#				for immediate subelement.
#
#				Access to multiple subelements with "*"
#				only works for accessing a single attribute
#				of the subelements. Can actually access more
#				than one attribute, but they are mixed together
#				in the same list.
#
#       Since the generated file is encoded as UTF8, the proper LaTeX packages 
#       should be used for compilation.
#
#				Info about courses and administrative tasks are
#				not extracted yet.
#
#       alms: - dÃ¡ pau em palavras como C#TS, C# e Haskell# devido ao "hash".
#             - & dÃ¡ pau tambÃ©m {alterar extraiElemento?}
#             - itemizes vazios (com begin end mas sem itens) tambem nao funcionam...
#                     {replicar soluÃ§Ã£o implementada para Monografias e ICs em andamento}
#
#       Better explore croscutting mechanisms for handling the last item

def includeFile(fileName)
  File.open(fileName) do |file| 
	while line = file.gets
		puts line 
	end
  end
end	

def processaListaNomes(autores)
	if autores.size == 0 then
		""
	elsif autores.size == 1 then
		autores[0]
	elsif autores.size == 2 then
		autores[0] << " e " << autores[1]
	else 
		autores[0] << ", " << processaListaNomes(autores - [autores[0]])
	end
end

def processaNomeAutor(autor)
	match = /(\w+), (\w+)/.match(autor)
	if match then
		match[2].capitalize << " " << match[1].capitalize 
	else 
		autor
	end
end

def processaEditores(editores)
	match = /(\w+);/.match(editores)
	if match then
		editores << ", editores"
	elsif (editores != "") then	
		editores << ", editor"
	else
		""
	end
end

def processaPaginas(pgi,pgf)
	if (pgi != "" and  pgi!= "?") and (pgf != "" and  pgf!= "?") then
		"pgs #{pgi}--#{pgf}, "
	else 
		""
	end
end

def processaPagina(pgs)
	if (pgs != "" and  pgs != "?" and pgs != "0") then
		"#{pgs} pgs, "
	else 
		""
	end
end

def processaCoOrientacao(co)
	if (co == "CO_ORIENTADOR") then
		"Co-orientaÃ§Ã£o."
	else 
		""
	end
end

def processaTipoOrientacao(tipo)
	if ((tipo == "INICIACAO_CIENTIFICA") or (tipo == "IniciaÃ§Ã£o CientÃ­fica"))
		"IniciaÃ§Ã£o CientÃ­fica em "
	elsif ((tipo == "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO") or
		   (tipo == "Trabalho de conclusÃ£o de curso de graduaÃ§Ã£o") or
		   (tipo == "GraduaÃ§Ã£o"))
		"Trabalho de ConclusÃ£o de Curso de GraduaÃ§Ã£o, "
	elsif (tipo == "Doutorado")
		"Tese de Doutorado em "
	elsif (tipo == "Mestrado")
		"Tese de Mestrado em "
	else
		""
	end	
end

def processaAgencia(agencia)
	if (agencia != "") then
		" OrgÃ£o Financiador: #{agencia}."
	else
		""
	end
end
		
	
def extraiElemento(elemento, estrutura)
    map = {}
	estrutura.keys.each {|e|
		match = /(.*)\/\/(.*)/.match(e)
	    if match then	
	    	elemento.elements.each(match[1]) {|epai|
	    		epai.elements.each(match[2]) {|efilho|
	    			map = map.update(extraiElemento(efilho,estrutura[e]))
	    	}}	
	    else    
			elemento.elements.each(e) {|d|
				atts = d.attributes
				if estrutura[e].include?("*") then
					(estrutura[e] - ["*"]).each {|att|
					    map[e] = (if map[e] then map[e] else [] end) + 
				                 [atts[att]]
				    }
				else
					estrutura[e].each {|att|
						map[att] = atts[att]
					}
			  end
			}
		end
	}
	map	
end

def processaArtigosJornal(artigos, referencia)	
	estrutura = {"DADOS-BASICOS-DO-ARTIGO" => 
					["TITULO-DO-ARTIGO", "ANO-DO-ARTIGO"],
				 "DETALHAMENTO-DO-ARTIGO" => 
				 	["TITULO-DO-PERIODICO-OU-REVISTA", "VOLUME", "FASCICULO", "PAGINA-INICIAL", "PAGINA-FINAL"],
				 "AUTORES" => ["*", "NOME-PARA-CITACAO"]}	
	artigos.each{|a|
		map = extraiElemento(a,estrutura)
		fasc = if (map["FASCICULO"] != "") then "(#{map["FASCICULO"]})" else "" end		
		puts "\\item #{processaListaNomes(map["AUTORES"].collect{|na| processaNomeAutor(na)})}. \\emph\{#{map["TITULO-DO-ARTIGO"]}\}. #{map["TITULO-DO-PERIODICO-OU-REVISTA"]}, volume #{map["VOLUME"]}#{fasc}, #{processaPaginas(map["PAGINA-INICIAL"],map["PAGINA-FINAL"])}#{map["ANO-DO-ARTIGO"]}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaArtigosEventos(artigos, referencia)	
	estrutura = {"DADOS-BASICOS-DO-TRABALHO" => 
					["TITULO-DO-TRABALHO", "ANO-DO-TRABALHO", "PAIS-DO-EVENTO"],
				 "DETALHAMENTO-DO-TRABALHO" => 
				 	["NOME-DO-EVENTO", "PAGINA-INICIAL", "PAGINA-FINAL"],
				 "AUTORES" => ["*", "NOME-PARA-CITACAO"]}	
	artigos.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item #{processaListaNomes(map["AUTORES"].collect{|na| processaNomeAutor(na)})}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}. #{map["NOME-DO-EVENTO"]}, #{processaPaginas(map["PAGINA-INICIAL"],map["PAGINA-FINAL"])}#{map["PAIS-DO-EVENTO"]}, #{map["ANO-DO-TRABALHO"]}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaCapitulosLivros(capitulos, referencia)	
	estrutura = {"DADOS-BASICOS-DO-CAPITULO" => 
					["TITULO-DO-CAPITULO-DO-LIVRO", "ANO"],
				 "DETALHAMENTO-DO-CAPITULO" => 
				 	["TITULO-DO-LIVRO", "PAGINA-INICIAL", "PAGINA-FINAL", "ORGANIZADORES", "NOME-DA-EDITORA"],
				 "AUTORES" => ["*", "NOME-PARA-CITACAO"]}	
	capitulos.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item #{processaListaNomes(map["AUTORES"].collect{|na| processaNomeAutor(na)})}. #{map["TITULO-DO-CAPITULO-DO-LIVRO"]}. Em #{processaEditores(map["ORGANIZADORES"])}, \\emph\{#{map["TITULO-DO-LIVRO"]}\}, #{processaPaginas(map["PAGINA-INICIAL"],map["PAGINA-FINAL"])}#{map["NOME-DA-EDITORA"]}, #{map["ANO"]}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaOrientacoesConcluidas(orientacoes, referencia, tipo)	
	estrutura = {"DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo => 
					["TITULO", "ANO"],
				 "DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo => 
				 	["NOME-DO-ORIENTADO", "NOME-DA-INSTITUICAO", "NOME-DO-CURSO", "NUMERO-DE-PAGINAS", "TIPO-DE-ORIENTACAO"]}	
	orientacoes.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item #{map["NOME-DO-ORIENTADO"]}. \\emph\{#{map["TITULO"]}\}. Tese de #{tipo.capitalize} em #{map["NOME-DO-CURSO"]}, #{map["NOME-DA-INSTITUICAO"]}, #{processaPagina(map["NUMERO-DE-PAGINAS"])}#{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\DOC\{#{referencia}\}"
	}	
	referencia = referencia + 1
	referencia
end

def processaOrientacoesEmAndamento(orientacoes, referencia, tipo)
	estrutura = {"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo => 
					["TITULO-DO-TRABALHO", "ANO"],
				 "DETALHAMENTO-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo => 
				 	["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO", "TIPO-DE-ORIENTACAO"]}	
	orientacoes.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item #{map["NOME-DO-ORIENTANDO"]}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}. Tese de #{tipo.capitalize} em #{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\DOC\{#{referencia}\}"		
	}	
	referencia = referencia + 1
	referencia
end

def processaOutrasOrientacoesConcluidas(orientacoes, referencia, tipo)	
	estrutura = {"DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-CONCLUIDAS" => 
					["TITULO", "ANO"],
				 "DETALHAMENTO-DE-OUTRAS-ORIENTACOES-CONCLUIDAS"  => 
				 	["NOME-DO-ORIENTADO", "NOME-DA-INSTITUICAO", "NOME-DO-CURSO", "NUMERO-DE-PAGINAS", "TIPO-DE-ORIENTACAO-CONCLUIDA", "NOME-DA-AGENCIA"]}	
	orientacoes.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item #{map["NOME-DO-ORIENTADO"]}. #{map["TITULO"]}.  #{processaTipoOrientacao(tipo)}#{map["NOME-DO-CURSO"]}, #{map["NOME-DA-INSTITUICAO"]}, #{processaPagina(map["NUMERO-DE-PAGINAS"])}#{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO-CONCLUIDA"])}#{processaAgencia(map["NOME-DA-AGENCIA"])} \\DOC\{#{referencia}\}"			
	}	
	referencia = referencia + 1
	referencia
end

def processaOutrasOrientacoesEmAndamento(orientacoes, referencia, tipo)
	estrutura = {"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo => 
					["TITULO-DO-TRABALHO", "ANO", "NATUREZA"],
				 "DETALHAMENTO-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo => 
				 	["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO", "NOME-DA-AGENCIA"]}	
	orientacoes.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item #{map["NOME-DO-ORIENTANDO"]}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. #{processaAgencia(map["NOME-DA-AGENCIA"])} \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaBancas(bancas, referencia, tipo)
	estrutura = {"DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo => 
					["TITULO", "ANO", "NATUREZA"],
				 "DETALHAMENTO-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo => 
				 	["NOME-DO-CANDIDATO", "NOME-INSTITUICAO", "NOME-CURSO"],
				 "PARTICIPANTE-BANCA" => ["*", "NOME-PARA-CITACAO-DO-PARTICIPANTE-DA-BANCA"]}	
	bancas.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item #{map["NOME-DO-CANDIDATO"]}. \\emph\{#{map["TITULO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. Examinadores: #{processaListaNomes(map["PARTICIPANTE-BANCA"].collect{|na| processaNomeAutor(na)})} \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaComites(comites, referencia)
	estrutura = {"DADOS-BASICOS-DE-DEMAIS-TRABALHOS" => 
					["TITULO", "ANO", "PAIS"]
				}	
	comites.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item #{map["TITULO"]}, #{map["PAIS"]}, #{map["ANO"]}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end


def processaProjetos(comites, referencia)
	estrutura = {"PROJETO-DE-PESQUISA" => 
					["NOME-DO-PROJETO", "ANO-INICIO", "ANO-FIM", "NATUREZA"],
				 "PROJETO-DE-PESQUISA//FINANCIADORES-DO-PROJETO" => 
					 {"FINANCIADOR-DO-PROJETO" => ["*", "NOME-INSTITUICAO"]},
				}	
	comites.each{|a|
		map = extraiElemento(a,estrutura)
		puts "\\item \\emph\{#{map["NOME-DO-PROJETO"]}\}, Projeto de #{map["NATUREZA"].capitalize}, de #{map["ANO-INICIO"]} atÃ© #{map["ANO-FIM"]}, instituiÃ§Ãµes alÃ©m da UFPE: #{processaListaNomes(map["FINANCIADOR-DO-PROJETO"])}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def selecionaElementosPorAno(vitae, anos, elemento, subelemento, attributoAno) 
	selecionaElementosPorAnoECondicao(vitae, anos, elemento, subelemento, attributoAno){|db| true}
end

def selecionaElementosPorAnoECondicao(vitae, anos, elemento, subelemento, attributoAno) #condicao 
	selecionaElementosPorCondicao(vitae, elemento, subelemento) {|db| anos.include?(db.attributes[attributoAno]) and yield(db)}
end

def selecionaElementosPorCondicao(vitae, elemento, subelemento) #condicao 
	elementos = []
	vitae.elements.each(elemento){|a|
		a.elements.each(subelemento){|db|
			if yield(db)
			then
				elementos = elementos + [a]
			end
		}
	}
	elementos
end

def selecionaArtigosJornal(vitae, anos) 
	selecionaElementosPorAno(vitae,anos,"//ARTIGO-PUBLICADO",
		"DADOS-BASICOS-DO-ARTIGO","ANO-DO-ARTIGO")
end

def selecionaArtigosEventosNacional(vitae, anos, natureza) 
	selecionaElementosPorAnoECondicao(vitae, anos, "//TRABALHO-EM-EVENTOS", "DADOS-BASICOS-DO-TRABALHO", "ANO-DO-TRABALHO") {|db| 
			        db.attributes["PAIS-DO-EVENTO"] == "Brasil" and 
			        db.attributes["NATUREZA"] == natureza}
end			        

def selecionaArtigosEventosInterNacional(vitae, anos, natureza) 
	selecionaElementosPorAnoECondicao(vitae, anos, "//TRABALHO-EM-EVENTOS", "DADOS-BASICOS-DO-TRABALHO", "ANO-DO-TRABALHO") {|db| 
			        db.attributes["PAIS-DO-EVENTO"] != "Brasil" and 
			        db.attributes["NATUREZA"] == natureza}			        
end

def selecionaCapitulosDeLivros(vitae, anos)	
	selecionaElementosPorAno(vitae,anos,"//CAPITULO-DE-LIVRO-PUBLICADO",
		"DADOS-BASICOS-DO-CAPITULO","ANO")
end

def selecionaOrientacoesConcluidas(vitae, anos, tipo)	
	selecionaElementosPorAno(vitae,anos,"//ORIENTACOES-CONCLUIDAS-PARA-" << tipo,
		"DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo,"ANO")
end

def selecionaOrientacoesEmAndamento(vitae, tipo)	
	selecionaElementosPorCondicao(vitae,"//ORIENTACAO-EM-ANDAMENTO-DE-" << tipo,
		"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo){|db| true}
end

def selecionaOutrasOrientacoesConcluidas(vitae, anos, tipo)	
	selecionaElementosPorAnoECondicao(vitae,anos,"//OUTRAS-ORIENTACOES-CONCLUIDAS","DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-CONCLUIDAS","ANO"){|db| db.attributes["NATUREZA"] == tipo}
end

def selecionaOutrasOrientacoesEmAndamento(vitae, tipo)	
	selecionaElementosPorCondicao(vitae,"//ORIENTACAO-EM-ANDAMENTO-DE-" << tipo, "DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo) {|db|   true}
end	

def selecionaBancas(vitae, anos, tipo)	
	selecionaElementosPorAno(vitae,anos,"//PARTICIPACAO-EM-BANCA-DE-" << tipo,"DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo,"ANO")
end

def selecionaComites(vitae, anos)	
	selecionaElementosPorAno(vitae,anos,"//DEMAIS-TRABALHOS","DADOS-BASICOS-DE-DEMAIS-TRABALHOS","ANO")
end

def selecionaProjetos(vitae, anos)	
	selecionaElementosPorCondicao(vitae,"//PARTICIPACAO-EM-PROJETO","PROJETO-DE-PESQUISA") {|db| anos.include?(db.attributes["ANO-INICIO"]) or anos.include?(db.attributes["ANO-FIM"])}
end

vitae = REXML::Document.new(File.open("vitaeCNPq.xml"))
anos = ["2009","2008","2007"]
referencia = 1

# InstruÃ§Ãµes de uso: 
# 
#	      1. CurrÃ­culo Lattes deve ser nomeado como vitaeCNPq.xml,
#          e colocado no mesmo diretÃ³rio deste programa
#       2. O arquivo inicio.tex, tambÃ©m colocado no mesmo diretÃ³rio 
#          deste programa, com dados iniciais da progressÃ£o
#       3. Alterar variÃ¡vel anos
#       4. Colocar disciplinas.tex no mesmo diretÃ³rio deste programa 
#       5. Colocar extensao.tex no mesmo diretÃ³rio deste programa
#       6. Colocar cursosemeventos.tex no mesmo diretÃ³rio deste programa
#
#       Para modificar a codificaÃ§Ã£o de caracteres de um arquivo
#       iconv -f LATIN1 -t UTF-8 cursosemeventos.tex > cursosemeventos1.tex 
#


puts ""
includeFile("inicio.tex")

puts "\\section{Grupo 1 --- Ensino}"
puts "\\subsection{Subgrupo 1}"
puts "\\subsubsection{OrientaÃ§Ã£o de Teses de Doutorado ConcluÃ­das}"
puts "\\begin{itemize}"
orientacoes = selecionaOrientacoesConcluidas(vitae, anos, "DOUTORADO")
referencia = processaOrientacoesConcluidas(orientacoes, referencia, "DOUTORADO")	
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{OrientaÃ§Ã£o de Teses de Mestrado ConcluÃ­das}"
puts "\\begin{itemize}"
orientacoes = selecionaOrientacoesConcluidas(vitae, anos, "MESTRADO")
referencia = processaOrientacoesConcluidas(orientacoes, referencia, "MESTRADO")	
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{OrientaÃ§Ã£o de Monografias de ConclusÃ£o de Curso ConcluÃ­das}"
puts "\\begin{itemize}"
orientacoes = selecionaOutrasOrientacoesConcluidas(vitae, anos, "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO")
referencia = processaOutrasOrientacoesConcluidas(orientacoes, referencia,"TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO")
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{OrientaÃ§Ã£o de Trabalhos de IniciaÃ§Ã£o CientÃ­fica e Monitoria}"
puts "\\begin{itemize}"
orientacoes = selecionaOutrasOrientacoesConcluidas(vitae, anos, "INICIACAO_CIENTIFICA")
referencia = processaOutrasOrientacoesConcluidas(orientacoes, referencia,"INICIACAO_CIENTIFICA")
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{OrientaÃ§Ã£o de Teses de Doutorado em Andamento}"
puts "\\begin{itemize}"
orientacoes = selecionaOrientacoesEmAndamento(vitae, "DOUTORADO")
referencia = processaOrientacoesEmAndamento(orientacoes, referencia, "DOUTORADO")	
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{OrientaÃ§Ã£o de Teses de Mestrado em Andamento}"
puts "\\begin{itemize}"
orientacoes = selecionaOrientacoesEmAndamento(vitae, "MESTRADO")
referencia = processaOrientacoesEmAndamento(orientacoes, referencia, "MESTRADO")	
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{OrientaÃ§Ã£o de Monografias de ConclusÃ£o de Curso em Andamento}"
orientacoes = selecionaOutrasOrientacoesEmAndamento(vitae, "GRADUACAO")
if (orientacoes != []) then
  puts "\\begin{itemize}"
  referencia = processaOutrasOrientacoesEmAndamento(orientacoes, referencia, "GRADUACAO")
  puts "\\end{itemize}"
else
  puts "Nenhuma atividade no perÃ­odo."
end

puts ""
puts "\\subsubsection{OrientaÃ§Ã£o de Trabalhos de IniciaÃ§Ã£o CientÃ­fica e Monitoria em Andamento}"
orientacoes = selecionaOutrasOrientacoesEmAndamento(vitae, "INICIACAO-CIENTIFICA")
if (orientacoes != []) then
  puts "\\begin{itemize}"
  referencia = processaOutrasOrientacoesEmAndamento(orientacoes, referencia, "INICIACAO-CIENTIFICA")
  puts "\\end{itemize}"
else
  puts "Nenhuma atividade no perÃ­odo."
end
	
puts ""
puts "\\subsection{Subgrupo 2}"
puts "\\subsubsection{ParticipaÃ§Ã£o em Banca de DissertaÃ§Ã£o de Doutorado}"
puts "\\begin{itemize}"
bancas = selecionaBancas(vitae, anos, "DOUTORADO")
referencia = processaBancas(bancas, referencia,"DOUTORADO")
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{ParticipaÃ§Ã£o em Banca de DissertaÃ§Ã£o de Mestrado}"
puts "\\begin{itemize}"
bancas = selecionaBancas(vitae, anos, "MESTRADO")
referencia = processaBancas(bancas, referencia,"MESTRADO")
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{ParticipaÃ§Ã£o em Banca de Exame de QualificaÃ§Ã£o de Doutorado}"
puts "\\begin{itemize}"
bancas = selecionaBancas(vitae, anos, "EXAME-QUALIFICACAO")
referencia = processaBancas(bancas, referencia,"EXAME-QUALIFICACAO")
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{ParticipaÃ§Ã£o em Banca de Monografia de ConclusÃ£o de Curso}"
puts "\\begin{itemize}"
bancas = selecionaBancas(vitae, anos, "GRADUACAO")
referencia = processaBancas(bancas, referencia,"GRADUACAO")
puts "\\end{itemize}"

puts ""
includeFile("disciplinas.tex")

puts ""
puts "\\section{Grupo 2 --- ProduÃ§Ã£o CientÃ­fica}"
puts "\\subsection{Subgrupo 1}"
puts "\\subsubsection{Artigos completos publicados em anais de congressos nacionais}"
puts "\\begin{itemize}"
artigosEventos = selecionaArtigosEventosNacional(vitae, anos, "COMPLETO")
nArtigosEventos = artigosEventos.length
referencia = processaArtigosEventos(artigosEventos, referencia)	
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{Artigos completos publicados em anais de congressos internacionais}"
puts "\\begin{itemize}"
artigosEventos = selecionaArtigosEventosInterNacional(vitae, anos, "COMPLETO") 
nArtigosEventos = nArtigosEventos + artigosEventos.length
referencia = processaArtigosEventos(artigosEventos, referencia)	
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{ParticipaÃ§Ã£o em ComitÃªs de Programa de Eventos CientÃ­ficos}"
puts "\\begin{itemize}"
comites = selecionaComites(vitae, anos)
referencia = processaComites(comites, referencia)
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{Projetos de Pesquisa}"
puts "\\begin{itemize}"
projetos = selecionaProjetos(vitae, anos)
referencia = processaProjetos(projetos, referencia)
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{Resumos expandidos publicados em anais de congressos nacionais}"
puts "\\begin{itemize}"
artigosEventos = selecionaArtigosEventosNacional(vitae, anos, "RESUMO_EXPANDIDO") 
nResumosEventos = artigosEventos.length
referencia = processaArtigosEventos(artigosEventos, referencia)	
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{Resumos expandidos publicados em anais de congressos internacionais}"
puts "\\begin{itemize}"
artigosEventos = selecionaArtigosEventosInterNacional(vitae, anos, "RESUMO_EXPANDIDO") 
nResumosEventos = nResumosEventos + artigosEventos.length
referencia = processaArtigosEventos(artigosEventos, referencia)	
puts "\\end{itemize}"

puts ""
includeFile("cursosemeventos.tex")

puts ""
puts "\\subsection{Subgrupo 2}"
puts "\\subsubsection{Trabalhos publicados em periÃ³dicos especializados}"
puts "\\begin{itemize}"
artigosJornal = selecionaArtigosJornal(vitae, anos) 
nArtigosJornal = artigosJornal.length
referencia = processaArtigosJornal(artigosJornal, referencia)	
puts "\\end{itemize}"

puts ""
puts "\\subsubsection{CapÃ­tulos de Livros}"
puts "\\begin{itemize}"
capitulos = selecionaCapitulosDeLivros(vitae, anos)
nCapitulos = capitulos.length
referencia = processaCapitulosLivros(capitulos, referencia)
puts "\\end{itemize}"

puts ""
includeFile("extensao.tex")

puts "Relatorio"
puts "Artigos Jornal = " 
puts nArtigosJornal
puts "ResumosEventos = "
puts nResumosEventos
puts "Capitulos = "
puts nCapitulos
puts "Artigos Eventos = "
puts nArtigosEventos
