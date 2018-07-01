# AWS Cloudformation HA LAMP Web Services Demo

AWS Cloudformation HA LAMP Web Services Demo

## Getting Started

This is demo Cloudformation setup for making autoscaled HA Frontend/Backend based LAMP infrastructure. The MySQL server is also running on Amazon RDS.

### Prerequisites

Requires Amazon Web CLI (aws-cli):

```
pip install python-awscli
```
Also requires working administrative credentials for applying Cloudformation templates with various resources.

### Installing

The structure is as follows:

1) 2 separated templates for setting up networking and server stack
2) The network stack installation have to be run before spinning up web servers stack
3) There are helper scripts which allow to run all steps
4) The SSH key "webservices" is looked up in the AWS account. This is required for ec2-user SSH access. If you are using different key please reference name on "SecurityKey" variable it in parameters.json file.

```
* first_bootstrap.sh - Sets up Network stack with VPC and install servers stack
* setup_network_stack.sh - Sets up VPC and Network stack
* setup_lamp_stack.sh - Sets up LAMP stack
* remove_stacks.sh - Purges LAMP and Networking stacks from AWS
* cloudformatrion.sh - Multipurpose aws-cli wrapper. Allows convienent execution of AWS tasks for installing/updating/status/deleting of stacks. Requires template and parameter files as arguments.
                       Limitation: Expects VPcId in parameters json file for stack name for automatic stack naming.

```

After setting up LAMP HA stack the Cloudformation console outputs tab will have Load Balancer URLs for Frontend and Backend Web servers.

## Things todo for improvement

At the moment the templates are setting up static PHP demo pages. For automated CI deployments the S3 buckets need to be created and web-services template need modification for web code deployment.
For managed Web pages configuration with tools such as Ansible/Puppet/Chef the additional hooking scripts need to be written.
The networking stack is using simple layout structure and the additional networks are set for future develpment.
The VPN (OpenVPN or AWS builtin) solution or Bastion server stack need to be added for locking down remote access.

## Built With

* Bash shell scripting
* AWS Cloudformation templates
* mcedit Text editor

## Authors

* **Arunas Pranckevicius** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Credits for:
* Amazon Cloudformation templates documatation
* Cloudformation templates from multiple contributors in GitHub
