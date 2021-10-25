#!/bin/bash

# install kubectl

# getting kubectl golang binary
get_bin() {
	# u know other host? change it
	#TODO: lock stdout instead do i/o op
	if ping -q4c 1 google.com 1>/dev/null; then

		echo "The file have aproximately 50MiB, you want to download? [y/n]"

		local opt
		read -r opt

		if [ "$opt" = 'y' ]; then
			# kubectl version
			local kctl_v 
			kctl_v=$(curl -L -sS https://dl.k8s.io/release/stable.txt)

			if [ ! -e 'kubectl' ]; then
				curl -LO \
				"https://dl.k8s.io/release/${kctl_v}/bin/linux/amd64/kubectl"
			fi

			checksum "$kctl_v"
		fi

	else
		echo "Are you connected to the internet?"
	fi
}

checksum() {
	if [ ! -e 'kubectl.sha256' ]; then
		curl -LO -sS \
		"httpS://dl.k8s.io/${1}/bin/linux/amd64/kubectl.sha256"
	fi

	# inserting target file
	sed  -E "s/^[[:xdigit:]]{64}$/\0 *kubectl/" kubectl.sha256 -i

	# doing checksum
	sha256sum --quiet -c kubectl.sha256 && \
		echo "Valid file!" && inst_local
}

inst_local() {
	echo 'Installing on ~/.local/bin/kubectl'

	mkdir -p ~/.local/bin/kubectl/bin

	mv kubectl.sha256 ~/.local/bin/kubectl/

	chmod ug+x kubectl
	mv kubectl ~/.local/bin/kubectl/bin/

	add_path
}

# add binary command to path
add_path() {
	echo 'export PATH="${PATH}:/${HOME}/.local/bin/kubectl/bin"' \
	>> ~/.bashrc
	source ~/.bashrc
}

main() {
	get_bin
}

main "$@"
