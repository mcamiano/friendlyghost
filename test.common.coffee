utils  = require("utils")
fs  = require("fs")

##################################################
# Test Helpers
###############################

casper.snapshotName = (currtest) ->
  return "./testout/snapshot.png" if not currtest? or currtest == ''
  currtestpathname=currtest.replace(/.*\/testsuite\//,'')
  currtestpath="./testout/"+currtestpathname.replace(/[^\/]*\.coffee/,'')
  fs.makeDirectory(currtestpath) if ! fs.isDirectory(currtestpath)
  "./testout/#{currtestpathname}.png"

# triggers events in the client browser context
casper.throwClientEvent = (evname, elemname) ->
  @evaluate((evname, elemname) ->
    elem = __utils__.findOne(selector)
    evt = document.createEvent("HTMLEvents")
    evt.initEvent evname, false, true
    elem.dispatchEvent evt
  , evname, elemname)

casper.throwOnChange = (fieldSel) ->
  @throwClientEvent "change", fieldSel

casper.throwOnFocus = (fieldSel) ->
  @throwClientEvent "focus", fieldSel

casper.throwOnBlur = (fieldSel) ->
  @throwClientEvent "blur", fieldSel

casper.setValue = (selector, value) ->
  @evaluate (selector, value) ->
    elem= __utils__.findOne(selector)
    elem.value = value
    evt = document.createEvent("HTMLEvents")
    evt.initEvent 'change', false, true
    elem.dispatchEvent evt
    @throwClientEvent "blur", selector
  ,
    selector: selector
    value: value

casper.fillField = (fieldSel,val) ->
  @test.assertExists "##{fieldSel}",
    "field element '#{fieldSel}' should be present in DOM"
  @throwOnFocus "##{fieldSel}"
  @setValue "##{fieldSel}", val
  @throwOnBlur "##{fieldSel}"
  @test.assertField fieldSel, val, "field #{fieldSel}.value set to #{val}"

casper.checkEveryField = (_previous, form_selector) ->
  verified_fields = Object.keys(_previous)
  response_form=@getFormValues form_selector
  @each( verified_fields, (self, key) ->
    @test.assertEquals( "#{response_form[key]}", "#{@_previous[key]}", key+' is set correctly')
  )

casper.test.assertFieldWithValueExists = (val) ->
  @assertExists "input[value=\""+casper.escapeValue(val)+"\"]", 'Input exists [value="'+casper.escapeValue(val)+'"]'

casper.takeScreenshot = (testfilename)  ->
  @capture @snapshotName(testfilename)
  @exit 1

casper.repeat = (nTimes,func) ->
  @each [1..nTimes], func

casper.rand = (magnitude=1000)          ->
  Math.floor(Math.random()*magnitude)

casper.randomstr = (str,magnitude=1000) ->
  str + @rand(magnitude)

casper.escapeValue = (str) ->
  str.replace /'/g, "\'"

# Lightweight Data Fakers
casper.mock = casper.faker = { }
casper.mock.firstname = ->
  names=[
    'Amy', 'Adrienne', 'Albert', 'Alphonse',
    'Benificent', 'Benjamin', 'Beth Anne', 'Bethany',
    'Carlos', 'Carlita', 'Cheryl',
    'Daniel', 'Danica', 'Daryll', 'Danitra\'payobala',
    'Ellen', 'Ernest',
    'Ford', 'Fenwick',
    'George', 'Glen', 'Glenda', 'Gatano', 'Gabriel',
    'Harrison', 'Horatio', 'Helmut',
    'Izzy', 'Iona', 'i\'Krit',
    'Joe', 'Jerry', 'Jonas',
    'Kevin', 'Karl', 'Karen', 'Keith',
    'Larry', 'Levin', 'Linda Lou',
    'Mary-Sue', 'Michael', 'Malabendrabanerjopadrehyeyh', 'Marvin',
    'Nicolas', 'Nancy', 'Ned',
    'Oscar', 'Orin',
    'Patrick', 'Petunia', 'Pamela',
    'Qbert', 'Quentin', 'Querell',
    'Randy', 'Roberto', 'Roberta', 'Ronald', 'Raymond',
    'Samuel', 'Samantha', 'Stephen',
    'Thomas', 'Taranga', 'Tilly',
    'Ungoliath', 'Uriel', 'Ursella',
    'Victor', 'Verity',
    'William', 'Willemina',
    'Xavier',
    'Yana',
    'Zeno', 'Zelda'
  ]
  names[casper.rand(names.length)]

casper.mock.lastname = ->
  names=[
    'Adams', 'Al Jabb\'r', 'Alexander', 'Allen', 'Anderson',
    'Bailey', 'Baker', 'Barnes', 'Bell', 'Ben Israel', 'Bennett', 'Brooks', 'Brown', 'Bryant', 'Butler',
    'Campbell', 'Carter', 'Clark', 'Cole', 'Coleman', 'Collins', 'Cook', 'Cooper', 'Cox', 'Cruz',
    'Davis', 'Diaz',
    'Edwards', 'El-Sabim', 'Ellis', 'Evans',
    'Fisher', 'Flores', 'Ford', 'Foster',
    'Garcia', 'Gibson', 'Gomez', 'Gonzales', 'Gonzalez', 'Graham', 'Gray', 'Green', 'Griffin',
    'Hall', 'Hamilton', 'Harris', 'Harrison', 'Hayes', 'Henderson', 'Hernandez', 'Hill', 'Howard', 'Hughes',
    'Icarus', 'Illuminato',
    'Jackson', 'James', 'Jenkins', 'Johnson', 'Jones', 'Jordan',
    'Kelly', 'King',
    'Lee', 'Lewis', 'Long', 'Lopez',
    'Marcellinus', 'Marshall', 'Martin', 'Martinez', 'Mc Donald', 'Mcdonald', 'Miller', 'Misbahendrapodoyopayata O\'Keefe',
    'Mitchell', 'Moore', 'Morgan', 'Morris', 'Murphy', 'Myers',
    'Nelson',
    'O\'Malley', 'O\'donahue', 'Ortiz', 'Owens',
    'Parker', 'Patterson', 'Perez', 'Perry', 'Peterson', 'Phillips', 'Powell', 'Price',
    'Qwazni',
    'Ramirez', 'Reed', 'Reynolds', 'Richardson', 'Rivera', 'Roberts', 'Robinson', 'Rodriguez', 'Rogers', 'Ross', 'Russell',
    'Sanchez', 'Sanders', 'Scott', 'Simmons', 'Smith', 'Stewart', 'Sullivan',
    'Taylor', 'Thomas', 'Thompson', 'Torres', 'Turner',
    'Walker', 'Wallace', 'Ward', 'Washington', 'Watson', 'West', 'White', 'Williams', 'Wilson', 'Wood', 'Woods', 'Wright',
    'Young',
    'Zamir'
  ]
  names[casper.rand(names.length)]

casper.mock.streetname = ->
  names=[
    'Main St'
    'Main Street'
    'Ridge Rd'
    'Ridge Road'
    'High Street'
    'Colorado Blvd'
    'Colorado Boulevard'
    'Pennsylvania Ave'
    'Pennsylvania Avenue'
    'Washingtonian Circle'
  ]
  names[casper.rand(names.length)]

casper.mock.street = ->
  casper.rand(500)+' '+casper.mock.streetname()

casper.mock.town = ->
  names=[
    'Washingtonian Circle'
  ]
  names[casper.rand(names.length)]

casper.mock.state = (abbr=false) ->
  names=
    'Alabama': 'AL', 'Alaska': 'AK', 'Arizona': 'AZ', 'Arkansas': 'AR',
    'California': 'CA', 'Colorado': 'CO', 'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID', 'Illinois': 'IL', 'Indiana': 'IN', 'Iowa': 'IA',
    'Kansas': 'KS', 'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME', 'Maryland': 'MD', 'Massachusetts': 'MA', 'Michigan': 'MI', 'Minnesota': 'MN', 'Mississippi': 'MS', 'Missouri': 'MO', 'Montana': 'MT',
    'Nebraska': 'NE', 'Nevada': 'NV', 'New Hampshire': 'NH', 'New Jersey': 'NJ', 'New Mexico': 'NM', 'New York': 'NY', 'North Carolina': 'NC', 'North Dakota': 'ND',
    'Ohio': 'OH', 'Oklahoma': 'OK', 'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC', 'South Dakota': 'SD',
    'Tennessee': 'TN', 'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT', 'Virginia': 'VA',
    'Washington': 'WA', 'West Virginia': 'WV', 'Wisconsin': 'WI', 'Wyoming': 'WY'
  k=Object.keys(names)
  return names[k[casper.rand(k.length)]] if (abbr)
  k[casper.rand(k.length)]

casper.mock.stateabbr = ->
  casper.mock.state(true)

casper.mock.digit = (max=9) ->
  max=max%10
  "#{casper.rand(max)}"

casper.mock.nonzerodigit = (max=9) ->
  max=max%10
  "#{(1+casper.rand(max-1))}"

casper.mock.stringof = (num=2,cb) ->
  return '' if num < 1
  ++num
  arr = while num -= 1
    cb()
  arr.join('')

casper.mock.digits = (num=2) ->
  casper.mock.stringof(num, casper.mock.digit)

casper.mock.nonzerodigits = (num=2) ->
  casper.mock.stringof(num, casper.mock.nonzerodigit)

casper.mock.zip = ->
  casper.mock.digits(5)

casper.mock.zip4 = ->
  casper.mock.digits(5) + '-' + casper.mock.digits(4)

casper.mock.areacode = =>
  casper.mock.nonzerodigit() + casper.mock.digits(2)

casper.mock.recentdate = (yearsago=25,days=28) ->
  d=new Date()
  "#{casper.rand(12)}/#{casper.rand(days)}/#{d.getFullYear() - casper.rand(yearsago)}"

casper.mock.email = (prefix='wolftech',max=100000000) ->
  prefix+'-'+btoa("#{casper.rand(max)}")+'@mailinator.com'   # you can check the emails for wolftech-NN@mailinator.com at mailinator.com
casper.mock.email1 = (prefix='wolftech') ->
  prefix+'-1@mailinator.com'
casper.mock.email2 = (prefix='wolftech') ->
  prefix+'-2@mailinator.com'
casper.mock.email3 = (prefix='wolftech') ->
  prefix+'-3@mailinator.com'
casper.mock.email4 = (prefix='wolftech') ->
  prefix+'-4@mailinator.com'

casper.mock.areacode = ->
  200+casper.rand(699)

casper.mock.exchange = ->
  casper.mock.areacode()

casper.mock.phoneext = ->
  casper.mock.digits(4)

casper.mock.phone9digit = (sepchar='') ->
  casper.mock.areacode()+sepchar+casper.mock.exchange()+sepchar+casper.mock.phoneext()

casper.mock.loremIpsum = ->
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

casper.mock.loremParagraphs = ->
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur neque urna, luctus vel lobortis sit amet, convallis vel tortor. Etiam interdum tempus sapien ac varius. Etiam vel neque non odio tristique congue sit amet id quam. Mauris posuere dictum volutpat. Nulla iaculis diam nec eros suscipit auctor. Praesent gravida, nunc a lacinia consequat, mauris neque placerat ligula, at mollis erat mauris vitae dui. Nulla commodo mauris a velit malesuada vel placerat sem bibendum.
  
  Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Suspendisse sit amet risus ante, in egestas lacus. Nunc arcu lorem, dictum a convallis non, sagittis eget orci. Praesent porttitor sagittis est. Donec vel nulla lacus. Curabitur tincidunt lectus sit amet nulla porta eu vehicula tortor rhoncus. Praesent eget nunc non urna pulvinar ornare. Aenean feugiat, turpis sollicitudin elementum egestas, massa orci aliquam neque, id pharetra urna dolor et dui. Nam aliquet, sem in venenatis posuere, odio est dignissim massa, vitae lobortis velit orci a risus. Mauris tristique porta mauris, a mollis nulla placerat at. Donec metus mi, blandit quis consequat sit amet, dapibus a nibh. Sed molestie augue eu nunc lobortis tincidunt.
  "

casper.dumpAllHeaders = ->
  @currentResponse.headers.forEach (header) ->
    casper.echo "Header: "+header.name+': '+header.value

##################################################
# Event Hooks
###############################

casper.test.on "fail",       (failure)  ->
  casper.takeScreenshot(casper.testSetup.currenttest)

casper.on 'http.status.404', (resource) ->
  @echo 'this url is 404 Not Found: ' + resource.url

casper.on 'http.status.500', (resource) ->
  @echo 'Detected 500 server error: ' + resource.url

casper.on 'page.created',    (page)     ->
  @echo 'Page Creation Detected '+page.url

casper.on 'url.changed',     (url)      ->
  @echo 'URL Change Detected: '+url

casper.on 'http.status.301', (resource) ->
  @echo '301 permanently moved received '+resource.url

casper.on "load.finished", (status) ->
  @echo "Loaded document"
  @stepReady = false
  @stepReady = true if "success" is status

# Scan for the word notice|warning|error|exception by default
# casper.on "step.complete", (page) ->
  # Skip urls that can contain 'error'/'exception'
  # u = casper.getCurrentUrl()
  # if (u == "https://#{testhost}/nonexistent")
    # return

casper.test.done 0
