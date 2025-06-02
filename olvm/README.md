# Install Oracle Linux Virtualization Manager in Oracle Cloud Infrastructure (OCI)

This sample includes a series of playbooks that:

- Deploy the OCI resources for an Oracle Linux Virtualization Manager installation
  - Virtual Private Network (VCN), Subnets, VLAN (L2), etc.
  - An engine and several KVM hosts
  - Block Storage

- Provisions a 3-node (default) Oracle Linux Virtualization Manager installation using the included `defaults_vars.yml` file.

## Prerequisites

- Ansible Core (< 2.16 due to compatibility with Python 3.6 in Oracle Linux 8)
- Oracle Cloud Infrastructure SDK for Python
- Ovirt Python SDK version 4
- Python modules - jmespath, passlib
- Access to an OCI tenancy with the proper resources
- SSH public and private key pair for use to connect to the OCI instances

The easiest way to do this is using a Python Virtual environment. For example, on macOS:

1. Create a directory for the virtual environment.

   ```shell
   mkdir python-env
   cd python-env
   ```

1. Create the Python virtual environment.

   ```shell
   python3 -m venv ansible2.16
   ```

1. Activate the Python virtual environment.

   ```shell
   source ansible2.16/bin/activate
   ```

1. Install Ansible in the virtual environment.

   ```shell
   python3 -m pip install ansible-core==2.16
   ```

1. Verify the installation.

   ```shell
   ansible --version
   ```

   The output should report the version as 2.16 if everything installs correctly.

1. Install the OCI SDK for Python

   ```shell
   pip install oci
   ```

1. Install the oVirt 4 Python SDK

   ```shell
   pip install ovirt-engine-sdk-python
   ```

1. Install Jmespath and Passlib Python modules.

   ```shell
   pip install jmespath
   pip install passlib
   ```

## Instructions

1. Create a custom variables file.

   Rather than modify the `default_vars.yml` file directly, create a new YAML custom variables file. Provide values specific to your tenancy and environment.

   > ```text
   > ad_placement: <Enter the OCI Availability Domain to use [1,2,3]>
   > compartment_id: <Enter the OCID for the compartment within your tenancy>
   > private_key: <Enter the name of your SSH key without the extension>
   > ```

   - The `private_key` variable defaults to looking for the file `id_rsa` in your local users $HOME/.ssh directory
   - If your OCI configuration file om `~/.oci/config` has multiple profiles, then also set the variable `oci_config_section` to the profile name.

   > Sample:
   >
   > ```shell
   > cat << EOF | tee sample.yml > /dev/null 
   > ad_placement: 2 
   > compartment_id: "ocid1.compartment.oc1..aaa..............zzz" 
   > private_key: "my_sshkey" 
   > EOF
   > ```

1. Install the required collections:

   ```shell
   ansible-galaxy collection install -r requirements.yml
   ```

1. (Optional) Create an inventory file for localhost.

   The control node requires this step in environments that use non-venv environments for Python and Ansible to ensure that Ansible can find the OCI and oVirt modules.

   ```shell
   cat << EOF | tee hosts > /dev/null
   localhost ansible_connection=local ansible_connection=local ansible_python_interpreter=/usr/bin/python3.6
   EOF
   ```

1. Deploy the environment.

   ```shell
   ansible-playbook create_instance.yml -e "@<name of custom vars file>.yml"
   ```

   You can pass extra variables or variable files on the `ansible-playbook` command line using `-e` or `--extra-vars`. Ansible treats these variables as having the highest precedence and reads them from the command line from left to right.

   > Sample:
   >
   > ```shell
   > ansible-playbook create_instance.yml -e "@sample.yml" -e debug_enabled=true
   > ```

## Install Oracle Linux Virtualization Engine

The `default_vars.yml` file contains several variables that enable you to automate steps in the setup and configuration of Oracle Linux Virtualization Manager. Here is a list of those variables and what they do:

- **install_engine:** Runs the *provision_olvm_engine.yml* playbook, which installs the packages for the engine and KVM hosts and then executes `engine-setup`.
- **copy_engine_publickey:** Runs the *provision_olvm_engine_publickey.yml* playbook, which copies the engine public key to each KVM host.
- **config_olvm:** Runs a series of *ovirt* playbooks that configure Oracle Linux Virtualization Manager based on the steps provided in the associated [lab](https://luna.oracle.com/lab/c912c867-a5cd-420e-9ee5-ee9017b2b957).

## Related Links

Explore our other tutorials and labs on our [Oracle Linux Training Station](www.oracle.com/goto/oltrain).
