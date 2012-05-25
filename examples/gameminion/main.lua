------------------------------------------------------------------------------------------
-- Gideros currently seems to have a bug w/ simultaneous urlloader's OR my code has a bug?
-- This following utilities delay api calls and handle responses generically
------------------------------------------------------------------------------------------
local delay = 1000
local inc   = 1000
function delayedCall(func, ...)
   local arg = {n=select('#', ...), ...}
   Timer.delayedCall(delay, function() func(unpack(arg)) end)
   delay = delay + inc
end

function h(r, name)
   return function(r)
         print("--------------- "..name)
         if r.error then print("ERROR") else print(inspect(r.data)) end
   end
end

------------------------------------------------------------------------------------------
-- Access and secret keys are given to you when you get a GameMinion account
------------------------------------------------------------------------------------------
accessKey = "REMOVED - YOU NEED TO FILL THIS IN"
secretKey = "REMOVED - YOU NEED TO FILL THIS IN"

-- Initialize GameMinion object
gm = GameMinion.new(accessKey, secretKey)

-- Login 
gm:login("<username ... add this>", "<password ... add this>", function(r)
   if r.error then
      print("--------------- Error logging in")
      print(r.url)
   else
      print("SUCCESS: Logged in!")

      -- Get my profile
      delayedCall(gm.getMyProfile, gm, h(r,"getMyProfile"))

      -- Get another users profile
      delayedCall(gm.getUserProfile, gm, "4fbc84410b6c20000100000e", h(r,"getUserProfile"))

      -- Add a friend
      delayedCall(gm.addFriend, gm, "4fbc84410b6c20000100000e", h(r,"addFriend"))

      -- Get friends
      delayedCall(gm.getFriends, gm, h(r,"getFriends"))

      -- Remove a friend
      delayedCall(gm.removeFriend, gm, "4fbc84410b6c20000100000e", h(r,"removeFriend"))

      -- Get leaderboards
      delayedCall(gm.getLeaderboards, gm, h(r,"getLeaderboards"))

      -- Submit high scores
      delayedCall(gm.submitHighScore, gm, "4fbc961b5aea69000100004b", 7200, h(r,"submitHighScore"))
      delayedCall(gm.submitHighScore, gm, "4fbc98205aea690001000055", 3395, h(r,"submitHighScore"))

      -- Get high scores
      delayedCall(gm.getHighScores, gm, "4fbc961b5aea69000100004b", h(r,"getHighScores"))
      delayedCall(gm.getHighScores, gm, "4fbc98205aea690001000055", h(r,"getHighScores"))

      -- Get news
      delayedCall(gm.getNews, gm, h(r,"getNews"))

      -- Get unread news
      delayedCall(gm.getUnreadNews, gm, h(r,"getUnreadNews"))

      -- Get news article
      delayedCall(gm.getNewsArticle, gm, "4fbec83534121b0001000034", h(r,"getNewsArticle"))

   end
end)
