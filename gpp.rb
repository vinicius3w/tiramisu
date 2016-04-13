#$KCODE = "UTF8" #encoding type do arquivo: utf-8 without boom
require 'jcode' if RUBY_VERSION < '1.9'
require 'rexml/document'
include REXML
require_relative 'Cin'
include Cin

# Copyright by Paulo Borba, 2008
#
# Known issues: Access to subelements with // only works
#			for immediate subelement.
#
#     Access to multiple subelements with "*"
#			only works for accessing a single attribute
#			of the subelements. Can actually access more
#			than one attribute, but they are mixed together
#			in the same list.
#
#     Since the generated file is encoded as UTF8, the proper LaTeX packages 
#     should be used for compilation.
#
#			Info about courses and administrative tasks are
#			not extracted yet.
#
#     alms: - dá pau em palavras como C#TS, C# e Haskell# devido ao "hash".
#           - & dá pau também {alterar extraiElemento?}
#           - itemizes vazios (com begin end mas sem itens) tambem nao funcionam...
#           {replicar solução implementada para Monografias e ICs em andamento}
#
#     Better explore croscutting mechanisms for handling the last item

def includeFile(fileName)
	saida = ""
  File.open(fileName) do |file| 
		while line = file.gets
			puts line 
			saida = saida + line
		end
  end
  return saida
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
		"Co-orienta\c{c}\~{a}o."
	else 
		""
	end
end

def processaTipoOrientacao(tipo)
	if ((tipo == "INICIACAO_CIENTIFICA") or (tipo == "Inicia\c{c}\~{a}o Cient\'{\i}fica"))
		"Inicia\c{c}\~{a}o Cient\'{\i}fica em "
	elsif ((tipo == "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO") or
		   (tipo == "Trabalho de conclus\~{a}o de curso de gradua\c{c}\~{a}o") or
		   (tipo == "Gradua\c{c}\~{a}o"))
		"Trabalho de Conclus\~{a}o de Curso de Gradua\c{c}\~{a}o, "
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
		" Org\~{a}o Financiador: #{agencia}."
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

def processaArtigosJornal(artigos, referencia, cv)	
	estrutura = {"DADOS-BASICOS-DO-ARTIGO" => 
					["TITULO-DO-ARTIGO", "ANO-DO-ARTIGO"],
				 "DETALHAMENTO-DO-ARTIGO" => 
				 	["TITULO-DO-PERIODICO-OU-REVISTA", "VOLUME", "FASCICULO", "PAGINA-INICIAL", "PAGINA-FINAL"],
				 "AUTORES" => ["*", "NOME-PARA-CITACAO"]}	
	artigos.each{|a|
		map = extraiElemento(a,estrutura)
		fasc = if (map["FASCICULO"] != "") then "(#{map["FASCICULO"]})" else "" end		
		cv.puts "\\item #{processaListaNomes(map["AUTORES"].collect{|na| processaNomeAutor(na)})}. \\emph\{#{map["TITULO-DO-ARTIGO"]}\}. #{map["TITULO-DO-PERIODICO-OU-REVISTA"]}, volume #{map["VOLUME"]}#{fasc}, #{processaPaginas(map["PAGINA-INICIAL"],map["PAGINA-FINAL"])}#{map["ANO-DO-ARTIGO"]}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaArtigosEventos(artigos, referencia, cv)	
	estrutura = {"DADOS-BASICOS-DO-TRABALHO" => 
					["TITULO-DO-TRABALHO", "ANO-DO-TRABALHO", "PAIS-DO-EVENTO"],
				 "DETALHAMENTO-DO-TRABALHO" => 
				 	["NOME-DO-EVENTO", "PAGINA-INICIAL", "PAGINA-FINAL"],
				 "AUTORES" => ["*", "NOME-PARA-CITACAO"]}	
	artigos.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item #{processaListaNomes(map["AUTORES"].collect{|na| processaNomeAutor(na)})}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}. #{map["NOME-DO-EVENTO"]}, #{processaPaginas(map["PAGINA-INICIAL"],map["PAGINA-FINAL"])}#{map["PAIS-DO-EVENTO"]}, #{map["ANO-DO-TRABALHO"]}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaCapitulosLivros(capitulos, referencia, cv)	
	estrutura = {"DADOS-BASICOS-DO-CAPITULO" => 
					["TITULO-DO-CAPITULO-DO-LIVRO", "ANO"],
				 "DETALHAMENTO-DO-CAPITULO" => 
				 	["TITULO-DO-LIVRO", "PAGINA-INICIAL", "PAGINA-FINAL", "ORGANIZADORES", "NOME-DA-EDITORA"],
				 "AUTORES" => ["*", "NOME-PARA-CITACAO"]}	
	capitulos.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item #{processaListaNomes(map["AUTORES"].collect{|na| processaNomeAutor(na)})}. #{map["TITULO-DO-CAPITULO-DO-LIVRO"]}. Em #{processaEditores(map["ORGANIZADORES"])}, \\emph\{#{map["TITULO-DO-LIVRO"]}\}, #{processaPaginas(map["PAGINA-INICIAL"],map["PAGINA-FINAL"])}#{map["NOME-DA-EDITORA"]}, #{map["ANO"]}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaOrientacoesConcluidas(orientacoes, referencia, tipo, cv)	
	estrutura = {"DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo => 
					["TITULO", "ANO"],
				 "DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo => 
				 	["NOME-DO-ORIENTADO", "NOME-DA-INSTITUICAO", "NOME-DO-CURSO", "NUMERO-DE-PAGINAS", "TIPO-DE-ORIENTACAO"]}	
	orientacoes.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item #{map["NOME-DO-ORIENTADO"]}. \\emph\{#{map["TITULO"]}\}. Tese de #{tipo.capitalize} em #{map["NOME-DO-CURSO"]}, #{map["NOME-DA-INSTITUICAO"]}, #{processaPagina(map["NUMERO-DE-PAGINAS"])}#{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\DOC\{#{referencia}\}"
	}	
	referencia = referencia + 1
	referencia
end

def processaOrientacoesEmAndamento(orientacoes, referencia, tipo, cv)
	estrutura = {"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo => 
					["TITULO-DO-TRABALHO", "ANO"],
				 "DETALHAMENTO-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo => 
				 	["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO", "TIPO-DE-ORIENTACAO"]}	
	orientacoes.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item #{map["NOME-DO-ORIENTANDO"]}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}. Tese de #{tipo.capitalize} em #{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\DOC\{#{referencia}\}"		
	}	
	referencia = referencia + 1
	referencia
end

def processaOutrasOrientacoesConcluidas(orientacoes, referencia, tipo, cv)	
	estrutura = {"DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-CONCLUIDAS" => 
					["TITULO", "ANO"],
				 "DETALHAMENTO-DE-OUTRAS-ORIENTACOES-CONCLUIDAS"  => 
				 	["NOME-DO-ORIENTADO", "NOME-DA-INSTITUICAO", "NOME-DO-CURSO", "NUMERO-DE-PAGINAS", "TIPO-DE-ORIENTACAO-CONCLUIDA", "NOME-DA-AGENCIA"]}	
	orientacoes.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item #{map["NOME-DO-ORIENTADO"]}. #{map["TITULO"]}.  #{processaTipoOrientacao(tipo)}#{map["NOME-DO-CURSO"]}, #{map["NOME-DA-INSTITUICAO"]}, #{processaPagina(map["NUMERO-DE-PAGINAS"])}#{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO-CONCLUIDA"])}#{processaAgencia(map["NOME-DA-AGENCIA"])} \\DOC\{#{referencia}\}"			
	}	
	referencia = referencia + 1
	referencia
end

def processaOutrasOrientacoesEmAndamento(orientacoes, referencia, tipo, cv)
	estrutura = {"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo => 
					["TITULO-DO-TRABALHO", "ANO", "NATUREZA"],
				 "DETALHAMENTO-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo => 
				 	["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO", "NOME-DA-AGENCIA"]}	
	orientacoes.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item #{map["NOME-DO-ORIENTANDO"]}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. #{processaAgencia(map["NOME-DA-AGENCIA"])} \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaBancas(bancas, referencia, tipo, cv)
	estrutura = {"DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo => 
					["TITULO", "ANO", "NATUREZA"],
				 "DETALHAMENTO-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo => 
				 	["NOME-DO-CANDIDATO", "NOME-INSTITUICAO", "NOME-CURSO"],
				 "PARTICIPANTE-BANCA" => ["*", "NOME-PARA-CITACAO-DO-PARTICIPANTE-DA-BANCA"]}	
	bancas.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item #{map["NOME-DO-CANDIDATO"]}. \\emph\{#{map["TITULO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. Examinadores: #{processaListaNomes(map["PARTICIPANTE-BANCA"].collect{|na| processaNomeAutor(na)})} \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end

def processaComites(comites, referencia, cv)
	estrutura = {"DADOS-BASICOS-DE-DEMAIS-TRABALHOS" => 
					["TITULO", "ANO", "PAIS"]
				}	
	comites.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item #{map["TITULO"]}, #{map["PAIS"]}, #{map["ANO"]}. \\DOC\{#{referencia}\}"
			referencia = referencia + 1
	}	
	referencia
end


def processaProjetos(comites, referencia, cv)
	estrutura = {"PROJETO-DE-PESQUISA" => 
					["NOME-DO-PROJETO", "ANO-INICIO", "ANO-FIM", "NATUREZA"],
				 "PROJETO-DE-PESQUISA//FINANCIADORES-DO-PROJETO" => 
					 {"FINANCIADOR-DO-PROJETO" => ["*", "NOME-INSTITUICAO"]},
				}	
	comites.each{|a|
		map = extraiElemento(a,estrutura)
		cv.puts "\\item \\emph\{#{map["NOME-DO-PROJETO"]}\}, Projeto de #{map["NATUREZA"].capitalize}, de #{map["ANO-INICIO"]} at\'{e} #{map["ANO-FIM"]}, institui\c{c}\~{o}es al\'{e}m da UFPE: #{processaListaNomes(map["FINANCIADOR-DO-PROJETO"])}. \\DOC\{#{referencia}\}"
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
anos = ["2015"]
referencia = 1
root = vitae.root()
#puts root.elements[1].attributes["NOME-COMPLETO"].to_s
siape = "1807586"
departamento = "Departamento de Informa\\c{c}\\~{a}o e Sistemas"
dataInicio = "20 de Agosto de 2014"
dataFim = "19 de Agosto de 2016"
categoriaOrigem = "Adjunto N\'{i}vel 3"
categoriaDestino = "Adjunto N\'{i}vel 4"
categoriaProgressao = "Horizontal"
memorial = File.open( "vitaeCNPq.tex", "w+" )


# Instruções de uso: 
# 
#	  1. Currículo Lattes deve ser nomeado como vitaeCNPq.xml,
#     e colocado no mesmo diretório deste programa
#   2. O arquivo inicio.tex, também colocado no mesmo diretório 
#     deste programa, com dados iniciais da progressão
#   3. Alterar variável anos
#   4. Colocar disciplinas.tex no mesmo diretório deste programa 
#   5. Colocar extensao.tex no mesmo diretório deste programa
#   6. Colocar cursosemeventos.tex no mesmo diretório deste programa
#
#   Para modificar a codificação de caracteres de um arquivo
#   iconv -f LATIN1 -t UTF-8 cursosemeventos.tex > cursosemeventos1.tex 
#

#memorialTeXHeader(root.elements[1].attributes["NOME-COMPLETO"].to_s, siape, anos, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao, memorial)

#memorialTeXPresentation(professor, departamento, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao, memorial)

#atividadesDeEnsino(memorial)

memorial << ""
memorial << includeFile("inicio.tex")
#memorial << includeFile("header.tex")

memorial << "\\section{Grupo 1 --- Ensino}"
memorial << "\\subsection{Subgrupo 1}"
memorial << "\\subsubsection{Orienta\c{c}\~{a}o de Teses de Doutorado Conclu\'{\i}­das}"
memorial << "\\begin{itemize}"
orientacoes = selecionaOrientacoesConcluidas(vitae, anos, "DOUTORADO")
referencia = processaOrientacoesConcluidas(orientacoes, referencia, "DOUTORADO", memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Orienta\c{c}\~{a}o de Teses de Mestrado Conclu\'{\i}­das}"
memorial << "\\begin{itemize}"
orientacoes = selecionaOrientacoesConcluidas(vitae, anos, "MESTRADO")
referencia = processaOrientacoesConcluidas(orientacoes, referencia, "MESTRADO", memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Orienta\c{c}\~{a}o de Monografias de Conclus\~{a}o de Curso Conclu\'{\i}­das}"
memorial << "\\begin{itemize}"
orientacoes = selecionaOutrasOrientacoesConcluidas(vitae, anos, "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO")
referencia = processaOutrasOrientacoesConcluidas(orientacoes, referencia,"TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO", memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Orienta\c{c}\~{a}o de Trabalhos de Inicia\c{c}\~{a}o Cient\'{\i}­fica e Monitoria}"
memorial << "\\begin{itemize}"
orientacoes = selecionaOutrasOrientacoesConcluidas(vitae, anos, "INICIACAO_CIENTIFICA")
referencia = processaOutrasOrientacoesConcluidas(orientacoes, referencia,"INICIACAO_CIENTIFICA", memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Orienta\c{c}\~{a}o de Teses de Doutorado em Andamento}"
memorial << "\\begin{itemize}"
orientacoes = selecionaOrientacoesEmAndamento(vitae, "DOUTORADO")
referencia = processaOrientacoesEmAndamento(orientacoes, referencia, "DOUTORADO", memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Orienta\c{c}\~{a}o de Teses de Mestrado em Andamento}"
memorial << "\\begin{itemize}"
orientacoes = selecionaOrientacoesEmAndamento(vitae, "MESTRADO")
referencia = processaOrientacoesEmAndamento(orientacoes, referencia, "MESTRADO", memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Orienta\c{c}\~{a}o de Monografias de Conclus\~{a}o de Curso em Andamento}"
orientacoes = selecionaOutrasOrientacoesEmAndamento(vitae, "GRADUACAO")
if (orientacoes != []) then
  memorial << "\\begin{itemize}"
  referencia = processaOutrasOrientacoesEmAndamento(orientacoes, referencia, "GRADUACAO", memorial)
  memorial << "\\end{itemize}"
else
  memorial << "Nenhuma atividade no per\'{\i}­odo."
end

memorial << ""
memorial << "\\subsubsection{Orienta\c{c}\~{a}o de Trabalhos de Inicia\c{c}\~{a}o Cient\'{\i}­fica e Monitoria em Andamento}"
orientacoes = selecionaOutrasOrientacoesEmAndamento(vitae, "INICIACAO-CIENTIFICA")
if (orientacoes != []) then
  memorial << "\\begin{itemize}"
  referencia = processaOutrasOrientacoesEmAndamento(orientacoes, referencia, "INICIACAO-CIENTIFICA", memorial)
  memorial << "\\end{itemize}"
else
  memorial << "Nenhuma atividade no per\'{\i}­odo."
end
	
memorial << ""
memorial << "\\subsection{Subgrupo 2}"
memorial << "\\subsubsection{Participa\c{c}\~{a}o em Banca de Disserta\c{c}\~{a}o de Doutorado}"
memorial << "\\begin{itemize}"
bancas = selecionaBancas(vitae, anos, "DOUTORADO")
referencia = processaBancas(bancas, referencia,"DOUTORADO", memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Participa\c{c}\~{a}o em Banca de Disserta\c{c}\~{a}o de Mestrado}"
memorial << "\\begin{itemize}"
bancas = selecionaBancas(vitae, anos, "MESTRADO")
referencia = processaBancas(bancas, referencia,"MESTRADO", memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Participa\c{c}\~{a}o em Banca de Exame de Qualifica\c{c}\~{a}o de Doutorado}"
memorial << "\\begin{itemize}"
bancas = selecionaBancas(vitae, anos, "EXAME-QUALIFICACAO")
referencia = processaBancas(bancas, referencia,"EXAME-QUALIFICACAO", memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Participa\c{c}\~{a}o em Banca de Monografia de Conclus\~{a}o de Curso}"
memorial << "\\begin{itemize}"
bancas = selecionaBancas(vitae, anos, "GRADUACAO")
referencia = processaBancas(bancas, referencia,"GRADUACAO", memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << includeFile("disciplinas.tex")

memorial << ""
memorial << "\\section{Grupo 2 --- Produ\c{c}\~{a}o Cient\'{\i}­fica}"
memorial << "\\subsection{Subgrupo 1}"
memorial << "\\subsubsection{Artigos completos publicados em anais de congressos nacionais}"
memorial << "\\begin{itemize}"
artigosEventos = selecionaArtigosEventosNacional(vitae, anos, "COMPLETO")
nArtigosEventos = artigosEventos.length
referencia = processaArtigosEventos(artigosEventos, referencia, memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Artigos completos publicados em anais de congressos internacionais}"
memorial << "\\begin{itemize}"
artigosEventos = selecionaArtigosEventosInterNacional(vitae, anos, "COMPLETO") 
nArtigosEventos = nArtigosEventos + artigosEventos.length
referencia = processaArtigosEventos(artigosEventos, referencia, memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Participa\c{c}\~{a}o em Comit\^{e}s de Programa de Eventos Cient\'{\i}­ficos}"
memorial << "\\begin{itemize}"
comites = selecionaComites(vitae, anos)
referencia = processaComites(comites, referencia, memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Projetos de Pesquisa}"
memorial << "\\begin{itemize}"
projetos = selecionaProjetos(vitae, anos)
referencia = processaProjetos(projetos, referencia, memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Resumos expandidos publicados em anais de congressos nacionais}"
memorial << "\\begin{itemize}"
artigosEventos = selecionaArtigosEventosNacional(vitae, anos, "RESUMO_EXPANDIDO") 
nResumosEventos = artigosEventos.length
referencia = processaArtigosEventos(artigosEventos, referencia, memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Resumos expandidos publicados em anais de congressos internacionais}"
memorial << "\\begin{itemize}"
artigosEventos = selecionaArtigosEventosInterNacional(vitae, anos, "RESUMO_EXPANDIDO") 
nResumosEventos = nResumosEventos + artigosEventos.length
referencia = processaArtigosEventos(artigosEventos, referencia, memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << includeFile("cursosemeventos.tex")

memorial << ""
memorial << "\\subsection{Subgrupo 2}"
memorial << "\\subsubsection{Trabalhos publicados em peri\'{o}dicos especializados}"
memorial << "\\begin{itemize}"
artigosJornal = selecionaArtigosJornal(vitae, anos) 
nArtigosJornal = artigosJornal.length
referencia = processaArtigosJornal(artigosJornal, referencia, memorial)	
memorial << "\\end{itemize}"

memorial << ""
memorial << "\\subsubsection{Cap\'{\i}­tulos de Livros}"
memorial << "\\begin{itemize}"
capitulos = selecionaCapitulosDeLivros(vitae, anos)
nCapitulos = capitulos.length
referencia = processaCapitulosLivros(capitulos, referencia, memorial)
memorial << "\\end{itemize}"

memorial << ""
memorial << includeFile("extensao.tex")

memorial << "Relat\'{o}rio"
memorial.print "Artigos Jornal = " 
memorial << nArtigosJornal
memorial.print "Resumos Eventos = "
memorial << nResumosEventos
memorial.print "Capitulos = "
memorial << nCapitulos
memorial.print "Artigos Eventos = "
memorial << nArtigosEventos