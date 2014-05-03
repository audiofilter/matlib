TOPDIR = Opt
SUBDIRS = @CTProcess Doc examples @Lattice @LinConstr @NDProcess \
	@optArray @optGenSequence @optQuad @optQuadVector \
	@optSequence @optVector @Process @Region @SOCConstr
EXT := mexglx
CC = mex
MEXFILES += ./wherein.$(EXT) @CTProcess/private/pwrengine.$(EXT) \
	@NDProcess/private/pwrengine.$(EXT) \
	@NDProcess/private/ImpulseTime.$(EXT) \
	@optArray/private/fourierEngine.$(EXT) 
TEXFILES += usersguide.tex affine.tex CTfcn.tex design.tex latfcn.tex \
	linfcn.tex ndpfcn.tex oafcn.tex oqfcn.tex oqvfcn.tex \
	osfcn.tex ospfcn.tex ovfcn.tex process.tex procfcn.tex \
	regfcn.tex region.tex SOCfcn.tex  topfcn.tex
# solnfcn.tex
DOCFILE = usersguide
DOCDIR = Doc
.PHONY: doc

all : $(MEXFILES)

%.$(EXT) : %.c
	(cd $(@D); mex $(<F))

clean :
	for i in $(SUBDIRS) $(addsuffix /private,$(SUBDIRS)); do \
		(cd $$i; \
		rm -f *.m~; \
		rm -f *.c~;); \
	done

doc : $(DOCDIR)/$(DOCFILE).pdf

$(DOCDIR)/$(DOCFILE).pdf : $(addprefix $(DOCDIR)/,$(TEXFILES))
	(cd $(DOCDIR); \
	latex $(DOCFILE).tex; \
	latex $(DOCFILE).tex; \
	dvips -Ppdf -o $(DOCFILE).ps $(DOCFILE); \
	ps2pdf $(DOCFILE).ps $(DOCFILE).pdf;) 

dist:
	(cd ..; \
	 tar czvf Opt/opt.tar.gz \
	  --exclude=CVS --exclude="*.tex" --exclude="*.log" \
	  --exclude="*.aux" --exclude="*~" --exclude="*.mex*" \
          --exclude="*.eps" --exclude="*.dvi" --exclude="*.ps" \
	  --exclude="*.doc" --exclude="*.mat" \
         Opt )
