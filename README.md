
# Demo AWS infrastructure
## Terraform setup

Current configuration contain end-to-end setup of AWS infrastructure based on terraform. Configuration have splited to several scripts to achieve indepandece between "Infrastructure" and "Application" levels.
However it could be run  from scratch by simple wrappers. 

### Data structure

**bin**       - shell wrappers to simplify execution
**live**      - terraform scripts from all components
**modules**   - local modules
**nonpublic** - contain ssh key pair for ec2 instances

### Requirement

1. *terraform* version  *0.11* or later
2. *aws cli* configured 

### SetUP

- To create infrastructure from scratch please run the following command:
```
#!bash
    $ ./bin/deploy_from_cracth.sh
```
By default infrastructure will be created in *eu-west-1* region. It can be easily changed via *-var awd-region=REGION* variable
 
- To destroy demo infrastructure lease run the following command:
```
#!bash
    $ ./bin/destroy.sh
```
