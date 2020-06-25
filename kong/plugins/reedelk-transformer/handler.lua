local BasePlugin = require "kong.plugins.base_plugin"
local upstream_handler = require "kong.plugins.reedelk-transformer.upstream_handler"
local downstream_handler = require "kong.plugins.reedelk-transformer.downstream_handler"

local ReedHubPlugin = BasePlugin:extend()

ReedHubPlugin.PRIORITY = 2000

function ReedHubPlugin:new()
  ReedHubPlugin.super.new(self, "reedelk-transformer")
end

function ReedHubPlugin:access(conf)
  ReedHubPlugin.super.access(self)
  upstream_handler.execute(conf)
end

function ReedHubPlugin:header_filter(conf)
  ReedHubPlugin.super.header_filter(self)
  downstream_handler.handle_headers(conf)
end

function ReedHubPlugin:body_filter(conf)
  ReedHubPlugin.super.body_filter(self)
  downstream_handler.handle_body(conf)
end

return ReedHubPlugin