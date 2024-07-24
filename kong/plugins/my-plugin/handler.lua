local http  = require("resty.http")
local cjson = require("cjson.safe")

local MyPluginHandler = {
 PRIORITY = 1000,
 VERSION = "0.0.1",
}

function MyPluginHandler:response(conf)

 kong.log("response handler")

 local httpc = http.new()

 local res, err = httpc:request_uri(conf.service_url, {
   method = "GET",
 })

 if err then
   return kong.response.error(500,
     "Error when trying to access 3rd party service: " .. err,
     { ["Content-Type"] = "text/html" })
 end

 local body_table, err = cjson.decode(res.body)

 if err then
   return kong.response.error(500,
     "Error when decoding 3rd party service response: " .. err,
     { ["Content-Type"] = "text/html" })
 end

 kong.response.set_header(
   conf.response_header_name,
   body_table.url or "No URL found")

end

return MyPluginHandler

-- local http  = require("resty.http")
-- local cjson = require("cjson.safe")

-- local MyPluginHandler = {
--  PRIORITY = 1000,
--  VERSION = "0.0.1",
-- }

-- function MyPluginHandler:response(conf)
--   kong.log("response handler")

--   if kong.request.get_header("content-type") == "application/grpc" then
--     kong.log("Handling gRPC request")
--     -- Xử lý yêu cầu gRPC
--     local grpc_req = kong.grpc.req
--     local grpc_service = grpc_req.service
--     local grpc_method = grpc_req.method

--     local httpc = http.new()
--     local res, err = httpc:request_uri(conf.service_url, {
--       method = "POST",
--       body = cjson.encode({ service = grpc_service, method = grpc_method }),
--       headers = {
--         ["Content-Type"] = "application/json"
--       }
--     })

--     if err then
--       return kong.response.error(500, "Error when trying to access 3rd party service: " .. err)
--     end

--     local body_table, err = cjson.decode(res.body)
--     if err then
--       return kong.response.error(500, "Error when decoding 3rd party service response: " .. err)
--     end

--     kong.response.set_header(conf.response_header_name, body_table.message or "No message found")
--   else
--     kong.log("Handling HTTP request")
--     -- Xử lý yêu cầu HTTP
--     local httpc = http.new()
--     local res, err = httpc:request_uri(conf.service_url, {
--       method = "GET"
--     })

--     if err then
--       return kong.response.error(500, "Error when trying to access 3rd party service: " .. err)
--     end

--     local body_table, err = cjson.decode(res.body)
--     if err then
--       return kong.response.error(500, "Error when decoding 3rd party service response: " .. err)
--     end

--     kong.response.set_header(conf.response_header_name, body_table.url or "No URL found")
--   end
-- end

-- return MyPluginHandler