.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: copy-rc-additions ## apply all configs

copy-rc-additions:
	@cp .rc_additions ~/.rc_additions

zshrc: ## append "source .rc_additions" to ~/.zshrc
	@echo "source .rc_additions" >> ~/.zshrc
	@echo "bindkey \"^[[1;5D\" backward-word" >> ~/.zshrc
	@echo "bindkey \"^[[1;5C\" forward-word" >> ~/.zshrc
	@source ~/.zshrc

bashrc: ## append "source .rc_additions" to ~/.bashrc
	@echo "source .rc_additions" >> ~/.bashrc
	@source ~/.bashrc
