local http = require("socket.http")
local ltn12 = require"ltn12"

local _M = {}

function _M.execute(conf)
  if conf.upstream_transformer_url == nil then
    -- There is no upstream transformer URL, therefore
    -- we just return without calling the middleman service
    return
  end
 
  local payload = kong.request.get_raw_body()
  local respbody = {} 

  -- Call Reedelk flow
  body, respcode, respheaders = http.request {
    method = 'POST',
    url = conf.upstream_transformer_url,
    source = ltn12.source.string(payload),
    headers = kong.request.get_headers(),
    sink = ltn12.sink.table(respbody)
  }

  local transformed_body = table.concat(respbody)
  local ok, err = kong.service.request.set_raw_body(transformed_body)

end

return _M
