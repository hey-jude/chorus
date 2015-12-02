# Chorus Authorization component

This is an example of a "vertically integrated" component -- it touches Core, Api, and Admin.  
 
KT TODO documentation


## Database migrations

rake db:migrate
rake db:rollback VERSION=20151201215306


## Running the RSpec tests

    cd components/authorization_simpler
    ./bin/bundle
    RAILS_ENV=test rake app:db:create app:db:migrate    
    rpsec spec