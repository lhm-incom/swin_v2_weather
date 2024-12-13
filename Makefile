.ONESHELL:

SHELL=/bin/bash
CONDA_ACTIVATE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate
DIR_NAME = $(notdir $(CURDIR))

ifeq (,$(shell which conda))
    CONDA_INSTALLED=False
else
    CONDA_INSTALLED=True
endif	

# to see all colors, run
# bash -c 'for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done'
# the first 15 entries are the 8-bit colors

# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

# set target color
TARGET_COLOR := $(BLUE)
DELIM := "🌍🌏🌎"

POUND = \#

.PHONY: clean test lint pipelines train

.DEFAULT_GOAL := help

colors:
	@echo "${BLACK}BLACK${RESET}"
	@echo "${RED}RED${RESET}"
	@echo "${GREEN}GREEN${RESET}"
	@echo "${YELLOW}YELLOW${RESET}"
	@echo "${LIGHTPURPLE}LIGHTPURPLE${RESET}"
	@echo "${PURPLE}PURPLE${RESET}"
	@echo "${BLUE}BLUE${RESET}"
	@echo "${WHITE}WHITE${RESET}"


install: ## Install project dependencies
ifeq ($(CONDA_INSTALLED), False)
	@echo "${TARGET_COLOR}Please install conda: ${RESET} https://conda.io/projects/conda/en/latest/user-guide/install/index.html"
else
	@echo "${PURPLE}${DELIM} Installing project dependencies ${DELIM}${RESET}"
	conda env create --solver libmamba --file conda.yaml --yes --name $(DIR_NAME)
	($(CONDA_ACTIVATE) $(DIR_NAME); poetry install)	
	@echo ""
	@echo "To activate this environment, use"
	@echo ""
	@echo "${PURPLE}    $$ conda activate $(DIR_NAME)${RESET}"
	@echo ""
endif

clean: ## Delete compiled and cached files
	@echo "${TARGET_COLOR}${DELIM} Cleaning compiled and cached files ${DELIM}${RESET}"
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
	rm -rf .pytest_cache
	rm -rf .cache
	@echo
	find . -type f -name "*.egg-info" -delete
	rm -rf build
	rm -rf dist


lint: ## Lint source code
	@echo "${TARGET_COLOR}${DELIM} Linting project ${DELIM}${RESET}"
	isort . --profile black
	black -l 88 .	
	flake8 . --max-complexity=12 --max-line-length=110 --select=C,E,F,W,B,B950,BLK --ignore=E203,E231,E501,W503 --exclude=.cache


help: ## Print help
	@echo "${BLACK}-----------------------------------------------------------------${RESET}"
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "${TARGET_COLOR}%-30s${RESET} %s\n", $$1, $$2}'
	@echo "${BLACK}-----------------------------------------------------------------${RESET}"

