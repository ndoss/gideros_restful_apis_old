------------------------------------------------------------------------------------------
-- This following utility function handles responses generically
------------------------------------------------------------------------------------------
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
      gm:getMyProfile(h(r,"getMyProfile"))

      -- Get another users profile
      gm:getUserProfile("4fbc84410b6c20000100000e", h(r,"getUserProfile"))

      -- Get leaderboards
      gm:getLeaderboards(h(r,"getLeaderboards"))

      -- Submit high scores
      gm:submitHighScore("4fbc961b5aea69000100004b", 7200, h(r,"submitHighScore"))
      gm:submitHighScore("4fbc98205aea690001000055", 3395, h(r,"submitHighScore"))

      -- Get high scores
      gm:getHighScores("4fbc961b5aea69000100004b", h(r,"getHighScores"))
      gm:getHighScores("4fbc98205aea690001000055", h(r,"getHighScores"))

      -- Get news
      gm:getNews(h(r,"getNews"))

      -- Get unread news
      gm:getUnreadNews(h(r,"getUnreadNews"))

      -- Get news article
      gm:getNewsArticle("4fbec83534121b0001000034", h(r,"getNewsArticle"))

      -- Add a friend, verify he was added, then delete him
      gm:addFriend("4fbc84410b6c20000100000e", function(r)
         print("--------------- addFriend")
         if r.error then 
            print("ERROR") 
         else 
            print(inspect(r.data)) 
            gm:getFriends(function(r)
               print("--------------- getFriends")
               if r.error then 
                  print("ERROR") 
               else 
                  -- It was a short friendship
                  print(inspect(r.data)) 
                  gm:removeFriend("4fbc84410b6c20000100000e", h(r,"removeFriend"))
               end
            end)
         end
      end)
   end
end)