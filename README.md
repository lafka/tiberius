# I am!

`erl_boot_server` is a bit of a mess. _Tiberius_ provides the building
blocks for working with Erlang containers.

This is so alpha that there is little besides this readme and a makefile.
The future will be alot more exciting. All code available under BSD 2-clause.

## Tell me more!!!!

Erlang/OTP provides the primitives required for remote code loading.
This needs to follow a specific structure and is non-trivial to do
manually for many releases.

Tiberius consumes a _code registry_ that contains a set of Erlang
releases (.tar'ed together). These releases are deployed by spawning a
minimal version of ERTS that uses the `inet` loader to fetch the .boot,
.config, code etc files from a Tiberius server.

## A script is worth a thousand words

```bash
$ tiberius help
usage: tiberius <command>

Commands:
  foreground  -- Start Tiberius in foreground for debugging
  server      -- Start/stop a Tiberius daemon
  artifact    -- Add, remove code artifacts from Tiberius
  config      -- Manipulate the configuration of a code artifact
  container   -- Commands for working with containers (spawn, delete, upgrade, etc)


# Add some code
$ tiberius server start
$ tiberius artifact add riak 1.3.1 /var/cache/riak-1.3.1.tar
$ tiberius artifact add wapp 3.0.4 /var/cache/wapp-1.0.9.tar

# Set leveldb backend for all instances, applies only to next startup
$ tiberius artifact config riak-1.3.1 riak_kv.storage_backend riak_kv_eleveldb_backend

# Spawn a one-time container
$ tiberius container spawn riak 1.3.1`
riak-reb84

# Create supervised containers
$ tiberius container create riak-1.3.1 --num 3
riak-1ed5h riak-90bb0 riak-a0e6c

$ tiberius container create wapp-1.0.9 --num 3
wapp-2eb1e wapp-8812e wapp-403f3

# Set container specific configuration (this is persisted) and restart
$ tiberius container config wapp-403f3 wapp.listen '[{80, http}, {443, https}]'
$ tiberius container restart wapp-403f3

# List all containers
$ tiberius container list
riak (1.3.1):
  riak-3eb84 riak-1ed5h riak-90bb0 riak-a0e6c

wapp (1.0.9):
  wapp-2eb1e wapp-8812e wapp-403f3
```

In the above code we registered the available code and deployed a Riak
and application cluster.  The supervised instances are monitored by Tiberius,
if any instances crashes it will be restarted.


## Creating Tiberius code appliances
Have a release? then you are done. Erlang artifacts are just zip files
with the structure <appname->[-<appvsn>]/{ebin,lib,..}.


```bash
$ zip -r myapp-0.0.1.ez myapp-0.0.1
```

