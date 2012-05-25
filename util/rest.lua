-----------------------------------------------------------------------------------------
-- Private utility functions
-----------------------------------------------------------------------------------------
local json = require("Json")

local methods = {
   GET    = UrlLoader.GET,
   PUT    = UrlLoader.PUT,
   POST   = UrlLoader.POST,
   DELETE = UrlLoader.DELETE,
}

function restCall(baseUrl, path, method, headers, argList, callback)
   -- Handle args and path/arg substitution
   local args = ""
   local newpath = path
   for a,v in pairs(argList) do
      -- Try to substitue into path
      newpath, count = newpath:gsub(":"..a, v)
      if count == 0 then
         if args == "" then
            args = "?"..a.."="..v
         else
            args = args .."&".. a .."="..v
         end
      end
   end

   -- Call load the url
   local url = baseUrl .. "/" .. newpath .. args
   local urlLoader = UrlLoader.new(url, methods[method], headers)

   -- Add event handlers
   function handleResponse(response, error)
      response.url     = url
      response.method  = method
      response.error   = error
      if response.data then
         local ok, msg = pcall(function() return json.Decode(response.data) end)
         if ok then
            response.data    = msg
         end
      else
         response.data    = {}
      end
      if callback then callback(response) end
   end

   urlLoader:addEventListener(Event.COMPLETE, function(response) handleResponse(response, false) end)
   urlLoader:addEventListener(Event.ERROR,    function(response) handleResponse(response, true) end)
end
