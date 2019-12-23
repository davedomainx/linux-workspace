Run these when installing a new plugin
:source %
:PluginInstall

:CocConfig
:verbose imap

==
Install puppet-language syntax support in vim

https://voxpupuli.org/blog/2019/04/08/puppet-lsp-vim/
==

Needs vim 8.1
http://www.theubuntumaniac.com/2018/09/install-vim-810374-on-ubuntu-1604-1804.html

sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update
sudo apt-get upgrade vim # will upgrade to 8.1

==

https://github.com/neoclide/vim-node-rpc

Install yarn:
https://linux4one.com/how-to-install-yarn-on-ubuntu-18-04/

Then run:
yarn global add vim-node-rpc

Once all are installed run ":PlugInstall" in vimrc

==

$ git clone https://github.com/lingua-pupuli/puppet-editor-services.git
$ cd puppet-editor-services
$ sudo apt-get install ruby-dev # required for below
$ bundle install

mkmf.rb can't find header files for ruby at /usr/lib/ruby/include/ruby.h

sudo apt-get install ruby-dev

Performance Cops will be removed from RuboCop 0.68. Use rubocop-performance gem instead.

Put this in your Gemfile.

  gem 'rubocop-performance'

And then execute:

  $ bundle install

Put this into your .rubocop.yml.

  require: rubocop-performance

More information: https://github.com/rubocop-hq/rubocop-performance

vim +CocConfig
	adjust paths to own environment

==
Bash Language Server

vimrc:
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

