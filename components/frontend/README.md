# Chorus Frontend component

I considered calling it `frontend_backbone` -- it contains the javascript backbone.js generated UI, as well as the CSS 
this requires.  It also contains a huge Jasmine test suite.  

It's dependent on the Api component to interact with the Core component.
 
# Running the Jasmine specs

There are two ways:
 
  1) Run the Jasmine server, and then load the tests in your browser in an interactive test runner:

    cd components/frontend
    ./bin/bundle
    rake app:jasmine
    Visit -> http://localhost:8888/
    
  You can zero in on specific tests using this syntax:
     
     http://localhost:8888/?spec=chorus.alerts.Analyze
     
  2) KT TODO: Run the Jasmine server, and then run them using phantomjs.