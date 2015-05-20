# The problem

You have an api entry point which have a static and a dynamic part.
You want to cache the static part and not the dynamic part, but still
having clients use a single entry point.

# The solution

Split the api into 2 entry points in the backend, and use varnish
ESI to join the outputs.

# Example API and methods

Supose we want an api like so:

    $ curl http://localhost/hi/Giorgenes
    {"message":"hello", "name":"Giorgenes"}

The message is the static part that we want to cache, but
we don't want to cache the dynamic part (name: "Giorgenes")

So we split into 2 separate calls:

    $ curl http://localhost:8000/static
    {"message":"hello"}
    $ curl http://localhost:8000/dynamic/Giorgenes
    {"name":"Giorgenes"}

Then we use [Varnish ESI black magic](https://www.varnish-cache.org/docs/4.0/users-guide/esi.html?highlight=esi_syntax)
to tie the 2 backend methods together. We have to make the api call on
the backend return ESI information to varnish, like so:

    $ curl http://localhost:8000/hi/Giorgenes
    {"static":<esi:include src="/static" />,"dynamic":<esi:include src="/dynamic/Giorgenes" />}

This will instruct varnish to fetch the 2 backend entry points specified
in the output and replace in the final output:

    $ curl http://localhost/hi/Giorgenes
    {"static":{"message":"hello"},"dynamic":{"name":"Giorgenes"}}

The only problem here is that we now have a json with 2 parts:
static and dynamic. But this can easily be solved by clients
by passing the output into a merger filter, like so:

    deep_merge(result['static'], result['dynamic'])
    => { 'message' : 'hello', 'name' : 'Giorgenes'}

# Dependencies

- varnish =~ 4.0.3
