# Kong Plugin Reedelk Transformer

The Reedelk transformer plugin allows to transform the upstream request body or downstream response body by invoking a Reedelk REST flow before hitting the upstream server or before sending the downstream response back to the client. The plugin allows to apply upstream and downstream transformation together as well.

## Prerequisites for integrating Reedelk and Kong
Please note, in order to use the Reedelk plugin for Kong, you must first install the Reedelk IntelliJ IDEA plugin.

* Install Reedelk IntelliJ flow designer plugin from IntelliJ Marketplace: From IntelliJ Preferences > Plugin > Marketplace search ‘Reedelk’, install the plugin and restart IntelliJ.

* Manually install Reedelk IntelliJ flow designer plugin: download the plugin from the [Reedelk releases](https://www.reedelk.com/documentation/releases) page.
From IntelliJ Preferences > Plugin > Settings icon > Install Plugin From Disk and restart IntelliJ.

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

## Kong Reedelk Transformer plugin 'Hello World'

Preconditions:

* [Docker](https://www.docker.com/) must be [Installed](https://www.docker.com/get-started).
* [IntelliJ IDEA IDE](https://www.jetbrains.com/idea/) must be [Installed](https://www.jetbrains.com/idea/download)
* [Reedelk IntelliJ Flow Designer Plugin](https://www.reedelk.com/documentation/intellijplugin) must be [Installed](https://www.reedelk.com/documentation/intellijplugin) on your IntelliJ distribution.


In this example we are going to use a pre-packaged kong-reedelk docker image with Kong and reedelk-transformer plugin already installed. The kong-reedelk docker images can be found on [Dockerhub](https://hub.docker.com/repository/docker/reedelk/kong-reedelk). 

The kong-reedelk image is pre-configured to use the following [kong.yml](https://github.com/reedelk/kong-plugin-reedelk-transformer/blob/master/kong.yml) file which defines an [upstream service](https://www.reedelk.com/tutorials/upstream/service) mapped on route http://localhost:8000/transform and invokes a downstream transformer with the reedelk-transformer plugin. The configured downstream transformer integration flow URL is: http://host.docker.internal:8282/api/message. 

In the following steps we will run kong-reedelk docker image and then create a new Reedelk project containing the integration flow to be invoked by the downstream transformer:

1. Run the kong-reedelk image:
```bash
docker run -d --name kong-reedelk-transformer-plugin \
            -p 8000:8000 \
            -p 8443:8443 \
            -p 127.0.0.1:8001:8001 \
            -p 127.0.0.1:8444:8444 \
            reedelk/kong-reedelk-transformer-plugin:1.0.0
```

2. Make sure that kong is up and running correctly with reedelk-transformer plugin installed:
```bash
curl http://localhost:8001/plugins
```

3. Open IntelliJ and create a new Reedelk project. The newly created project contains a 'POST Hello World' flow that we are going to use as integration flow to be invoked by the downstream transformer.

4. Start the new Reedelk project by clicking on the 'Play' button next to the Reedelk runtime run configuration.

5. Call the Kong route [http://localhost:8000/transform](http://localhost:8000/transform). The result should be: 'Hello World John'.

## Supported Kong Releases
The Kong Reedelk Transformer Plugin is supported from Kong version >= 1.5.1.

## Credits

made by [Reedelk](https://www.reedelk.com/)
