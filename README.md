# Workflow 

This project's goal is the __security__ of a workflow's team project: proving, improving and testing the process. 

It contains a nginx sample project which can be:
- build,
- publish in a docker registry,
- deploy on environments like dvt, QA ...etc,
- release,
- deliver.

:star: This worklow encourages you to write knowledge in the documentary space and instructions in README files.

:books: Documentary space : 

:writing_hand: Markdown instructions for readablity: https://docs.gitlab.com/ee/user/markdown.html

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You need a recent version of __docker__ and __docker-compose__ in a *Linux* system.

It will be better to have an access to the network for the private docker registry and the deployment environments, but you can change the configuration of this project to push builded images on your private docker registry and deploy on your teamsi' machines.  

### Installing

Get the project

```
git clone https://github.com/thomasfourest/workflow.git
```

Build and publish the `nginxhello` image on docker registry 

```
cd workflow
make build
make publish
```

Run `nginxhello` container

```
make up
```

To reach the resulted web page in the running docker container, better is to start the *traefic reverse proxy* project to expose the `nginxhello` container on the nginxhello.local route. 

```
git clone https://github.com/thomasfourest/docker-reverse-proxy.git
cd docker-reverse-proxy
make up
```

Open the browser of your system on the `nginxhello.local` url.

## Gitflow 

### Branches

The __protected__ `master` branch is the receptacle of different sorts of developmentis: __features__, __bugs__, __fixes__ ...etc

There are other __protected__ branches, one for each phase of the project that need a working environment which could be fixed.  
 - `preprod`,
 - `prod`,
 - ...etc

The other __short-live__ branches are used for features, bugs, fixes' developments. 

![gitflow branches](/gitflow/branches1.png)

You can also see the git log in graphic form :
```
git log --all --decorate --oneline --graph
```

### Feature/bug/fix's development 

![add a feature](/gitflow/feature1.png)

First, create a __GitLab issue__ describing the feature.

And generate a __merge request__ and the __specific branch__ from this issue .
```
# you can also create the specific branch via git commands
git checkout -b 33-feature-export master
git push --set-upstream origin 33-feature-export
```

Please begin you work on this specific branch, adding an entry in the __release note__ (release-note.md).

After the end of the commmits for this feature, and before merginig on `master`, __rebase__ your specific branch on `master`:
```
# update local master 
git checkout master
git fetch origin
git pull
git checkout 33-feature-export
git rebase master
# if there is conflicts, solve them now
# you can also squash your commits for efficient git work: git rebase -i HEAD~nbCommitsBeforeSpecificBranch
git push --force
```

You cant finish the __team review__ on the __merge request__.

After that you can merge the branch with __no fast forward__:
```
git checkout master
git merge --no-ff 33-feature-export
git push 
```

### Prepare Release Candidate for the product

![release](/gitflow/release1.png)

First, create a __tag__ on the commit you identify for the release candidate.
```
git tag -a $VERSION-rc1 345e5b5 -m "RELEASE CANDIDATE M.m.r-rc1"
```

And deliver your RELEASE-CANDIDATE docker image in registry (publishing with rc tag)...


Preparing the upgrade of the product version number, create a __GitLab issue__ whith name *release-M.m.r-bump-to-M-m-r+1* and an associated __specific branch__ 
```
# you can also create the specific branch via git commands
git checkout -b 51-release-2.0.1-bump-to-2.0.2 master
git push --set-upstream origin 51-release-2.0.1-bump-to-2.0.2
```

Increment the revision number in the file VERSION and push the __bump__ commit, and add a new entry in the __release note__ for the futur release.  
```
vi VERSION # exemple: change "2.0.1" to "2.0.2"
git add VERSION
vi release-note.md # exemple: add the new section "# Release 2.0.2"
git add release-note.md
git commit -m "prepare 2.0.2 freezing the release 2.0.1
git push
```
> :exclamation: TODO automaton for bump

Merge the __specific branch__ with __fast forward__ via the __GitLab issue__, __rebasing__ on `master`
```
# update local master 
git fetch origin
git checkout master
git pull
git checkout 51-release-2.0.1-bump-to-2.0.2
git rebase master
# if there is conflicts, solve them now
git push --force
# and merge 
git checkout master
git merge 51-release-2.0.1-bump-to-2.0.2
git push 
```
> :exclamation: TODO GitLab API usage to add a generated release note     

### Promote release

![promote on preprod](/gitflow/promotepreprod1.png)

A monday, you want deliver your release candidate in `preprod`, so...

Create a __merge request__ in GitLab on `preprod`, and merge whith __fast forward__:
```
git fetch --tags origin
git checkout preprod
git merge 2.0.1-rc1
git push
```

After QA validation, create a RELEASE __tag__ on the commit you have identified for the release candiate.
```
git tag -a $VERSION 345e5b5 -m "RELEASE CANDIDATE M.m.r"
```

And deliver your RELEASE docker image in registry (publishing with release tag)...

Then, as time went on,

![promote on production](/gitflow/promoteproduction1.png)

The month of sundays, you want deliver your release in `production`, so...

Create a __merge request__ in GitLab on `production`, and merge whith __fast forward__:
```
git fetch --tags origin
git checkout production
git merge 2.0.1
git push
```

### Hot fix in `production`

![add hot fix in production](/gitflow/hotfix1.png)

Create a __GitLab issue__ and the associated __specific branch__.

At the end of the commmit for this hot fix, create a __merge request__ on `production`.

Add a __commit__ to bump the VERSION and __merge__ on `production` with __fast forward__:

```
# add -fix-numOfIssue at the end of the version 
# exemple : 2.0.1-fix93
vi VERSION
git add VERSION
git commit -m "bump version for fix 93"
git tag -a 2.0.1-fix93
git push
# merge 
git checkout production
git merge 93-hotfix-burning
git push 
```
> :exclamation: TODO automaton for bump

Finally, report the fix commit on `master`
```
git checkout master
git rebase production 
git push --force
```

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc

