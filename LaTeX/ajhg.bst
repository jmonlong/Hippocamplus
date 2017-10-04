%% File: `ajhg.bst'
%% A merge of the `unsrtnat.bst' from natbib (https://www.ctan.org/tex-archive/macros/latex/contrib/natbib/)
%% and the `cell.bst' from https://www.ctan.org/tex-archive/macros/latex/contrib/cell. It provides AJHG style and
%% the reference ordered as they appear in the text. To use with '\usepackage[comma,super]{natbib}' for example.
%%
%% In addition to the cell/unsrt merge, I removed the emphasis on the Journal/Book name to fit AJHG style.
%%
%% The number of displayed authors before it switches to "et al." can be specified by changing the lines
%% with 'max.num.names.before.forced.et.al' and 'num.names.shown.with.forced.et.al'. Change the current value (10)
%% into the desired number.
%%
%% DISCLAIMER: I merged the two .bst without deep understanding of the system. It seems to work fine but I'd recommend checking the output.
%%
ENTRY
  { address
    author
    booktitle
    chapter
    doi
    eid
    edition
    editor
    howpublished
    institution
    isbn
    issn
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    url
    volume
    year
  }
  {}
  { label extra.label sort.label short.list }

INTEGERS { output.state before.all mid.sentence after.sentence after.block docomma }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  
  #0 'docomma :=    % if it is 0 then don't do commas, otherwise do them.
}

STRINGS { s t }


FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
% "in of output.nonnull" warning$

% %    { ", " * write$ }  % the comma here is responsible for every comma!
% %                       % But JMB doesn't want commas, so away it goes!
%      { " " * write$ }    % That does it!

    { % doing a comma is controlled specifically in JMB using docomma
      docomma #0 =
      { " " * write$ }
      { ", " * write$ }
      if$
    }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
% "out of output.nonnull" warning$
}
% FUNCTION {output.nonnull}
% { 's :=
%   output.state mid.sentence =
%     { ", " * write$ }
%     { output.state after.block =
%         { add.period$ write$
%           newline$
%           "\newblock " write$
%         }
%         { output.state before.all =
%             'write$
%             { add.period$ " " * write$ }
%           if$
%         }
%       if$
%       mid.sentence 'output.state :=
%     }
%   if$
%   s
% }

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
% "in output.check" warning$
  duplicate$ empty$
     {  t "title" =
           { pop$ } % jmb ignores titles and does not object if missing
           { pop$ "empty " t * " in " * cite$ * warning$ }
        if$
     }
    'output.nonnull  % block periods
    % { pop$  } % don't do anything
  if$
% "ouT of output.check" warning$
}
% FUNCTION {output.check}
% { 't :=
%   duplicate$ empty$
%     { pop$ "empty " t * " in " * cite$ * warning$ }
%     'output.nonnull
%   if$
% }

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "\emph{" swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

INTEGERS { max.num.names.before.forced.et.al num.names.shown.with.forced.et.al }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  #10 'max.num.names.before.forced.et.al :=
  #10 'num.names.shown.with.forced.et.al :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}{, jj}{, f.}" format.name$ 't :=   % last name first
      nameptr #1 >
        { nameptr num.names.shown.with.forced.et.al #1 + =
          numnames max.num.names.before.forced.et.al >
          and
            { "others" 't :=
              #1 'namesleft :=
            }
            { skip$ }
          if$
          namesleft #1 >
            { ", " * t * }
            { t "others" =
                { " " * "et~al." emphasize * }
                { numnames #2 >
                    { "," * }
                    { skip$ }
                  if$
                  " and " * t *
                }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
        { ", editors" * }
        { ", editor" * }
      if$
    }
  if$
}

FUNCTION {format.isbn}
{ isbn empty$
    { "" }
    { new.block "ISBN " isbn * }
  if$
}

FUNCTION {format.issn}
{ issn empty$
    { "" }
    { new.block "ISSN " issn * }
  if$
}

FUNCTION {format.url}
{ "" }
%%{ url empty$
%%    { "" }
%%    { new.block "URL \url{" url * "}" * }
%%  if$
%%}

FUNCTION {format.doi}
{ "" }
%%{ doi empty$
%%    { "" }
%%    { new.block "\doi{" doi * "}" * }
%%  if$
%%}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$ }
  if$
}

FUNCTION {format.full.names}
{'s :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv~}{ll}" format.name$ 't :=
      nameptr #1 >
        {
          namesleft #1 >
            { ", " * t * }
            {
              numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {author.editor.full}
{ author empty$
    { editor empty$
        { "" }
        { editor format.full.names }
      if$
    }
    { author format.full.names }
  if$
}

FUNCTION {author.full}
{ author empty$
    { "" }
    { author format.full.names }
  if$
}

FUNCTION {editor.full}
{ editor empty$
    { "" }
    { editor format.full.names }
  if$
}

FUNCTION {make.full.names}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.full
    { type$ "proceedings" =
        'editor.full
        'author.full
      if$
    }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  ")" make.full.names duplicate$ short.list =
     { pop$ }
     { * }
   if$
  "]{" * write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.date}
{ " (" year * "{\rm{" extra.label "}}" * * * ")" * % TDS emphasized label
  % " (" * year * ")"
  % year duplicate$ empty$
  %   { "empty year in " cite$ * warning$
  %      pop$ "" }
  %   'skip$
  % if$
  % month empty$
  %   'skip$
  %   { month
  %     " " * swap$ *
  %   }
  % if$
  % extra.label *
}

FUNCTION {output.year.check}
{ year empty$
    {
      "empty year in " cite$ ", using label: " extra.label * * * warning$
      write$
%      " (" extra.label * ")" * % TDS UNemphasized label

% zzz here is the problem:
% extra.label "BLURB" * warning$
      " ({\rm{" extra.label * "}})" * % TDS emphasized label
% "BLORB" warning$

    { label "{\rm{" extra.label "}}" * * * 'label :=}
% "BLUBEL" warning$

      mid.sentence 'output.state :=
% "BLIP" warning$
    }
    { write$

%      " (" year * extra.label * ")" * % TDS UNemphasized label
      " (" year * "{\rm{" extra.label "}}" * * * ")" * % TDS emphasized label

      mid.sentence 'output.state :=
    }
  if$
% "POW" warning$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "volume" volume tie.or.space.connect
      series empty$
        'skip$
        { " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { "number" }
            { "Number" }
          if$
          number tie.or.space.connect
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { " in " * series * }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { edition "l" change.case$ " edition" * }
        { edition "t" change.case$ " edition" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { "pages" pages n.dashify tie.or.space.connect }
        { "page" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.eid}
{ eid empty$
    { "" }
    { "art." eid tie.or.space.connect }
  if$
}

FUNCTION {format.vol.num.pages}
% { "{\rm " volume "}" * * field.or.null  % make volume bold face
{ "\emph{" volume "}" * * field.or.null  % make volume italics 2009 jul 11

% cell does not take numbers
%  number empty$
%    'skip$
%%    { " (" number * ")" * *
%    { " ({\em " number "\/}" * * ")" * * % CELL IS ITALICS
%% zzz
%       volume empty$
%	{ "there's a number but no volume in " cite$ * warning$ }
%	'skip$
%      if$
%    }
%  if$

  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
%	{ ":" * pages n.dashify * } % no more colons after the volume
	{ ", " * pages n.dashify * } % comma's instead
      if$
    }
  if$
}

FUNCTION {format.vol.num.eid}
{ volume field.or.null
  number empty$
    'skip$
    { "\penalty0 (" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  eid empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.eid }
        { ":\penalty0 " * eid * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "chapter" }
        { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "In " booktitle * }
        { "In " format.editors * ", " * booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { "In \emph{" journal * "}" * }
      if$
    }
    { "In " }
  if$
  " \citet{" * crossref * "}" *
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "In "
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { "\emph{" * series * "}" * }
          if$
        }
        'skip$
      if$
    }
    'skip$
  if$
  " \citet{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { "In \emph{" booktitle * "}" * }
          if$
        }
        { "In " }
      if$
    }
    { "In " }
  if$
  " \citet{" * crossref * "}" *
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.check					% apalike
  %  format.date "year" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    {
      journal #-1 #1 substring$ "." =
	{ journal }  % journal ended in period so don't do anything
	%      { journal ", " *}  % journal ended without period, so add comma
	{ journal " " *}  % journal ended without period, so add comma NONE FOR CELL
      if$
      "journal" output.check
      % journal "journal" output.check
      % format.vol.num.pages output
      eid empty$
        { format.vol.num.pages output }
        { format.vol.num.eid output }
      if$
      % format.date "year" output.check
    }
    { format.article.crossref output.nonnull
      format.pages output
      % eid empty$
      %   { format.pages output }
      %   { format.eid output }
      % if$
    }
  if$
  % format.issn output
  % format.doi output
  % format.url output
  % new.block
  % note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  output.year.check				% special for apalike
  new.block
  format.btitle "title" output.check
  #1 'docomma :=    % TURN COMMAS ON FOR JMB
  crossref missing$
    {
      format.bvolume output
      new.block
      format.number.series output
      format.edition output % TDS JMB position for edition
%      new.sentence
%         #0 'docomma := % no comma after address
%      address ":" * output % TDS
      publisher "publisher" output.check % TDS
%         #1 'docomma := % comma back on
%      publisher "publisher" output.check
%      address output
      address output % TDS - no colon!
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
%  format.edition output % TDS original position of edition
  new.block
  note output
  fin.entry
  #0 'docomma :=    % TURN COMMAS OFF
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  author format.key output				% special for
  output.year.check					% apalike
  new.block
  format.title "title" output.check
  new.block
  howpublished output
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  output.year.check				% special for apalike
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
         #0 'docomma := % no comma after address
      address ":" * output % TDS
      publisher "publisher" output.check % TDS
         #1 'docomma := % comma back on
%      publisher "publisher" output.check
%      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  author format.key output				% special for
  output.year.check					% apalike
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      publisher "publisher" output.check
      address output
      format.edition output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  author format.key output				% special for
  output.year.check					% apalike
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    {
%      #1 'docomma :=    % TURN COMMAS ON FOR JMB, BUT NOT FOR JTB: inconsistent. TDS NOW
      format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages
        pages empty$
          { output }
          { "," * output } % TDS toss in comma instead of period
        if$

%      address output % TDS address is below for JTB
%      new.sentence % TDS remove period
      organization output
         #0 'docomma := % NO COMMA AFTER ADDRESS
      publisher "publisher" output.check % TDS
         #1 'docomma := % comma back on

%      publisher output					% are simpler
      address output % TDS
      #0 'docomma :=    % TURN COMMAS OFF
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  format.authors output
  author format.key output				% special for
  output.year.check					% apalike
  new.block
  format.btitle "title" output.check
  organization address new.block.checkb
  organization output
  address output
  format.edition output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output				% special for
  output.year.check					% apalike
  new.block
  format.title "title" output.check
  new.block
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  author format.key output				% special for
  output.year.check					% apalike
  new.block
  format.title output
  new.block
  howpublished output
  new.block
  note output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output				% special for
  output.year.check					% apalike
  new.block
  format.btitle "title" output.check
  new.block
  "PhD thesis," format.thesis.type output.nonnull
  school "school" output.check
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  format.editors output
  editor format.key output				% special for
  output.year.check					% apalike
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address output				% for apalike
  new.sentence					% we always output
  organization output				% a nonempty organization
  publisher output				% here
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  author format.key output				% special for
  output.year.check					% apalike
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  author format.key output				% special for
% "===> about to unpuBLISH" warning$
  output.year.check					% apalike
% "===> out of to unpuBLISH" warning$
  new.block
% "===> PLEASE PLEASE BE HERE" warning$

% Since format.title is out of commission, the original method won't work:
%  format.title "title" output.check
% so do the equivalent of the format.title procedure: (TDS)
  title empty$
    { "" }
    { title "t" change.case$ } % produce the title
  if$
% "===> perfidity 1" warning$
  "title" output.check
% "===> perfidity" warning$

  new.block
  note "note" output.check
  fin.entry

% "===> GOlly done" warning$
}

FUNCTION {default.type} { misc }


MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}



MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}


READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {format.lab.names}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " and " * s #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.short.authors}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.organization.label
        { type$ "manual" =
            'author.key.organization.label
            'author.key.label
          if$
        }
      if$
    }
  if$
  'short.list :=
}

FUNCTION {calc.label}
{ calc.short.authors
  short.list
  "("
  *
  year duplicate$ empty$
  short.list key field.or.null = or
     { pop$ "" }
     'skip$
  if$
  *
  'label :=
}

INTEGERS { seq.num }

FUNCTION {init.seq}
{ #0 'seq.num :=}

EXECUTE {init.seq}

FUNCTION {int.to.fix}
{ "000000000" swap$ int.to.str$ *
  #-1 #10 substring$
}


FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  seq.num #1 + 'seq.num :=
  seq.num  int.to.fix
  'sort.label :=
  sort.label *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label last.label next.extra }

INTEGERS { longest.label.width last.extra.num number.label }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
  #0 'number.label :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'next.extra :=
  extra.label
  duplicate$ empty$
    'skip$
    { "{\natexlab{" swap$ * "}}" * }
  if$
  'extra.label :=
  label extra.label * 'label :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {bib.sort.order}
{ sort.label  'sort.key$ :=
}

ITERATE {bib.sort.order}

SORT

FUNCTION {begin.bib}
{   preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{" number.label int.to.str$ * "}" *
  write$ newline$
  "\providecommand{\natexlab}[1]{#1}"
  write$ newline$
  "\providecommand{\url}[1]{\texttt{#1}}"
  write$ newline$
  "\expandafter\ifx\csname urlstyle\endcsname\relax"
  write$ newline$
  "  \providecommand{\doi}[1]{doi: #1}\else"
  write$ newline$
  "  \providecommand{\doi}{doi: \begingroup \urlstyle{rm}\Url}\fi"
  write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
