# Kong Plugin Reedelk Transformer

The Reedelk transformer plugin allows to transform the upstream request body or downstream request body by invoking a Reedelk REST flow before hitting the upstream server or before sending the response downstream back to the client. The plugin allows to apply upstream and downstream transformation together as well.


## Configuration

This plugin is compatible with requests with the following protocols:

* HTTP
* HTTPS

### Enabling the plugin on a Service

Configure this plugin on a Service by making the following request:

```bash
$ curl -X POST http://kong:8001/services/{service}/plugins \
    --data "name=reedelk-transformer"
```

`service`: the `id` or `name` of the Service that this plugin configuration will target.

### Enabling the plugin on a Route

Configure this plugin on a Route with:

```bash
$ curl -X POST http://kong:8001/routes/{route_id}/plugins \
    --data "name=reedelk-transformer"
```

`route_id`: the `id` of the Route that this plugin configuration will target.

### Enabling the plugin on a Consumer
You can use the `http://localhost:8001/plugins` endpoint to enable this plugin on specific Consumers:

```bash
$ curl -X POST http://kong:8001/plugins \
    --data "name=reedelk-transformer" \
    --data "consumer_id={consumer_id}"

## Building and packaging using LuaRocks

```bash
# install it locally (based on the `.rockspec` in the current directory)
$ luarocks make
```

```bash
# pack the installed rock
$ luarocks pack kong-plugin-reedelk-transformer 0.1.0-1
```

## Credits

made by Reedelk