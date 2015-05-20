vcl 4.0;

backend default {
  .host = "127.0.0.1";
  .port = "8000";
}


sub vcl_backend_response {
  set beresp.do_esi = true;
}

