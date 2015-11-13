# Chorus Api component

This is a JSON API -- namespaced behind an `/api` root.  There are routes, which wire up controllers, which use the
models (from the Core component) to get data from Postgres.  Then, there's a custom system (the 'presenters') 
for rendering the Ruby objects into JSON.

There's API documentation as well using Chorus's forked [rspec_api_documentation](https://github.com/Chorus/rspec_api_documentation) 
gem.  That stuff is in `spec/api_docs`.
 
## Running the RSpec tests

    cd components/api
    ./bin/bundle
    rpsec spec
