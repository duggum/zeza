# see: https://makefiletutorial.com/

# make sure we use zsh
SHELL=/bin/zsh

# output label & colors
tag := \e[37m[\e[38;5;214mzeza\e[37m]:\e[0m
red := \e[31m
grn := \e[32m
ylw := \e[33m
cynb := \e[96m
wht := \e[37m
und := \e[4m
rst := \e[0m

# 'shdoc' to process doc comments
zsd := tools/shdoc/shdoc

# uses version data from the plugin to add version info to README.md
zuv := tools/update_versions

# the output docs
doc_dir := docs
doc_files := zeza.md main.md utils.md

# for versions
readme := README.md

#
# all
#

# don't include clean!
all: docs versions

#
# docs
#
docs: doc_label $(doc_files)

# formatted label for docs
doc_label:
	@printf "\n"
	@printf "%b %b%bCreating Docs%b\n" "$(tag)" "$(wht)" "$(und)" "$(rst)"
	@printf "\n"

# the doc targets and sources
zeza.md: zeza.plugin.zsh
main.md: functions/.zeza_main
utils.md: lib/zeza_utils.leza

# process all
$(doc_files):
	@$(zsd) < $^ > $(doc_dir)/$@
	@printf "\t%b%s %b\t> %b%s%b\n" "$(ylw)" "$^" "$(red)" "$(cynb)" "$@" "$(rst)"

#
# versions
#

# the 'update_versions' script handles the README file so there is no need to
# include it as a prerequisite for the target
versions:
	@$(zuv)

#
# clean
#

# use .PHONY for safety
.PHONY: clean
clean:
	@printf "\n"
	@printf "%b %bCleaning up...%b" "$(tag)" "$(wht)"
	@rm -f $(readme).bak
	@printf "%bDone%b\n" "$(grn)" "$(rst)"
	@printf "\n"
