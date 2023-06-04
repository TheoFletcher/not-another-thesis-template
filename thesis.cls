% TODO: Formatting for mathematical environments
% - Theorem, corrolary, lemma, etc

% TODO: More control of different fonts on the title page
%   - e.g.: Change font of title and author individually

% TODO: copyright page
% TODO: optionally include supervisor's name

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2023/06/01 v0.1 Not another thesis template]

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}

\makeatletter

% --------------------------------------------------------------- %
% OPTIONS
% --------------------------------------------------------------- %

% Some options don't seem to work with PassOptionsToClass
% Assigning the options to a variable and passing to LoadClass is a work-around
\newcommand{\@setoption}[2]{%
    \DeclareOption{#1}{\renewcommand{#2}{#1}}
}

% Font size
\newcommand{\@fontsize}{}
\@setoption{10pt}{\@fontsize}
\@setoption{11pt}{\@fontsize}
\@setoption{12pt}{\@fontsize}
\ExecuteOptions{12pt}

% Paper size
\newcommand{\@papersize}{}
\@setoption{a4paper}{\@papersize}
\@setoption{letterpaper}{\@papersize}
\@setoption{a5paper}{\@papersize}
\@setoption{b5paper}{\@papersize}
\@setoption{executivepaper}{\@papersize}
\@setoption{legalpaper}{\@papersize}
\@setoption{a4paper}{\@papersize}
\ExecuteOptions{a4paper}

% One or two sided
\newif\iftwoside
\DeclareOption{oneside}{%
    \PassOptionsToClass{\CurrentOption}{book}
    \PassOptionsToPackage{left=3cm,right=3cm}{geometry}
    \twosidefalse
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{\CurrentOption}{book}
    \PassOptionsToPackage{twoside,inner=4cm,outer=2cm}{geometry}
    \twosidetrue
}
\ExecuteOptions{oneside}

% Start chapter on any page or right page
\DeclareOption{openany}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{openright}{\PassOptionsToClass{\CurrentOption}{book}}
\ExecuteOptions{openright}

% Other base class options
\DeclareOption{fleqn}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{leqno}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption*{\OptionNotUsed}

% Line spacing
\newcommand{\@linespacing}{}
\newcommand{\quotespacing}{}
\DeclareOption{singlespacing}{%
    \renewcommand{\@linespacing}{\singlespacing}
    \renewcommand{\quotespacing}{\singlespacing}
}
\DeclareOption{onehalfspacing}{%
    \renewcommand{\@linespacing}{\onehalfspacing}
    \renewcommand{\quotespacing}{\onehalfspacing}
}
\DeclareOption{doublespacing}{%
    \renewcommand{\@linespacing}{\doublespacing}
    \renewcommand{\quotespacing}{\onehalfspacing}
}
\ExecuteOptions{doublespacing}


\ProcessOptions*
\let\@setoption\undefined

\LoadClass[\@fontsize,\@papersize,titlepage]{book}
\RequirePackage[\@papersize,top=3cm,bottom=3cm,headheight=15pt]{geometry}
\let\@fontsize=\undefined
\let\@papersize=\undefined

\RequirePackage{setspace}
\@linespacing
\let\@linespacing\undefined


% --------------------------------------------------------------- %
% PAGE STYLES
% --------------------------------------------------------------- %

\RequirePackage{textcase}
\RequirePackage{fancyhdr}

\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% Returns the raw text for the chapter mark
% - if there is no chapter number:     "(name)"
% - if there is a number but not name: "Chapter (number)"
% - if there is a number and a name:   "(number) (name)"
\newcommand{\@chaptermarktext}[1]{%
    \ifnum\c@secnumdepth>\m@ne  % if chapter numbering turned on
        \if@mainmatter          % if in mainmatter
            \ifx\empty#1\empty  % if argument (chapter title) is empty
                \chaptername\ \thechapter
            \else
                \thechapter\quad #1
            \fi
        \else
            #1
        \fi
    \else
        #1
    \fi
}
\renewcommand{\chaptermark}[1]{%
    \markboth{\MakeTextUppercase{\@chaptermarktext{#1}}}%
             {\MakeTextUppercase{\@chaptermarktext{#1}}}%
}

\renewcommand{\sectionmark}[1]{%
    \markright{\MakeTextUppercase{\thesection\quad #1}}%
}

% TODO: producing warnings when using onesided mode, 
%       need some kind of toggle here for onesided and twosided options
\fancypagestyle{fancy}{%
    \fancyhf{}
    \iftwoside
        \fancyhead[LO]{\footnotesize\rightmark}
        \fancyhead[RO]{\thepage}
        \fancyhead[LE]{\thepage}
        \fancyhead[RE]{\footnotesize\leftmark}    
    \else
        \fancyhead[L]{\footnotesize\rightmark}
        \fancyhead[R]{\thepage}
    \fi
}

\fancypagestyle{plain}{%
    \fancyhf{}
    \iftwoside
        \fancyhead[RO]{\thepage}
        \fancyhead[LE]{\thepage}
    \else
        \fancyhead[R]{\thepage}
    \fi
}

% Redefine cleardoublepage such that, if it creates an extra page, it is empty
\let\@oldcleardoublepage\cleardoublepage
\renewcommand{\cleardoublepage}{%
    \clearpage\thispagestyle{empty}\@oldcleardoublepage 
}

\pagestyle{fancy}
\raggedbottom


% --------------------------------------------------------------- %
% TEXT ENVIRONMENTS
% --------------------------------------------------------------- %

\newcommand{\quotefont}{}

\let\@oldquote\quote
\let\@oldendquote\endquote
\renewenvironment{quote}{\@oldquote\quotespacing\quotefont}{\@oldendquote}

\let\@oldquotation\quotation
\let\@oldendquotation\endquotation
\renewenvironment{quotation}{\@oldquotation\quotespacing\quotefont}{\@oldendquotation}

\let\@oldverse\verse
\let\@oldendverse\endverse
\renewenvironment{verse}{\@oldverse\quotespacing\quotefont}{\@oldendverse}


% --------------------------------------------------------------- %
% SECTION HEADINGS
% --------------------------------------------------------------- %

\RequirePackage{titlesec}

% Section depth - this will number part, chapter, section and subsection
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}

% Default font for all headings
\newcommand{\headingfont}{\rmfamily}

% Part
\newcommand{\partfont}{\headingfont}
\titleformat{\part}[display]%
  {\filcenter\Huge\partfont}%
  {\rmfamily\fontsize{48pt}{60pt}\selectfont\thepart}{0pt}%
  {\thispagestyle{empty}\MakeUppercase}

% Chapter
\newcommand{\chapterfont}{\headingfont}
\titleformat{\chapter}[display]%
  {\filcenter\singlespacing\large\scshape\chapterfont}%
  {\MakeUppercase{\chaptertitlename~\thechapter}}{10pt}%
  {\LARGE}
\titlespacing*{\chapter}{0pt}{10pt}{40pt}

% Section
\newcommand{\sectionfont}{\headingfont}
\titleformat{\section}%
  {\filcenter\singlespacing\large\scshape\sectionfont}{\thesection}{1em}{}

% Subsection
\newcommand{\subsectionfont}{\headingfont}
\titleformat{\subsection}%
    {\large\bfseries\subsectionfont}{\thesubsection}{1em}{}

% Subsubsection
\newcommand{\subsubsectionfont}{\headingfont}
\titleformat{\subsubsection}%
    {\bfseries\subsubsectionfont}{}{}{}

% Paragraph
\newcommand{\paragraphfont}{\headingfont}
\titleformat{\paragraph}[runin]%
    {\bfseries\paragraphfont}{}{}{}

% Subparagraph
\newcommand{\subparagraphfont}{\headingfont}
\titleformat{\subparagraph}[runin]%
    {\itshape\subparagraphfont}{}{}{}


% --------------------------------------------------------------- %
% TITLE PAGE
% --------------------------------------------------------------- %

% Variables that feature on the title page
\renewcommand{\title}[1]{ \def\@title{#1} }
\renewcommand{\author}[1]{ \def\@author{#1} }
\providecommand{\subtitle}[1]{ \def\@subtitle{#1} }
\providecommand{\institution}[1]{ \def\@institution{#1} }
\providecommand{\department}[1]{ \def\@department{#1} }
\providecommand{\documenttype}[1]{ \def\@documenttype{#1} }

% Set default values
\title{}
\subtitle{}
\author{}
\institution{}
\department{}
\documenttype{}
\date{\today}

% Used to create standard text for the document type
\providecommand{\forthedegreeof}[1]{%
    A thesis submitted for the degree of \\ \textsl{#1}%
}

% Displays a crest or logo at the top of the titlepage
\providecommand{\maketitlecrest}{}

% TODO: More control of fonts for each line on the title page
\renewcommand{\maketitle}{%
    \begin{center}

        \thispagestyle{empty}
        \setlength{\parindent}{0pt}
        \onehalfspacing

        \vspace*{50pt}
        \maketitlecrest

        \vspace{100pt}
        
        {\LARGE \@title}  \leavevmode\\[0.5\baselineskip]
        {\large \@subtitle}  \leavevmode\\[50pt]
        \vfill
        
        {\Large \textsc \@author}  \leavevmode\\[0.5\baselineskip]
        {\@department}  \leavevmode\\
        {\@institution} 
        \vfill
        
        {\@documenttype}  \leavevmode\\[\baselineskip]
        {\large \bfseries \@date}
        \vfill
    
    \end{center}
    \clearpage
    \let\maketitle\relax%
}


% --------------------------------------------------------------- %
% TABLE OF CONTENTS
% --------------------------------------------------------------- %

\RequirePackage[titles]{tocloft}

\let\@oldtoc\tableofcontents
\renewcommand{\tableofcontents}{{\onehalfspacing\@oldtoc}}
%\renewcommand{\cftdot}{}

% Change parts to be large and uppercase in the TOC
% This won't work by just adding MakeUppercase to cftpartfont
% Must completely redefine \l@part
% Arugment #2 is intentionally not forwarded,
% because this prevents the page number from being printed
\let\oldl@part\l@part
\renewcommand*{\l@part}[2]{\oldl@part{\MakeUppercase{#1}}{#2}}
\renewcommand{\cftpartfont}{\large}
\cftpagenumbersoff{part}

\let\@oldlistoffigures\listoffigures
\renewcommand{\listoffigures}{%
    \addcontentsline{toc}{chapter}{List of Figures}
    {\quotespacing\@oldlistoffigures}
}
\setlength{\cftbeforefigskip}{0.5\baselineskip}

\let\@oldlistoftables\listoftables
\renewcommand{\listoftables}{%
    \addcontentsline{toc}{chapter}{List of Tables}
    {\quotespacing\@oldlistoftables}
}
\setlength{\cftbeforetabskip}{0.5\baselineskip}

% TODO: Automatic formatting for custom lists using tocloft and \newlistof


% --------------------------------------------------------------- %
% FRONTMATTER AND BACKMATTER
% --------------------------------------------------------------- %

\newenvironment{abstract}{%
    \begin{center}
        \onehalfspacing
        {\LARGE \@title}  \leavevmode\\[0.2\baselineskip]
        {\large \@subtitle}  \leavevmode\\[20pt]
        {\Large \textsc \@author}  \leavevmode\\
        {\@institution} \leavevmode\\[20pt]
        {\@documenttype} \leavevmode\\[30pt]
    \end{center}
    \thispagestyle{empty}
    \begin{quotation}
    \normalfont
}{%
    % blank line to put date on a new line
    
    {\hfill \textsl \@date}
    \end{quotation}
    \vfill
}

\newenvironment{dedication}{%
    \clearpage
    \thispagestyle{empty}
    \vspace*{\stretch{1}}
    \centering\doublespacing
}{%
    \vspace*{\stretch{3}}
    \clearpage
}

\newenvironment{acknowledgements}[1][Acknowledgements]{%
    \chapter*{#1}
    \thispagestyle{empty}
    \begin{quotation}
    \normalfont
}{%
    \end{quotation}
}

\let\@oldappendix\appendix
\renewcommand{\appendix}{%
    \cleardoublepage
    \@oldappendix
    \part*{Appendices}
}


% --------------------------------------------------------------- %
% FLOATS, FIGURES AND TABLES
% --------------------------------------------------------------- %

\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{booktabs}  % Table formatting

\RequirePackage[%
    %labelsep=endash,
    justification=centerlast,
    margin=12pt,
    font={singlespacing,small},labelfont={bf}
    ]{caption}


% --------------------------------------------------------------- %
% MATHEMATICS
% --------------------------------------------------------------- %

\RequirePackage{amsmath,amsfonts,amssymb}
\RequirePackage{physics}

\renewcommand{\vec}[1]{\boldsymbol{#1}}


% --------------------------------------------------------------- %
% REFERENCING AND METADATA
% --------------------------------------------------------------- %

\RequirePackage[hidelinks]{hyperref}

\RequirePackage{cleveref}
\crefname{subappendix}{section}{sections}
\Crefname{subappendix}{Section}{Sections}

\let\@oldeqref\eqref
\renewcommand{\eqref}[1]{Eq.~\@oldeqref{#1}}

% Change footnotes to used symbols instead of letters
\renewcommand*{\thefootnote}{\fnsymbol{footnote}}

\AtBeginDocument{\hypersetup{
    pdfauthor={\@author},
    pdftitle={\@title}
}}

\makeatother