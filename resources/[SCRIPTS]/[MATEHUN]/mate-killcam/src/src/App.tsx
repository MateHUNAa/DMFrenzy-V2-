import { useState } from 'react'
import useNuiEvent from './hooks/useNuiEvent';
import { KillerPlayer } from './types/killer';
import { debugData } from './utils/debugData';
import PlayerCard from './components/PlayerCard';

const PFP: string = "https://cdn.discordapp.com/avatars/575342593630797825/d35c0ebf35bc2499a2a29771b0233f9a.png?size=1024"

function App() {
  const [visible, setVisibility] = useState<boolean>(false)
  const [player, setData] = useState<KillerPlayer | null>()

  useNuiEvent("off", () => {
    console.log("OFF")
    setVisibility(false)
    setData(null)
  })

  useNuiEvent("showData", (data: KillerPlayer) => {
    setVisibility(true)
    setData(data)
  })

  return (
    <div className="App">
      {visible && (
        <div className="fixed bottom-4 left-1/2 -translate-x-1/2  w-full max-w-6xl mx-auto">
          <div className="flex items-center justify-center space-x-6 ">
            {
              player ? <PlayerCard data={player} /> : <></>
            }
          </div>
        </div>
      )}
    </div>
  )
}

debugData([
  {
    action: "showData",
    data: {
      deaths: 3,
      kills: 10,
      discordId: "1414141414414",
      discordName: "MateHUN",
      imageURL: PFP,
      health: 65,
      armour: 80,
      killerWeapon: "AP PISTOL",
      rank: "DIAMOND"
    } as KillerPlayer
  }
])

export default App
