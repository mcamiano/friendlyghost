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

Think about how you want to organize the testsuite... casper is probably best for integration and acceptance testing and exercising the UI, not as fast or as isolated as you would want for unit testing. 
If you use multiple unstable branches for, e.g. client customizations, keep the majority of the tests on the primary unstable development branch or in its own testing branch, so they can be merged and/or rebased easily. 

boo 
===
boo, also called 'exectest', is a shell script to run casperjs test suites, view and clean up test outputs.

boo provides a lot of options and makes a lot of assumptions:
* It expects to be run in the top level directory of your repo.
* the default host is dev.wolftech.ncsu.edu and the default webpath is /

There are three sets of files assumed by the boo:

* testout/*.txt and *.png   Test output; exectest makes these and assigns them the name $testcasename.$datetime.txt .

* testsuite/*.coffee  Test cases; you create these.

* testtools/friendlyghost  exectest assumes that friendlyghost was added as a git submodule under the testtools directory. 

It is handy to add the latter path to your PATH variable:
```bash
PATH=$PATH:./testtools/friendlyghost
```

To view output files, use the -v option or less -R  (consider using source-highlight and lesspipe).

boo Usage
==============
```bash
boo -case testcasename [--path webrootpath] [--site hostname] [--open] [--nop] [--a "--username=foo" [-a "--password=bar"] ...]
boo (-h|--help)
boo -v|--view testcasename
```

Examples:
---------
```bash
boo --open optional_other_inputs

boo -case optional_other_inputs --path reu-assist --open
```

```bash 
boo -x         # remove all test outputs
```


Problems
========

Test Freezes or Hangs
---------------------
CasperJS is based on PhantomJS, which has almost non-existant error reporting. 
As a result, even the simplest of syntactic errors and semantic errors can cause a test to mysteriously hang unresponsively. 
If this happens, simply hit CTRL-C to terminate the process. 

To compensate, it is advised that you use a Coffeescript lint tool often. Assume that frozen tests are code errors. 

How to set Parameters
---------------------
Particulars about deployed locations, usernames, passwords, or resources are a bad thing to have in your test scripts. 
Turn these facts into parameters, and stick them into a casper.testSetup object inside of the testsuite/pretest.coffee script. 
(Ideally, a test suite configuration should be a command line option to boo, but for the moment it is fixed to pretest.coffee).
