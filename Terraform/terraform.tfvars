region = "ap-south-1" # Set your own region

ami_id = "ami-0d60cff8925d28dad" # Set a Ubuntu os(arm64)

profile = "Kube" # Config this profile in aws

controlplane_instance = "t4g.medium"

worker_instance = "t4g.medium"

public_key = "## COPY YOUR SSH KEY HERE"

worker_nodes = 2 # Enter you desired number
