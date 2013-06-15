# Reltool breaks

It seems like reltool generated releases are not working out of the
box. It seems to be related to the paths in <rel>.script are relative
to the root dir of the client vm. When rewritten[1] it seems to work.

**[1] Fixing bootscripts** _(validate by checking `erl_prim_loader:get_path()`)_
```bash
sed -i 's/\$ROOT/\/tmp\/boottest\/_rel/g' _rel/releases/myapp-0.0.1/myapp.script
erl -eval 'systools:script2boot("_rel/releases/myapp-0.0.1/myapp").'
```

# Generating & loading archives

```bash
# Generate release and deploy to boot server
relx
ln -s _rel myapp-0.0.1
zip -r myapp-0.0.1.ez myapp-0.0.1
mkdir -p /tmp/tiberius/dist
cp myapp-0.0.1.ez /tmp/tiberius/dist
cd /tmp/tiberius
erl -id bootserver -name bootserver -run erl_boot_server start 127.0.0.1 
```

```bash
# Load remote release
erl -id myapp -name myapp -loader inet -hosts 127.0.0.1 -boot dist/myapp-0.0.1.ez/myapp-0.0.1/releases/myapp-0.0.1/myapp 
```

## Problems with starting release

If using `reltool` based release, the application will not start
automatically. This is due to a lacking `{apply,{application,start_boot,[myapp,permanent]}}`
argument in the boot file _(relx fucked up?)_.  Alternativly, a it can
be fixed by calling application:start/1 manualy.


