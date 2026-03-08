# Create your inventory file

import json
import socket

def is_reachable(host, port=22, timeout=2):
    """
    Works perfectly on Windows, Mac, and Linux.
    No sudo required.
    """
    try:
        # We try to open a TCP connection
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except (socket.timeout, ConnectionRefusedError, OSError):
        return False

ctrpl_content = "[control-plane]"
wrk_content = "[worker-nodes]"

tfstate = open('Terraform/terraform.tfstate', 'r')
con = tfstate.read()
output = json.loads(con)
for entry in output['resources']:
     if entry['type'] == 'aws_instance':
         for instance in entry['instances']:
             tags = instance['attributes'].get('tags', '')
             ip = instance['attributes'].get('public_ip', '')
             if is_reachable(instance['attributes']['public_ip']):
                 print(f'{ip} is reachable adding to inventory file')
                 if 'control' in tags['Name'] :
                    ctrpl_content += f'\n{tags['Name']} ansible_host={ip}'
                 elif 'worker' in tags['Name'] :
                    wrk_content += f'\n{tags['Name']} ansible_host={ip}'
             else: 
                 print('ip is not reachable')

file_content = "#Kubernetes node info" + '\n\n' + ctrpl_content + '\n\n' +  wrk_content

# Write to the inventory file
with open('Ansible/inventory.ini', 'w') as inventory:
  inventory.write(file_content)
