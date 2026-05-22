VIPDATA = {
     [1] = {
          label = "SIMA"
     },
     [2] = {
          label = "PRO"
     },
     [3] = {
          label = "EXTRA"
     }
}


exports("GetRankData", function(lvl)
     return VIPDATA[lvl]
end)
