friendlyghost
=============

Scriptable and headless webkit based app testing and web scraping with CasperJS

OSX Quick Start
===============

You need [casperjs](http://casperjs.org) installed in an executable path; [homebrew](http://mxcl.github.io/homebrew/) is the easiest way to get it. 

```bash
brew install casperjs
```

I prefer to add friendlyghost as a submodule to my repos (but you can clone it):  

```bash
cd workspace/myGitRepo
mkdir testtools
git submodule add git@github.ncsu.edu:mcamiano/friendlyghost.git testtools/friendlyghost
```

Think about how you want to organize the testsuite... casper is probably best for integration and acceptance testing and exercising the UI, not as fast or as isolated as you would want for unit testing. 

If you use multiple unstable branches for, e.g. client customizations, keep the majority of the tests on the primary unstable development branch or in its own testing branch, so they can be merged and/or rebased easily. 

boo 
===
boo, also called 'exectest', is a shell script to run casperjs test suites, view and clean up test outputs.

boo provides several options and makes a few assumptions, the first of which is that it expects to be run in the top level directory of your repo.

There are three sets of files assumed by boo:

* testout/*.txt and *.png   Test output; boo makes these and assigns them the name $testcasename.$datetime.txt .

* testsuite/*.coffee  Test cases; you create these.

* testtools/friendlyghost  boo  assumes that friendlyghost was added as a git submodule under the testtools directory. 

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
boo --open optional_other_inputs         # Run a single case

boo -case optional_other_inputs --path reu-assist --open       # Run a case, set a path, and open png snapshot on errors
```

```bash 
boo -x         # remove all test outputs
```


Problems
========

"What Is This Thing You Call CoffeeScript?!"
--------------------------------------------
CoffeeScript is an alternative syntax for JavaScript that is much shorter to write and adds clever helpers inspired by Python and Ruby.
Boo assumes test case filenames end in ".coffee", but it would not be difficult to change over to JavaScript.
It doesn't use JS syntax by default since it is far more verbose and much less readable, and CoffeeScript is not difficult to pick up. 

Test Freezes or Hangs
---------------------
CasperJS is based on PhantomJS, which has almost non-existant error reporting. 
As a result, even the simplest of syntactic errors and semantic errors can cause a test to mysteriously hang unresponsively. 
If this happens, simply hit CTRL-C to terminate the process. 

To compensate, it is advised that you use a CoffeeScript lint tool such as [coffeelint](http://www.coffeelint.org) often. Assume that frozen tests are code errors. 

How to set Parameters
---------------------
Particulars about deployed locations, usernames, passwords, or resources are a bad thing to have in your test scripts. 
Turn these facts into parameters, and stick them into a casper.testSetup object inside of the testsuite/pretest.coffee script. 
(Ideally, a test suite configuration should be a command line option to boo, but for the moment it is fixed to pretest.coffee).

Using in Travis CI
==================
boo is a shell script that depends on casperjs (and optionally coffeelint). To get it running on Travis CI you'll need to install casperjs, either in the base machine via a chef recipe
such as https://github.com/jenkinslaw/casperjs-cookbook/tree/master/recipes , or via a local copy of the code.

Friendlyghost should itself be installed via a chef recipe. The skunkworks versions used a git submodule, which is not ideal and could be a problem depending upon the submodule support in Travis CI. 

Other than that, boo should return a non-zero status code on failure, zero on a clean test. (If the skunkworks script doesn't in all cases, that's a bug.)

Limitations
===========
There are many, and frequent. Suites are still ill-defined constructs. Boo is a skunkworks shell script with some error checking but many assumptions. For that reason also, there is not yet a test suite for boo. The plan is to re-write it in Ruby when the basic functionality has settled down.
