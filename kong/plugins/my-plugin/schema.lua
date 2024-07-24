local typedefs = require "kong.db.schema.typedefs"

local PLUGIN_NAME = "my-plugin"

local schema = {
 name = PLUGIN_NAME,
 fields = {
   { config = {
       type = "record",
       fields = {
         { response_header_name = typedefs.header_name {
           required = false,
           default = "X-MyPlugin" } },
         { service_url = {
           type = "string",
           required = true,
         }},
       },
     },
   },
 },
}

return schema