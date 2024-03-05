# TODO

- [ ] FIX: Dockefile on `devops-coding-challenge/compose/local/django/Dockerfile` have a redundant sed expresion
    - Documentation related [Configuring Git to handle line endings](https://docs.github.com/es/get-started/getting-started-with-git/configuring-git-to-handle-line-endings)

- [ ] FIX: Parsing restricted subset of SARIF data has failed: parse error: expected string near
    - Error related with the generation of the report by SNYK
    - Due this error the report could not be attached to the pull-request
- [ ] UPGRADE: If the CI pipeline becomes too large, split it into different workflows
- [ ] ADD: Attach the test coverage to the pull request
- [ ] ADD: Infrastructure code with terraform and (AWS)
        - I create a dummy terrafrom config that is present on `./infra/terraform.tf`
- [ ] ADD: Create [Molecule](https://ansible.readthedocs.io/projects/molecule/) project to test ansible roles
