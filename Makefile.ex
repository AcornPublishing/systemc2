#!/usr/bin/make -f
# COPYRIGHT (C) 2004 Eklectic Ally, Inc.---------------------------{{{#
# See EKLECTIC_LICENSE for information on legal usage of this file.   #
# -----------------------------------------------------------------}}}#
#
# NOTE TO THE READER:
# This Makefile is used to automate the examples as a package. It is
# reasonably complex, only needed for overall automation/regression
# purposes. It is not necessary for to understand this file for the
# examples. If you wish to understand a `make' itself, you may find
# this interesting.

ifeq "$(old)" ""
ifeq "$(new)" ""
ifeq "$(update)" ""
ifeq "$(wildcard ./EKLECTIC_LICENSE)" ""
ifeq "$(wildcard ../EKLECTIC_LICENSE)" ""
DEFAULT:
	@banner ERROR
	@echo 'ERROR: Missing required EKLECTIC_LICENSE file!?';
	@perl -e 'exit 1';
else
DEFAULT: $(notdir $(shell pwd))
endif
else
DEFAULT: help
endif

# The following is a list of target examples
# and is used in part to generate the 'all' target
EXAMPLES:=\
  Fork\
  Hello_SystemC\
  adapt\
  addition\
  async_mem\
  bit_ops\
  buffer_ex\
  ch\
  clock_gen\
  connections\
  convertible\
  danger_ex\
  datatypes\
  engine_time\
  extras\
  equalizer_ex\
  eval_update\
  event_filled\
  export_ex\
  fifo_fir\
  fifo_of_ptr\
  fifo_of_smart_ptr\
  function_template\
  gas_station\
  heartbeat\
  hier_chan\
  interrupt\
  jalopy\
  lfsr_ex\
  logic\
  manage\
  method_delay\
  method_fifo_fir\
  mutex_ex\
  next_trigger\
  pcix\
  primitive\
  processor\
  resolved_ex\
  sedan\
  semaphore_ex\
  shift_register\
  signal_ex\
  simple_process_ex\
  simple_spawn\
  sparse_memory_map\
  static_error\
  static_sensitivity\
  switch\
  time_flies\
  tracing\
  turn_of_events\
  uni_string_rep\
  varports\
  wave\
  EOL

# The following is a list of incomplete examples and
# is for the developer only. These may or may not be
# released at a later date.
INSITU:=\
  CBus\
  complete\
  cpp_interface\
  cthreads\
  infinite_ex\
  my_interface\
  report\
  start\
  video_mix\
  waiting\
  EOL

VERSION=0.9
ZIPARCH=SCFTGU_examples-$(VERSION).zip
TARBALL=SCFTGU_examples-$(VERSION).tgz
TPATT=Makefile *.h *.cpp *.c *.v *.dat *.scr *.cfg *.inc
TARLIST =       \
  EKLECTIC_LICENSE \
  README        \
  CHANGES       \
  Makefile      \
  Makefile.defs \
  Makefile.ex   \
  bin/systemc_version \
  $(wildcard $(foreach i,$(filter-out EOL,$(EXAMPLES) templates),$(foreach j,$(TPATT),$i/$j)))

EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)
RULER:=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
define BANNER
  echo "$(RULER)";
  echo "# EXAMPLE: $1 $(CFLAGS)"
  echo "$(RULER)";
endef
ifdef MODULE
export MODULE
endif
ifdef MODULE
export SRCS
endif

.PHONY: help hello $(filter-out EOL,$(EXAMPLES) $(INSITU)) \
        all ALL insitu INSITU log sum tar zip version clean

help:
	@echo "$(RULER)"
	@echo "Choose target from:"
	@echo "  all clean hello $(filter-out EOL,$(EXAMPLES)) help" | fmt
	@echo "$(RULER)"

dev devel: help
	@echo "  insutu tar zip $(filter-out EOL,$(INSITU))"
	@echo "  make [nocvs=] new=NAME"
	@echo "  make update=NAME"
	@echo "$(RULER)"

version:
	$(MAKE) -f $(RULES) version

all: ALL hello $(filter-out EOL,$(EXAMPLES))
	$(MAKE) DIRS="$(filter-out EOL,$(EXAMPLES))" SUMMARY=all.log log
	@echo "All done"

ALL:
	@$(call BANNER,ALL)
	@echo ""; echo ""

insitu: INSITU $(filter-out EOL,$(INSITU))
	$(MAKE) DIRS="$(filter-out EOL,$(INSITU))" SUMMARY=insitu.log log
	@echo "Insitu done"

INSITU:
	@$(call BANNER,INSITU)
	@echo ""; echo ""

log:
	@$(call BANNER,Logging)
	@echo "Logging to $(SUMMARY) from $(DIRS)"; echo ""
	@-rm -f $(SUMMARY)
	@for dir in $(DIRS); do                   \
          for log_file in $$dir/*.log; do         \
            echo "TEST: $$log_file" >>$(SUMMARY); \
            cat $$log_file >>$(SUMMARY);          \
            echo "" >>$(SUMMARY);                 \
          done;                                   \
        done

CPATT:=*.o *.x *.log *\#* *.deps *.vvp
SPATT:=*.vcd *.vpd *.awif vcd*.sav
CLEAN:=$(wildcard $(foreach i,. *,$(foreach j,$(CPATT),$i/$j)))
SUPER:=$(wildcard $(foreach i,. *,$(foreach j,$(SPATT),$i/$j)))
clean:
	@$(call BANNER,Clean)
ifneq "$(CLEAN)" ""
	rm -f $(CLEAN)
else
	@echo "Already clean"
endif

superclean: clean
ifneq "$(SUPER)" ""
	rm -f $(SUPER)
else
	@echo "Nothing left"
endif

# List tarlist
tarlist:
	@echo $(TARLIST)

# Calculate checksums
sum: list.md5
list.md5: $(TARLIST)
	@rm -f list.cksum list.md5
	cksum $(TARLIST) > list.cksum
	md5   $(TARLIST) > list.md5
	chmod a=r list.cksum list.md5

# Create a design zip archive for distribution
zip: $(ZIPARCH)
$(ZIPARCH): sum $(TARLIST)
	@-rm -f $@
	cd .. && zip $(addprefix Examples/,$(ZIPARCH) $(TARLIST) list.cksum list.md5)
	chmod a+r $@
	@echo "INFO: Created $@"

# Create a design tarball for distribution
tar: $(TARBALL)
$(TARBALL): sum $(TARLIST)
	@-rm -f $@
	cd .. && tar czf $(addprefix Examples/,$(TARBALL) $(TARLIST) list.cksum list.md5)
	chmod a+r $@
	@echo "INFO: Created $@"

# Call `make' to do the actual work and record the results in a log file.
# The real work is accomplished in Makefile.defs located by Makefile.
# Compilications arise because this may be executed either in the actual
# directory or one above.
$(filter-out EOL,$(EXAMPLES) $(INSITU)):
	@$(call BANNER,$@)
	if [ -d $@ ]; then \
	$(MAKE) -C $@ -f ../Makefile MODULE=$@ $(DFLT) 2>&1 | tee $@/$@.log; \
	else\
	$(MAKE) -f ./Makefile MODULE=$@ $(DFLT) 2>&1 | tee $@.log; \
	fi
	@echo $(RULER);echo "Created $@.log";

###############################################################################
# Special cases (non-SystemC targets)
###############################################################################
hello: $(addprefix Hello_SystemC/,Hello_C.x Hello_Cpp.x Hello_Verilog.log) Hello_SystemC

HCLOG=Hello_SystemC/Hello_C.log
Hello_SystemC/Hello_C.x: Hello_SystemC/Hello_C.c
	@$(call BANNER,$@)
	@echo "gcc $(CFLAGS) -o $@ $?" >$(HCLOG)
	gcc $(CFLAGS) -o $@ $? 2>&1 | tee -a $(HCLOG)
	@echo "./$@"           >>            $(HCLOG)
	./$@                   2>&1 | tee -a $(HCLOG)

HPLOG=Hello_SystemC/Hello_Cpp.log
Hello_SystemC/Hello_Cpp.x: Hello_SystemC/Hello_Cpp.cpp
	@$(call BANNER,$@)
	@echo "g++ $(CPPFLAGS) -IHello_SystemC/ -o $@ $?" >$(HPLOG)
	g++ $(CPPFLAGS) -IHello_SystemC/ -o $@ $? 2>&1 | tee -a $(HPLOG)
	@echo "./$@"           >>            $(HPLOG)
	./$@                   2>&1 | tee -a $(HPLOG)

VPATT:=verilog iverilog vcs ncverilog
VEXEC:= $(wildcard $(foreach d,$(subst :, ,$(PATH)),$(foreach x,$(VPATT),$d/$x)))
VLOG:=$(firstword $(VEXEC))

Hello_SystemC/Hello_Verilog.log: Hello_SystemC/Hello_Verilog.v
	@$(call BANNER,$@)
ifeq "$(notdir $(VLOG))" ""
	@echo "WARNING: No verilog simulator found" | tee $@
else
	@echo "INFO: Using $(VLOG)" | tee $@
endif
ifeq "$(notdir $(VLOG))" "verilog"
	@echo "verilog $?" >> $@
	verilog $? 2>&1 | tee -a $@
endif
ifeq "$(notdir $(VLOG))" "iverilog"
	@echo "iverilog -o $?vp $?" >> $@
	iverilog -o $?vp $? 2>&1 | tee -a $@
	@echo "vvp $?vp" >> $@
	vvp $?vp 2>&1 | tee -a $@
endif
ifeq "$(notdir $(VLOG))" "ncverilog"
	@echo "ncverilog -x $?" >> $@
	ncverilog -x $? 2>&1 | tee -a $@
endif
ifeq "$(notdir $(VLOG))" "vcs"
	@echo "vcs -R $?" >> $@
	vcs -R $? 2>&1 | tee -a $@
endif

E%:
	@-rm -f static_error/*.o
	$(MAKE) CFLAGS=-DE$* static_error

else
# update example
DEFAULT:
	@$(call BANNER,Update)
	env DESCRIPTION="$(update) example for book" \
	PROJECT_NAME="SystemC: From the Ground Up" \
        add_copyright -cpp  -published $(update)/$(update).h
	add_copyright -cpp  -published $(update)/$(update).cpp
	add_copyright -cpp  -published $(update)/main.cpp
	add_copyright -make -published $(update)/Makefile
  endif
else
# new example
DEFAULT:
	@$(call BANNER,New)
	mkdir $(new)
	rsync -C -av TEMPLATE/ $(new)/
	mv $(new)/TEMPLATE.cpp $(new)/$(new).cpp
	mv $(new)/TEMPLATE.h   $(new)/$(new).h  
	perl -pi -e 's/TEMPLATE/$(new)/g' $(new)/$(new).* $(new)/main.cpp $(new)/Makefile
	perl -pi -e 's/$(new)_H/\U$$&\E/' $(new)/$(new).h
	perl -pi -e 'if($$l){$$o=$$_;s/  [[:word:]]+/$$o  $(new)/;$$l=0}elsif(m/INSITU:=/){$$l=1}' Makefile.ex
	perl -pi -e 'if(/^INSITU:=/../EOL$$/){if(/EOL$$/){print sort@L}elsif(!/INSITU/){push@L,$$_;$$_=""}}' Makefile.ex
ifndef nocvs
	cvs add $(new)
	cvs add $(new)/[Ma-z]*
endif
endif
else
# rename old=new
FILES=$(1)/main.cpp $(1)/$(1).h $(1)/$(1).cpp
CP=rsync -lptgo
DEFAULT:
	@$(call BANNER,Rename)
	@echo "Renaming '$(old)' to '$(new)'"
	@echo "- Copying dirs/files"
	mkdir $(new)
	$(CP) $(old)/Makefile $(new)/
	$(CP) $(old)/*.cpp    $(new)/
	$(CP) $(old)/*.h      $(new)/
	-$(CP) $(old)/$(old).cfg $(new)/$(new).cfg
	-$(CP) $(old)/$(old).dat $(new)/$(new).dat
	@echo "- Correcting filenames"
	-mv $(new)/$(old).h   $(new)/$(new).h
	-mv $(new)/$(old).cpp $(new)/$(new).cpp
	@echo "- Fixing internals"
	gsub $(old)=$(new) Makefile.ex $(call FILES,$(new))
ifndef nocvs
	@echo "- Adding to CVS"
	cvs add $(new)
	cvs add $(new)/Makefile $(call FILES,$(new))
	cvs rm  $(old)/main.cpp
endif
	@echo "- DONE"
endif

# COPYRIGHT (C) 2004 Eklectic Ally, Inc.---------------------------{{{#
# See EKLECTIC_LICENSE for information on legal usage of this file.   #
# -----------------------------------------------------------------}}}#
#END $Id: Makefile.ex,v 1.53 2004/05/07 13:52:39 dcblack Exp $
