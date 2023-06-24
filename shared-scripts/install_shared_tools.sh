#!/bin/zsh

# Banner:
echo " -------- STARTING INSTALL_SHARED_TOOLS.SH"
cd /home/vagrant

# Some globals:
declare -i tools_installed=0
# Cuz I'm queen of making shit complicated, find out who our user is from a safe starting point:
target_user=$(cat /etc/passwd | grep "puppy" | cut -d ":" -f 1)
tools_to_install=("git" "vim")

pain_in_ass_tools=(handle_golang)
	
# Some useful little functions:
check_for_apt_package(){
	# $1 is our package to check:
	check_func=$(apt list --installed 2>/dev/null | grep -c "^$1/")
	echo "               -- checking that $1 doesn't already exist"
	if [[ check_func -eq 0 ]]; then
		installed=0
		echo "               -- $1 not found, installing..."
	else
		installed=1
		echo "               -- $1 already installed, skipping."
	fi
return $installed
}
# check_for_apt_package(){
# 	# $1 is our package to check:
# 	echo "                                      -- checking that $1 doesn't already exist"
# 	if dpkg -s "$1" | grep -q "*not installed"; then
# 		installed=0
# 		echo "                                      -- $1 not found, installing..."
# 	else
# 		installed=1
# 		echo "                                      -- $1 already installed, skipping."
# 	fi
# return $installed
# }

install_apt_package(){
	sudo apt install $1 -y	
}

handle_golang(){
	# Check for golang:
	# go_exists=$(go version | grep )
echo "               -- installing golang..."                           
	sudo ./install_golang.sh
}

cd /home/"$target_user"
echo "          ---- installing tools..."
for t in ${tools_to_install[@]}; do
	# Check for tool:
	check_for_apt_package $t
	result_t=$?

	if [[ $result_t -eq 0 ]]; then
		install_apt_package $t
		tools_installed+=1
	else
		continue
	fi
done

echo "          ---- installing pain in ass tools..."
for pa in ${pain_in_ass_tools[@]}; do
	"$pa"
done

# Finishing up:
cd /home/vagrant
echo " -------- FINISHED: $tools_installed new tools installed."

