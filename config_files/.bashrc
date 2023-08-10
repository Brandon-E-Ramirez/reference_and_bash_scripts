# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#!/bin/sh

##	+-----------------------------------+-----------------------------------+
##	|                                                                       |
##	|                            FANCY BASH PROMT                           |
##	|                                                                       |
##	| Copyright (c) 2018, Andres Gongora <mail@andresgongora.com>.          |
##	|                                                                       |
##	| This program is free software: you can redistribute it and/or modify  |
##	| it under the terms of the GNU General Public License as published by  |
##	| the Free Software Foundation, either version 3 of the License, or     |
##	| (at your option) any later version.                                   |
##	|                                                                       |
##	| This program is distributed in the hope that it will be useful,       |
##	| but WITHOUT ANY WARRANTY; without even the implied warranty of        |
##	| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
##	| GNU General Public License for more details.                          |
##	|                                                                       |
##	| You should have received a copy of the GNU General Public License     |
##	| along with this program. If not, see <http://www.gnu.org/licenses/>.  |
##	|                                                                       |
##	+-----------------------------------------------------------------------+


##
##	DESCRIPTION:
##	This script updates your "PS1" environment variable to display colors.
##	Addicitionally, it also shortens the name of your current part to maximum
##	25 characters, which is quite useful when working in deeply nested folders.
##
##
##
##	INSTALLATION:
##	Copy this script to your home folder and rename it to ".fancy-bash-promt.sh"
##	Run this command from any terminal: 
##		echo "source ~/.fancy-bash-promt.sh" >> ~/.bashrc
##
##	Alternatively, copy the content of this file into your .bashrc file
##
##
##
##	FUNCTIONS:
##
##	* bash_prompt_command()
##	  This function takes your current working directory and stores a shortened
##	  version in the variable "NEW_PWD".
##
##	* format_font()
##	  A small helper function to generate color formating codes from simple
##	  number codes (defined below as local variables for convenience).
##
##	* bash_prompt()
##	  This function colorizes the bash promt. The exact color scheme can be
##	  configured here. The structure of the function is as follows:
##		1. A. Definition of available colors for 16 bits.
##		1. B. Definition of some colors for 256 bits (add your own).
##		2. Configuration >> EDIT YOUR PROMT HERE<<.
##		4. Generation of color codes.
##		5. Generation of window title (some terminal expect the first
##		   part of $PS1 to be the window title)
##		6. Formating of the bash promt ($PS1).
##
##	* Main script body:	
##	  It calls the adequate helper functions to colorize your promt and sets
##	  a hook to regenerate your working directory "NEW_PWD" when you change it.
## 




################################################################################
##  FUNCTIONS                                                                 ##
################################################################################

##
##	ARRANGE $PWD AND STORE IT IN $NEW_PWD
##	* The home directory (HOME) is replaced with a ~
##	* The last pwdmaxlen characters of the PWD are displayed
##	* Leading partial directory names are striped off
##		/home/me/stuff -> ~/stuff (if USER=me)
##		/usr/share/big_dir_name -> ../share/big_dir_name (if pwdmaxlen=20)
##
##	Original source: WOLFMAN'S color bash promt
##	https://wiki.chakralinux.org/index.php?title=Color_Bash_Prompt#Wolfman.27s
##
bash_prompt_command() {
	# How many characters of the $PWD should be kept
	local pwdmaxlen=25

	# Indicate that there has been dir truncation
	local trunc_symbol=".."

	# Store local dir
	local dir=${PWD##*/}

	# Which length to use
	pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))

	NEW_PWD=${PWD/#$HOME/\~}
	
	local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))

	# Generate name
	if [ ${pwdoffset} -gt "0" ]
	then
		NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
		NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
	fi
}




##
##	GENERATE A FORMAT SEQUENCE
##
format_font()
{
	## FIRST ARGUMENT TO RETURN FORMAT STRING
	local output=$1


	case $# in
	2)
		eval $output="'\[\033[0;${2}m\]'"
		;;
	3)
		eval $output="'\[\033[0;${2};${3}m\]'"
		;;
	4)
		eval $output="'\[\033[0;${2};${3};${4}m\]'"
		;;
	*)
		eval $output="'\[\033[0m\]'"
		;;
	esac
}



##
## COLORIZE BASH PROMT
##
bash_prompt() {

	############################################################################
	## COLOR CODES                                                            ##
	## These can be used in the configuration below                           ##
	############################################################################
	
	## FONT EFFECT
	local      NONE='0'
	local      BOLD='1'
	local       DIM='2'
	local UNDERLINE='4'
	local     BLINK='5'
	local    INVERT='7'
	local    HIDDEN='8'
	
	
	## COLORS
	local   DEFAULT='9'
	local     BLACK='0'
	local       RED='1'
	local     GREEN='2'
	local    YELLOW='3'
	local      BLUE='4'
	local   MAGENTA='5'
	local      CYAN='6'
	local    L_GRAY='7'
	local    D_GRAY='60'
	local     L_RED='61'
	local   L_GREEN='62'
	local  L_YELLOW='63'
	local    L_BLUE='64'
	local L_MAGENTA='65'
	local    L_CYAN='66'
	local     WHITE='67'
	
	
	## TYPE
	local     RESET='0'
	local    EFFECT='0'
	local     COLOR='30'
	local        BG='40'
	
	
	## 256 COLOR CODES
	local NO_FORMAT="\[\033[0m\]"
	local ORANGE_BOLD="\[\033[1;38;5;208m\]"
	local TOXIC_GREEN_BOLD="\[\033[1;38;5;118m\]"
	local RED_BOLD="\[\033[1;38;5;1m\]"
	local CYAN_BOLD="\[\033[1;38;5;87m\]"
	local BLACK_BOLD="\[\033[1;38;5;0m\]"
	local WHITE_BOLD="\[\033[1;38;5;15m\]"
	local GRAY_BOLD="\[\033[1;90m\]"
	local BLUE_BOLD="\[\033[1;38;5;74m\]"
	
	
   #RED="\e[31m"
   #LBLUE="\e[1;34m"
   #GREEN="\e[32m"
   #CONE="\e[91m"
   #CTWO="\e[96m"
   #CTHREE="\e[38;5;82m"
   #CFOUR="\e[38;5;198m"
   #BLUE="\e[0;34m"
   #PURPLE="\e[0;35m"
   #ENDCOLOR="\e[0m"	
	
	##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
	  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
	##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## 

	
	
	##                          CONFIGURE HERE                                ##

	
	
	############################################################################
	## CONFIGURATION                                                          ##
	## Choose your color combination here                                     ##
	############################################################################
	local FONT_COLOR_1=$WHITE
	local BACKGROUND_1=$BLUE
	local TEXTEFFECT_1=$BOLD
	
	local FONT_COLOR_2=$WHITE
	local BACKGROUND_2=$L_BLUE
	local TEXTEFFECT_2=$BOLD
	
	local FONT_COLOR_3=$D_GRAY
	local BACKGROUND_3=$WHITE
	local TEXTEFFECT_3=$BOLD
	
	local PROMT_FORMAT=$BLUE_BOLD

	
	############################################################################
	## EXAMPLE CONFIGURATIONS                                                 ##
	## I use them for different hosts. Test them out ;)                       ##
	############################################################################
	
	## CONFIGURATION: BLUE-WHITE
	if [ "$HOSTNAME" = dell ]; then
		FONT_COLOR_1=$WHITE; BACKGROUND_1=$BLUE; TEXTEFFECT_1=$BOLD
		FONT_COLOR_2=$WHITE; BACKGROUND_2=$L_BLUE; TEXTEFFECT_2=$BOLD	
		FONT_COLOR_3=$D_GRAY; BACKGROUND_3=$WHITE; TEXTEFFECT_3=$BOLD	
		PROMT_FORMAT=$CYAN_BOLD
	fi
	
	## CONFIGURATION: BLACK-RED
	if [ "$HOSTNAME" = giraff6 ]; then
		FONT_COLOR_1=$WHITE; BACKGROUND_1=$BLACK; TEXTEFFECT_1=$BOLD
		FONT_COLOR_2=$WHITE; BACKGROUND_2=$D_GRAY; TEXTEFFECT_2=$BOLD
		FONT_COLOR_3=$WHITE; BACKGROUND_3=$RED; TEXTEFFECT_3=$BOLD
		PROMT_FORMAT=$RED_BOLD
	fi
	
	## CONFIGURATION: RED-BLACK
	#FONT_COLOR_1=$WHITE; BACKGROUND_1=$RED; TEXTEFFECT_1=$BOLD
	#FONT_COLOR_2=$WHITE; BACKGROUND_2=$D_GRAY; TEXTEFFECT_2=$BOLD
	#FONT_COLOR_3=$WHITE; BACKGROUND_3=$BLACK; TEXTEFFECT_3=$BOLD
	#PROMT_FORMAT=$RED_BOLD

	## CONFIGURATION: CYAN-BLUE
	if [ "$HOSTNAME" = sharkoon ]; then
		FONT_COLOR_1=$BLACK; BACKGROUND_1=$L_CYAN; TEXTEFFECT_1=$BOLD
		FONT_COLOR_2=$WHITE; BACKGROUND_2=$L_BLUE; TEXTEFFECT_2=$BOLD
		FONT_COLOR_3=$WHITE; BACKGROUND_3=$BLUE; TEXTEFFECT_3=$BOLD
		PROMT_FORMAT=$CYAN_BOLD
	fi
	
	## CONFIGURATION: GRAY-SCALE
	if [ "$HOSTNAME" = giraff ]; then
		FONT_COLOR_1=$WHITE; BACKGROUND_1=$BLACK; TEXTEFFECT_1=$BOLD
		FONT_COLOR_2=$WHITE; BACKGROUND_2=$D_GRAY; TEXTEFFECT_2=$BOLD
		FONT_COLOR_3=$WHITE; BACKGROUND_3=$L_GRAY; TEXTEFFECT_3=$BOLD
		PROMT_FORMAT=$BLACK_BOLD
	fi
	
	## CONFIGURATION: GRAY-CYAN
	if [ "$HOSTNAME" = light ]; then
		FONT_COLOR_1=$WHITE; BACKGROUND_1=$BLACK; TEXTEFFECT_1=$BOLD
		FONT_COLOR_2=$WHITE; BACKGROUND_2=$D_GRAY; TEXTEFFECT_2=$BOLD
		FONT_COLOR_3=$BLACK; BACKGROUND_3=$L_CYAN; TEXTEFFECT_3=$BOLD
		PROMT_FORMAT=$CYAN_BOLD
	fi
	
	
	##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
	  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
	##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## 	

	
	
	
	############################################################################
	## TEXT FORMATING                                                         ##
	## Generate the text formating according to configuration                 ##
	############################################################################
	
	## CONVERT CODES: add offset
	FC1=$(($FONT_COLOR_1+$COLOR))
	BG1=$(($BACKGROUND_1+$BG))
	FE1=$(($TEXTEFFECT_1+$EFFECT))
	
	FC2=$(($FONT_COLOR_2+$COLOR))
	BG2=$(($BACKGROUND_2+$BG))
	FE2=$(($TEXTEFFECT_2+$EFFECT))
	
	FC3=$(($FONT_COLOR_3+$COLOR))
	BG3=$(($BACKGROUND_3+$BG))
	FE3=$(($TEXTEFFECT_3+$EFFECT))
	
	FC4=$(($FONT_COLOR_4+$COLOR))
	BG4=$(($BACKGROUND_4+$BG))
	FE4=$(($TEXTEFFECT_4+$EFFECT))
	

	## CALL FORMATING HELPER FUNCTION: effect + font color + BG color
	local TEXT_FORMAT_1
	local TEXT_FORMAT_2
	local TEXT_FORMAT_3
	local TEXT_FORMAT_4	
	format_font TEXT_FORMAT_1 $FE1 $FC1 $BG1
	format_font TEXT_FORMAT_2 $FE2 $FC2 $BG2
	format_font TEXT_FORMAT_3 $FC3 $FE3 $BG3
	format_font TEXT_FORMAT_4 $FC4 $FE4 $BG4
	
	
	# GENERATE PROMT SECTIONS
	local PROMT_USER=$"$TEXT_FORMAT_1 \u "
	local PROMT_HOST=$"$TEXT_FORMAT_2 \h "
	local PROMT_PWD=$"$TEXT_FORMAT_3 \${NEW_PWD} "
	local PROMT_INPUT=$"$PROMT_FORMAT "


	############################################################################
	## SEPARATOR FORMATING                                                    ##
	## Generate the separators between sections                               ##
	## Uses background colors of the sections                                 ##
	############################################################################
	
	## CONVERT CODES
	TSFC1=$(($BACKGROUND_1+$COLOR))
	TSBG1=$(($BACKGROUND_2+$BG))
	
	TSFC2=$(($BACKGROUND_2+$COLOR))
	TSBG2=$(($BACKGROUND_3+$BG))
	
	TSFC3=$(($BACKGROUND_3+$COLOR))
	TSBG3=$(($DEFAULT+$BG))
	

	## CALL FORMATING HELPER FUNCTION: effect + font color + BG color
	local SEPARATOR_FORMAT_1
	local SEPARATOR_FORMAT_2
	local SEPARATOR_FORMAT_3
	format_font SEPARATOR_FORMAT_1 $TSFC1 $TSBG1
	format_font SEPARATOR_FORMAT_2 $TSFC2 $TSBG2
	format_font SEPARATOR_FORMAT_3 $TSFC3 $TSBG3
	

	# GENERATE SEPARATORS WITH FANCY TRIANGLE
	local TRIANGLE=$'\uE0B0'	
	local SEPARATOR_1=$SEPARATOR_FORMAT_1$TRIANGLE
	local SEPARATOR_2=$SEPARATOR_FORMAT_2$TRIANGLE
	local SEPARATOR_3=$SEPARATOR_FORMAT_3$TRIANGLE



	############################################################################
	## WINDOW TITLE                                                           ##
	## Prevent messed up terminal-window titles                               ##
	############################################################################
	case $TERM in
	xterm*|rxvt*)
		local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
		;;
	*)
		local TITLEBAR=""
		;;
	esac



	############################################################################
	## BASH PROMT                                                             ##
	## Generate promt and remove format from the rest                         ##
	############################################################################
	PS1="$TITLEBAR\n${PROMT_USER}${SEPARATOR_1}${PROMT_HOST}${SEPARATOR_2}${PROMT_PWD}${SEPARATOR_3}${PROMT_INPUT}"

	

	## For terminal line coloring, leaving the rest standard
	none="$(tput sgr0)"
	trap 'echo -ne "${none}"' DEBUG
}




################################################################################
##  MAIN                                                                      ##
################################################################################

##	Bash provides an environment variable called PROMPT_COMMAND. 
##	The contents of this variable are executed as a regular Bash command 
##	just before Bash displays a prompt. 
##	We want it to call our own command to truncate PWD and store it in NEW_PWD

#PROMPT_COMMAND=neofetch
PROMPT_COMMAND=bash_prompt_command

##	Call bash_promnt only once, then unset it (not needed any more)
##	It will set $PS1 with colors and relative to $NEW_PWD, 
##	which gets updated by $PROMT_COMMAND on behalf of the terminal
bash_prompt
unset bash_prompt

#aliases for changing directory (cd)
alias fd='cd /media/yaboi_sakurai/FILES/'
alias school='cd /media/yaboi_sakurai/FILES/#UNIVERSITY-SUM23'
alias library='cd /media/yaboi_sakurai/FILES/LIBRARY'
alias downloads='cd /home/yaboi_sakurai/Downloads'
alias files='cd /home/yaboi_sakurai/files'

#misc packages that need to be run using bash 
alias renpy='/home/yaboi_sakurai/renpy-8.1.1-sdk/renpy.sh'

#bash scripts
alias k='cd'
alias ..='cd ..'
alias c='clear'


#updates and upgrades all system packages
alias renew='sudo apt update && sudo apt upgrade -y'
alias tools='bash /home/yaboi_sakurai/files/tools.sh'
alias monitor='bash /home/yaboi_sakurai/files/monitoring.sh'
alias kanji='bash /home/yaboi_sakurai/files/kanji.sh'
alias colors='bash /home/yaboi_sakurai/files/256-colors.sh'

#misc aids 
alias neofetch='printf " \n" && neofetch'
alias weather='echo -e "Weather and Date: " && date && cal && curl wttr.in'
alias clock='tty-clock'


#system monitoring
alias info='printf "Basic system information:[uname -a, uname -r, uptime, hostname, hostname -I, last reebot]\n" && uname -a && uname -r && uptime && hostname && last reebot && hostname -I && printf " \n"'
alias ls='lsd -Fl -a'
alias ins='sudo apt install'
alias review='sysinfotext info && printf " \n" && printf "Non-volatile storage use: \n" && df && printf "Volatile storage use: \n" && free'
alias pcfetch='neofetch && cpufetch && mem5 && echo -e "" && cpu5'
alias test='procfetch && curl ip-api.com && printf " \n" && echo "Public IP: " && curl ipinfo.io/ip && curl ipaddy.net && echo -e "" && speedtest'

#helper aliases
#alias q='Ctrl Shift q'
alias speedtest='printf " \n" && curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias myip='curl ipinfo.io/ip'
alias mem5='echo -e "********************top five memory hungry processes********************" && ps auxf | sort -nr -k 4 | head -5'
alias cpu5='echo -e "**************top five computationally expensive processes**************" && ps auxf | sort -nr -k 3 | head -5'
alias lorem='printf "https://www.lipsum.com/feed/html: \n Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean fringilla ultricies dignissim. Ut posuere dolor orci, eget commodo nisl pellentesque eget. Quisque bibendum accumsan dapibus. Sed laoreet porttitor viverra. Quisque malesuada eget quam eu ultrices. Suspendisse ut maximus leo. Sed orci eros, auctor et ultricies vitae, efficitur non sem. Quisque mollis luctus dui ac lacinia. Pellentesque vulputate a ex ac cursus. Aliquam sodales ipsum eget maximus lacinia. Suspendisse aliquet sollicitudin ornare. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed sed tristique urna. Sed semper sagittis neque. Curabitur laoreet ante a elit iaculis maximus. Sed condimentum sodales magna. Praesent et mollis eros, in varius est. Donec ornare libero eget pharetra hendrerit. Sed et risus velit. Sed accumsan ut tortor quis accumsan. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris consequat magna vitae massa fermentum, quis varius libero tincidunt. Sed varius risus ac quam pulvinar, aliquet condimentum ligula egestas. Fusce arcu erat, posuere a dolor in, rutrum fermentum sem. Suspendisse ullamcorper ipsum convallis, convallis justo a, imperdiet est. Suspendisse eget ultricies felis, quis vulputate diam. Cras in lectus erat. Sed quis congue purus. Etiam tempus non nisl vitae porta. Curabitur eleifend commodo nibh, quis elementum nisi. Fusce pulvinar bibendum justo, ut tincidunt est ultrices ac. Proin vulputate neque ut neque pulvinar ullamcorper. Donec in massa mi. Nam lectus libero, euismod vitae consequat in, lobortis sed libero. Nam posuere vel ante at pretium. Morbi id mattis nibh, id molestie nulla. Vivamus risus enim, ultricies facilisis laoreet et, gravida nec lectus. Ut non ex ullamcorper, tincidunt nunc vitae, suscipit est. Proin ligula ex, consequat non odio semper, mollis dignissim eros. Duis vehicula ipsum vel ex tincidunt euismod. Vestibulum semper nisl sit amet vestibulum venenatis. Ut nisi libero, aliquam a sapien id, suscipit facilisis sem. Nulla ultricies est id lorem convallis feugiat. Aliquam dignissim justo ex, ut porta diam volutpat et. Pellentesque egestas mauris aliquam lectus dapibus vulputate. Vivamus elit purus, ullamcorper non dolor ut, semper volutpat libero. Cras rhoncus pellentesque consequat. Cras et laoreet purus, non dapibus sem. Sed ornare, leo quis malesuada convallis, diam nisl mattis arcu, sit amet venenatis nisi sem id diam.
\n  Aliquam dui elit, tempor a mi dictum, commodo laoreet elit. Mauris tempor elementum libero ut aliquam. Nulla ac semper est. Vivamus eget euismod nunc. Duis in tortor orci. Curabitur ut augue nunc. Curabitur ligula ex, porttitor sit amet lacus eget, fermentum porta mauris. Morbi pulvinar maximus quam, id rutrum nibh. Mauris velit sem, pulvinar a tortor suscipit, blandit pharetra mauris. Morbi ut rhoncus massa. Aliquam erat volutpat. Nunc in neque et nisl rhoncus convallis eget ac arcu. Pellentesque imperdiet ligula nisi, nec semper felis gravida sit amet. Sed vel tellus dictum neque fringilla rutrum id ut quam. Sed auctor ullamcorper semper. Mauris egestas odio lectus, vitae finibus mi dictum id. Suspendisse non blandit augue, nec vulputate elit. Nulla facilisi. Sed in fermentum turpis. Curabitur tortor justo, condimentum quis elit vitae, iaculis tristique quam. Vestibulum egestas, urna sit amet tempor malesuada, ligula elit auctor nulla, eget posuere arcu est eget felis. Integer posuere, mauris sed faucibus condimentum, dolor mauris pretium enim, in dapibus felis justo ut ligula. Fusce id lacinia tellus. Maecenas feugiat in magna quis vehicula. Vestibulum tempus, nunc eget tristique vulputate, arcu ante iaculis massa, vel commodo felis lectus id justo. Ut pharetra sagittis purus. Praesent tempus placerat eros non hendrerit. Phasellus magna purus, tincidunt in finibus non, suscipit a sem. Mauris vitae tortor vestibulum, sagittis erat in, pellentesque ipsum. Duis eu convallis lacus. Donec efficitur felis urna, non imperdiet metus suscipit a. Cras sit amet dictum enim, vel tristique ex. Cras molestie nulla a justo laoreet malesuada. Duis sollicitudin accumsan laoreet. Pellentesque vitae accumsan nulla. Sed a nisi eu metus cursus feugiat. Quisque pellentesque fermentum velit hendrerit sagittis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Aliquam elementum nunc mi, sed condimentum purus mollis id. Quisque a scelerisque ex. Cras accumsan rutrum dui, sit amet lobortis urna egestas in. Curabitur nulla quam, venenatis eu nibh eget, aliquet suscipit turpis. Maecenas pellentesque quis mi in ultrices. Suspendisse potenti. Aliquam porttitor dignissim felis, vitae suscipit magna luctus at. "'



alias sysinfotext='
printf " \n"
echo -e "${GREEN}███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗    ██╗███╗   ██╗███████╗ ██████╗ ${ENDCOLOR}"
echo -e "${GREEN}██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║    ██║████╗  ██║██╔════╝██╔═══██╗${ENDCOLOR}"
echo -e "${GREEN}███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║    ██║██╔██╗ ██║█████╗  ██║   ██║${ENDCOLOR}"
echo -e "${GREEN}╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║    ██║██║╚██╗██║██╔══╝  ██║   ██║${ENDCOLOR}"
echo -e "${GREEN}███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║    ██║██║ ╚████║██║     ╚██████╔╝${ENDCOLOR}"
echo -e "${GREEN}╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝    ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ ${ENDCOLOR}"
'


export PATH=$PATH:/home/yaboi_sakurai/.cargo/bin
### EOF ###

neofetch

#export PATH="/Directory1:/home/yaboi_sakurai/.cargo/bin"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
