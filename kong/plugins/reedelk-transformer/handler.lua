local BasePlugin = require "kong.plugins.base_plugin"
local upstream_handler = require "kong.plugins.reedelk-transformer.upstream_handler"
local downstream_handler = require "kong.plugins.reedelk-transformer.downstream_handler"

local ReedelkPlugin = BasePlugin:extend()

ReedelkPlugin.PRIORITY = 2000

function ReedelkPlugin:new()
  ReedelkPlugin.super.new(self, "reedelk-transformer")
end

function ReedelkPlugin:access(conf)
  ReedelkPlugin.super.access(self)
  upstream_handler.execute(conf)
end

function ReedelkPlugin:header_filter(conf)
  ReedelkPlugin.super.header_filter(self)
  downstream_handler.handle_headers(conf)
end

function ReedelkPlugin:body_filter(conf)
  ReedelkPlugin.super.body_filter(self)
  downstream_handler.handle_body(conf)
end

return ReedelkPlugin