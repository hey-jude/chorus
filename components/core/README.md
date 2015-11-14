# Chorus Core component

An alternative name we considered was `persistence` (as in, database persistence).  It contains
the Rails models, migrations, 'services' and other Ruby-centric stuff.

Whereas, we might consider swapping out the 'api' or 'frontend' components, it's hard to imagine replacing
this Core component, it really is, the Core of the app.
 
## Running the RSpec tests

    cd components/core
    ./bin/bundle
    rpsec spec
