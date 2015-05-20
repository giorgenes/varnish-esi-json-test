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
    {"message":"hello", "name":"5"}

# Dependencies

- varnish =~ 4.0.3
