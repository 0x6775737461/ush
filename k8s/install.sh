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

			curl -LO \
			"https://dl.k8s.io/release/${kctl_v}/bin/linux/amd64/kubectl" && \
				echo "File downloaded!!" 
		fi

	else
		echo "Are you connected to the internet?"

	fi
}

main() {
	get_bin
}

main "$@"
