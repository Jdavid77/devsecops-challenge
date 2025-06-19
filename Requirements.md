We would like to deploy a VM with k3s inside in GCP. k3s should have a container running with a REST API. No need to make your own container. You can use this one (https://github.com/eaccmk/node-app-http-docker). Since we are quite crazy about security we would like to make sure that only our trusted container can run on that k3s. 
Some requirements:
- everything should be deployed via pipelines in github
- you should use GCP project
- the code needs to be stored in Github
- you should use as much as possible infra as code
- the VM cannot have a public IP but we would like to access it
- even if I have access to the VM, I should not be able to deploy any other containers
- all containers running on the application should be vetted by the pipeline
- it would be nice to have authentication (bonus question)