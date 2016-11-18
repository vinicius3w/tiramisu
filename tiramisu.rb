# encoding: UTF-8
require 'jcode' if RUBY_VERSION < '1.9'
require 'rexml/document'
#require 'nokogiri'

def include_file(fileName)
  saida = ""
  File.open(fileName) do |file|
    while line = file.gets
      puts line
      saida = saida + line
    end
  end
  return saida
end

def extrai_elemento(elemento, estrutura)
  map = {}
  estrutura.keys.each {|e|
    match = /(.*)\/\/(.*)/.match(e)
    if match then
      elemento.elements.each(match[1]) {|epai|
        epai.elements.each(match[2]) {|efilho|
          map = map.update(extrai_elemento(efilho, estrutura[e]))
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

def processa_inicio_arquivo_TeX(professor, siape, anos, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao)

  result = String.new("\n")

  result = File.read("header.tex")

  result << "\n"

  result << "\\usepackage[bookmarks,colorlinks,pdfpagelabels,
        pdftitle={Memorial Descritivo de Atividades}, \n
        pdfauthor={#{professor}}, \n
        pdfsubject={Solicita\\c{c}\\~{a}o de progress\\~{a}o funcional docente de #{categoriaOrigem} para #{categoriaDestino} apresentada \\`{a} Comiss\\~{a}o de Avalia\\c{c}\\~{a}o de Progress\\~{a}o #{categoriaProgressao} do Centro de Inform\\'{a}tica da Universidade Federal de Pernambuco.}, \n
        pdfcreator={#{professor}}, pdfkeywords={Progress\\~{a}o, #{categoriaOrigem}, #{categoriaDestino}, #{categoriaProgressao}, UFPE, CIn}]{hyperref}\n"

  result << "\n"

  result << "\\newcommand{\\otoprule}{\\midrule[\\heavyrulewidth]}\n"
  result << "\n"
  result << "% Definicao de margens\n"
  result << "\\setlength{\\textwidth}{16cm} %\n"
  result << "\\setlength{\\textheight}{23cm} %\n"
  result << "\\setlength{\\oddsidemargin}{0cm} %\n"
  result << "\\setlength{\\evensidemargin}{0cm} %\n"
  result << "\\setlength{\\topmargin}{0cm}\n"
  result << "\n"
  result << "\\renewcommand{\\abstractname}{Resumo}\n"
  result << "\\renewcommand{\\contentsname}{\\'{I}ndice Anal\\'{\\i}tico}\n"
  result << "\\renewcommand{\\refname}{Refer\\^{e}ncias}\n"
  result << "\\renewcommand{\\appendixname}{Ap\\^{e}ndice}\n"
  result << "\\renewcommand{\\tablename}{Tabela}\n"
  result << "\n"
  result << "%% Formatacao do cabecalho e rodape\n"
  result << "\\lhead{\\footnotesize Memorial Descritivo de Atividades} %\n"
  result << "\\rhead{\\footnotesize \\emph{#{professor}}} %\n"
  result << "\\chead{} %\n"
  result << "\\cfoot{} %\n"
  result << "\\lfoot{\\footnotesize\\nouppercase\\leftmark} %\n"
  result << "\\rfoot{\\bfseries\\thepage}\n"
  result << "\\renewcommand{\\footrulewidth}{0.1pt}\n"
  result << "\n"
  result << "% Comando para inserir numero de documento\n"
  result << "\\newcounter{document}%[section]\n"
  result << "\\setcounter{document}{0}\n"
  result << "\\renewcommand\\theenumi{\\arabic{section}.\\arabic{enumi}}\n"
  result << "\\newcommand\\Doc{{\\addtocounter{document}{1}\\mbox{\\sffamily\\bfseries [Doc. \\arabic{document}]}}}\n"
  result << "\n"
  result << "% Comando para repetir um numero de documento ja citado\n"
  result << "% \\mbox{\\sffamily{\\bfseries{[Doc. XX]}}}\n"
  result << "\n"
  result << "%% Alternativa na edicao dos comandos.\n"
  result << "%% Comando para inserir numero de documento\n"
  result << "% \\newcommand\\thedocument{%\n"
  result << "%    \\ifthenelse{\\arabic{subsection}=0}\n"
  result << "%      {\\thesection.\\arabic{document}}\n"
  result << "%      {\\thesubsection.\\arabic{document}}}\n"
  result << "% \\newcounter{document}[section]\n"
  result << "% \\setcounter{document}{0}\n"
  result << "% \\renewcommand\\theenumi{\\arabic{section}.\\arabic{enumi}}\n"
  result << "% \\ifthenelse{\\arabic{subsection} = 0}{\\newcommand\\Doc{{\\stepcounter{document}\\bfseries [Doc. \\arabic{section}.\\arabic{document}]}}}{\\newcommand\\Doc{{\\stepcounter{document}\\bfseries [Doc. \\arabic{section}.\\arabic{subsection}.\\arabic{document}]}}}\n"
  result << "% %\\newcommand\\Doc{{\\addtocounter{document}{1}\\mbox{\\bfseries [Doc. \\arabic{document}]}}}\n"
  result << "\n"
  result << "\n"
  result << "% Ambiente para centralizar vertical\n"
  result << "\\newenvironment{vcenterpage}\n"
  result << "     {\\newpage\\vspace*{\\fill}}\n"
  result << "     {\\vspace*{\\fill}\\par\\pagebreak}\n"
  result << "\n"
  result << "\\sloppy\n"
  result << "\n"
  result << "\\pagestyle{fancy}\n"
  result << "\n"
  result << "\\setcounter{secnumdepth}{4}\n"
  result << "\n"
  result << "\\begin{document}\n"
  result << "\\pagenumbering{Alph}\n"
  result << "\\begin{titlepage}\n"
  result << "\n"
  result << "\\vspace{-5.0cm}\n"
  result << "\n"
  result << "\\begin{figure}[!htb]\n"
  result << " \\centering{\\includegraphics[scale=4.0]{logo2.eps}}\n"
  result << " \\label{fig:UFPE_logo}\n"
  result << "\\end{figure}\n"
  result << "\n"
  result << "\\begin{center}\n"
  result << "\\vspace{1cm}\n"
  result << "%{\\huge \\textsf{Solicita\\c{c}\\~{a}o de Progress\\~{a}o Funcional Docente}} \\\\[1cm]\n"
  result << "\\rule{1.0\\textwidth}{1pt} \\\\ [0.5cm]\n"
  result << "{\\Huge \\textbf{\\textsf{Memorial Descritivo de Atividades}}} \\\\ \n"
  result << "\\rule{1.0\\textwidth}{1pt} \\\\ \n"
  result << "\\vspace{2cm}\n"
  result << "\n"
  result << "\\doublespacing\n"
  result << "{\\Large \\textsf{Solicita\\c{c}\\~{a}o de progress\\~{a}o funcional docente de #{categoriaOrigem} para #{categoriaDestino} apresentada \\`{a} Comiss\\~{a}o de Avalia\\c{c}\\~{a}o de Progress\\~{a}o #{categoriaProgressao} do Centro de Inform\\'{a}tica da Universidade Federal de Pernambuco}}\\\\ \n"
  result << "\\vspace{1.5cm}\n"
  result << "{\\LARGE \\textsf{Solicitante: \\textbf{#{professor}}}}\\\\ \n"
  result << "\\vspace{0.5cm}\n"
  result << "{\\Large \\textsf{SIAPE: \\textbf{#{siape}}}} \\\\ \n"
  result << "\\vspace{0.5cm}\n"
  result << "{\\Large \\textsf{Per\\'{\\i}odo: \\textbf{#{dataInicio} - #{dataFim}}}} \\\\ \n"
  result << " \n"
  result << "\\vspace{2.0cm} \n"
  result << " \n"
  result << "\\normalsize \\textsf{\\today} \n"
  result << " \n"
  result << "\\end{center} \n"
  result << "\\thispagestyle{empty} \n"
  result << "\\end{titlepage} \n"
  result << "\\pagenumbering{arabic} \n"
  result << " \n"
  result << "\\tableofcontents \n"
  result << "%\\include{Lista_Anexos} \\cleartooddpage[\\thispagestyle{empty}] \n"
end

def processa_apresentacao_arquivo_TeX(professor, departamento, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao)
  result = String.new("\n")

  result << "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n"
  result << "% APRESENTACAO \n"
  result << "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n"
  result << " \n"
  result << "\\newpage \n"
  result << "\\section*{Apresenta\\c{c}\\~{a}o} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"
  result << "\\begin{onehalfspace} \n"
  result << " \n"
  result << "Memorial apresentado por \\textbf{#{professor}}, Professor #{categoriaOrigem}, lotado no #{departamento} do Centro de Inform\\'{a}tica (CIn) da Universidade Federal de Pernambuco (UFPE), para avalia\\c{c}\\~{a}o de desempenho acad\\^{e}mico, para fins de acesso por Progress\\~{a}o #{categoriaProgressao} \\`{a} classe de Professor #{categoriaDestino}. \n"
  result << " \n"
  result << "O presente arquivo relata as atividades desempenhadas no per\\'{\i}odo de \\textbf{#{dataInicio} a #{dataFim}} e foi elaborado com base nas diretrizes estabelecidas nas Resolu\\c{c}\\~{o}es 04/2008 e 02/2011 do Conselho Universit\\'{a}rio (CONSUN) da UFPE e na Portaria 554, de 20/06/2013, do Minist\\'{e}rio da Educa\\c{c}\\~{a}o (MEC). Os documentos comprobat\\'{o}rios referenciados neste arquivo est\\~{a}o organizados em volumes anexos devidamente numerados. Por fim, os Anexos que se referem a artigos publicados em confer\\^{e}ncias e peri\\'{o}dicos cont\\'{e}m apenas a primeira p\\'{a}gina do trabalho e o email informando a aceita\\c{c}\\~{a}o do trabalhao para publica\\c{c}\\~{a}o (quando pertinente). \n"
  result << "\\end{onehalfspace} \n"
end

def processa_final_arquivo_TeX
  result = String.new("\n")

  result << "% Appendix \n"
  result << "\\clearpage \n"
  result << "%\\addappheadtotoc \n"
  result << "\\appendix \n"
  result << "%\\appendixpage \n"
  result << "\\newpage \n"
  result << "\\section{Documentos comprobat\\'{o}rios} \n"
  result << "Esta se\\c{c}\\~{a}o cont\\'{e}m os documentos comprobat\\'{o}rios referentes \\`{a}s atividades listadas neste memorial. \n"
  result << "\\addcontentsline{toc}{section}{Documentos comprobat\\'{o}rios} \n"
  result << "\\renewcommand{\\thesubsection}{\\arabic{subsection}} \n"
  result << "% \\renewcommand{\\subsection}{ \n"
  result << "% \\titleformat{\\subsection} \n"
  result << "%   {\\Huge\\bfseries\\center\\vspace{.4\\textwidth}\\thispagestyle{fancy}} % format \n"
  result << "%   {}                % label \n"
  result << "%   {0pt}             % sep \n"
  result << "%   {\\huge}           % before-code \n"
  result << "% } \n"
  result << " \n"
  result << "\\include{appendices} \n"
  result << " \n"
  result << "\\end{document} \n"
  result << " \n"
  result << "%%% EOF \n"
end

def processa_texto_para_TeX(texto)
  map = {'ã' => '\\~{a}', 'õ' => '\\~{o}', 'à' => "\\`{a}", 'ç' => '\\c{c}',
         'á' => "\\'{a}", 'é' => "\\'{e}", 'í' => "\\'{\\i}", 'ó' => "\\'{o}", 'ú' => "\\'{u}",
         'â' => '\\^{a}', 'ê' => '\\^{e}', 'ô' => '\\^{o}',
         '<' => '\\textless', '>' => '\\textgreater', '%' => '\\%', '$' => '\\$', '|' => '\\textbar', '#' => '\\#',
         '&' => '\\&', '~' => '\\textasciitilde{}', "_" => " "
  }
  re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
  result = texto.gsub(re, map)
end

def processa_paginas(pgi, pgf)
  if (pgi != "" and  pgi!= "?") and (pgf != "" and  pgf!= "?") then
    "pgs #{pgi}--#{pgf}, "
  else
    ""
  end
end

def processa_lista_nomes(autores)
  if autores.size == 0 then
    ""
  elsif autores.size == 1 then
    autores[0]
  elsif autores.size == 2 then
    autores[0] << " e " << autores[1]
  else
    autores[0] << ", " << processa_lista_nomes(autores - [autores[0]])
  end
end

def processa_nome_autor(autor)
  match = /(\w+), (\w+)/.match(autor)
  if match then
    match[2].capitalize << " " << match[1].capitalize
    processa_texto_para_TeX(match)
  else
    processa_texto_para_TeX(autor)
  end
end

def processa_nome_autor_citacao(autor)
  match = /(\w+), (\w+)/.match(autor)
  if match then
    match[2].capitalize << " " << match[1].capitalize
  else
    autor
  end
end

def processa_editores(editores)
  match = /(\w+);/.match(editores)
  if match then
    editores << ", editores"
  elsif (editores != "") then
    editores << ", editor"
  else
    ""
  end
end

def processa_co_orientacao(co)
  if (co == "CO_ORIENTADOR") then
    "Co-orienta\\c{c}\\~{a}o."
  else
    "Orienta\\c{c}\\~{a}o."
  end
end

def processa_tipo_orientacao(tipo)
  if ((tipo == "INICIACAO_CIENTIFICA") or (tipo == "Inicia\\c{c}\\~{a}o Cient\\'{\\i}fica"))
    "Inicia\\c{c}\\~{a}o Cient\\'{\\i}fica em "
  elsif ((tipo == "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO") or
      (tipo == "Trabalho de conclus\\~{a}o de curso de Gradua\\c{c}\\~{a}o") or
      (tipo == "Gradua\\c{c}\\~{a}o"))
    "Trabalho de Conclus\\~{a}o de Curso de Gradua\\c{c}\\~{a}o, "
  elsif (tipo == "DOUTORADO")
    "Tese de Doutorado em "
  elsif (tipo == "MESTRADO")
    "Disserta\\c{c}\\~{a} de Mestrado em "
  elsif (tipo == "MONOGRAFIA_DE_CONCLUSAO_DE_CURSO_APERFEICOAMENTO_E_ESPECIALIZACAO")
    "Especializa\\c\\~{a}o em"
  else
    ""
  end
end

def processa_trabalhos_periodicos(artigos)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DO-ARTIGO" =>
                   ["TITULO-DO-ARTIGO", "ANO-DO-ARTIGO"],
               "DETALHAMENTO-DO-ARTIGO" =>
                   ["TITULO-DO-PERIODICO-OU-REVISTA", "VOLUME", "FASCICULO", "PAGINA-INICIAL", "PAGINA-FINAL"],
               "AUTORES" => ["*", "NOME-COMPLETO-DO-AUTOR"]}
  artigos.each{|a|
    map = extrai_elemento(a, estrutura)
    fasc = if (map["FASCICULO"] != "") then "(#{map["FASCICULO"]})" else "" end
    #cv.puts "\\item #{processaListaNomes(map["AUTORES"].collect{|na| processaNomeAutor(na)})}. \\emph\{#{map["TITULO-DO-ARTIGO"]}\}. #{map["TITULO-DO-PERIODICO-OU-REVISTA"]}, volume #{map["VOLUME"]}#{fasc}, #{processaPaginas(map["PAGINA-INICIAL"],map["PAGINA-FINAL"])}#{map["ANO-DO-ARTIGO"]}. \\DOC\{#{referencia}\}"
  }
  result << "\\item #{processa_lista_nomes(map["AUTORES"].collect{|na| processa_nome_autor(na)})}. \\textbf\{#{processa_texto_para_TeX(map["TITULO-DO-ARTIGO"])}\}. #{processa_texto_para_TeX(map["TITULO-DO-PERIODICO-OU-REVISTA"])}, volume #{map["VOLUME"]}#{fasc}, #{processa_paginas(map["PAGINA-INICIAL"], map["PAGINA-FINAL"])}#{map["ANO-DO-ARTIGO"]}. \n"
  result
end

def processa_participacao_em_projetos(comites)
  result = String.new("\n")
  estrutura = {"PROJETO-DE-PESQUISA" =>
                   ["NOME-DO-PROJETO", "ANO-INICIO", "ANO-FIM", "NATUREZA", "SITUACAO"],
               "PROJETO-DE-PESQUISA//FINANCIADORES-DO-PROJETO" =>
                   {"FINANCIADOR-DO-PROJETO" => ["*", "NOME-INSTITUICAO"]}
  }
  comites.each{|a|
    map = extrai_elemento(a, estrutura)
    #cv.puts "\\item \\emph\{#{map["NOME-DO-PROJETO"]}\}, Projeto de #{map["NATUREZA"].capitalize}, de #{map["ANO-INICIO"]} at\'{e} #{map["ANO-FIM"]}, institui\c{c}\~{o}es al\'{e}m da UFPE: #{processaListaNomes(map["FINANCIADOR-DO-PROJETO"])}. \\DOC\{#{referencia}\}"

    result <<  "\\item \\textbf{T\\'{\\i}tulo do projeto:} #{processa_texto_para_TeX(map["NOME-DO-PROJETO"])}\\\\ \n"
    result <<  "    \\textbf{Fun\\c{c}\\~{a}o no projeto:} \\\\ \n"
    result <<  "    \\textbf{N\\'{u}mero do processo:} \\\\ \n"
    result <<  "    \\textbf{Financiador/Edital:} #{processa_texto_para_TeX(processa_lista_nomes(map["FINANCIADOR-DO-PROJETO"]))}\\\\ \n"
    #result <<  "    \\textbf{Institui\c{c}\~{o}es al\'{e}m da UFPE:}  \\\\ \n"
    result <<  "    \\textbf{Per\\'{\\i}odo (in\\'{\\i}cio-fim):} #{map["ANO-INICIO"]} -- #{map["ANO-FIM"]}\\\\ \n"
    result <<  "    \\textbf{Situ\\c{c}\\~{a}o:} #{processa_texto_para_TeX(map["SITUACAO"].capitalize)}\\\\ \n"
    result <<  "    \\textbf{Natureza:} Projeto de #{processa_texto_para_TeX(map["NATUREZA"].capitalize)} \n"
  }
  result
end

def processa_autoria_artigos_em_eventos(artigos)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DO-TRABALHO" =>
                   ["TITULO-DO-TRABALHO", "ANO-DO-TRABALHO", "PAIS-DO-EVENTO"],
               "DETALHAMENTO-DO-TRABALHO" =>
                   ["NOME-DO-EVENTO", "PAGINA-INICIAL", "PAGINA-FINAL"],
               "AUTORES" => ["*", "NOME-COMPLETO-DO-AUTOR"]}
  artigos.each{|a|
    map = extrai_elemento(a, estrutura)
    #cv.puts "\\item #{processaListaNomes(map["AUTORES"].collect{|na| processaNomeAutor(na)})}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}. #{map["NOME-DO-EVENTO"]}, #{processaPaginas(map["PAGINA-INICIAL"],map["PAGINA-FINAL"])}#{map["PAIS-DO-EVENTO"]}, #{map["ANO-DO-TRABALHO"]}. \\DOC\{#{referencia}\}"

    result << "\\item #{processa_lista_nomes(map["AUTORES"].collect{|na| processa_nome_autor_citacao(na)})}. \\textbf\{#{processa_texto_para_TeX(map["TITULO-DO-TRABALHO"])}\}. #{processa_texto_para_TeX(map["NOME-DO-EVENTO"])}, #{processa_paginas(map["PAGINA-INICIAL"], map["PAGINA-FINAL"])} #{processa_texto_para_TeX(map["PAIS-DO-EVENTO"])}, #{map["ANO-DO-TRABALHO"]}. \n"
  }
  result
end

def processa_orientacoes_em_andamento(orientacoes, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo =>
                   ["TITULO-DO-TRABALHO", "ANO", "TIPO", "NATUREZA"],
               "DETALHAMENTO-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo =>
                   ["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO", "TIPO-DE-ORIENTACAO"]}
  orientacoes.each{|a|
    map = extrai_elemento(a, estrutura)
    #cv.puts "\\item #{map["NOME-DO-ORIENTANDO"]}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}. Tese de #{tipo.capitalize} em #{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Aluno:} #{processa_texto_para_TeX(map["NOME-DO-ORIENTANDO"])} \\\\ \n"
    result << "            \\textbf{T\\'{\\i}tulo:} #{processa_texto_para_TeX(map["TITULO-DO-TRABALHO"])}\\\\ \n"
    result << "            \\textbf{Natureza:} #{processa_texto_para_TeX(map["NATUREZA"])} em #{processa_texto_para_TeX(map["NOME-CURSO"])} \\\\ \n"
    if (tipo == "MESTRADO")
      if (map["TIPO"] == "ACADEMICO")
        result << "            \\textbf{Tipo:} Acad\\^{e}mico \\\\ \n"
      else
        result << "            \\textbf{Tipo:} Profissional \\\\ \n"
      end
    end
    result << "            \\textbf{Data de In\\'{\\i}cio:} #{map["ANO"]} \\\\ \n"
    result << "            \\textbf{Supervis\\~{a}o:} #{processa_co_orientacao(map["TIPO-DE-ORIENTACAO"])} \\\\ \n"
    result << "            \\textbf{Institui\\c{c}\\~{a}o:} #{processa_texto_para_TeX(map["NOME-INSTITUICAO"])}\n"
  }

  result
end

def processa_outras_orientacoes_concluidas(orientacoes, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-CONCLUIDAS" =>
                   ["TITULO", "ANO", "TIPO"],
               "DETALHAMENTO-DE-OUTRAS-ORIENTACOES-CONCLUIDAS"  =>
                   ["NOME-DO-ORIENTADO", "NOME-DA-INSTITUICAO", "NOME-DO-CURSO", "NUMERO-DE-PAGINAS", "TIPO-DE-ORIENTACAO-CONCLUIDA", "NOME-DA-AGENCIA"],
               "INFORMACOES-ADICIONAIS" => ["DESCRICAO-INFORMACOES-ADICIONAIS"]}
  orientacoes.each{|a|
    map = extrai_elemento(a, estrutura)
    #cv.puts "\\item #{map["NOME-DO-ORIENTADO"]}. #{map["TITULO"]}.  #{processaTipoOrientacao(tipo)}#{map["NOME-DO-CURSO"]}, #{map["NOME-DA-INSTITUICAO"]}, #{processaPagina(map["NUMERO-DE-PAGINAS"])}#{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO-CONCLUIDA"])}#{processaAgencia(map["NOME-DA-AGENCIA"])} \\DOC\{#{referencia}\}"

    result << "\\item       \\textbf{Aluno:} #{processa_texto_para_TeX(map["NOME-DO-ORIENTADO"])} \\\\ \n"
    result << "            \\textbf{Curso/Institui\\c{c}\\~{a}o:} #{processa_texto_para_TeX(map["NOME-DO-CURSO"])}/#{processa_texto_para_TeX(map["NOME-DA-INSTITUICAO"])} \\\\ \n"
    result << "            \\textbf{T\\'{\\i}tulo:} #{processa_texto_para_TeX(map["TITULO"])} \\\\ \n"
    result << "            \\textbf{Supervis\\˜{a}:} #{processa_co_orientacao(tipo)} \\\\ \n"
    if(map["DESCRICAO-INFORMACOES-ADICIONAIS"] == "")
      result << "            \\textbf{Data da Conclus\\~{a}o:} #{map["ANO"]} \n"
    else
      result << "            \\textbf{Data da Conclus\\~{a}o:} #{map["ANO"]} \\\\ \n"
      result << "            \\textbf{Informa\\c{c}\\~{o}es:} #{processa_texto_para_TeX(map["DESCRICAO-INFORMACOES-ADICIONAIS"])} \n"
    end
  }

  result
end

def processa_outras_orientacoes_em_endamento(orientacoes, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo =>
                   ["TITULO-DO-TRABALHO", "ANO", "NATUREZA"],
               "DETALHAMENTO-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo =>
                   ["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO", "NOME-DA-AGENCIA"],
               "INFORMACOES-ADICIONAIS" => ["DESCRICAO-INFORMACOES-ADICIONAIS"]}
  orientacoes.each{|a|
    map = extrai_elemento(a, estrutura)
    #cv.puts "\\item #{map["NOME-DO-ORIENTANDO"]}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. #{processaAgencia(map["NOME-DA-AGENCIA"])} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Aluno:} #{processa_texto_para_TeX(map["NOME-DO-ORIENTANDO"])} \\\\ \n"
    result << "            \\textbf{Curso/Institui\\c{c}\\~{a}o:} #{processa_texto_para_TeX(map["NOME-CURSO"])}/#{processa_texto_para_TeX(map["NOME-INSTITUICAO"])} \\\\ \n"
    result << "            \\textbf{T\\'{\\i}tulo:} #{processa_texto_para_TeX(map["TITULO-DO-TRABALHO"])} \\\\ \n"
    result << "            \\textbf{Supervis\\˜{a}:} #{processa_co_orientacao(tipo)} \\\\ \n"
    if(map["DESCRICAO-INFORMACOES-ADICIONAIS"] == "")
      result << "            \\textbf{Data da Conclus\\~{a}o:} #{map["ANO"]} \n"
    else
      result << "            \\textbf{Data da Conclus\\~{a}o:} #{map["ANO"]} \\\\ \n"
      result << "            \\textbf{Informa\\c{c}\\~{o}es:} #{processa_texto_para_TeX(map["DESCRICAO-INFORMACOES-ADICIONAIS"])} \n"
    end
  }
  result
end

def processa_orientacoes_concluidas(orientacoes, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo =>
                   ["TITULO", "ANO", "NATUREZA"],
               "DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo =>
                   ["NOME-DO-ORIENTADO", "NOME-DA-INSTITUICAO", "NOME-DO-CURSO", "NUMERO-DE-PAGINAS", "TIPO-DE-ORIENTACAO"]}
  orientacoes.each{|a|
    map = extrai_elemento(a, estrutura)
    #cv.puts "\\item #{map["NOME-DO-ORIENTADO"]}. \\emph\{#{map["TITULO"]}\}. Tese de #{tipo.capitalize} em #{map["NOME-DO-CURSO"]}, #{map["NOME-DA-INSTITUICAO"]}, #{processaPagina(map["NUMERO-DE-PAGINAS"])}#{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Aluno:} #{processa_texto_para_TeX(map["NOME-DO-ORIENTADO"])} \\\\ \n"
    result << "            \\textbf{T\\'{\\i}tulo:} #{processa_texto_para_TeX(map["TITULO"])}\\\\ \n"
    result << "            \\textbf{Natureza:} #{processa_texto_para_TeX(map["NATUREZA"])} em #{processa_texto_para_TeX(map["NOME-DO-CURSO"])} \\\\ \n"
    if (tipo == "MESTRADO")
      if (map["TIPO"] == "ACADEMICO")
        result << "            \\textbf{Tipo:} Acad\\^{e}mico \\\\ \n"
      else
        result << "            \\textbf{Tipo:} Profissional \\\\ \n"
      end
    end
    result << "            \\textbf{Data da Defesa:} #{map["ANO"]} \\\\ \n"
    result << "            \\textbf{Supervis\\~{a}o:} #{processa_co_orientacao(map["TIPO-DE-ORIENTACAO"])} \\\\ \n"
    result << "            \\textbf{Institui\\c{c}\\~{a}o:} #{processa_texto_para_TeX(map["NOME-DA-INSTITUICAO"])}\n"
  }

  result
end

def processa_supervisao_estagio_em_andamento(orientacoes)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-EM-ANDAMENTO" =>
                   ["TITULO-DO-TRABALHO", "ANO", "NATUREZA"],
               "DETALHAMENTO-DE-OUTRAS-ORIENTACOES-EM-ANDAMENTO" =>
                   ["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO"]}
  orientacoes.each{|a|
    map = extrai_elemento(a, estrutura)

    result << "\\item       \\textbf{Aluno:} #{processa_texto_para_TeX(map["NOME-DO-ORIENTANDO"])}\\\\ \n"
    result << "            \\textbf{Curso/Institui\\c{c}\\~{a}o:} #{processa_texto_para_TeX(map["NOME-CURSO"])}/#{processa_texto_para_TeX(map["NOME-INSTITUICAO"])}\\\\ \n"
    #result << "            \\textbf{Instituição:} #{map["NOME-INSTITUICAO"]}\\\\ \n"
    #result << "            \\textbf{Natureza:} #{processaTipoOrientacao(map["NATUREZA"])}\\\\ \n"
    result << "            \\textbf{Empresa:} #{processa_texto_para_TeX(map["TITULO-DO-TRABALHO"])}\\\\ \n"
    result << "            \\textbf{Per\\'{\\i}odo:} #{map["ANO"]} \n"
  }
  result
end

def processa_participacao_em_bancas(bancas, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo =>
                   ["TITULO", "ANO", "NATUREZA", "TIPO"],
               "DETALHAMENTO-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo =>
                   ["NOME-DO-CANDIDATO", "NOME-INSTITUICAO", "NOME-CURSO"],
               "PARTICIPANTE-BANCA" => ["*", "NOME-COMPLETO-DO-PARTICIPANTE-DA-BANCA"]}
  bancas.each{|a|
    map = extrai_elemento(a, estrutura)

    #cv.puts "\\item #{map["NOME-DO-CANDIDATO"]}. \\emph\{#{map["TITULO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. Examinadores: #{processaListaNomes(map["PARTICIPANTE-BANCA"].collect{|na| processaNomeAutor(na)})} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Candidato:} #{processa_texto_para_TeX(map["NOME-DO-CANDIDATO"])}  \\\\ \n"
    result << "            \\textbf{T\\'{\i}tulo da Tese:} #{processa_texto_para_TeX(map["TITULO"])}\\\\ \n"
    result << "            \\textbf{Natureza:} #{processa_tipo_orientacao(tipo)} #{processa_texto_para_TeX(map["NOME-CURSO"])} \\\\ \n"
    if (tipo == "MESTRADO")
      if (map["TIPO"] == "ACADEMICO")
        result << "            \\textbf{Tipo:} Acad\\^{e}mico \\\\ \n"
      elsif (map["TIPO"] == "NAO_INFORMADO")
        result << "            \\textbf{Tipo:} Profissional \\\\ \n"
      end
    end
    if (tipo =="GRADUACAO")
      result << "            \\textbf{Programa:} Gradua\\c{c}\\~{a}o em #{processa_texto_para_TeX(map["NOME-CURSO"])}\\\\ \n"
    else
      result << "            \\textbf{Programa:} P\\'{o}s-Gradua\\c{c}\\~{a}o em #{processa_texto_para_TeX(map["NOME-CURSO"])}\\\\ \n"
    end
    result << "            \\textbf{Universidade:} #{processa_texto_para_TeX(map["NOME-INSTITUICAO"])}\\\\ \n"
    result << "            \\textbf{Examinadores}: #{processa_lista_nomes(map["PARTICIPANTE-BANCA"].collect{|na| processa_nome_autor(na)})} \\\\ \n"
    result << "            \\textbf{Data:} #{map["ANO"]} \n"
  }
  result
end

def processa_participacao_em_bancas_julgadoras(bancas, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DA-BANCA-JULGADORA-PARA-" << tipo =>
                   ["TITULO", "ANO", "NATUREZA"],
               "DETALHAMENTO-DA-BANCA-JULGADORA-PARA-" << tipo =>
                   ["NOME-INSTITUICAO"],
               "PARTICIPANTE-BANCA" => ["*", "NOME-COMPLETO-DO-PARTICIPANTE-DA-BANCA"]}
  bancas.each{|a|
    map = extrai_elemento(a, estrutura)

    #cv.puts "\\item #{map["NOME-DO-CANDIDATO"]}. \\emph\{#{map["TITULO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. Examinadores: #{processaListaNomes(map["PARTICIPANTE-BANCA"].collect{|na| processaNomeAutor(na)})} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Natureza:} #{processa_texto_para_TeX(map["NATUREZA"])}  \\\\ \n"
    result << "            \\textbf{Descri\\c{c}\\~{a}o:} #{processa_texto_para_TeX(map["TITULO"])}\\\\ \n"
    #result << "            \\textbf{Natureza:} #{processa_tipo_orientacao(tipo)} #{processa_texto_para_TeX(map["NOME-CURSO"])} \\\\ \n"

    result << "            \\textbf{Universidade:} #{processa_texto_para_TeX(map["NOME-INSTITUICAO"])}\\\\ \n"
    result << "            \\textbf{Examinadores}: #{processa_lista_nomes(map["PARTICIPANTE-BANCA"].collect{|na| processa_nome_autor(na)})} \\\\ \n"
    result << "            \\textbf{Data:} #{map["ANO"]} \n"
  }
  result
end

def seleciona_elementos_por_ano(vitae, anos, elemento, subelemento, attributoAno)
  seleciona_elementos_por_ano_e_condicao(vitae, anos, elemento, subelemento, attributoAno){|db| true}
end

def seleciona_elementos_por_ano_e_condicao(vitae, anos, elemento, subelemento, attributoAno) #condicao
  seleciona_elementos_por_condicao(vitae, elemento, subelemento) {|db| anos.include?(db.attributes[attributoAno]) and yield(db)}
end

def seleciona_elementos_por_condicao(vitae, elemento, subelemento) #condicao
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

def seleciona_trabalhos_em_periodicos(documento, anos)
  seleciona_elementos_por_ano(documento, anos, "//ARTIGO-PUBLICADO",
                              "DADOS-BASICOS-DO-ARTIGO", "ANO-DO-ARTIGO")
end

def seleciona_participacao_em_projetos(documento, anos)
  seleciona_elementos_por_condicao(documento, "//PARTICIPACAO-EM-PROJETO", "PROJETO-DE-PESQUISA") {|db| anos.include?(db.attributes["ANO-INICIO"]) or anos.include?(db.attributes["ANO-FIM"])}
end

def seleciona_artigos_publicados_em_eventos(documento, anos, natureza)
  seleciona_elementos_por_ano_e_condicao(documento, anos, "//TRABALHO-EM-EVENTOS", "DADOS-BASICOS-DO-TRABALHO", "ANO-DO-TRABALHO") {|db|
    #db.attributes["PAIS-DO-EVENTO"] == "Brasil" and
        db.attributes["NATUREZA"] == natureza}
end

def seleciona_participacao_em_bancas(documento, anos, tipo)
  seleciona_elementos_por_ano(documento, anos, "//PARTICIPACAO-EM-BANCA-DE-" << tipo, "DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo, "ANO")
end

def seleciona_participacao_em_bancas_julgadoras(documento, anos, tipo)
  seleciona_elementos_por_ano(documento, anos, "//BANCA-JULGADORA-PARA-CONCURSO-PUBLICO", "DADOS-BASICOS-DA-BANCA-JULGADORA-PARA-" << tipo, "ANO")
end

def seleciona_outras_orientacoes_em_andamento(vitae, tipo)
  seleciona_elementos_por_condicao(vitae, "////ORIENTACAO-EM-ANDAMENTO-DE-", "DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-") {|db|   true}
end

def seleciona_orientacoes_em_andamento(vitae, tipo)
  seleciona_elementos_por_condicao(vitae, "//ORIENTACAO-EM-ANDAMENTO-DE-" << tipo,
                                   "DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo){|db| true}
end

def seleciona_outras_orientacoes_concluidas(vitae, anos, tipo)
  seleciona_elementos_por_ano_e_condicao(vitae, anos, "//OUTRAS-ORIENTACOES-CONCLUIDAS", "DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-CONCLUIDAS", "ANO"){|db| db.attributes["NATUREZA"] == tipo}
end

def seleciona_orientacoes_concluidas(vitae, anos, tipo)
  seleciona_elementos_por_ano(vitae, anos, "//ORIENTACOES-CONCLUIDAS-PARA-" << tipo,
                              "DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo, "ANO")
end

def seleciona_supervisao_estagio_em_andamento(documento)
  seleciona_elementos_por_condicao(documento, "//OUTRAS-ORIENTACOES-EM-ANDAMENTO", "DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-EM-ANDAMENTO") {|db|   true}
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Supervisao de estagios curriculares e extracurriculares Concluido
def supervisao_estagio_concluido(documento, anos)
  result = String.new("\n")

  result << "\\subsection{Supervis\\~{a}o de est\\'{a}gios curriculares e extracurriculares Conclu\\'{i}das}\n"
  result << "\\vspace{0.3cm}\n"
  result << "\n"

  orientacoes = selecionaSupervisaoEstagioConcluido(documento, anos)
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaSupervisaoEstagioConcluido(orientacoes)
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Supervisao de estagios curriculares e extracurriculares em Andamento
def supervisao_estagio_em_andamento(documento)
  result = String.new("\n")

  result << "\\subsection{Supervis\\~{a}o de est\\'{a}gios curriculares e extracurriculares em Andamento}\n"
  result << "\\vspace{0.3cm}\n"
  result << "\n"

  orientacoes = seleciona_supervisao_estagio_em_andamento(documento)
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_supervisao_estagio_em_andamento(orientacoes)
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Teses de Doutorado Concluidas
def orientacao_doutorado_concluida(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o e Co-Orienta\\c{c}\\~{a}o de Teses de Doutorado Conclu\\'{i}das} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_orientacoes_concluidas(documento, anos, "DOUTORADO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_orientacoes_concluidas(orientacoes, "DOUTORADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Teses de Doutorado em Andamento
def orientacao_doutorado_em_andamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o e Co-Orienta\\c{c}\\~{a}o de Teses de Doutorado em Andamento} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_orientacoes_em_andamento(documento, "DOUTORADO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_orientacoes_em_andamento(orientacoes, "DOUTORADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Disertacoes de Mestrado Concluidas
def orientacao_mestrado_concluida(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o e Co-Orienta\\c{c}\\~{a}o de Disserta\\c{c}\\~{o}es de Mestrado Conclu\\'{i}das} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_orientacoes_concluidas(documento, anos, "MESTRADO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_orientacoes_concluidas(orientacoes, "MESTRADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Disertacoes de Mestrado Em Andamento
def orientacao_mestrado_em_andamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o e Co-Orienta\\c{c}\\~{a}o de Disserta\\c{c}\\~{o}es de Mestrado Em Andamento} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_orientacoes_em_andamento(documento, "MESTRADO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_orientacoes_em_andamento(orientacoes, "MESTRADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Trabalhos de Conclusao de Curso Concluidas
def orientacao_trabalho_conclusao_curso_concluida(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Monografias de Trabalhos de Conclus\\~{a}o de Curso Conclu\\'{\\i}das'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_outras_orientacoes_concluidas(documento, anos, "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_outras_orientacoes_concluidas(orientacoes, "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Trabalhos de Conclusao de Curso Em Andamento
def orientacao_trabalho_conclusao_curso_em_andamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Monografias de Trabalhos de Conclus\\~{a}o de Curso Em Andamento'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_orientacoes_em_andamento(documento, "GRADUACAO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_outras_orientacoes_em_endamento(orientacoes, "GRADUACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

#TODO
# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Monitorias
def orientacao_monitoria_concluida(arquivo)
  result = String.new("\n")

  result << include_file("#{arquivo}")
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Iniciacao Cientifica Concluida
def orientacao_iniciacao_cientifica_concluida(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Inicia\\c{c}\\~{a}o Cient\\'{\\i}fica Conclu\\'{\\i}das'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_outras_orientacoes_concluidas(documento, anos, "INICIACAO_CIENTIFICA")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_outras_orientacoes_concluidas(orientacoes, "INICIACAO_CIENTIFICA")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Iniciacao Cientifica Em Andamento
def orientacao_iniciacao_cientifica_em_andamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Inicia\\c{c}\\~{a}o Cient\\'{\\i}fica em Andamento'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_outras_orientacoes_em_andamento(documento, "INICIACAO_CIENTIFICA")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_outras_orientacoes_em_endamento(orientacoes, "INICIACAO_CIENTIFICA")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Trabalho de Apoio Academico Concluido
def orientacao_trabalho_apoio_academico_concluido(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Apoio Acad\\^{e}mico Conclu\'{\\i}das'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_outras_orientacoes_concluidas(documento, anos, "ORIENTACAO-DE-OUTRA-NATUREZA")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_outras_orientacoes_concluidas(orientacoes, "ORIENTACAO-DE-OUTRA-NATUREZA")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Trabalho de Apoio Academico em Andamento
def orientacao_trabalho_apoio_academico_em_andamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Apoio Acad\\^{e}mico em Andamento'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = seleciona_outras_orientacoes_em_andamento(documento, "ORIENTACAO-DE-OUTRA-NATUREZA")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_outras_orientacoes_em_endamento(orientacoes, "ORIENTACAO-DE-OUTRA-NATUREZA")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas Examinadoras de Concurso
def participacao_em_bancas_examinadoras_de_concurso(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas Examinadoras de Concurso'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = seleciona_participacao_em_bancas_julgadoras(documento, anos, "CONCURSO-PUBLICO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    result << "\n"
    result << processa_participacao_em_bancas_julgadoras(bancas,"CONCURSO-PUBLICO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas Congressos de Iniciacao Cientifica ou de Extensao
def participacao_em_bancas_congressos_iniciacao_ou_extensao(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas Congressos de Inicia\\c{c}\\~{a}o Cient\\'{i}fica ou de Extens\\~{a}o'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  #bancas = selecionaBancas(documento, anos, "GRADUACAO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    #result << processaBancas(bancas,"GRADUACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas de Trabalho de Conclusao de Curso
def participacao_em_bancas_trabalho_de_conclusao_de_curso(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas de Disserta\\c{c}\\~{a}o de Mestrado'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = seleciona_participacao_em_bancas(documento, anos, "GRADUACAO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_participacao_em_bancas(bancas, "GRADUACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas de Dissertacao de Mestrado
def participacao_em_bancas_dissertacao_de_mestrado(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas de Disserta\\c{c}\\~{a}o de Mestrado'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = seleciona_participacao_em_bancas(documento, anos, "MESTRADO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_participacao_em_bancas(bancas, "MESTRADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas de Qualificacao/Defesa de Proposta de Tese de Doutorado
def participacao_em_bancas_qualificacao_de_doutorado(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas de Qualifica\\c{c}\\~ao / Proposta de Tese de Doutorado'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = seleciona_participacao_em_bancas(documento, anos, "EXAME-QUALIFICACAO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_participacao_em_bancas(bancas, "EXAME-QUALIFICACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas de Tese de Doutorado
def participacao_em_bancas_tese_de_doutorado(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas de Tese de Doutorado'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = seleciona_participacao_em_bancas(documento, anos, "DOUTORADO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_participacao_em_bancas(bancas, "DOUTORADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.4 - Avaliacao Didatica Docente pelo Discente
# Avaliacao Didatica Docente pelo Discente
def atividades_de_ensino_graduacao_e_pos_graduacao(arquivo)
  result = String.new("\n")

  result << include_file("#{arquivo}")
end

def avaliacao_docente_pelo_discente(arquivo)
result = String.new("\n")

result << include_file("#{arquivo}")
end

# TODO
# Subgrupo 2.1 - Produtividade de Pesquisa
# Bolsista de produtividade em pesquisa e em inovacao tecnologica
def bolsista_produtividade(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bolsista de produtividade em pesquisa e em inova\\c{c}\\~{a}o tecnol\\'{o}gica'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bolsaPQDT = [] #selecionaBolsistaProdutividade(documento, anos, "DOUTORADO")

  if (bolsaPQDT != []) then
    # result << "\\begin{enumerate}\n"
    # result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaBolsaProdutividade(bolsaPQDT)
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# TODO
# Subgrupo 2.1 - Produtividade de Pesquisa
# Participacao em Eventos Cientificos (com apresentacao de trabalho ou oferecimento de cursos, palestras ou debates
def participacao_em_eventos_cientificos(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Participa\\c{c}\\~{a}o em Eventos Cient\\'{\\i}ficos (com apresenta\\c{c}\\~{a}o de trabalho ou oferecimento de cursos, palestras ou debates)} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  eventos = [] #selecionaParticipacaoEmEventosCientificos(documento, anos, "DOUTORADO")

  if (eventos != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaParticipacaoEmEventosCientificos(eventos)
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 2.1 - Produtividade de Pesquisa
# Autoria de artigos completos publicados em anais de congresso, em jornais e revistas de circulacao nacional e
# internacional na sua area
def autoria_artigos_completos(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Autoria de artigos completos publicados em anais de congresso, em jornais e revistas de " +
            "circula\\c{c}\\~{a}o nacional e internacional na sua \\'{a}rea} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  artigosEventos = seleciona_artigos_publicados_em_eventos(documento, anos, "COMPLETO")

  if (artigosEventos != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_autoria_artigos_em_eventos(artigosEventos)
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 2.1 - Produtividade de Pesquisa
# Coordenacao e/ou Participacao em Projetos Aprovados por Orgaos de Fomento
def participacao_em_projetos_aprovados(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Coordena\\c{c}\\~{a}o e/ou Participa\\c{c}\\~{a}o em Projetos Aprovados por " +
            "\\'{O}rg\\~{a}os de Fomento} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  projetos = seleciona_participacao_em_projetos(documento, anos)

  if (projetos != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_participacao_em_projetos(projetos)
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

#TODO
# Subgrupo 2.1 - Produtividade de Pesquisa
# Consultoria as Instituicoes de Fomento a Pesquisa, Ensino e Extensao
def consultoria_a_instituicoes_de_fomento(documento, anos)

end

#TODO
# Subgrupo 2.1 - Produtividade de Pesquisa
# Premios Recebidos pela Producao Cientifica e Tecnica
def premios_recebidos(documento, anos)

end

# Subgrupo 2.2 - Producao Cientifica
# Trabalhos Publicados em Periodicos Especializados do Pais ou do Exterior
def autoria_de_trabalhos_em_periodicos(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Trabalhos Publicados em Peri\\'{o}dicos Especializados do Pa\\'{\\i}s ou do Exterior} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  trabalhos = seleciona_trabalhos_em_periodicos(documento, anos)

  if (trabalhos != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processa_trabalhos_periodicos(trabalhos)
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end



# --------------------------------------------------------- #


#doc = Nokogiri::XML(File.open("vitaeCNPq.xml"))
#doc = Nokogiri::XML(File.read("vitaeCNPq.xml"))
#doc.encoding = "utf-8"
doc = REXML::Document.new(File.open("vitaeCNPq.xml"))

#anos = ["2014", "2015", "2016"]
anos = ["2010", "2011", "2012"]

siape = "1807586"
departamento = "Departamento de Informa\\c{c}\\~{a}o e Sistemas"
data_inicio = "20 de Agosto de 2014"
data_fim = "19 de Agosto de 2016"
categoria_origem = "Adjunto N\'{i}vel 3"
categoria_destino = "Adjunto N\'{i}vel 4"
categoria_progressao = "Horizontal"

#puts arquivoTeXHeader(doc.elements[0].elements[0].attr("NOME-COMPLETO").to_s, siape, anos, data_inicio, data_fim,
#      categoria_origem, categoria_destino, categoria_progressao)

#puts arquivoTeXPresentation(doc.elements[0].elements[0].attr("NOME-COMPLETO").to_s, departamento, data_inicio, data_fim,
#      categoria_origem, categoria_destino, categoria_progressao)

###############################################################################
#                       Grupo 1 - Atividades de Ensino                        #
###############################################################################

###############################################################################
#                 Subgrupo 1.1 - Orientacoes e Co-Orientacoes                 #
###############################################################################

# TODO
# puts supervisao_estagio_concluido(doc, anos)

# puts supervisao_estagio_em_andamento(doc)

# puts orientacao_doutorado_concluida(doc, anos)

# puts orientacao_doutorado_em_andamento(doc)

# puts orientacao_mestrado_concluida(doc, anos)

# puts orientacao_mestrado_em_andamento(doc)

# puts orientacao_trabalho_conclusao_curso_concluida(doc, anos)

# puts orientacao_trabalho_conclusao_curso_em_andamento(doc)

# puts orientacao_monitoria_concluida("monitoria.tex")

# puts orientacao_iniciacao_cientifica_concluida(doc, anos)

# puts orientacao_iniciacao_cientifica_em_andamento(doc)

# puts orientacao_trabalho_apoio_academico_concluido(doc, anos)

# puts orientacao_trabalho_apoio_academico_em_andamento(doc)

###############################################################################
#            Subgrupo 1.2 - Participacao em Comissoes Examinadoras            #
###############################################################################

#puts participacao_em_bancas_examinadoras_de_concurso(doc, anos)

# TODO
# puts participacao_em_bancas_congressos_iniciacao_ou_extensao(doc, anos)

# puts participacao_em_bancas_trabalho_de_conclusao_de_curso(doc, anos)

# puts participacao_em_bancas_dissertacao_de_mestrado(doc, anos)

# puts participacao_em_bancas_qualificacao_de_doutorado(doc, anos)

# puts participacao_em_bancas_tese_de_doutorado(doc, anos)

# TODO
# puts participacao_em_bancas_selecao_pos_graduacao(doc, anos)

###############################################################################
#     Subgrupo 1.3 - Atividades de Ensino na Graduacao e na Pos-Graduacao     #
###############################################################################

# puts atividades_de_ensino_graduacao_e_pos_graduacao("disciplinas.tex")

###############################################################################
#           Subgrupo 1.4 - Avaliacao Didatica Docente pelo Discente           #
###############################################################################

# puts avaliacao_docente_pelo_discente("avaliacaodocente.tex")

###############################################################################
# Grupo 2: Atividades de Producao Cientifica e Tecnica, Artistica e Cultural  #
###############################################################################

###############################################################################
#                  Subgrupo 2.1 - Produtividade de Pesquisa                   #
###############################################################################

# TODO
# puts bolsista_produtividade(doc, anos)

# TODO
# puts participacao_em_eventos_cientificos(doc, anos)

# TODO
# puts autoria_artigos_completos(doc, anos)

#TODO
#puts participacao_em_projetos_aprovados(doc, anos)



###############################################################################
#                     Subgrupo 2.2 - Producao Cientifica                      #
###############################################################################



###############################################################################
#                       Grupo 3 - Atividades de Extensao                      #
###############################################################################

###############################################################################
#                   Subgrupo 3.1 - Coordenacao e Orientacao                   #
###############################################################################

###############################################################################
#            Subgrupo 3.2 - Coordenacao de Eventos e Conferencista            #
###############################################################################

###############################################################################
#          Grupo 4 - Atividades de Formacao e Capacitacao Academica           #
###############################################################################

###############################################################################
#                     Grupo 5 - Atividades Administrativas                    #
###############################################################################


# puts processa_final_arquivo_TeX