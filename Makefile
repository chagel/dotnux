DOTS := $(shell ls dots)
CONFIGS := $(shell ls configs)
BASE := $(shell pwd)

all: init link 

init: 
	## make .config folder
	@mkdir -pv ${HOME}/.config

link:
	## link dotfile under ${HOME} and ${XDG_CONFIG_HOME}
	@for item in $(DOTS); do ln -vsfn ${BASE}/dots/$$item ${HOME}/.$$item; done
	@for item in $(CONFIGS); do ln -vsfn ${BASE}/configs/$$item ${HOME}/.config/$$item; done
	## link vim 
	@ln -vsfn ${BASE}/dotbase/nvim ${HOME}/.config/nvim
	## link tmux
	@ln -vsfn ${BASE}/dotbase/tmux ${HOME}/.tmux
	@ln -vsf ${BASE}/dotbase/tmux/tmux.conf ${HOME}/.tmux.conf

tmux-setup:
	## config tmux 
	@rm -rf ${HOME}/.tmux/plugins/tpm
	@git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

tmux-update:
	## update tmux plugins 
	~/.tmux/plugins/tpm/bin/install_plugins
	~/.tmux/plugins/tpm/bin/update_plugins all
