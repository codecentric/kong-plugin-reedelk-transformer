# Kong Plugin Reedelk Transformer

The Reedelk transformer plugin allows to transform the upstream request body or downstream response body by invoking a Reedelk REST flow before hitting the upstream server or before sending the downstream response back to the client. The plugin allows to apply upstream and downstream transformation together as well.

## Prerequisites for integrating Reedelk and Kong
Please note, in order to use the Reedelk plugin for Kong, you must first install the Reedelk IntelliJ IDEA plugin.



* Install Reedelk IntelliJ flow designer plugin from IntelliJ Marketplace: From IntelliJ Preferences > Plugin > Marketplace search ‘Reedelk’, install the plugin and restart IntelliJ.

* Manually install Reedelk IntelliJ flow designer plugin: download the plugin from the [Reedelk releases](https://www.reedelk.com/documentation/releases) page.
From IntelliJ Preferences > Plugin > Settings icon > Install Plugin From Disk ...

## Installation

1. The [LuaRocks](http://luarocks.org) package manager must be [Installed](https://github.com/luarocks/luarocks/wiki/Download).

2. [Git](https://git-scm.com/downloads) must be installed.

2. [Kong](https://getkong.org) must be [Installed](https://getkong.org/install/) and you must be familiar with using and configuring Kong.

3. Clone the kong-plugin-reedelk-transformer:
```bash
git clone https://github.com/reedelk/kong-plugin-reedelk-transformer.git

cd kong-plugin-reedelk-transformer
```

4. Install the module kong-plugin-reedelk-transformer.
```bash
luarocks install kong-plugin-reedelk-transformer-0.1.0-1.all.rock
```

5. Add the custom plugin to the `kong.conf` file (e.g. `/etc/kong/kong.conf`)
```
plugins = ...,reedelk-transformer
```
6. Restart kong

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

#### With database:

```bash
  $ curl -X POST http://kong:8001/services/{service}/plugins \
    --data "name=reedelk-transformer" \
    --data "upstream_transformer_url=http://myhost/upstream/transform"
    --data "downstream_transformer_url=http://myhost/downstream/transform"
```

`service`: the `id` or `name` of the Service that this plugin configuration will target. The `upstream_transformer_url` and `downstream_transformer_url` are the URL of the Reedelk REST flow endpoint to be invoked for the upstream/downstream request/response transformations e.g. http://localhost:8888/apiabledev/transform

#### Without a database:
Add the following to the kong.yml configuration file:

```bash
  plugins:
  - name: reedelk-transformer
    service: {service}
    config:
     upstream_transformer_url: "http://myhost/upstream/transform"
     downstream_transformer_url: "http://myhost/downstream/transform"
```

### Enabling the plugin on a Route

#### With database:

```bash
  $ curl -X POST http://kong:8001/routes/{route_id}/plugins \
    --data "name=reedelk-transformer" \
    --data "upstream_transformer_url=http://myhost/upstream/transform"
    --data "downstream_transformer_url=http://myhost/downstream/transform"
```

`route_id`: the `id` of the Route that this plugin configuration will target. The `upstream_transformer_url` and `downstream_transformer_url` are the URL of the Reedelk REST flow endpoint to be invoked for the upstream/downstream request/response transformations e.g. http://localhost:8888/apiabledev/transform

#### Without a database:
Add the following to the kong.yml configuration file:

```bash
  plugins:
  - name: reedelk-transformer
    route: {route}
    config:
     upstream_transformer_url: "http://myhost/upstream/transform"
     downstream_transformer_url: "http://myhost/downstream/transform"
```

## Building and Packaging

1. The [LuaRocks](http://luarocks.org) package manager must be [Installed](https://github.com/luarocks/luarocks/wiki/Download).

2. Build the plugin locally (based on the `.rockspec` in the current directory).

```bash
$ luarocks make
```

3. Package the plugin.

```bash
$ luarocks pack kong-plugin-reedelk-transformer 0.1.0-1
```

## Credits

made by [Reedelk](https://www.reedelk.com/)