# Install Oracle Cloud Native Environment in Oracle Cloud Infrastructure (OCI)

This sample includes a series of playbooks that:

 - help deploy the OCI resources for an Oracle Cloud Native Environment installation

   - Virtual Private Network (VCN), Subnet, etc.
   - Compute instances with public IP address
   - (Optional) File System Storage
   - (Optional) Load Balancer

 - provision a 4-node (default) Oracle Cloud Native Environment using the included `defaults_vars.yaml` file.
 
# Instructions

To run the sample, after ensuring that you have the prerequisites for OCI Ansible Collection, please create a new YAML variables file and provide values for the following that are specific to your tenancy.
 
 > ```text
 > ad_placement: <Enter the OCI Availability Domain to use [1,2,3]>
 > compartment_id: <Enter the OCID for the compartment within your tenancy>
 > private_key: <Enter the name of your SSH key without the extension>.
 > ```

 Playbook defaults to looking for the file `id_rsa` in your $HOME/.ssh directory> 

 > Sample:
 > 
 > ```shell
 > cat << EOF | tee sample.yaml > /dev/null 
 > ad_placement: 2 
 > compartment_id: "ocid1.compartment.oc1..aaa..............zzz" 
 > private_key: "my_sshkey" 
 > EOF
 > ``` 

Install the required collections:

 ```shell
 ansible-galaxy collection install -r requirements.yaml
 ```

Deploy the lab environment by running the following:

 ```shell
 ansible-playbook create_instance.yaml -e "@<name_of_new_YAML_vars_file>.yaml"
 ```

You can pass extra variables or variable files on the `ansible-playbook` command line using `-e` or `--extra-vars`. Ansible treats these variables as having the highest precedence and reads them from the command line from left to right.

 > Sample:
 > 
 > ```shell
 > ansible-playbook create_instance.yaml -e "@sample.yaml" -e debug_enabled=true
 > ```

# More Learning Resources

Explore our other tutorials and labs on our [Oracle Linux Training Station](www.oracle.com/goto/oltrain).