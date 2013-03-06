## Setup
##########################################################################

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

# Scan for the word notice|warning|error|exception by default
# casper.on "step.complete", (page) ->
  # Skip urls that can contain 'error'/'exception'
  # u = casper.getCurrentUrl()
  # if (u == "https://#{testhost}/nonexistent")
    # return


## Testcases
##########################################################################

# This is an app that has everything (even the /news page) behind a login.

# try to access nonexistent when logged in (don't 404, we only tell customers what exists and what not)
casper.start "http://#{testhost}/", ->
  @test.assertHttpStatus(200, "should be http code 200")
  @test.assertUrlMatch /\//, "root of site"
  @test.assertExists "#ugrad_institution option[class='other']", 'found "other" option for undergrad institution'
  @test.assertExists ".optional_demographics option"
  @test.assertDoesntExist ".optional_demographics:not(option[class='other'])", 'found demographic option with no "other" option'

# casper.thenOpen "http://#{testhost}/news/", ->
  #@test.assertTextExists "I could not give you access to", "cannot access news without login"
  #@test.assertUrlMatch /\/customers\/login/, "redirect to login"
  #@test.assertTitle "Please login", "login page title is the one expected"
  #@test.assertExists "form[action=\"/customers/login/\"]", "login page must have a form with customer/login action"
  #@fill "form[action=\"/customers/login/\"]", { "data[Customer][username]": "janedoe", "data[Customer][password]": "jsdi32ld!" }, true

# redirect to landing page /news/
#casper.then ->
  #@test.assertUrlMatch /\/news/, "redirected to landing page after login"

# notice login twice
#casper.thenOpen "http://#{testhost}/customers/login", ->
  #@test.assertTextExists "You are already logged in", "notice already logged in"

# try to access admin page
#casper.thenOpen "http://#{testhost}/admin/tickets", ->
  #@test.assertTextExists "I could not give you access to ", "prohibit to access admin page"

# try to access nonexistent when logged in
#casper.thenOpen "http://#{testhost}/nonexistent", ->
  #@test.assertHttpStatus 404, "nonexistent should 404 when logged in"

# dashboard has panels
#casper.thenOpen "http://#{testhost}/customers/dashboard", ->
  #@test.assertTitle "Dashboard", "customer dashboard title is ok"
  #@test.assertEvalEquals ->
  #  __utils__.findAll(".user-dashboard div.accordion-heading").length
  #, 8, "found 8 customer dashboard panels"

# calculate storage price
#casper.thenOpen "http://#{testhost}/storage_accounts/add", ->
#  @evaluate ->
#    $("#StorageAccountBytesMax").val("10737418240")
#    $("#StorageAccountPassword").val("dlfksfag!1")
#    $("#StorageAccountEmail").val("janedoe@example.com")
#    $("#StorageAccountBytesMax").change()

  #  @waitFor ->
  #  @evaluate ->
  #    $("#billabe_buy").text() != "Calculating..."
  #, ->
  #  @test.assertSelectorHasText "#billabe_buy", "45.00", "10gb is 45.00 euros for janedoe"

# unowned invoice: prohibit
#casper.thenOpen "http://#{testhost}/invoices/view/201100493", ->
#  @test.assertTextExists "Invoice not found", "prohibit access to invoice of another customer"

# owned invoice: allow and check it's price is 12 cents
#casper.thenOpen "http://#{testhost}/invoices/view/201100975", ->
#  @test.assertTextExists "Subtotal", "my invoice has a subtotal"
#  @test.assertEval ->
#    $("td.total").text().indexOf("0.12") > -1
#  , "invoice 201100975 total is 12 cents"


## Bombs away
##########################################################################

casper.run ->
  @test.renderResults true

