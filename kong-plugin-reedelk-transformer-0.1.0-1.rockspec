package = "kong-plugin-reedelk-transformer"
version = "0.1.0-1"

local pluginName = package:match("^kong%-plugin%-(.+)$")

supported_platforms = {"linux", "macosx"}
source = {
  url = "https://github.com/reedelk/kong-plugin-reedelk-transformer.git",
  tag = "0.1.0"
}

description = {
  summary = "Reedelk Transformer Plugin",
  homepage = "https://www.reedelk.com",
  license = "Apache 2.0"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
    ["kong.plugins."..pluginName..".downstream_handler"] = "kong/plugins/"..pluginName.."/downstream_handler.lua",
    ["kong.plugins."..pluginName..".upstream_handler"] = "kong/plugins/"..pluginName.."/upstream_handler.lua",
  }
}