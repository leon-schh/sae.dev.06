# Docker Swarm Deployment and Testing

This project demonstrates the deployment and testing of a microservice using Docker Swarm and Ansible. The microservice is built using Tornado and includes various stages such as provisioning, deployment, testing, and destruction of VMs on a Proxmox VE server.

## Table of Contents

- [Deploying the Microservice](#deploying-the-microservice)
- [Running Tests](#running-tests)
- [Destroying VMs](#destroying-vms)
- [CI/CD Pipeline](#cicd-pipeline)
- [License](#license)


## Deploying the Microservice

The microservice is deployed using Ansible playbooks. The `build_playbook.yaml` and `playbook.yml` files contain the necessary tasks for deployment.

1. Ensure Ansible is installed:

    ```bash
    $ sudo apt-get install ansible
    ```

2. Run the Ansible playbook to deploy the microservice:

    ```bash
    $ ansible-playbook -i inventory.ini build_playbook.yaml
    ```

## Running Tests

The project includes various tests such as static type checking, linting, unit tests, and code coverage.

1. Run static type checker:

    ```bash
    $ mypy ./addrservice ./tests
    ```

2. Run linter:

    ```bash
    $ flake8 ./addrservice ./tests
    ```

3. Run unit tests:

    ```bash
    $ python -m unittest discover tests -p '*_test.py'
    ```

4. Run code coverage:

    ```bash
    $ coverage run --source=addrservice --branch -m unittest discover tests -p '*_test.py'
    $ coverage report
    $ coverage html
    ```

## Destroying VMs

The `destroy.sh` script destroys the provisioned VMs on the Proxmox VE server.

1. Run the destroy script:

    ```bash
    $ chmod +x provisioning/docker-swarm/destroy.sh
    $ provisioning/docker-swarm/destroy.sh
    ```

## CI/CD Pipeline

The project includes a GitLab CI/CD pipeline defined in the `.gitlab-ci.yml` file. The pipeline includes stages for testing, provisioning, deployment, and destruction of VMs.

### Stages

- **destroy**: Destroys the existing VMs.
- **deploy**: Provisions new VMs and deploys the microservice.
- **test**: Runs static type checking, linting, unit tests, and code coverage.
- **image-test**: Runs compliance and security checks on the Docker image.
- **deploy_swarm**: Deploys the microservice to Docker Swarm.
- **api_test**: Runs API tests to verify the microservice functionality.

### Example CI/CD Configuration

```yaml
stages:
  - destroy
  - deploy
  - test
  - image-test
  - deploy_swarm
  - api_test

variables:
  PROXMOX_HOST: "10.129.4.100"
  PROXMOX_USER: "toto"
  PROXMOX_PASSWORD: "Jaaaj!0"

destroy:
  stage: destroy
  image: alpine:latest
  before_script:
    - apk add --no-cache bash wget
  script:
    - chmod +x [destroy.sh](http://_vscodecontentref_/0)
    - [destroy.sh](http://_vscodecontentref_/1)

deploy:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache bash wget
  script:
    - chmod +x [provisioning.sh](http://_vscodecontentref_/2)
    - [provisioning.sh](http://_vscodecontentref_/3)

typecheck:
  stage: test
  image: python:3.8
  before_script:
    - apt update && apt install -y tree
    - pip install mypy
  script:
    - cd tutorial-python-microservice-tornado-master
    - mypy ./addrservice ./tests

linter:
  stage: test
  image: python:3.8
  before_script:
    - apt update && apt install -y tree
    - pip install -r [requirements.txt](http://_vscodecontentref_/4)
  script:
    - cd tutorial-python-microservice-tornado-master
    - python3 -m flake8 ./addrservice ./tests
    - python3 ./run.py lint

unit_test:
  stage: test
  image: python:3.8
  before_script:
    - apt update && apt install -y tree
    - pip install -r [requirements.txt](http://_vscodecontentref_/5)
  script:
    - cd tutorial-python-microservice-tornado-master
    - python -m unittest discover -s tests

coverage:
  stage: test
  image: python:3.8
  before_script:
    - apt update && apt install -y tree
    - pip install -r [requirements.txt](http://_vscodecontentref_/6)
    - pip install coverage
  script:
    - cd tutorial-python-microservice-tornado-master
    - coverage run -m unittest discover -s tests
    - coverage report -m
    - coverage html
  artifacts:
    paths:
      - tutorial-python-microservice-tornado-master/htmlcov/

compliance:
  stage: image-test
  image:
    name: hadolint/hadolint:latest-alpine
    entrypoint: [""]
  script:
    - /bin/hadolint Dockerfile

security:
  stage: image-test
  image:
    name: aquasec/trivy
    entrypoint: [""]
  before_script:
    - echo "Registry: ${CI_REGISTRY}"
    - echo "Image: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}"
    - trivy registry login --insecure --username ${CI_REGISTRY_USER} --password ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
  script:
    - trivy image --scanners misconfig --insecure ${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}

deploy_swarm:
  stage: deploy_swarm
  image: alpine/ansible:2.18.1
  variables:
    ANSIBLE_HOST_KEY_CHECKING: FALSE
  script:
    - ansible-playbook playbook.yml -i [inventory.ini](http://_vscodecontentref_/7)

build_and_deploy:
  stage: deploy
  image: alpine/ansible:2.18.1
  variables:
    ANSIBLE_HOST_KEY_CHECKING: FALSE
  before_script:
    - export IMAGE_TAG=${CI_COMMIT_REF_NAME}
  script:
    - ansible-playbook build_playbook.yaml -i [inventory.ini](http://_vscodecontentref_/8)

api_post_test:
  stage: api_test
  image: alpine/ansible:2.18.1
  variables:
    ANSIBLE_HOST_KEY_CHECKING: FALSE
  script:
    - apk add curl
    - curl -i -X POST http://10.129.4.102:8080/addresses -d '{"full_name": "Bill Gates"}'

api_get_test:
  stage: api_test
  image: alpine/ansible:2.18.1
  variables:
    ANSIBLE_HOST_KEY_CHECKING: FALSE
  script:
    - apk add curl
    - curl -i -X GET http://10.129.4.102:8080/addresses


This README provides an overview of the project, including setup instructions, provisioning, deployment, testing, and CI/CD pipeline configuration. Adjust the repository URL and any other specific details as needed.
