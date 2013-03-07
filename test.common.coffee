utils  = require("utils")
casper = require("casper").create
  verbose: true
  logLevel: "warning"
  exitOnError: true
  safeLogs: true
  viewportSize:
    width: 1024
    height: 768

testhost   = casper.cli.get "testhost"
screenshot = casper.cli.get "screenfile"

casper
  .log("Using testhost: #{testhost}", "info")
  .log("Using screenshot: #{screenshot}", "info")

if not testhost
  casper
    .echo("Usage: $ casperjs --ignore-ssl-errors=yes testcase.coffee  --testhost=<testhost> [--screenfile=<testcase.coffee.png>]")
    .exit(1)

if screenshot
  if /\.(png)$/i.test screenshot
    casper
      .echo("Warning: screenshot should have a PNG extension")

## Hooks
##########################################################################

# Capture screens from all fails
casper.test.on "fail", (failure) ->
  if screenshot
    casper.capture(screenshot)
  casper.exit 1

# Capture screens from timeouts from e.g. @waitUntilVisible
# Requires RC3 or higher.
casper.options.onWaitTimeout = ->
  if screenshot
    @capture(screenshot)
  @exit 1


