#!/bin/sh
#assemble and preprocess all the sources files

pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/pre.tex
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/intro.tex

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --lua-filter=comment.lua --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to latex > latex/"$(basename "$filename" .txt).tex"
done

pandoc text/epi.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/epi.tex

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"
done

pandoc latex/pre.tex latex/intro.tex -o latex/tempintro.tex

pandoc latex/ch0* -o latex/tempchp.tex

pandoc latex/apx* -o latex/tempapx.tex

pandoc latex/epi.tex latex/tempapx.tex -o latex/tempend.tex

pandoc -s latex/tempintro.tex latex/tempchp.tex latex/tempend.tex -o latex/book.tex

rm latex/temp*

sed -i 's/Figure/Εικόνα/g' ./latex/book.tex

sed -i 's/\.\.\/i/i/g' latex/book.tex

pandoc -N --variable mainfont=FreeSerif --variable fontsize=12pt --variable version=1.0 latex/book.tex --pdf-engine=xelatex --toc --toc-depth=2 -o book.pdf
