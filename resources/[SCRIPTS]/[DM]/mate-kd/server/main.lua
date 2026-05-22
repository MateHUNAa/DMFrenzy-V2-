local pedCache = {}
local eventLog = {}

local newKdPlayer =
"INSERT INTO `mate_kd` SET identifier = ?, kills = ?, deaths = ?, headshot = ?, npc_killed = ?, player_name = ?, highestKS = 0"
local updateKdPLayer = "UPDATE `mate_kd` SET kills = kills + 1 "
local updateNpcKills = "UPDATE `mate_kd` SET npc_killed = npc_killed + 1 "

function split(iunputstr, sep)
     local t = {}
     for str in string.gmatch(iunputstr, "([^" .. sep .. "]+)") do
          table.insert(t, str)
     end
     return t
end

-- local debug = GetConvar("matehun:global_debug", "0")

-- if debug == "0" then
--      print("[^4MateHUN-KD^0]: Server logs are disabled !")
--      function print()
--           return nil
--      end
-- else
--      print("[^4MateHUN-KD^0]: Debug mode is ^2enabled^0 !")
-- end


Log = (function(message, type)
     mCore.sendMessage(message, mCore.RequestWebhook(type), ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))
end)

local names = {
     human = {
          male = {
               "James", "John", "Robert", "Michael", "William", "David", "Richard", "Joseph", "Thomas", "Charles",
               "Christopher", "Daniel", "Matthew", "Anthony", "Donald", "Mark", "Paul", "Steven",
               "Andrew", "Kenneth", "Joshua", "Kevin", "Brian", "George", "Edward", "Ronald", "Timothy", "Jason",
               "Jeffrey",
               "Ryan", "Jacob", "Gary", "Nicholas", "Eric", "Jonathan", "Stephen",
               "Larry", "Justin", "Scott", "Brandon", "Benjamin", "Samuel", "Frank", "Gregory", "Raymond", "Alexander",
               "Patrick", "Jack", "Dennis", "Jerry", "Tyler", "Aaron", "Henry", "Adam",
               "Douglas", "Nathan", "Peter", "Zachary", "Kyle", "Walter", "Harold", "Jeremy", "Ethan", "Carl", "Keith",
               "Roger", "Gerald", "Christian", "Terry", "Sean", "Arthur", "Austin", "Noah",
               "Lawrence", "Jesse", "Joe", "Bryan", "Billy", "Jordan", "Albert", "Dylan", "Bruce", "Willie", "Gabriel",
               "Alan", "Juan", "Logan", "Wayne", "Ralph", "Roy", "Randy", "Vincent",
               "Russell", "Louis", "Philip", "Bobby", "Johnny", "Bradley", "Leon", "Lucas"
          },
          female = {
               "Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Barbara", "Susan", "Jessica", "Sarah", "Karen",
               "Nancy", "Lisa", "Margaret", "Betty", "Sandra", "Ashley", "Dorothy", "Kimberly", "Emily",
               "Donna", "Michelle", "Carol", "Amanda", "Melissa", "Deborah", "Stephanie", "Rebecca", "Laura", "Sharon",
               "Cynthia", "Kathleen", "Amy", "Shirley", "Angela", "Helen", "Anna", "Brenda", "Pamela",
               "Nicole", "Samantha", "Katherine", "Emma", "Ruth", "Christine", "Catherine", "Debra", "Rachel", "Carolyn",
               "Janet", "Virginia", "Maria", "Heather", "Diane", "Julie", "Joyce", "Victoria", "Kelly",
               "Christina", "Lauren", "Joan", "Evelyn", "Olivia", "Judith", "Megan", "Cheryl", "Martha", "Andrea",
               "Frances", "Hannah", "Jacqueline", "Ann", "Gloria", "Jean", "Kathryn", "Alice", "Teresa", "Sara",
               "Janice", "Doris", "Madison", "Julia", "Grace", "Judy", "Abigail", "Marie", "Denise", "Beverly", "Amber",
               "Theresa", "Marilyn", "Danielle", "Diana", "Brittany", "Natalie", "Sophia", "Rose",
               "Isabella", "Alexis", "Kayla", "Charlotte"
          }
     },
     animal = {
          cat = {
               "Luna", "Milo", "Oliver", "Leo", "Loki", "Bella", "Charlie", "Willow", "Lucy", "Simba",
               "Lily", "Nala", "Kitty", "Max", "Jack", "Ollie", "Jasper", "Chadwick", "Taylor", "Tom"
          },
          cormorant = {
               "Pterodactylus", "Greenie", "Chaffie", "Lolly", "Chiffy", "Goldie", "Shortie", "Buzzy", "Reggie", "Eider"
          },
          cow = {
               "Bessie", "Brownie", "Buttercup", "Clarabelle", "Dottie", "Guinness", "Magic", "Nellie", "Penelope",
               "Penny",
               "Rosie", "Snowflake", "Sprinkles", "Sugar", "Annabelle", "Bella", "Betty", "Betsie", "Bossy", "Daisy"
          },
          coyote = {
               "Jerry", "Jamul", "Yoda", "Tembi", "Ivory", "Apollo", "Cunawabi", "Billy", "Bobby", "Emma",
               "Iris", "Onyx", "Buddy", "Tilly", "Rex", "Suri", "Tequila", "Tokyo", "Noah", "Nova"
          },
          crow = {
               "Jon Snow", "Ravenclaw", "Darth Vader", "Watchman", "Crow Foot", "Russel Crowe", "Marty McFly", "Tweety",
               "Chick Jagger", "Chandler Wing",
               "Flappers", "Cheep", "Wing Crosby", "Paulie", "Feather Fawcett", "Luna", "Flight", "Stephen", "Charlotte",
               "Ruppet"
          },
          dog = {
               "Luna", "Milo", "Oliver", "Bear", "Loki", "Bella", "Charlie", "Cooper", "Lucy", "Max",
               "Lily", "Nala", "Kitty", "Max", "Jack", "Ollie", "Jasper", "Jax", "Penny", "Winston"
          },
          deer = {
               "Abie", "Bambi", "Beauty", "Blessed", "Bucky", "Buttercup", "Cainy", "Faith", "Freckles", "Gabriella",
               "Goodeness", "Goodiva", "Goody", "Gracie", "Hope", "Hurricane", "Isabella", "Ivan", "Stormy", "Wendy"
          },
          dolphin = {
               "Star", "Chirp", "Clicker", "Fin", "Cuddly", "Happy", "Lazy", "Bubbles", "Kisser", "Jumper",
               "Jumpy", "Trickster", "Hops", "Hopster", "Agape", "Flipper", "Snorky", "Alpha", "Beta", "Snowflake"
          },
          fish = {
               "Magikarp", "Sushi", "Nemo", "Delta", "Bait", "Neptune", "Atlantis", "Captain Jack", "Pacific", "Speedy",
               "Bob", "Fin", "Flounder", "Walleye", "Finn", "Oswald", "Ollie", "Flash", "Rex", "Salty"
          },
          hawk = {
               "Dudley", "Icarus", "Ristretto", "Maloney", "Chicory", "Timor", "Marlon", "Skyler", "Griffin", "Adelaide",
               "Lucy", "Cob", "Molly", "Mischief", "Zippo", "Tasha", "Dusty", "Sal", "Lou", "Tattoo"
          },
          hen = {
               "Albert Eggstein", "Big Bird", "Big Red", "Peri-Peri", "Eggs Benny", "Marshmallow", "Fluffy", "Molly",
               "Miss Daisy", "Snowball",
               "Bradley Coop-er", "Hen Solo", "Cluck Vader", "Princess Lay-a", "Jaba", "Hilary Fluff", "Meggatron",
               "Fowler", "Beaker", "Henny Penny"
          },
          humpback = {
               "Alpha", "Gamma", "Gunther", "Bruce", "Sergeant", "Gatsby", "Orlando", "Razor", "Lord", "Draco",
               "Zero", "Ralph", "King", "Zoro", "Silver", "Dragon", "Indigo", "Carlos", "Jackson", "Thaddeus"
          },
          killerwhale = {
               "Luna", "Springer", "Tilikum", "Ikaiki", "Ulises", "Tahlequah", "Granny", "Keiko", "Old Tom", "Lolita",
               "Moby Dhick", "Willy", "Namu", "Roxanne", "Tilly", "Winter", "Samson", "Iceberg", "Papa Whale", "Ariel"
          },
          mtlion = {
               "King", "Slim", "Fluffy", "Pudge", "Blimpy", "Butterball", "Achilles", "Chunk", "Chubbles", "Big Foot",
               "Giant", "Thumbelina", "Tundra", "Quarterback", "Chubby", "Fatma", "President", "Lord", "Fridge", "Speck"
          },
          panther = {
               "Darth", "Alfie", "Hunter", "Zara", "Salem", "Amy", "Halloween", "Phantom", "Annie", "Mr. Black",
               "Maya", "Damian", "Andy", "Freda", "Dante", "Kuro", "Hades", "Inky", "Mystery", "Yuka"
          },
          pig = {
               "Ace", "Aero", "Alexander", "Amy Swinehouse", "Anastacia", "Apollo", "Arabella", "Archie", "Arlo", "Atlas",
               "Babe", "Bacon", "Bartholomew", "Bella", "Benjamina", "Bloedworst", "Boerewors", "Bratwurst", "Bristle",
               "Buddy"
          },
          pigeon = {
               "Fred", "Chirpie", "Candy", "Florence", "Polly", "Sunny", "Auzzie", "Chip", "Jazzy", "Jonas",
               "Frankie", "Cherry", "Orlando", "Plato", "Odin", "Peachy", "Roxy", "Isabelle", "Wilbur", "Stella"
          },
          rabbit = {
               "Thumper", "Oreo", "Bun", "Bunn", "Coco", "Cocoa", "Daisy", "Bunny", "Cinnabun", "Snowball",
               "Buggs", "Marshmallow", "Midnight", "Thunderbunny", "Peppy Hare", "Oswald", "Jupiter", "Mars", "Neptune",
               "Artemis"
          },
          rat = {
               "Piper", "Reggie", "Flint", "Churro", "Wasabi", "Sushi", "Cheddar", "Benny", "Einstein", "Pascale",
               "Hugs", "Scarlet", "Dove", "Bella", "Hazel", "Chutney", "Mina", "Autumn", "Pip", "Fawn"
          },
          rhesus = {
               "Chucky", "George", "Bing", "Charlie", "Congo", "Leo", "Cedric", "Bear", "Milo", "Monty",
               "Jared", "Hunky", "Caesar", "Max", "Albert", "Steve", "Chester", "Hector", "Banana", "Bubbles"
          },
          seagull = {
               "Aqua", "Prickles", "Spring", "Jerry", "Munchkin", "Sue", "Gail", "Ivory", "Pickle", "Apricot",
               "Sasha", "Cupcake", "Josh", "Maddie", "Peachy", "Quirky", "Katie", "Bill", "Vanilla", "Tiny", "Nimble"
          },
          shark = {
               "Fuzzy", "Sugar", "Hairless", "Greyskin", "Sandy", "Tommy", "Ashleigh", "Umber", "Lawrence", "Fishy",
               "Hutch", "Werner", "Macy", "Peri", "Starsky", "Anakin", "Marge", "Cindy", "Jimbo", "Pamela"
          },
          stingray = {
               "Stripe", "Manta Ray", "Manta", "Batfish", "Ray", "Shark Ray", "Devilfish", "Sting Ray", "Parting",
               "Parsnip",
               "Whipray", "Skat", "Skate", "Ramp", "Stingaree", "Gail", "Spring", "Wasabi", "Sushi", "Flint"
          }
     }
}
local animalTypes = {
     [1462895032]  = "cat",         -- a_c_cat_01
     [1457690978]  = "cormorant",   -- a_c_cormorant
     [-50684386]   = "cow",         -- a_c_cow
     [1682622302]  = "coyote",      -- a_c_coyote
     [402729631]   = "crow",        -- a_c_crow
     [351016938]   = "dog",         -- a_c_chop
     [-1788665315] = "dog",         -- a_c_rottweiler
     [1318032802]  = "dog",         -- a_c_husky
     [882848737]   = "dog",         -- a_c_retriever
     [1126154828]  = "dog",         -- a_c_shepherd
     [-1384627013] = "dog",         -- a_c_westy
     [1125994524]  = "dog",         -- a_c_poodle
     [1832265812]  = "dog",         -- a_c_pug
     [-664053099]  = "deer",        -- a_c_deer
     [-1950698411] = "dolphin",     -- a_c_dolphin
     [802685111]   = "fish",        -- a_c_fish
     [-1430839454] = "hawk",        -- a_c_chickenhawk
     [1794449327]  = "hen",         -- a_c_hen
     [1193010354]  = "humpback",    -- a_c_humpback
     [-1920284487] = "killerwhale", -- a_c_killerwhale
     [307287994]   = "mtlion",      -- a_c_mtlion
     [-417505688]  = "panther",     -- a_c_panther
     [-832573324]  = "pig",         -- a_c_boar
     [-1323586730] = "pig",         -- a_c_pig
     [111281960]   = "pigeon",      -- a_c_pigeon
     [-541762431]  = "rabbit",      -- a_c_rabbit_01
     [-1011537562] = "rat",         -- a_c_rat
     [-1026527405] = "rhesus",      -- a_c_rhesus
     [-745300483]  = "seagull",     -- a_c_seagull
     [1015224100]  = "shark",       -- a_c_sharkhammer
     [113504370]   = "shark",       -- a_c_sharktiger
     [-1589092019] = "stingray"     -- a_c_stingray
}

local animalSuffixes = {
     ['cat']         = " the Cat",
     ['cormorant']   = " the Cormorant",
     ['cow']         = " the Cow",
     ['coyote']      = " the Coyote",
     ['crow']        = " the Crow",
     ['dog']         = " the Dog",
     ['deer']        = " the Deer",
     ['dolphin']     = " the Dolphin",
     ['fish']        = " the Fish",
     ['hawk']        = " the Hawk",
     ['hen']         = " the Hen",
     ['humpback']    = " the Humpback",
     ['killerwhale'] = " the Killerwhale",
     ['mtlion']      = " the Mountain Lion",
     ['panther']     = " the Panther",
     ['pig']         = " the Pig",
     ['pigeon']      = " the Pigeon",
     ['rabbit']      = " the Rabbit",
     ['rat']         = " the Rat",
     ['rhesus']      = " the Rhesus",
     ['seagull']     = " the Seagull",
     ['shark']       = " the Shark",
     ['stingray']    = " the Stingray"
}

-- END NAMES

ESX.RegisterServerCallback("matehunkd:getKd", function(src, cb)
     local xPlayer = mCore.getXPlayer(src)
     local identifer = xPlayer.getIdentifier()

     MySQL.query("SELECT * FROM `mate_kd` WHERE identifier = ?", {
          identifer
     }, function(res)
          if res then
               cb(res[1])
          else
               cb(false)
          end
     end)
end)


--
-- NPC KILLED ( KILLFEED )
--

local function AsyncRemoveCachedName(id)
     Citizen.CreateThread(function()
          Citizen.Wait(10000)
          pedCache[id] = nil
     end)
end
local function GetAnimalType(ped)
     local model = GetEntityModel(ped)
     return animalTypes[model]
end


local function GetRandomName(ped, pedType, gender)
     if pedType == "animal" then
          local animalType = GetAnimalType(ped)
          local index = math.random(1, #names.animal[animalType])
          local name = names.animal[animalType][index]

          if Config.AddAnimalSuffix then
               name = name .. animalSuffixes[animalType]
          end

          if Config.AddAnimalPrefix then
               name = Config.AnimalPrefix .. name
          end

          return name
     end

     if Config.UseEasterEggs then
          local easterEgg = math.random(1, 1000)
          if easterEgg == 69 then
               local index = math.random(1, #Config.EasterEggs)
               local name = Config.EasterEggs[index]

               if Config.AddAIPrefix then
                    name = Config.AIPrefix .. name
               end

               return name
          end
     end

     local index = math.random(1, #names[pedType][gender])
     local name = names[pedType][gender][index]

     if Config.AddAIPrefix then
          name = Config.AIPrefix .. name
     end

     return name
end


--
-- Events
--

---@class Player
---@field identifier string
---@field name string
---@field sourceId string
---@field netId number
---@field type "player"|"npc"|"animal"|"NotFound"

local killStreak = {}


---@param killer Player
---@param victim Player/
---@param noScoped boolean
---@param headshot boolean
---@param driveBy boolean
---@param showDist boolean|number
---@param image string
RegisterNetEvent('matehunkd:SaveData', function(killer, victim, noScoped, headshot, driveBy, showDist, image, weapon)
     if not killer or not victim then
          DropPlayer(source, "Exploit detection !")
          mCore.sendMessage(("%s(%s) Potential exploiting !"), mCore.RequestWebhook("error"),
               ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))
     end
     if killer.netId ~= 0 then
          if killer.type == "player" then
               killer.name = GetPlayerName(killer.sourceId)
               local killerIdentifier = GetPlayerIdentifierByType(killer.sourceId, "license")
               local killerPlayer = ESX.GetPlayerFromId(killer.sourceId)
               killer.identifier = split(killerIdentifier, ":")[2]

               while not killerPlayer do Wait(150) end

               killer.xPlayer = killerPlayer
          end

          if victim.type == "player" then
               victim.name = GetPlayerName(victim.sourceId)
               local victimIdentifier = GetPlayerIdentifierByType(victim.sourceId, "license")
               victim.identifier = split(victimIdentifier, ":")[2]
          end

          if showDist then
               if killerEntity == nil then
                    killerEntity = NetworkGetEntityFromNetworkId(killer.netId)
               end
               victimEntity = NetworkGetEntityFromNetworkId(victim.netId)
               showDist = #(GetEntityCoords(killerEntity) - GetEntityCoords(victimEntity))
               if Config.KillDistanceUnit == "feet" then
                    showDist = math.floor((showDist * 3.2808399) + 0.5) .. " ft"
               else
                    showDist = math.floor(showDist + 0.5) .. " m"
               end
          end

          if not pedCache[killer.netId] then
               if killer.type == "player" and victim.type == "player" then
                    TriggerEvent("mate-kd:onKill", killer, victim, headshot, driveBy)
                    TriggerClientEvent("mate-kd:onKill", victim.sourceId, killer, victim, headshot, driveBy, weapon)
                    TriggerClientEvent("mate-kd:onKill", killer.sourceId, killer, victim, headshot, driveBy, weapon)

                    if not killStreak[tostring(killer.sourceId)] then
                         killStreak[tostring(killer.sourceId)] = {
                              kills = 0
                         }
                    end
                    killStreak[tostring(killer.sourceId)]["kills"] = killStreak[tostring(killer.sourceId)]["kills"] + 1

                    TriggerClientEvent("mate-kd:client:updateKillstreak", killer.sourceId,
                         killStreak[tostring(killer.sourceId)]["kills"])
                    TriggerClientEvent("mate-kd:client:updateKillstreak", victim.sourceId, 0)
                    if killStreak[tostring(victim.sourceId)] then
                         local data = MySQL.scalar.await("SELECT `highestKS` from `mate_kd` WHERE identifier = ?", {
                              victim.identifier
                         })
                         if not data then
                              local res = MySQL.update.await(
                                   "UPDATE `mate_kd` SET highestKS = ? WHERE identifier = ?", {
                                        killStreak[tostring(victim.sourceId)]["kills"],
                                        victim.identifier
                                   })

                              print(json.encode(res))
                         end
                         killStreak[tostring(victim.sourceId)] = nil
                    end

                    if killer.sourceId ~= victim.sourceId then
                         if victim.type == "player" then
                              Config.onKill(killer.sourceId, victim.sourceId, headshot,
                                   killStreak[tostring(killer.sourceId)]["kills"] or 0)
                              local kdUser = MySQL.scalar.await(
                                   "SELECT `identifier` FROM `mate_kd` WHERE `identifier` = ? LIMIT 1", {
                                        killer.identifier
                                   })

                              if not kdUser then
                                   MySQL.insert.await(newKdPlayer, {
                                        killer.identifier,
                                        1, -- Kills
                                        0,
                                        0,
                                        0,
                                        GetPlayerName(killer.sourceId)
                                   })
                                   Wait(50)
                                   Functions.insertDiscordId(killer.xPlayer)
                                   Functions.insertPlayerName(killer.xPlayer)
                              else
                                   if headshot then
                                        MySQL.update.await(
                                             updateKdPLayer .. ", headshot = headshot + 1 WHERE identifier = ?", {
                                                  killer.identifier
                                             })
                                        Wait(50)
                                        Functions.insertDiscordId(killer.xPlayer)
                                        Functions.insertPlayerName(killer.xPlayer)
                                   else
                                        MySQL.update.await(updateKdPLayer .. " WHERE identifier = ?", {
                                             killer.identifier
                                        })
                                        Wait(50)
                                        Functions.insertDiscordId(killer.xPlayer)
                                        Functions.insertPlayerName(killer.xPlayer)
                                   end
                              end
                              TriggerClientEvent('matehunkd:handleNewKill', -1)
                         end
                    elseif killer.sourceId == victim.sourceId then
                         print(string.format("^3%s^0 has Suicide", GetPlayerName(killer.sourceId)))
                         Config.onSuicide(victim.sourceId)
                    end



                    local victimKdUser = MySQL.scalar.await(
                         "SELECT `identifier` FROM `mate_kd` WHERE `identifier` = ? LIMIT 1", {
                              victim.identifier
                         })

                    if not victimKdUser then
                         MySQL.insert.await(newKdPlayer, {
                              victim.identifier,
                              0,
                              1, -- deaths
                              0,
                              0,
                              GetPlayerName(victim.sourceId)
                         })
                         TriggerClientEvent('matehunkd:handleNewKill', -1)
                         Wait(50)
                         Functions.insertDiscordId(killer.xPlayer)
                    else
                         MySQL.update.await("UPDATE `mate_kd` SET deaths = deaths + 1 WHERE `identifier` = ?",
                              {
                                   victim.identifier
                              })
                         TriggerClientEvent('matehunkd:handleNewKill', -1)
                    end
               elseif victim.type == 'npc' then
                    local kdUser = MySQL.scalar.await(
                         "SELECT `identifier` FROM `mate_kd` WHERE `identifier` = ? LIMIT 1", {
                              killer.identifier
                         })

                    if not kdUser then
                         MySQL.insert.await(newKdPlayer, {
                              killer.identifier,
                              0, -- Kills
                              0,
                              0,
                              0,
                              GetPlayerName(killer.sourceId)
                         })
                         Wait(50)
                         Functions.insertDiscordId(killer.xPlayer)
                    end
                    victimEntity = NetworkGetEntityFromNetworkId(victim.netId)
                    if Config.UseRandomAINames then
                         victim.name = GetRandomName(victimEntity, victim.pedType, victim.gender)
                    else
                         victim.name = victimEntity
                    end
                    pedCache[victim.netId] = victim.name
                    AsyncRemoveCachedName(victim.netId)

                    MySQL.update.await(updateNpcKills .. "WHERE identifier = ?", {
                         killer.identifier
                    })

                    local numberOfNpcKilled = MySQL.scalar.await(
                         "SELECT `npc_killed` FROM `mate_kd` WHERE `identifier` = ? LIMIT 1", {
                              killer.identifier
                         })

                    Config.onNpcKilled(killer.sourceId, headshot)
                    print(string.format("[^4MateHUN-KD^0]: %s Killed an NPC", GetPlayerName(killer.sourceId)))
               end
          end


          local s, r = pcall(function()
               local streak = killStreak and killStreak[tostring(killer.sourceId)] and
                   killStreak[tostring(killer.sourceId)]["kills"] or 0 or 0
               killer.name = ("%s | %s"):format(killer.xPlayer.getJob().label, GetPlayerName(killer.sourceId))
               TriggerClientEvent('killfeed:recivePlayerKillFeed', -1, killer, victim, image, noScoped or false,
                    headshot or false,
                    driveBy or false,
                    showDist or false, streak or 0)
               TriggerClientEvent("killfeed:player-killed", killer.sourceId, killer, victim, headshot, streak or 0)
          end)
     end
end)

Citizen.CreateThread(function()
     Wait(3000)
     TriggerEvent("mCore:checkMoudleKey", GetCurrentResourceName(), Config.LicenseKey)
end)

CreateThread(function()
     Citizen.Await(Functions.createMateKDTable())
end)


RegisterNetEvent('mate-kd:s:registerHeadshot', function(victim)
     TriggerClientEvent("mate-kd:registerHeadshot", victim)
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(pid)
     TriggerClientEvent("matehunkd:handleNewKill", pid)
end)


RegisterNetEvent('mate-kd:s:tmdmg', (function(netId)
     print("Same team dmg detected: ", netId)
end))


exports("GetStats", (function(pid)
     local success, type, idf = Functions.ParseIdentifier(pid)

     if not success then
          return false
     end
     local lic = nil
     local query = "SELECT * FROM `mate_kd` WHERE identifier = ?"
     if type == "license" then
          lic = idf
     elseif type == "playerid" then
          lic = GetPlayerIdentifierByType(idf, "license"):sub(9)
     elseif type == "discord" then
          lic = idf
          query = "SELECT * FROM `mate_kd` WHERE discordid = ?"
     end

     -- Get Stats

     local data = MySQL.single.await(query, { lic })
     return data
end))
