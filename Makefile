# Derived values (don't change these).
CURRENT_MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_MAKEFILE_DIR := $(patsubst %/,%,$(dir $(CURRENT_MAKEFILE_PATH)))

MMD_DIR := $(CURRENT_MAKEFILE_DIR)
OUTPUT_DIR := $(CURRENT_MAKEFILE_DIR)/output
CONFIG_DIR := $(CURRENT_MAKEFILE_DIR)/configs

# If no target is specified, display help
.DEFAULT_GOAL := help

help:  # Display this help.
	@-+echo "Run make with one of the following targets:"
	@-+echo
	@-+grep -Eh "^[a-z-]+:.*#" $(CURRENT_MAKEFILE_PATH) | sed -E 's/^(.*:)(.*#+)(.*)/  \1 @@@ \3 /' | column -t -s "@@@"

generate: $(OUTPUT_DIR) # Generate the SVGs
	@for mmd in $(MMD_DIR)/*.mmd; do \
		for json in $(CONFIG_DIR)/*.json; do \
			echo "Generating SVG for MMD: $$mmd, Config: $$json"; \
			mmdc -c "$$json" -i "$$mmd" -o "$(OUTPUT_DIR)/$$(basename "$$mmd" .mmd)-$$(basename "$$json" .json).svg" -b transparent; \
		done; \
	done

$(OUTPUT_DIR):
	mkdir -p "$@"

.PHONY: help generate
