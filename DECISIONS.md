# Decisions

### Pre-flight checks
- [x] Understand project components
    - `devops-coding-challenge` is a django app that use a task queue framework called [Celery](https://docs.celeryq.dev/en/stable/getting-started/introduction.html) wich utilizes Redis as a broker.
    - Cerely components
        - `Worker` resposable to execute the tasks defined in a Celery application recived by the broker.
        - `Flower` is a web tool for monitoring and administrating Celery clusters.
        - `Beat` ([django-celery-beat](https://django-celery-beat.readthedocs.io/en/latest/)) is a utility daemon to set task with a schedule
    - Related with the persistence we have a `Postgresql` database
    - [Mailhog](https://github.com/mailhog/MailHog) emulate an SMTP en local (writen in go)
    - [Sphinx](https://www.sphinx-doc.org/en/master/usage/quickstart.html) documentation generator
- [x] Review documentation about django, Celery...
- [x] Test in localhost to run the application with docker compose and without

#### Usefull commands

``` sh
# Start the project:
docker compose -f local.yml up

# Execute only postgresql:
docker compose -f local.yml up postgres -d

# Execute the test:
DATABASE_URL='postgres://xamwURhxlxJWCJPsOstECJahSBlooGvJ:sEvQt1iIvCgSUOSKDnTu6OnTOUlgTz3rqscUmz9KViNtkT72tI756hg4Jck5Zxnm@localhost:5432/devops_interview_test' CELERY_BROKER_URL='redis://redis:6379/0' pytest

## build
 docker build -t test-build --build-arg BUILD_ENVIRONMENT=production  -f ./compose/local/django/Dockerfile .
```

## Milestones
> I chose to create the pipeline using GitHub Actions, workflow located at `.github/workflows/ci.yml` "

The pipeline should:

- [x] Install the required dependencies.
- [x] Deploy the mandatory services to execute the tests.
- [x] Execute the tests located in the `devops_interview_test` folder.
- [x] Ensure that the test coverage meets the appropriate thresholds.
    - Coverage should be more than 80%
- [x] Ensure compatibility bettwen versions (pyhton versions)
- [x] Apply linting tool that checks the Python code (Flake8)
    - F401 module imported but unused
    - E1 Indentation errors
    - E2 Whitespace errors
- [x] Build a docker imange only if all the tests pass
- [x]Check the security vulneravilities related to the docker image
    - ex. [snyk](https://snyk.io/)
    - Report should be provided in the pull request
- [x]Log in to docker registry and push final image
- [x]Create a dummy deploy for multiple environments (dev, pro)
    - Config the repository to not allow deploy in pro without approval from the revisors
- [x]Create a dummy example about how validate the terraform code and plan operation


### Deploy the mandatory services to execute the tests.

I have decided to avoid deploying all other components such as Redis and Mailhog,
dude they are not necessary for executing the tests.

## Ensure that the test coverage meets the appropriate thresholds.

In the test step, I have added a threshold to ensure that the application has an good amount of tests
before building the image. This step could be enhanced by reporting the coverage statistics directly in the pull request
or by sharing this information with other tools or communication channels such as Slack.

## Check the security vulneravilities related to the docker image

This step was added to enhance the security of the Docker image and to stay tuned about
potential vulnerabilities. It's a best practice because it involves proactive monitoring
and mitigation of any identified vulnerabilities.

## Create a dummy example about how validate the terraform code and plan operation

In case to use infrastructure-as-code it's essential to ensure that the code is properly formatted, validated, and ensure that
the code will not broken the currect infra. To address this, I've included some steps to illustrate how to validate the
format and syntax of Terraform code. For another hand it's crucial to perform a plan operation to verify that all
changes align with expectations and prevent accidental resource destruction.

## Create a dummy deploy for multiple environments (dev, pro)

It's a good practice to have at least three different environments (dev, staging, and prod)
for deploying the application and ensure that all work as expected. In this challenge, I've chosen to illustrate
how the deployment flow should be managed based on the environment. For instance, probably for dev we might want
to deploy every time there are new changes but in the case of production we should have a pre-step to not deploy before
guaranty that all is working as expected, in this case this decision should be not automated to avoid unexpected behaviors
or downtimes.

![Github actions production](./screenshots/production.png)


## (Optional) Deployment Suggestions

Here a brief proposal about a how to deploy the application on AWS.

First of all, there are some topics that should be evaluated in terms of choosing the correct cloud provider, budget, team skills, and specific
requirements. Creating infrastructure in the cloud involves important considerations like budget, which can influence how we choose our resources. For example, in this challenge, we could evaluate create and administrate our own PostgreSQL but this aproach has advantages such as more control but also disadvantages like repetitive maintenance tasks. Services like RDS (OPTION B) offer us the oportunity to delegate these tasks to AWS, which will provide us with a managed relational database service, administration tasks such as provisioning, patching, backups, and monitoring will be simplified.

To keep it this simple I will propose just deploy our container inside of a [EC2 intances](https://aws.amazon.com/es/ec2/instance-types/)(OPTION A) that fit with the requirements of the application. Selecting the appropriate instance type is essential to avoid additional costs and ensure optimal performance.

To make the application more resilient and available I desing this simple arquitecture of 2 layer:

- Public layer: Here resides the Django application that can be reached by the clients via internate gateway > load banlancer. The application is inside of
a autoscaling groud that will provide us the ability to scale up and down, based on predefined conditions or metrics. Also in this layer we have some components like NAT gateway that enables outbound internet traffic for resources within a private subnet.

- Private layer: In this level will be deployed our database, redis etc.. all this resources that should not be accesible directly
  from internet.

High availability and fault isolation this is possible due that the application will be deploy cross multiple Availability zones.

All the traffic is managed by the Application load balancer, which is responsible for distributing incoming traffic across multiple instances launched by the Auto Scaling group.

![Diagram AWS](./screenshots/aws_diagram.png)

#### Others services that could be fit:

- Amazon CloudFront + S3: this service allow deliver static and dynamic web content like html, js, css, and image file to the user faster, due that the contend is load on edge locations close to the user.

- AWS Cloudwatch: Observability is essential for understanding what is happening in our infrastructure, gathering metrics about the status of the system is invaluable for detecting failures and taking proactive actions to prevent them.

The deploy process should be made via terraform to create all the resources previously mentioned and Ansible shoud be responsible to provision the EC2 instances with all the needed dependencies and also be responsable to manage the containers.


## Related documentation
- [First steps with Django (Celery)](https://docs.celeryq.dev/en/stable/django/first-steps-with-django.html)
- [First Steps with Celery](https://docs.celeryq.dev/en/stable/getting-started/first-steps-with-celery.html#installing-celery)
- [Mailhog](https://github.com/mailhog/MailHog)
- [Github Actions](https://docs.github.com/en/actions/quickstart)
- [Working with the Container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [How to obtain and authenticate with your Snyk API token](https://docs.snyk.io/getting-started/how-to-obtain-and-authenticate-with-your-snyk-api-token)
- [Sphinx](https://www.sphinx-doc.org/en/master/usage/quickstart.html)
- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
