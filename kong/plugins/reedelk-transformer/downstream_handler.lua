local concat = table.concat
local kong = kong
local ngx = ngx
local http = require("socket.http")
local ltn12 = require"ltn12"

local _M = {}

function _M.handle_headers(conf)
 if conf.downstream_transformer_url ~= nil then
  -- downstream transformer url has been configured for the plugin, 
  -- we must remove the content length because the downstream transformer 
  -- has (potentially) changed the payload, and therefore the content length has changed.
  -- ngx will take care of setting the correct content length for us.
  kong.response.clear_header("Content-Length")
  return
 end
end

function _M.handle_body(conf)
 if conf.downstream_transformer_url == nil then
  -- downstream transformer url has not been configured for the plugin.
  -- nothing to do, we just return immediately. 
  return
 end

 local ctx = ngx.ctx
 local chunk, eof = ngx.arg[1], ngx.arg[2]

 ctx.rt_body_chunks = ctx.rt_body_chunks or {}
 ctx.rt_body_chunk_number = ctx.rt_body_chunk_number or 1

 -- the handle body method can be called multiple times if the response
 -- from the upstream service is bigger than a certain size or the
 -- response content encoding from the service is 'chunked'.
 -- Before calling the downstream transformer we must wait until the
 -- full response has been received, and we store each chunk into a
 -- temporary array named 'rt_body_chunks'. If we reached 'eof',
 -- then all the chunks have been received and stored in memory and we
 -- can call the downstream transformer service with the downstream service
 -- payload. The result of the transformation is assigned to the 'ngx.arg[1]'
 -- variable which will be used to determine the content to be sent back to
 -- the client.
 if eof then
  local chunks = concat(ctx.rt_body_chunks)
  local respbody = {}

  -- Call Reedelk flow
  body, respcode, respheaders = http.request {
  	method = 'POST',
  	url = conf.downstream_transformer_url,
  	source = ltn12.source.string(chunks),
  	sink = ltn12.sink.table(respbody),
  	headers = kong.service.response.get_headers()
  }

  ngx.arg[1] = table.concat(respbody)

 else
   ctx.rt_body_chunks[ctx.rt_body_chunk_number] = chunk
   ctx.rt_body_chunk_number = ctx.rt_body_chunk_number + 1
   ngx.arg[1] = nil
 end

end


return _M