import { useState, useEffect } from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faBarsStaggered, faBomb, faChartSimple, faCrosshairs, faCrown, faCube, faSkullCrossbones } from '@fortawesome/free-solid-svg-icons';
import "@/index.css"
interface INUIMessage {
  type: string;
  state: boolean;
  data: playerdata;
}

interface playerdata {
  kills: number;
  deaths: number;

  killstreak: number;
  highestKS: number;
}

function App() {
  const [visible, setVisibility] = useState<boolean>(false)
  const [xVisible, setxVisible] = useState<boolean>(false)
  const [message, setMessage] = useState<string>("Player Killed")
  const [playerData, setPlayerData] = useState<playerdata>({ deaths: 1, highestKS: 1, kills: 1, killstreak: 1 })

  useEffect(() => {
    const handleNUImessage = (event: MessageEvent) => {
      const message = event.data

      if (message.type === "mVisibility") {
        setVisibility(message.state)
      }

      if (message.type === "mLoadData") {
        setPlayerData(message.data)
      }

      if (message.type === "player-killed") {
        setxVisible(true)
        setMessage(message.data.message || "MESSAGE NOT RECIVED !")
        setTimeout(() => {
          setxVisible(false)
        }, 1000)
      }

      return () => {
        removeEventListener('message', handleNUImessage)
      }
    }

    addEventListener("message", handleNUImessage)
  }, [])

  return (
    <div className="App">
      <>
        {visible && (
          <div className='flex items-center h-screen'>
            <div className='flex'>

              <div className="p-4 space-y-4 mt-80">
                <div className='flex flex-col gap-4 min-w-52 max-w-52'>

                  {/* ServerName */}
                  <div id='serverName' className='bg-gradient-to-r from-black/50 to-transparent p-2 border-l-2 border-[#ffa500] '>
                    <h2 className='text-center font-semibold mx-4 text-white tracking-[0.3em]'><span className='text-[#ffa500]'>Rime</span> DM</h2>
                  </div>

                  {/* Stats */}
                  <div className='flex bg-gradient-to-r from-black/50 to-transparent p-2 border-l-2 border-[#ffa500] '>
                    <div className='justify-center items-center my-auto text-[#ffa500]'>
                      <FontAwesomeIcon icon={faChartSimple} className='w-8 h-8 glow'></FontAwesomeIcon>
                    </div>

                    <div className='ml-3 flex flex-col'>
                      <div className='text-white font-normal truncate'><FontAwesomeIcon icon={faCrosshairs} /> <span className='font-medium text-white'><span className='text-[#ffa500]'>Kills:</span> <span className='font-bold'>{playerData.kills}</span></span></div>
                      <div className='text-white font-normal truncate'><FontAwesomeIcon icon={faSkullCrossbones} /> <span className='font-medium text-white'><span className='text-[#ffa500]'>Deaths:</span> <span className='font-bold'>{playerData.deaths}</span></span></div>
                      <div className='text-white font-normal truncate'><FontAwesomeIcon icon={faChartSimple} /> <span className='font-medium text-white'><span className='text-[#ffa500]'>KD:</span> <span className='font-bold'>{(playerData.kills / playerData.deaths).toFixed(2)}</span></span></div>
                    </div>
                  </div>

                  {/* KillStreak */}
                  <div className='flex bg-gradient-to-r from-black/50 to-transparent p-2 border-l-2 border-[#ffa500] '>
                    <div className='justify-center items-center my-auto text-[#ffa500]'>
                      <FontAwesomeIcon icon={faCrown} className='w-8 h-8 glow'></FontAwesomeIcon>
                    </div>


                    <div className='ml-3 flex flex-col'>
                      <div className='text-white font-normal truncate'><FontAwesomeIcon icon={faBarsStaggered} /> <span className='font-medium text-white'><span className='text-[#ffa500]'>Killstreak:</span> <span className='font-bold'>{playerData.killstreak}</span></span></div>
                      <div className='text-white font-normal truncate'><FontAwesomeIcon icon={faBomb} /> <span className='font-medium text-white'><span className='text-[#ffa500]'>Highest KS:</span> <span> <span className='font-bold'>{playerData.highestKS}</span></span></span></div>
                    </div>
                  </div>

                </div>
              </div>
            </div>
          </div>
        )}

        {xVisible && (
          <div className="block fixed top-1/2 left-1/2 -translate-x-1/2 translate-y-8 bg-black/50 text-[#ffa500] text-lg px-4 py-2 rounded-lg font-bold">
            {message}
          </div>
        )}

      </>
    </div>
  )
}

export default App
