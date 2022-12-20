### ====================================================================
### [30-Jul-2005]
### ====================================================================

prefix		= /usr/local

CP		= /bin/cp -p

INSTDIRS	= $(prefix)/share/lib/tex/inputs \
		  $(prefix)/share/lib/tex/latex \
		  $(prefix)/share/lib/tex/latex2e/unpacked

LATEX		= latex
LATEX		= latex2e

LN		= /bin/ln -f

LS		= ls

RM		= /bin/rm -f

SHELL		= /bin/sh

TEX		= tex

### ====================================================================

LTXFILES	= tepsf2.ltx

TEXFILES	= tepsf1.tex  tepsf3.tex

### ====================================================================

all:
	@echo There is nothing to build in this directory.

check:	check-latex check-tex

check-latex:
	for f in $(LTXFILES) ; \
	do \
		$(LATEX) $$f ; \
		$(LS) -l `basename $$f .ltx`.* ; \
	done

check-tex:
	for f in $(TEXFILES) ; \
	do \
		$(TEX) $$f ; \
		$(LS) -l `basename $$f .tex`.* ; \
	done

clean:
	-$(RM) *.aux
	-$(RM) *.dvi
	-$(RM) *.log
	-$(RM) *~
	-$(RM) \#*
	-$(RM) a.out
	-$(RM) core core.*

clobber:	distclean

distclean:	mostlyclean

maintainer-clean:	distclean
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."

mostlyclean: clean

install:	uninstall
	for d in $(INSTDIRS) ; \
	do \
		$(CP) epsf.tex $$d/epsf.tex ; \
		$(LN) $$d/epsf.tex $$d/epsf.sty ; \
	done

uninstall:
	for d in $(INSTDIRS) ; \
	do \
		$(RM) $$d/epsf.tex $$d/epsf.sty ; \
	done
