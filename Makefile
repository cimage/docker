# ---------------------------------------------------------------------------
#
# General setup
#

# Detect OS
OS = $(shell uname -s)

# Defaults
ECHO = echo

# Make adjustments based on OS
ifneq (, $(findstring CYGWIN, $(OS)))
	ECHO = /bin/echo -e
endif

# Colors and helptext
NO_COLOR	= \033[0m
ACTION		= \033[32;01m
OK_COLOR	= \033[32;01m
ERROR_COLOR	= \033[31;01m
WARN_COLOR	= \033[33;01m

# Which makefile am I in?
WHERE-AM-I = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_MAKEFILE := $(call WHERE-AM-I)

# Echo some nice helptext based on the target comment
HELPTEXT = $(ECHO) "$(ACTION)--->" `egrep "^\# target: $(1) " $(THIS_MAKEFILE) | sed "s/\# target: $(1)[ ]*-[ ]* / /g"` "$(NO_COLOR)"

# target: help                    - Displays help with targets available.
.PHONY:  help
help:
	@$(call HELPTEXT,$@)
	@echo "Usage:"
	@echo " make [target] ..."
	@echo "target:"
	@egrep "^# target:" Makefile | sed 's/# target: / /g'



# ---------------------------------------------------------------------------
#
# Specifics
# 
D  := docker
DC := docker-compose



# target: build                   - Build the docker images.
.PHONY: build
build:
	@$(call HELPTEXT,$@)
	#--no-cache=true 
	$(D) build --file php71/Dockerfile --tag cimage/php71-apache:latest php71
	$(D) build --file php70/Dockerfile --tag cimage/php70-apache:latest php70
	$(D) build --file php56/Dockerfile --tag cimage/php56-apache:latest php56
 


# target: push                    - Push the docker images to Docker cloud.
.PHONY: push
push:
	@$(call HELPTEXT,$@)
	$(D) push cimage/php71-apache:latest
	$(D) push cimage/php70-apache:latest
	$(D) push cimage/php56-apache:latest
