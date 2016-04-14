# encoding: UTF-8
require 'jcode' if RUBY_VERSION < '1.9'
require 'rexml/document'
#require 'nokogiri'

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

def arquivoTeXHeader(professor, siape, anos, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao)

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

def arquivoTeXPresentation(professor, departamento, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao)
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

def arquivoTeXFooter
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

def processaTextoParaTeX(texto)
  map = {'ã' => '\\~{a}', 'õ' => '\\~{o}', 'à' => "\\`{a}", 'ç' => '\\c{c}',
         'á' => "\\'{a}", 'é' => "\\'{e}", 'í' => "\\'{\\i}", 'ó' => "\\'{o}", 'ú' => "\\'{u}",
         'â' => '\\^{a}', 'ê' => '\\^{e}', 'ô' => '\\^{o}',
         '<' => '\\textless', '>' => '\\textgreater', '%' => '\\%', '$' => '\\$', '|' => '\\textbar', '#' => '\\#',
         '&' => '\\&', '~' => '\\textasciitilde{}'
  }
  re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
  result = texto.gsub(re, map)
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
    processaTextoParaTeX(match)
  else
    processaTextoParaTeX(autor)
  end
end

def processaCoOrientacao(co)
  if (co == "CO_ORIENTADOR") then
    "Co-orienta\\c{c}\\~{a}o."
  else
    "Orienta\\c{c}\\~{a}o."
  end
end

def processaTipoOrientacao(tipo)
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

def processaOrientacoesEmAndamento(orientacoes, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo =>
                   ["TITULO-DO-TRABALHO", "ANO", "TIPO", "NATUREZA"],
               "DETALHAMENTO-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo =>
                   ["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO", "TIPO-DE-ORIENTACAO"]}
  orientacoes.each{|a|
    map = extraiElemento(a,estrutura)
    #cv.puts "\\item #{map["NOME-DO-ORIENTANDO"]}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}. Tese de #{tipo.capitalize} em #{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Aluno:} #{processaTextoParaTeX(map["NOME-DO-ORIENTANDO"])} \\\\ \n"
    result << "            \\textbf{T\\'{\\i}tulo:} #{processaTextoParaTeX(map["TITULO-DO-TRABALHO"])}\\\\ \n"
    result << "            \\textbf{Natureza:} #{processaTextoParaTeX(map["NATUREZA"])} em #{processaTextoParaTeX(map["NOME-CURSO"])} \\\\ \n"
    if (tipo == "MESTRADO")
      if (map["TIPO"] == "ACADEMICO")
        result << "            \\textbf{Tipo:} Acad\\^{e}mico \\\\ \n"
      else
        result << "            \\textbf{Tipo:} Profissional \\\\ \n"
      end
    end
    result << "            \\textbf{Data de In\\'{\\i}cio:} #{map["ANO"]} \\\\ \n"
    result << "            \\textbf{Supervis\\~{a}o:} #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\\\ \n"
    result << "            \\textbf{Institui\\c{c}\\~{a}o:} #{processaTextoParaTeX(map["NOME-INSTITUICAO"])}\n"
  }

  result
end

def processaOutrasOrientacoesConcluidas(orientacoes, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-CONCLUIDAS" =>
                   ["TITULO", "ANO", "TIPO"],
               "DETALHAMENTO-DE-OUTRAS-ORIENTACOES-CONCLUIDAS"  =>
                   ["NOME-DO-ORIENTADO", "NOME-DA-INSTITUICAO", "NOME-DO-CURSO", "NUMERO-DE-PAGINAS", "TIPO-DE-ORIENTACAO-CONCLUIDA", "NOME-DA-AGENCIA"],
               "INFORMACOES-ADICIONAIS" => ["DESCRICAO-INFORMACOES-ADICIONAIS"]}
  orientacoes.each{|a|
    map = extraiElemento(a,estrutura)
    #cv.puts "\\item #{map["NOME-DO-ORIENTADO"]}. #{map["TITULO"]}.  #{processaTipoOrientacao(tipo)}#{map["NOME-DO-CURSO"]}, #{map["NOME-DA-INSTITUICAO"]}, #{processaPagina(map["NUMERO-DE-PAGINAS"])}#{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO-CONCLUIDA"])}#{processaAgencia(map["NOME-DA-AGENCIA"])} \\DOC\{#{referencia}\}"

    result << "\\item       \\textbf{Aluno:} #{processaTextoParaTeX(map["NOME-DO-ORIENTADO"])} \\\\ \n"
    result << "            \\textbf{Curso/Institui\\c{c}\\~{a}o:} #{processaTextoParaTeX(map["NOME-DO-CURSO"])}/#{processaTextoParaTeX(map["NOME-DA-INSTITUICAO"])} \\\\ \n"
    result << "            \\textbf{T\\'{\\i}tulo:} #{processaTextoParaTeX(map["TITULO"])} \\\\ \n"
    result << "            \\textbf{Supervis\\˜{a}:} #{processaCoOrientacao(tipo)} \\\\ \n"
    if(map["DESCRICAO-INFORMACOES-ADICIONAIS"] == "")
      result << "            \\textbf{Data da Conclus\\~{a}o:} #{map["ANO"]} \n"
    else
      result << "            \\textbf{Data da Conclus\\~{a}o:} #{map["ANO"]} \\\\ \n"
      result << "            \\textbf{Informa\\c{c}\\~{o}es:} #{processaTextoParaTeX(map["DESCRICAO-INFORMACOES-ADICIONAIS"])} \n"
    end
  }

  result
end

def processaOutrasOrientacoesEmAndamento(orientacoes, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo =>
                   ["TITULO-DO-TRABALHO", "ANO", "NATUREZA"],
               "DETALHAMENTO-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo =>
                   ["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO", "NOME-DA-AGENCIA"],
               "INFORMACOES-ADICIONAIS" => ["DESCRICAO-INFORMACOES-ADICIONAIS"]}
  orientacoes.each{|a|
    map = extraiElemento(a,estrutura)
    #cv.puts "\\item #{map["NOME-DO-ORIENTANDO"]}. \\emph\{#{map["TITULO-DO-TRABALHO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. #{processaAgencia(map["NOME-DA-AGENCIA"])} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Aluno:} #{processaTextoParaTeX(map["NOME-DO-ORIENTANDO"])} \\\\ \n"
    result << "            \\textbf{Curso/Institui\\c{c}\\~{a}o:} #{processaTextoParaTeX(map["NOME-CURSO"])}/#{processaTextoParaTeX(map["NOME-INSTITUICAO"])} \\\\ \n"
    result << "            \\textbf{T\\'{\\i}tulo:} #{processaTextoParaTeX(map["TITULO-DO-TRABALHO"])} \\\\ \n"
    result << "            \\textbf{Supervis\\˜{a}:} #{processaCoOrientacao(tipo)} \\\\ \n"
    if(map["DESCRICAO-INFORMACOES-ADICIONAIS"] == "")
      result << "            \\textbf{Data da Conclus\\~{a}o:} #{map["ANO"]} \n"
    else
      result << "            \\textbf{Data da Conclus\\~{a}o:} #{map["ANO"]} \\\\ \n"
      result << "            \\textbf{Informa\\c{c}\\~{o}es:} #{processaTextoParaTeX(map["DESCRICAO-INFORMACOES-ADICIONAIS"])} \n"
    end
  }
  result
end

def processaOrientacoesConcluidas(orientacoes, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo =>
                   ["TITULO", "ANO", "NATUREZA"],
               "DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo =>
                   ["NOME-DO-ORIENTADO", "NOME-DA-INSTITUICAO", "NOME-DO-CURSO", "NUMERO-DE-PAGINAS", "TIPO-DE-ORIENTACAO"]}
  orientacoes.each{|a|
    map = extraiElemento(a,estrutura)
    #cv.puts "\\item #{map["NOME-DO-ORIENTADO"]}. \\emph\{#{map["TITULO"]}\}. Tese de #{tipo.capitalize} em #{map["NOME-DO-CURSO"]}, #{map["NOME-DA-INSTITUICAO"]}, #{processaPagina(map["NUMERO-DE-PAGINAS"])}#{map["ANO"]}. #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Aluno:} #{processaTextoParaTeX(map["NOME-DO-ORIENTADO"])} \\\\ \n"
    result << "            \\textbf{T\\'{\\i}tulo:} #{processaTextoParaTeX(map["TITULO"])}\\\\ \n"
    result << "            \\textbf{Natureza:} #{processaTextoParaTeX(map["NATUREZA"])} em #{processaTextoParaTeX(map["NOME-DO-CURSO"])} \\\\ \n"
    if (tipo == "MESTRADO")
      if (map["TIPO"] == "ACADEMICO")
        result << "            \\textbf{Tipo:} Acad\\^{e}mico \\\\ \n"
      else
        result << "            \\textbf{Tipo:} Profissional \\\\ \n"
      end
    end
    result << "            \\textbf{Data da Defesa:} #{map["ANO"]} \\\\ \n"
    result << "            \\textbf{Supervis\\~{a}o:} #{processaCoOrientacao(map["TIPO-DE-ORIENTACAO"])} \\\\ \n"
    result << "            \\textbf{Institui\\c{c}\\~{a}o:} #{processaTextoParaTeX(map["NOME-DA-INSTITUICAO"])}\n"
  }

  result
end

def processaSupervisaoEstagioEmAndamento(orientacoes)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-EM-ANDAMENTO" =>
                   ["TITULO-DO-TRABALHO", "ANO", "NATUREZA"],
               "DETALHAMENTO-DE-OUTRAS-ORIENTACOES-EM-ANDAMENTO" =>
                   ["NOME-DO-ORIENTANDO", "NOME-INSTITUICAO", "NOME-CURSO"]}
  orientacoes.each{|a|
    map = extraiElemento(a,estrutura)

    result << "\\item       \\textbf{Aluno:} #{processaTextoParaTeX(map["NOME-DO-ORIENTANDO"])}\\\\ \n"
    result << "            \\textbf{Curso/Institui\\c{c}\\~{a}o:} #{processaTextoParaTeX(map["NOME-CURSO"])}/#{processaTextoParaTeX(map["NOME-INSTITUICAO"])}\\\\ \n"
    #result << "            \\textbf{Instituição:} #{map["NOME-INSTITUICAO"]}\\\\ \n"
    #result << "            \\textbf{Natureza:} #{processaTipoOrientacao(map["NATUREZA"])}\\\\ \n"
    result << "            \\textbf{Empresa:} #{processaTextoParaTeX(map["TITULO-DO-TRABALHO"])}\\\\ \n"
    result << "            \\textbf{Per\\'{\\i}odo:} #{map["ANO"]} \n"
  }
  result
end

def processaBancas(bancas, tipo)
  result = String.new("\n")
  estrutura = {"DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo =>
                   ["TITULO", "ANO", "NATUREZA", "TIPO"],
               "DETALHAMENTO-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo =>
                   ["NOME-DO-CANDIDATO", "NOME-INSTITUICAO", "NOME-CURSO"],
               "PARTICIPANTE-BANCA" => ["*", "NOME-COMPLETO-DO-PARTICIPANTE-DA-BANCA"]}
  bancas.each{|a|
    map = extraiElemento(a,estrutura)

    #cv.puts "\\item #{map["NOME-DO-CANDIDATO"]}. \\emph\{#{map["TITULO"]}\}.  #{processaTipoOrientacao(map["NATUREZA"])}#{map["NOME-CURSO"]}, #{map["NOME-INSTITUICAO"]}, #{map["ANO"]}. Examinadores: #{processaListaNomes(map["PARTICIPANTE-BANCA"].collect{|na| processaNomeAutor(na)})} \\DOC\{#{referencia}\}"
    result << "\\item       \\textbf{Candidato:} #{processaTextoParaTeX(map["NOME-DO-CANDIDATO"])}  \\\\ \n"
    result << "            \\textbf{T\\'{\i}tulo da Tese:} #{processaTextoParaTeX(map["TITULO"])}\\\\ \n"
    result << "            \\textbf{Natureza:} #{processaTipoOrientacao(tipo)} #{processaTextoParaTeX(map["NOME-CURSO"])} \\\\ \n"
    if (tipo == "MESTRADO")
      if (map["TIPO"] == "ACADEMICO")
        result << "            \\textbf{Tipo:} Acad\\^{e}mico \\\\ \n"
      elsif (map["TIPO"] == "NAO_INFORMADO")
        result << "            \\textbf{Tipo:} Profissional \\\\ \n"
      end
    end
    if (tipo =="GRADUACAO")
      result << "            \\textbf{Programa:} Gradua\\c{c}\\~{a}o em #{processaTextoParaTeX(map["NOME-CURSO"])}\\\\ \n"
    else
      result << "            \\textbf{Programa:} P\\'{o}s-Gradua\\c{c}\\~{a}o em #{processaTextoParaTeX(map["NOME-CURSO"])}\\\\ \n"
    end
    result << "            \\textbf{Universidade:} #{processaTextoParaTeX(map["NOME-INSTITUICAO"])}\\\\ \n"
    result << "            \\textbf{Examinadores}: #{processaListaNomes(map["PARTICIPANTE-BANCA"].collect{|na| processaNomeAutor(na)})} \\\\ \n"
    result << "            \\textbf{Data:} #{map["ANO"]} \n"
  }
  result
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

def selecionaBancas(documento, anos, tipo)
  selecionaElementosPorAno(documento,anos,"//PARTICIPACAO-EM-BANCA-DE-" << tipo,"DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-" << tipo,"ANO")
end

def selecionaOutrasOrientacoesEmAndamento(vitae, tipo)
  selecionaElementosPorCondicao(vitae,"////ORIENTACAO-EM-ANDAMENTO-DE-", "DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-") {|db|   true}
end

def selecionaOrientacoesEmAndamento(vitae, tipo)
  selecionaElementosPorCondicao(vitae,"//ORIENTACAO-EM-ANDAMENTO-DE-" << tipo,
                                "DADOS-BASICOS-DA-ORIENTACAO-EM-ANDAMENTO-DE-" << tipo){|db| true}
end

def selecionaOutrasOrientacoesConcluidas(vitae, anos, tipo)
  selecionaElementosPorAnoECondicao(vitae,anos,"//OUTRAS-ORIENTACOES-CONCLUIDAS","DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-CONCLUIDAS","ANO"){|db| db.attributes["NATUREZA"] == tipo}
end

def selecionaOrientacoesConcluidas(vitae, anos, tipo)
  selecionaElementosPorAno(vitae, anos,"//ORIENTACOES-CONCLUIDAS-PARA-" << tipo,
                           "DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-" << tipo,"ANO")
end

def selecionaSupervisaoEstagioEmAndamento(documento)
  selecionaElementosPorCondicao(documento,"//OUTRAS-ORIENTACOES-EM-ANDAMENTO", "DADOS-BASICOS-DE-OUTRAS-ORIENTACOES-EM-ANDAMENTO") {|db|   true}
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Supervisao de estagios curriculares e extracurriculares Concluido
def supervisaoEstagioConcluido(documento, anos)
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
def supervisaoEstagioEmAndamento(documento)
  result = String.new("\n")

  result << "\\subsection{Supervis\\~{a}o de est\\'{a}gios curriculares e extracurriculares em Andamento}\n"
  result << "\\vspace{0.3cm}\n"
  result << "\n"

  orientacoes = selecionaSupervisaoEstagioEmAndamento(documento)
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaSupervisaoEstagioEmAndamento(orientacoes)
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Teses de Doutorado Concluidas
def orientacaoDoutoradoConcluida(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o e Co-Orienta\\c{c}\\~{a}o de Teses de Doutorado Conclu\\'{i}das} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOrientacoesConcluidas(documento, anos, "DOUTORADO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOrientacoesConcluidas(orientacoes, "DOUTORADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Teses de Doutorado em Andamento
def orientacaoDoutoradoEmAndamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o e Co-Orienta\\c{c}\\~{a}o de Teses de Doutorado em Andamento} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOrientacoesEmAndamento(documento, "DOUTORADO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOrientacoesEmAndamento(orientacoes, "DOUTORADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Disertacoes de Mestrado Concluidas
def orientacaoMestradoConcluida(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o e Co-Orienta\\c{c}\\~{a}o de Disserta\\c{c}\\~{o}es de Mestrado Conclu\\'{i}das} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOrientacoesConcluidas(documento, anos, "MESTRADO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOrientacoesConcluidas(orientacoes, "MESTRADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Disertacoes de Mestrado Em Andamento
def orientacaoMestradoEmAndamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o e Co-Orienta\\c{c}\\~{a}o de Disserta\\c{c}\\~{o}es de Mestrado Em Andamento} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOrientacoesEmAndamento(documento, "MESTRADO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOrientacoesEmAndamento(orientacoes, "MESTRADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Trabalhos de Conclusao de Curso Concluidas
def orientacaoTrabalhoConclusaoCursoConcluida(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Monografias de Trabalhos de Conclus\\~{a}o de Curso Conclu\\'{\\i}das'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOutrasOrientacoesConcluidas(documento, anos, "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOutrasOrientacoesConcluidas(orientacoes, "TRABALHO_DE_CONCLUSAO_DE_CURSO_GRADUACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao e Co-Orientacao de Trabalhos de Conclusao de Curso Em Andamento
def orientacaoTrabalhoConclusaoCursoEmAndamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Monografias de Trabalhos de Conclus\\~{a}o de Curso Em Andamento'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOrientacoesEmAndamento(documento, "GRADUACAO")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOutrasOrientacoesEmAndamento(orientacoes, "GRADUACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

#TODO
# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Monitorias
def orientacaoMonitoriaConcluida(arquivo)
  result = String.new("\n")

  result << includeFile("#{arquivo}")
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Iniciacao Cientifica Concluida
def orientacaoIniciacaoCientificaConcluida(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Inicia\\c{c}\\~{a}o Cient\\'{\\i}fica Conclu\\'{\\i}das'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOutrasOrientacoesConcluidas(documento, anos, "INICIACAO_CIENTIFICA")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOutrasOrientacoesConcluidas(orientacoes, "INICIACAO_CIENTIFICA")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Iniciacao Cientifica Em Andamento
def orientacaoIniciacaoCientificaEmAndamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Inicia\\c{c}\\~{a}o Cient\\'{\\i}fica em Andamento'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOutrasOrientacoesEmAndamento(documento, "INICIACAO_CIENTIFICA")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOutrasOrientacoesEmAndamento(orientacoes, "INICIACAO_CIENTIFICA")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Trabalho de Apoio Academico Concluido
def orientacaoTrabalhoApoioAcademicoConcluido(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Apoio Acad\\^{e}mico Conclu\'{\\i}das'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOutrasOrientacoesConcluidas(documento, anos, "ORIENTACAO-DE-OUTRA-NATUREZA")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOutrasOrientacoesConcluidas(orientacoes, "ORIENTACAO-DE-OUTRA-NATUREZA")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.1 - Orientacoes e Co-Orientacoes
# Orientacao de Trabalho de Apoio Academico em Andamento
def orientacaoTrabalhoApoioAcademicoEmAndamento(documento)
  result = String.new("\n")

  result << "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Apoio Acad\\^{e}mico em Andamento'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  orientacoes = selecionaOutrasOrientacoesEmAndamento(documento, "ORIENTACAO-DE-OUTRA-NATUREZA")
  if (orientacoes != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaOutrasOrientacoesEmAndamento(orientacoes, "ORIENTACAO-DE-OUTRA-NATUREZA")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas Examinadoras de Concurso
def bancasExaminadorasDeConcurso(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas Examinadoras de Concurso'} \n"
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
# Bancas Congressos de Iniciacao Cientifica ou de Extensao
def bancasCongressosIniciacaoOuExtensao(documento, anos)
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
def bancasTrabalhoDeConclusaoDeCurso(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas de Disserta\\c{c}\\~{a}o de Mestrado'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = selecionaBancas(documento, anos, "GRADUACAO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaBancas(bancas,"GRADUACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas de Dissertacao de Mestrado
def bancasDissertacaoDeMestrado(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas de Disserta\\c{c}\\~{a}o de Mestrado'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = selecionaBancas(documento, anos, "MESTRADO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaBancas(bancas,"MESTRADO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas de Qualificacao/Defesa de Proposta de Tese de Doutorado
def bancasQualificacaoDeDoutorado(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas de Qualifica\\c{c}\\~ao / Proposta de Tese de Doutorado'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = selecionaBancas(documento, anos, "EXAME-QUALIFICACAO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaBancas(bancas,"EXAME-QUALIFICACAO")
  else
    result << "Nada a declarar. \n"
  end

  result << "\n"
  result << "\\end{enumerate} \n"
end

# Subgrupo 1.2 - Participacao em Comissoes Examinadoras
# Bancas de Tese de Doutorado
def bancasTeseDeDoutorado(documento, anos)
  result = String.new("\n")

  result << "\\subsubsection{Bancas de Tese de Doutorado'} \n"
  result << "\\vspace{0.3cm} \n"
  result << " \n"

  bancas = selecionaBancas(documento, anos, "DOUTORADO")

  if (bancas != []) then
    result << "\\begin{enumerate}\n"
    result << "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}\n"
    #result << "\n"
    result << processaBancas(bancas,"DOUTORADO")
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

anos = ["2014", "2015", "2016"]

siape = "1807586"
departamento = "Departamento de Informa\\c{c}\\~{a}o e Sistemas"
dataInicio = "20 de Agosto de 2014"
dataFim = "19 de Agosto de 2016"
categoriaOrigem = "Adjunto N\'{i}vel 3"
categoriaDestino = "Adjunto N\'{i}vel 4"
categoriaProgressao = "Horizontal"

#puts arquivoTeXHeader(doc.elements[0].elements[0].attr("NOME-COMPLETO").to_s, siape, anos, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao)

#puts arquivoTeXPresentation(doc.elements[0].elements[0].attr("NOME-COMPLETO").to_s, departamento, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao)

###############################################################################
#                       Grupo 1 - Atividades de Ensino                        #
###############################################################################

###############################################################################
#                 Subgrupo 1.1 - Orientacoes e Co-Orientacoes                 #
###############################################################################

# TODO
# puts supervisaoEstagioConcluido(doc, anos)

# puts supervisaoEstagioEmAndamento(doc)

# puts orientacaoDoutoradoConcluida(doc, anos)

# puts orientacaoDoutoradoEmAndamento(doc)

# puts orientacaoMestradoConcluida(doc, anos)

# puts orientacaoMestradoEmAndamento(doc)

# puts orientacaoTrabalhoConclusaoCursoConcluida(doc, anos)

# puts orientacaoTrabalhoConclusaoCursoEmAndamento(doc)

# puts orientacaoMonitoriaConcluida("monitoria.tex")

# puts orientacaoIniciacaoCientificaConcluida(doc, anos)

# puts orientacaoIniciacaoCientificaEmAndamento(doc)

# puts orientacaoTrabalhoApoioAcademicoConcluido(doc, anos)

# puts orientacaoTrabalhoApoioAcademicoEmAndamento(doc)

###############################################################################
#            Subgrupo 1.2 - Participacao em Comissoes Examinadoras            #
###############################################################################

# TODO
# puts bancasExaminadorasDeConcurso(doc, anos)

# TODO
# puts bancasCongressosIniciacaoOuExtensao(doc, anos)

# puts bancasTrabalhoDeConclusaoDeCurso(doc, anos)

# puts bancasDissertacaoDeMestrado(doc, anos)

# puts bancasQualificacaoDeDoutorado(doc, anos)

# puts bancasTeseDeDoutorado(doc, anos)

# TODO
# puts bancasSelecaoPosGraduacao(doc, anos)

###############################################################################
#     Subgrupo 1.3 - Atividades de Ensino na Graduacao e na Pos-Graduacao     #
###############################################################################

###############################################################################
#           Subgrupo 1.4 - Avaliacao Didatica Docente pelo Discente           #
###############################################################################

###############################################################################
# Grupo 2: Atividades de Producao Cientifica e Tecnica, Artistica e Cultural  #
###############################################################################

###############################################################################
#                  Subgrupo 2.1 - Produtividade de Pesquisa                   #
###############################################################################

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


#puts arquivoTeXFooter