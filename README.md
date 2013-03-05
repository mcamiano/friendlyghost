friendlyghost
=============

Scriptable and headless webkit based app testing and web scraping with CasperJS

OSX Quick Start
===============

```bash
cd workspace/myGitRepo
mkdir testtools
git submodule add git@github.ncsu.edu:mcamiano/friendlyghost.git testtools/friendlyghost
brew install casperjs
testtools/friendlyghost/runtest.sh testtools/friendlyghost/test.cjs.coffee dev.wolftech.ncsu.edu/myapp
```

The sample test *will fail* on dev.wolftech.ncsu.edu, but red bars are always a good first step. 

By default, a snapshot of your languid failure will be saved on the desktop. You can open the image automatically by passing -open as the first argument to the script. 

To make the test work, copy the test case to myGitRepo/testsuite and edit to change up the assertion(s), then re-run:

```bash
mkdir testsuite
cp testtools/friendlyghost/test.cjs.coffee testsuite/check_site_title.coffee
vi testsuite/check_site_title.coffee
# edit, :wq
testtools/friendlyghost/runtest.sh  testsuite/check_site_title.coffee dev.wolftech.ncsu.edu/myapp
```

That's all for now. You should write your own wrappers to automate running the whole suite and parts of it.
Also think about how you want to organize the testsuite... casper is probably best for integration and acceptance testing and exercising the UI, not as fast or as isolated as you would want for unit testing. 
If you use multiple unstable branches for, e.g. client customizations, keep the majority of the tests on the primary unstable development branch or in its own testing branch, so they can be merged and/or rebased easily. 
