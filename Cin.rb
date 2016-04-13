# Copyright by Vinicius Garcia, 2016
#
# This script is based on a first version implemented by Prof. Paulo Borba (2008).
# 
# Known issues: Access to subelements with // only works
#     for immediate subelement.
#
#     Access to multiple subelements with "*"
#     only works for accessing a single attribute
#     of the subelements. Can actually access more
#     than one attribute, but they are mixed together
#     in the same list.
#
#     Since the generated file is encoded as UTF8, the proper LaTeX packages 
#     should be used for compilation.
#
#     Info about courses and administrative tasks are
#     not extracted yet.

module Cin

  def arquivoTeXHeader(professor, siape, anos, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao, arquivo)

      arquivo.puts File.readlines("header.tex")

      arquivo.puts ""

      arquivo.puts "\\usepackage[bookmarks,colorlinks,pdfpagelabels,
            pdftitle={Memorial Descritivo de Atividades}, 
            pdfauthor={#{professor}},
            pdfsubject={Solicita\\c{c}\\~{a}o de progress\\~{a}o funcional docente de #{categoriaOrigem} para #{categoriaDestino} apresentada \\`{a} Comiss\\~{a}o de Avalia\\c{c}\\~{a}o de Progress\\~{a}o #{categoriaProgressao} do Centro de Inform\\'{a}tica da Universidade Federal de Pernambuco.},
            pdfcreator={#{professor}}, pdfkeywords={Progress\\~{a}o, #{categoriaOrigem}, #{categoriaDestino}, #{categoriaProgressao}, UFPE, CIn}]{hyperref}"

      arquivo.puts ""

      arquivo.puts "\\newcommand{\\otoprule}{\\midrule[\\heavyrulewidth]}"
      arquivo.puts ""
      arquivo.puts "% Definicao de margens"
      arquivo.puts "\\setlength{\\textwidth}{16cm} %"
      arquivo.puts "\\setlength{\\textheight}{23cm} %"
      arquivo.puts "\\setlength{\\oddsidemargin}{0cm} %"
      arquivo.puts "\\setlength{\\evensidemargin}{0cm} %"
      arquivo.puts "\\setlength{\\topmargin}{0cm}"
      arquivo.puts ""
      arquivo.puts "\\renewcommand{\\abstractname}{Resumo}"
      arquivo.puts "\\renewcommand{\\contentsname}{\\'{I}ndice Anal\\'{\\i}tico}"
      arquivo.puts "\\renewcommand{\\refname}{Refer\\^{e}ncias}"
      arquivo.puts "\\renewcommand{\\appendixname}{Ap\\^{e}ndice}"
      arquivo.puts "\\renewcommand{\\tablename}{Tabela}"
      arquivo.puts ""
      arquivo.puts "%% Formatacao do cabecalho e rodape"
      arquivo.puts "\\lhead{\\footnotesize Memorial Descritivo de Atividades} %"
      arquivo.puts "\\rhead{\\footnotesize \\emph{#{professor}}} %"
      arquivo.puts "\\chead{} %"
      arquivo.puts "\\cfoot{} %"
      arquivo.puts "\\lfoot{\\footnotesize\\nouppercase\\leftmark} %"
      arquivo.puts "\\rfoot{\\bfseries\\thepage}"
      arquivo.puts "\\renewcommand{\\footrulewidth}{0.1pt}"
      arquivo.puts ""
      arquivo.puts "% Comando para inserir numero de documento"
      arquivo.puts "\\newcounter{document}%[section]"
      arquivo.puts "\\setcounter{document}{0}"
      arquivo.puts "\\renewcommand\\theenumi{\\arabic{section}.\\arabic{enumi}}"
      arquivo.puts "\\newcommand\\Doc{{\\addtocounter{document}{1}\\mbox{\\sffamily\\bfseries [Doc. \\arabic{document}]}}}"
      arquivo.puts ""
      arquivo.puts "% Comando para repetir um numero de documento ja citado"
      arquivo.puts "% \\mbox{\\sffamily{\\bfseries{[Doc. XX]}}}"
      arquivo.puts ""
      arquivo.puts "%% Alternativa na edicao dos comandos."
      arquivo.puts "%% Comando para inserir numero de documento"
      arquivo.puts "% \\newcommand\\thedocument{%"
      arquivo.puts "%    \\ifthenelse{\\arabic{subsection}=0}"
      arquivo.puts "%      {\\thesection.\\arabic{document}}"
      arquivo.puts "%      {\\thesubsection.\\arabic{document}}}"
      arquivo.puts "% \\newcounter{document}[section]"
      arquivo.puts "% \\setcounter{document}{0}"
      arquivo.puts "% \\renewcommand\\theenumi{\\arabic{section}.\\arabic{enumi}}"
      arquivo.puts "% \\ifthenelse{\\arabic{subsection} = 0}{\\newcommand\\Doc{{\\stepcounter{document}\\bfseries [Doc. \\arabic{section}.\\arabic{document}]}}}{\\newcommand\\Doc{{\\stepcounter{document}\\bfseries [Doc. \\arabic{section}.\\arabic{subsection}.\\arabic{document}]}}}"
      arquivo.puts "% %\\newcommand\\Doc{{\\addtocounter{document}{1}\\mbox{\\bfseries [Doc. \\arabic{document}]}}}"
      arquivo.puts ""
      arquivo.puts ""
      arquivo.puts "% Ambiente para centralizar vertical"
      arquivo.puts "\\newenvironment{vcenterpage}"
      arquivo.puts "     {\\newpage\\vspace*{\\fill}}"
      arquivo.puts "     {\\vspace*{\\fill}\\par\\pagebreak}"
      arquivo.puts ""
      arquivo.puts "\\sloppy"
      arquivo.puts ""
      arquivo.puts "\\pagestyle{fancy}"
      arquivo.puts ""
      arquivo.puts "\\setcounter{secnumdepth}{4}"
      arquivo.puts ""
      arquivo.puts "\\begin{document}"
      arquivo.puts "\\pagenumbering{Alph}"
      arquivo.puts "\\begin{titlepage}"
      arquivo.puts ""
      arquivo.puts "\\vspace{-5.0cm}"
      arquivo.puts ""
      arquivo.puts "\\begin{figure}[!htb]"
      arquivo.puts " \\centering{\\includegraphics[scale=4.0]{logo2.eps}}"
      arquivo.puts " \\label{fig:UFPE_logo}"
      arquivo.puts "\\end{figure}"
      arquivo.puts ""
      arquivo.puts "\\begin{center}"
      arquivo.puts "\\vspace{1cm}"
      arquivo.puts "%{\\huge \\textsf{Solicita\\c{c}\\~{a}o de Progress\\~{a}o Funcional Docente}} \\\\[1cm]"
      arquivo.puts "\\rule{1.0\\textwidth}{1pt} \\\\ [0.5cm]"
      arquivo.puts "{\\Huge \\textbf{\\textsf{Memorial Descritivo de Atividades}}} \\\\"
      arquivo.puts "\\rule{1.0\\textwidth}{1pt} \\\\"
      arquivo.puts "\\vspace{2cm}"
      arquivo.puts ""
      arquivo.puts "\\doublespacing"
      arquivo.puts "{\\Large \\textsf{Solicita\\c{c}\\~{a}o de progress\\~{a}o funcional docente de #{categoriaOrigem} para #{categoriaDestino} apresentada \\`{a} Comiss\\~{a}o de Avalia\\c{c}\\~{a}o de Progress\\~{a}o #{categoriaProgressao} do Centro de Inform\\'{a}tica da Universidade Federal de Pernambuco}}\\\\"
      arquivo.puts "\\vspace{1.5cm}"
      arquivo.puts "{\\LARGE \\textsf{Solicitante: \\textbf{#{professor}}}}\\\\"
      arquivo.puts "\\vspace{0.5cm}"
      arquivo.puts "{\\Large \\textsf{SIAPE: \\textbf{#{siape}}}} \\\\"
      arquivo.puts "\\vspace{0.5cm}"
      arquivo.puts "{\\Large \\textsf{Per\\'{\\i}odo: \\textbf{#{dataInicio} - #{dataFim}}}} \\\\"
      arquivo.puts ""
      arquivo.puts "\\vspace{2.0cm}"
      arquivo.puts ""
      arquivo.puts "\\normalsize \\textsf{\\today}"
      arquivo.puts ""
      arquivo.puts "\\end{center}"
      arquivo.puts "\\thispagestyle{empty}"
      arquivo.puts "\\end{titlepage}"
      arquivo.puts "\\pagenumbering{arabic}"
      arquivo.puts ""
      arquivo.puts "\\tableofcontents"
      arquivo.puts "%\\include{Lista_Anexos} \\cleartooddpage[\\thispagestyle{empty}]"
  end

  def arquivoTeXPresentation(professor, departamento, dataInicio, dataFim, categoriaOrigem, categoriaDestino, categoriaProgressao, arquivo)
    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% APRESENTACAO"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts ""
    arquivo.puts "\\newpage"
    arquivo.puts "\\section*{Apresenta\\c{c}\\~{a}o}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{onehalfspace}"
    arquivo.puts ""
    arquivo.puts "Memorial apresentado por \\textbf{#{professor}}, Professor #{categoriaOrigem}, lotado no #{departamento} do Centro de Inform\\'{a}tica (CIn) da Universidade Federal de Pernambuco (UFPE), para avalia\\c{c}\\~{a}o de desempenho acad\\^{e}mico, para fins de acesso por Progress\\~{a}o #{categoriaProgressao} \\`{a} classe de Professor #{categoriaDestino}."
    arquivo.puts ""
    arquivo.puts "O presente arquivo relata as atividades desempenhadas no per\\'{\i}odo de \\textbf{#{dataInicio} a #{dataFim}} e foi elaborado com base nas diretrizes estabelecidas nas Resolu\\c{c}\\~{o}es 04/2008 e 02/2011 do Conselho Universit\\'{a}rio (CONSUN) da UFPE e na Portaria 554, de 20/06/2013, do Minist\\'{e}rio da Educa\\c{c}\\~{a}o (MEC). Os documentos comprobat\\'{o}rios referenciados neste arquivo est\\~{a}o organizados em volumes anexos devidamente numerados. Por fim, os Anexos que se referem a artigos publicados em confer\\^{e}ncias e peri\\'{o}dicos cont\\'{e}m apenas a primeira p\\'{a}gina do trabalho e o email informando a aceita\\c{c}\\~{a}o do trabalhao para publica\\c{c}\\~{a}o (quando pertinente)."
    arquivo.puts "\\end{onehalfspace}"
  end

  def arquivoTeXFooter(arquivo)
    arquivo.puts "% Appendix"
    arquivo.puts "\\clearpage"
    arquivo.puts "%\\addappheadtotoc"
    arquivo.puts "\\appendix"
    arquivo.puts "%\\appendixpage"
    arquivo.puts "\\newpage"
    arquivo.puts "\\section{Documentos comprobat\\'{o}rios}"
    arquivo.puts "Esta se\\c{c}\\~{a}o cont\\'{e}m os documentos comprobat\\'{o}rios referentes \\`{a}s atividades listadas neste memorial."
    arquivo.puts "\\addcontentsline{toc}{section}{Documentos comprobat\\'{o}rios}"
    arquivo.puts "\\renewcommand{\\thesubsection}{\\arabic{subsection}}"
    arquivo.puts "% \\renewcommand{\\subsection}{"
    arquivo.puts "% \\titleformat{\\subsection}"
    arquivo.puts "%   {\\Huge\\bfseries\\center\\vspace{.4\\textwidth}\\thispagestyle{fancy}} % format"
    arquivo.puts "%   {}                % label"
    arquivo.puts "%   {0pt}             % sep"
    arquivo.puts "%   {\\huge}           % before-code"
    arquivo.puts "% }"
    arquivo.puts ""
    arquivo.puts "\\include{appendices}"
    arquivo.puts ""
    arquivo.puts "\\end{document}"
    arquivo.puts ""
    arquivo.puts "%%% EOF"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Supervisao de estagios curriculares e extracurriculares
  def supervisaoEstagios(arquivo, root, anos)
    arquivo.puts ""
    arquivo.puts "\\subsection{Supervis\\~{a}o de est\\'{a}gios curriculares e extracurriculares}"
    arquivo.puts "\\vspace{0.3cm}"

    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    #i = 0

    anos.each{|ano|
      target = XPath.match(arquivo, "//OUTRAS-ORIENTACOES-EM-ANDAMENTO/*[@ANO='#{ano}']")
      arquivo.puts ""
        arquivo.puts "\\item       \\textbf{Aluno:}  #{target.attribute('NOME-DO-ORIENTANDO')}\\\\"
        arquivo.puts "            \\textbf{Curso:} #{target.attribute('NOME-CURSO')}\\\\"
        arquivo.puts "            \\textbf{Empresa:}  #{target.attribute('TITULO-DO-TRABALHO')}\\\\"
        arquivo.puts "            \\textbf{Per\\'{\\i}odo:} #{target.attribute('ANO')}"
    }
    

    # root.each_element('//OUTRAS-ORIENTACOES-EM-ANDAMENTO') {|elemento| 
    #   puts elemento.elements[1].attributes['ANO'].to_s
    #   if (anos.include? elemento.elements[1].attributes['ANO'].to_s) 
    #     arquivo.puts ""
    #     arquivo.puts "\\item       \\textbf{Aluno:}  #{elemento.elements[2].attributes['NOME-DO-ORIENTANDO']}\\\\"
    #     arquivo.puts "            \\textbf{Curso:} #{elemento.elements[2].attributes['NOME-CURSO'].to_s}\\\\"
    #     arquivo.puts "            \\textbf{Empresa:}  #{elemento.elements[1].attributes['TITULO-DO-TRABALHO'].to_s}\\\\"
    #     arquivo.puts "            \\textbf{Per\\'{\\i}odo:} #{elemento.elements[1].attributes['ANO'].to_s}"
    #     i += 1
    #   end
    # }

    # if i<1
    #   arquivo.puts "\\item       \\textbf{Nada a declarar}"
    # end

    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Orientacao de Teses de Doutorado Concluidas
  def orientacaoDoutoradoConcluida(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Orienta\\c{c}\\~{a}o de Teses de Doutorado Conclu\\'{i}das}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Tese:} \\\\"
    arquivo.puts "            \\textbf{Data da Defesa:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Co-Orientacao de Teses de Doutorado Concluidas
  def coOrientacaoDoutoradoConcluida(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Co-Orienta\\c{c}\\~{a}o de Teses de Doutorado Conclu\\'{i}das}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Tese:} \\\\"
    arquivo.puts "            \\textbf{Data da Defesa:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Orientacao de Teses de Doutorado em Andamento
  def orientacaoDoutoradoAndamento(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Orienta\\c{c}\\~{a}o de Teses de Doutorado em Andamento}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    
    root.each_element('//ORIENTACAO-EM-ANDAMENTO-DE-DOUTORADO') {|elemento| 

      arquivo.puts ""
      arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
      arquivo.puts "            \\textbf{T\\'{\\i}tulo da Tese:} \\\\"
      arquivo.puts "            \\textbf{Data de In\\'{\\i}cio:}  \\\\"
      arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    
    }

    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Co-Orientacao de Teses de Doutorado em Andamento
  def coOrientacaoDoutoradoAndamento(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Co-Orienta\\c{c}\\~{a}o de Teses de Doutorado em Andamento}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Tese:} \\\\"
    arquivo.puts "            \\textbf{Data de In\\'{\\i}cio:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Orientacao de Dissertacoes de Mestrado Concluidas
  def orientacaoMestradoConcluida(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Orienta\\c{c}\\~{a}o de Disserta\\c{c}\\~{o}es de Mestrado Conclu\\'{i}das}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Disserta\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "            \\textbf{Tipo:} Acad\\^{e}mico | Profissional\\\\"
    arquivo.puts "            \\textbf{Data da Defesa:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Co-Orientacao de Dissertacoes de Mestrado Concluidas
  def coOrientacaoMestradoConcluida(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Co-Orienta\\c{c}\\~{a}o de Disserta\\c{c}\\~{o}es de Mestrado Conclu\\'{i}das}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Disserta\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "            \\textbf{Tipo:} Acad\\^{e}mico | Profissional\\\\"
    arquivo.puts "            \\textbf{Data da Defesa:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Orientacao de Dissertacoes de Mestrado em Andamento
  def orientacaoMestradoAndamento(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Orienta\\c{c}\\~{a}o de Disserta\\c{c}\\~{o}es de Mestrado em Andamento}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Disserta\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "            \\textbf{Tipo:} Acad\\^{e}mico | Profissional\\\\"
    arquivo.puts "            \\textbf{Data de In\\'{\\i}cio:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Co-Orientacao de Dissertacoes de Mestrado em Andamento
  def coOrientacaoMestradoAndamento(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Co-Orienta\\c{c}\\~{a}o de Disserta\\c{c}\\~{o}es de Mestrado em Andamento}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Disserta\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "            \\textbf{Tipo:} Acad\\^{e}mico | Profissional\\\\"
    arquivo.puts "            \\textbf{Data de In\\'{\\i}cio:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Orientacao de Trabalhos de Conclusao de Curso (TCC)
  def orientacaoTrabalhoConclusaoCurso(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Conclus\\~{a}o de Curso}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{Curso:} \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Monografia:} \\\\"
    arquivo.puts "            \\textbf{Data da Defesa:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Orientacao de Monitorias
  def orientacaoMonitoria(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Orienta\\c{c}\\~{a}o de Monitorias}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{Disciplina:}\\\\"
    arquivo.puts "            \\textbf{Curso:} \\\\"
    arquivo.puts "            \\textbf{Semestre:} "
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Orientacao de Iniciacao Cientifica
  def orientacaoIniciacaoCientifica(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Inicia\\c{c}\\~{a}o Cient\\'{\\i}fica}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{Projeto:}  \\\\"
    arquivo.puts "            \\textbf{Tema:}  \\\\"
    arquivo.puts "            \\textbf{Per\\'{\\i}odo:}  \\\\"
    arquivo.puts "            \\textbf{Financiamento:} "
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.1 - Orientacoes e Co-Orientacoes
  # Orientacao de Trabalho de Apoio Academico
  def orientacaoTrabalhoApoioAcademico(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Orienta\\c{c}\\~{a}o de Trabalhos de Apoio Acad\\^{e}mico}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{Projeto:}  \\\\"
    arquivo.puts "            \\textbf{Tema:}  \\\\"
    arquivo.puts "            \\textbf{Categoria:}  \\\\"
    arquivo.puts "            \\textbf{Per\\'{\\i}odo:}  \\\\"
    arquivo.puts "            \\textbf{Financiamento:} "
    arquivo.puts ""
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.2 - Participacao em Comissoes Examinadoras
  # Bancas Examinadoras de Concurso
  def participacaoBancasConcurso(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Bancas Examinadoras de Concurso}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Descri\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "        \\textbf{Institui\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "        \\textbf{Data/Per\\'{\\i}odo:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.2 - Participacao em Comissoes Examinadoras
  # Bancas Congressos de Iniciacao Cientifica ou de Extensao
  def participacaoBancasIniciacaoCientificaExtensao(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Bancas Congressos de Inicia\\c{c}\\~{a}o Cient\\'{i}fica ou de Extens\\~{a}o}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Descri\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "        \\textbf{Institui\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "        \\textbf{Data/Per\\'{\\i}odo:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.2 - Participacao em Comissoes Examinadoras
  # Bancas de Trabalho de Conclusao de Curso
  def participacaoBancasTrabalhoConclusaoCurso(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Bancas de Trabalho de Conclus\\~{a}o de Curso}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Aluno:}  \\\\"
    arquivo.puts "            \\textbf{Curso:} \\\\"
    arquivo.puts "            \\textbf{T\\'{\\i}tulo da Monografia:} \\\\"
    arquivo.puts "            \\textbf{Data da Defesa:}  \\\\"
    arquivo.puts "            \\textbf{Institui\\c{c}\\~{a}o:}"
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.2 - Participacao em Comissoes Examinadoras
  # Bancas de Dissertacao de Mestrado
  def participacaoBancasMestrado(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Bancas de Disserta\\c{c}\\~{a}o de Mestrado}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Candidato:} \\\\"
    arquivo.puts "        \\textbf{T\\'{\\i}tulo da Disserta\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "        \\textbf{Tipo:} \\\\"
    arquivo.puts "        \\textbf{Programa:} \\\\"
    arquivo.puts "        \\textbf{Universidade:} \\\\"
    arquivo.puts "        \\textbf{Data:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.2 - Participacao em Comissoes Examinadoras
  # Bancas de Qualificacao/Defesa de Proposta de Tese de Doutorado
  def participacaoBancasQualificacaoDoutorado(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Bancas de Qualifica\\c{c}\\~ao / Proposta de Tese de Doutorado}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Candidato:} \\\\"
    arquivo.puts "        \\textbf{T\\'{\\i}tulo da Qualifica\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "        \\textbf{Tipo:} \\\\"
    arquivo.puts "        \\textbf{Programa:} \\\\"
    arquivo.puts "        \\textbf{Universidade:} \\\\"
    arquivo.puts "        \\textbf{Data:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.2 - Participacao em Comissoes Examinadoras
  # Bancas de Tese de Doutorado
  def participacaoBancasDoutorado(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Bancas de Tese de Doutorado}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Candidato:} \\\\"
    arquivo.puts "        \\textbf{T\\'{\\i}tulo da Tese:} \\\\"
    arquivo.puts "        \\textbf{Tipo:} \\\\"
    arquivo.puts "        \\textbf{Programa:} \\\\"
    arquivo.puts "        \\textbf{Universidade:} \\\\"
    arquivo.puts "        \\textbf{Data:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 1.2 - Participacao em Comissoes Examinadoras
  # Bancas de Selecao para Ingresso no Programa de Pos-Graduacao do CIn/UFPE
  def participacaoBancasSelecaoPos(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Participa\\c{c}\\~{a}o em Bancas de Sele\\c{c}\\~{a}o para ingresso e exames de Qualifica\\c{c}\\~ao de Programa de P\\'{o}-Gradua\\c{c}\\~{a}o \\textit{Stricto Sensu}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item       \\textbf{Descri\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "        \\textbf{Programa:} \\\\"
    arquivo.puts "        \\textbf{Institui\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "        \\textbf{Per\\'{\\i}odo de Realiza\\c{c}\\~{a}o:}"
    arquivo.puts "\\end{enumerate}"
  end

  # Grupo 1 - Atividades de Ensino
  # @arquivo: arquivo latex de destino
  # @ root: elemento raiz do curriculo lattes xml
  def atividadesDeEnsino(arquivo, root, anos)
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Grupo 1 - Atividades de Ensino"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "\\newpage"
    arquivo.puts "\\section{Atividades de Ensino}"
    arquivo.puts ""
    arquivo.puts "%A seguir, listo as atividades de ensino que realizei no periodo, separadas por subgrupo, conforme rege o documento tal."
    arquivo.puts ""
    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Subgrupo 1.1 - Orientacoes e Co-Orientaoees"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    
    supervisaoEstagios(arquivo,root, anos)
    
    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""
    arquivo.puts "\\subsection{Orienta\\c{c}\\~{o}es e Co-Orienta\\c{c}\\~{o}es}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    orientacaoDoutoradoConcluida(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    coOrientacaoDoutoradoConcluida(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    orientacaoDoutoradoAndamento(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    coOrientacaoDoutoradoAndamento(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    orientacaoMestradoConcluida(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    coOrientacaoMestradoConcluida(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    orientacaoMestradoAndamento(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    coOrientacaoMestradoAndamento(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    orientacaoTrabalhoConclusaoCurso(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""  

    orientacaoMonitoria(arquivo, root)  

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    orientacaoIniciacaoCientifica(arquivo, root)  

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    orientacaoTrabalhoApoioAcademico(arquivo, root)

    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Subgrupo 1.2 - Participacao em Comissoes Examinadoras"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

    arquivo.puts ""
    arquivo.puts "\\subsection{Participa\\c{c}\\~{a}o em Comiss\\~{o}es Examinadoras}"
    arquivo.puts "\\vspace{0.3cm}"

    participacaoBancasConcurso(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    participacaoBancasIniciacaoCientificaExtensao(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    participacaoBancasTrabalhoConclusaoCurso(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    participacaoBancasMestrado(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    participacaoBancasQualificacaoDoutorado(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    participacaoBancasDoutorado(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts "" 

    participacaoBancasSelecaoPos(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Subgrupo 1.3 - Atividades de Ensino na Graduacao e na Pos-Graduacao"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts ""
    arquivo.puts "\\subsection{Atividades de Ensino na Gradua\\c{c}\\~{a}o e na P\\'{o}s-Gradua\\c{c}\\~{a}o}"
    arquivo.puts "\\vspace{0.3cm}"

    arquivo.puts File.readlines("disciplinas.tex")

    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Subgrupo 1.4 - Avaliacao Didatica Docente pelo Discente"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts ""
    arquivo.puts "\\vspace{5.0cm}"

    arquivo.puts File.readlines("avaliacaodocente.tex")
  end

  #TODO
  # Subgrupo 2.1 - Produtividade de Pesquisa
  # Bolsista de produtividade em pesquisa e em inovacao tecnologica
  def bolsistaProdutividade(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Bolsista de produtividade em pesquisa e em inova\\c{c}\\~{a}o tecnol\\'{o}gica}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "Nada a declarar."
  end

  #TODO
  # Subgrupo 2.1 - Produtividade de Pesquisa
  # Participacao em Eventos Cientificos (com apresentacao de trabalho ou oferecimento de cursos, palestras ou debates
  def participacaoEventosCientificos(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Participa\\c{c}\\~{a}o em Eventos Cient\\'{\\i}ficos (com apresenta\\c{c}\\~{a}o de trabalho ou oferecimento de cursos, palestras ou debates)}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item   \\textbf{Evento:} \\\\"
    arquivo.puts "    \\textbf{Prop\\'{o}sito:} \\\\"
    arquivo.puts "    \\textbf{Per\\'{\\i}odo:} \\\\"
    arquivo.puts "    \\textbf{Local:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 2.1 - Produtividade de Pesquisa
  # Autoria de artigos completos publicados em anais de congresso, em jornais e revistas de circulacao nacional e internacional na sua area
  def autoriaArtigosCompletos(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Autoria de artigos completos publicados em anais de congresso, em jornais e revistas de circula\\c{c}\\~{a}o nacional e internacional na sua \\'{a}rea}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item   "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 2.1 - Produtividade de Pesquisa
  # Arbitragem de Artigos Tecnico-Cientificos Nacionais e Internacionais na sua area de atuacao
  def arbitragemArtigos(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Arbitragem de Artigos T\\'{e}cnico-Cient\\'{\\i}ficos Nacionais e Internacionais na sua \\'{a}rea de atua\\c{c}\\~{a}o}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item   \\textbf{Peri\\'{o}dico:} \\\\"
    arquivo.puts "    \\textbf{Editora:} \\\\"
    arquivo.puts "    \\textbf{ISSN:} \\\\"
    arquivo.puts "    \\textbf{URL:} \\url{}"

    arquivo.puts "\\item \\textbf{Evento:} \\\\"
    arquivo.puts "  \\textbf{Ano:}  \\\\"
    arquivo.puts "  \\\textbf{Organiza\\c{c}\\~{a}o:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 2.1 - Produtividade de Pesquisa
  # Coordenacao e/ou Participacao em Projetos Aprovados por Orgaos de Fomento
  def participacaoProjetosAprovados(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Coordena\\c{c}\\~{a}o e/ou Participa\\c{c}\\~{a}o em Projetos Aprovados por \\'{O}rg\\~{a}os de Fomento}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item \\textbf{T\\'{\\i}tulo do projeto:} \\\\"
    arquivo.puts "  \\textbf{Fun\\c{c}\\~{a}o no projeto:} \\\\"
    arquivo.puts "  \\textbf{N\\'{u}mero do processo:} \\"
    arquivo.puts "  \\textbf{Financiador/Edital:} \\\\"
    arquivo.puts "  \\textbf{Per\\'{\\i}odo (in\\'{\\i}cio-fim):} \\\\"
    arquivo.puts "  \\textbf{Situ\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "  \\textbf{Natureza:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 2.1 - Produtividade de Pesquisa
  # Consultoria as Instituicoes de Fomento a Pesquisa, Ensino e Extensao
  def consultoriaInstituicoesFomento(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Consultoria \\`{a}s Institui\\c{c}\\~{o}es de Fomento \\`{a} Pesquisa, Ensino e Extens\\~{a}o}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item  "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 2.1 - Produtividade de Pesquisa
  # Premios Recebidos pela Producao Cientifica e Tecnica
  def premiosRecebidos(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Pr\\^{e}mios Recebidos pela Produ\\c{c}\\~{a}o Cient\\'{\\i}fica e T\\'{e}cnica}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 2.2 - Producao Cientifica
  # Trabalhos Publicados em Periodicos Especializados do Pais ou do Exterior
  def trabalhosPeriodicos(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Trabalhos Publicados em Peri\\'{o}dicos Especializados do Pa\\'{\\i}s ou do Exterior}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item   "
    arquivo.puts "\\end{enumerate}"
  end

  # Grupo 2 - Atividades de Producao Cientifica e Tecnica, Artistica e Cultural
  # @arquivo: arquivo latex de destino
  # @ root: elemento raiz do curriculo lattes xml
  def atividadesDeProducao(arquivo, root)
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Grupo 2 - Atividades de Producao Cientifica e Tecnica, Artistica e Cultural"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "\\newpage"
    arquivo.puts "\\section{Atividades de Produ\\c{c}\\~{a}o Cient\\'{\\i}fica e T\\'{e}cnica, Art\\'{\\i}stica e Cultural}"
    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Subgrupo 2.1 - Produtividade de Pesquisa"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts ""
    arquivo.puts "\\subsection{Produtividade de Pesquisa}"
    arquivo.puts "\\vspace{0.3cm}"

    bolsistaProdutividade(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    participacaoEventosCientificos(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    autoriaArtigosCompletos(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    arbitragemArtigos(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    participacaoProjetosAprovados(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    consultoriaInstituicoesFomento(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    premiosRecebidos(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Subgrupo 2.2 - Producao Cientifica"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts ""
    arquivo.puts "\\subsection{Produ\\c{c}\\~{a}o Cient\\'{\\i}fica}"
    arquivo.puts "\\vspace{0.3cm}"

    trabalhosPeriodicos(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""
  end

  #TODO
  # Subgrupo 3.1 - Coordenacao e Orientacao
  # Coordenacao e Orientacao de Projetos de Extensao
  def coordenacaoOrientacaoExtensao(arquivo, root)
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item \\textbf{T\\'{\\i}tulo do projeto:} \\\\"
    arquivo.puts "  \\textbf{Fun\\c{c}\\~{a}o no projeto:} \\\\"
    arquivo.puts "  \\textbf{N\\'{u}mero do processo:} \\"
    arquivo.puts "  \\textbf{Financiador/Edital:} \\\\"
    arquivo.puts "  \\textbf{Per\\'{\\i}odo (in\\'{\\i}cio-fim):} \\\\"
    arquivo.puts "  \\textbf{Situa\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "  \\textbf{Natureza:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 3.1 - Coordenacao e Orientacao
  # Coordenacao de Eventos e/ou Conferencista
  def coordenacaoEventosConferencista(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Comiss\\~{a}o Organizadora de Eventos Internacional, Nacional, Regional ou Local}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item  "
    arquivo.puts "\\end{enumerate}"
  end

  # Grupo 3: Atividades de Extensao
  # @arquivo: arquivo latex de destino
  # @ root: elemento raiz do curriculo lattes xml
  def atividadesDeExtensao(arquivo, root)
    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Grupo 3 - Atividades de Extensao"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "\\newpage"
    arquivo.puts "\\section{Atividades de Extens\\~{a}o}"
    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Subgrupo 3.1 - Coordenacao e Orientacao"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts ""
    arquivo.puts "\\subsection{Coordena\\c{c}\\~{a}o e Orienta\\c{c}\\~{a}o}"
    arquivo.puts "\\vspace{0.3cm}"

    coordenacaoOrientacaoExtensao(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Subgrupo 3.2 - Coordenacao de Eventos e Conferencista"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts ""
    arquivo.puts "\\subsection{Coordena\\c{c}\\~{a}o de Eventos e Conferencista}"
    arquivo.puts "\\vspace{0.3cm}"
    
    coordenacaoEventosConferencista(arquivo, root)
  end

  #TODO
  # Subgrupo 4.1 - Atualizacao e Cursos de Capacitacao ou Extenscao na Area de Conhecimento ou Afins com no Minimo 40h
  # 
  def atualizacaoCursosCapacitacao(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Atualiza\\c{c}\\~{a}o e Cursos de Capacita\\c{c}\\~{a}o ou Extens\\~{a}o na \\'{A}rea de Conhecimento ou Afins com no M\\'{\\i}nimo 40h}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts " \\item   \\textbf{Curso:}   \\\\"
    arquivo.puts "         \\textbf{Modalidade:} \\\\"
    arquivo.puts "         \\textbf{Carga Hor\\'{a}ria:}   \\\\"
    arquivo.puts "         \\textbf{Instrutor:} \\\\"
    arquivo.puts "         \\textbf{Institui\\c{c}\\~{a}o:} "
    arquivo.puts "\\end{enumerate}"
  end

  # Grupo 4: Atividades de Formacao e Capacitacao Academica
  # @arquivo: arquivo latex de destino
  # @ root: elemento raiz do curriculo lattes xml
  def atividadesDeFormacaoCapacitacaoAcademica(arquivo, root)
    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Grupo 4 - Atividades de Formacao e Capacitacao Academica"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "\\newpage"
    arquivo.puts "\\section{Atividades de Forma\\c{c}\\~{a}o e Capacita\\c{c}\\~{a}o Acad\\^{e}mica}"
    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    atualizacaoCursosCapacitacao(arquivo, root)
  end

  #TODO
  # Subgrupo 5.1 - Membro de Comissao Temporaria
  # 
  def membroComissaoTemporaria(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Membro de Comiss\\~{a}o Tempor\\'{a}ria}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item   \\textbf{Fun\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "    \\textbf{Comiss\\~{a}o:} \\\\"
    arquivo.puts "    \\textbf{Per\\'{\\i}odo:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 5.2 - Coordenador de Curso Pos-Graduacao strictu sensu
  # 
  def membroComissaoTemporaria(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Coordenador de Curso P\\'{o}s-Gradua\\c{c}\\~{a}o \textbf{strictu sensu}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item   \\textbf{Fun\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "    \\textbf{Per\\'{\\i}odo:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 5.3 - Membro de Nucleo Docente Estruturante
  # 
  def membroNDE(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Membro de N\\'{u}cleo Docente Estruturante}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item   \\textbf{Fun\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "    \\textbf{Per\\'{\\i}odo:} "
    arquivo.puts "\\end{enumerate}"
  end

  #TODO
  # Subgrupo 5.4 - Membro de Colegiado de Curso de Graduacao e Pos-Graduacao
  # 
  def membroColegiadoCurso(arquivo, root)
    arquivo.puts ""
    arquivo.puts "\\subsubsection{Membro de Colegiados de Curso de Gradua\\c{c}\\~{a}o e P\\'{o}s-Gradua\\c{c}\\~{a}o}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\begin{enumerate}"
    arquivo.puts "\\renewcommand{\\labelenumi}{{\\large\\bfseries\\arabic{enumi}.}}"
    arquivo.puts "\\vspace{0.3cm}"
    arquivo.puts ""
    arquivo.puts "\\item   \\textbf{Fun\\c{c}\\~{a}o:} \\\\"
    arquivo.puts "    \\textbf{Per\\'{\\i}odo:} "
    arquivo.puts "\\end{enumerate}"
  end

  # Grupo 5: Atividades Administrativas
  # @arquivo: arquivo latex de destino
  # @ root: elemento raiz do curriculo lattes xml
  def atividadesDeFormacaoCapacitacaoAcademica(arquivo, root)
    arquivo.puts ""
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "% Grupo 5 - Atividades Administrativas"
    arquivo.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    arquivo.puts "\\newpage"
    arquivo.puts "\\section{Atividades Administrativas}"
    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    membroComissaoTemporaria(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    membroNDE(arquivo, root)

    arquivo.puts ""
    arquivo.puts "%------------------------------------------------------------------------------"
    arquivo.puts ""

    membroColegiadoCurso(arquivo, root)
  end
end