# Kong Plugin Reedelk Transformer

The Reedelk transformer plugin allows to transform the upstream request body or downstream response body by invoking a Reedelk REST flow before hitting the upstream server or before sending the downstream response back to the client. The plugin allows to apply upstream and downstream transformation together as well.

## Installation

1. The [LuaRocks](http://luarocks.org) package manager must be [Installed](https://github.com/luarocks/luarocks/wiki/Download).

2. [Kong](https://getkong.org) must be [Installed](https://getkong.org/install/) and you must be familiar with using and configuring Kong.

3. Install the module kong-plugin-reedelk-transformer.
```bash
luarocks install kong-plugin-reedelk-transformer-0.1.0-1.all.rock
```

4. Add the custom plugin to the `kong.conf` file (e.g. `/etc/kong/kong.conf`)
```
plugins = ...,reedelk-transformer
```
5. Restart kong

## Configuration

The plugin accepts the following fields.

|Name    |Type|Required|Description                                                             |
|--------|----|--------|------------------------------------------------------------------------|
|upstream_transformer_url|string|false    | The URL of the Reedelk REST flow endpoint to be invoked for the upstream request transformation|
|downstream_transformer_url|string|false    | The URL of the Reedelk REST flow endpoint to be invoked for the downstram response transformation|

This plugin is compatible with requests with the following protocols:

* http
* https

This plugin is compatible with DB-less mode.

### Enabling the plugin on a Service

Configure this plugin on a Service by making the following request:

```bash
  $ curl -X POST http://kong:8001/services/{service}/plugins \
    --data "name=reedelk-transformer" \
    --data "upstream_transformer_url=http://myhost/upstream/transform"
    --data "downstream_transformer_url=http://myhost/downstream/transform"
```

`service`: the `id` or `name` of the Service that this plugin configuration will target. The `upstream_transformer_url` and `downstream_transformer_url` are the URL of the Reedelk REST flow endpoint to be invoked for the upstream/downstream request/response transformations.

### Enabling the plugin on a Route

Configure this plugin on a Route with:

```bash
  $ curl -X POST http://kong:8001/routes/{route_id}/plugins \
    --data "name=reedelk-transformer" \
    --data "upstream_transformer_url=http://myhost/upstream/transform"
    --data "downstream_transformer_url=http://myhost/downstream/transform"
```

`route_id`: the `id` of the Route that this plugin configuration will target. The `upstream_transformer_url` and `downstream_transformer_url` are the URL of the Reedelk REST flow endpoint to be invoked for the upstream/downstream request/response transformations.

## Building and Packaging using LuaRocks

```bash
# install it locally (based on the `.rockspec` in the current directory)
$ luarocks make
```

```bash
# pack the installed rock
$ luarocks pack kong-plugin-reedelk-transformer 0.1.0-1
```

## Credits

made by [Reedelk](https://www.reedelk.com/)