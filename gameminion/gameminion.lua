-----------------------------------------------------------------------------------------
-- GameMinion Class
-----------------------------------------------------------------------------------------
GameMinion = Core.class(EventDispatcher)

-----------------------------------------------------------------------------------------
function GameMinion:init(accessKey, secretKey)
   
   -- Save the api description
   self.api = dofile("gameminion.txt")

   -- Create authentication header
   self.headers = { Authorization = "Basic " .. b64enc(accessKey..":"..secretKey) }

   -- Other things we need to remember ...
   self.authToken = nil
   
   -- For each method
   for name, t in pairs(self.api.methods) do

      -- Create a function
      self[name] = function(self, ...)
         self:callMethod(name, t, ...)
      end

   end

end

-----------------------------------------------------------------------------------------
function GameMinion:callMethod(name, t, ...)
   local index    = 1
   local argList  = {}
   local callback = nil

   -- For each required argument
   if t.required_params then
      for _,a in ipairs(t.required_params) do
         argList[a] = arg[index]
         index = index + 1
      end
   end
   
   -- For each optional argument
   if t.optional_params then
      for _,a in ipairs(t.optional_params) do
         if arg[index] == nil or type(arg[index]) == "function" then
            break;
         else
            argList[a] = arg[index]
         end
         index = index + 1
      end
   end
   
   -- Handle callback if necessary
   if arg[index] and type(arg[index]) == "function" then
      callback = arg[index]
   end
   
   -- Add authentication key if required
   if t.authentication then
      assert(self.authToken)
      argList.auth_token = self.authToken
   end
   
   -- Call the method; handle login function as a special case
   if name == "login" then
      restCall(self.api.base_url, t.path, t.method, self.headers, argList, function(response)
         if not response.error then
            self.authToken = response.data.auth_token;
         end
         if callback then callback(response) end
      end)
   else
      restCall(self.api.base_url, t.path, t.method, self.headers, argList, callback)
   end
   
end
