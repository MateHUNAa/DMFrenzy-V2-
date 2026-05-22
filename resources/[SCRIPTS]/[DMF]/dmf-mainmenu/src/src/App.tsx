import { useExitListener } from '@/hooks/useExitListener';
import { useEffect, useState } from 'react'
import { useAppDispatch } from './store';
import { fetchNui } from './utils/fetchNui';
import { Gamemode } from './types/gamemodes';
import { debugData } from './utils/debugData';
import useNuiEvent from './hooks/useNuiEvent';
import Loading from './components/Loading';
import { GameLobbyCard } from './components/GameLobbyCard';
import { MakeGames } from './utils/misc';
import PlayerCard from './components/PlayerCard';
import { Player } from './types/player';
import { Button } from './components/ui/button';

const PFP: string = "https://cdn.discordapp.com/avatars/575342593630797825/d35c0ebf35bc2499a2a29771b0233f9a.png?size=1024"
function App() {
  const dispatch = useAppDispatch()

  const [visible, setVisibility] = useState<boolean>(false)
  const [page, setPage] = useState<string>("mainmenu")
  const [matchmake, setMatchmake] = useState<boolean>(false)
  const [player, setPlayer] = useState<Player | null>(null)

  const [GameModes, setGameModes] = useState<Gamemode[] | null>(null)

  useExitListener(setVisibility)

  useNuiEvent("open", () => {
    setVisibility(true)
  })

  useNuiEvent("loadGamemodes", (data: Gamemode[]) => {
    setGameModes(data)
  })

  useNuiEvent("loadPlayer", (data: Player) => {
    setPlayer(data)
  })

  useNuiEvent("setVisibility", (data: boolean) => setVisibility(data))

  const ToggleMatchmake = () => {
    setMatchmake((prev) => !prev)
    fetchNui("toggleMatchmake", { newVal: matchmake })
  }

  const HandleJoinGamemode = (gameId: string) => {
    fetchNui("join", {
      gameId: gameId
    })
  }

  useEffect(() => {
    const handleClick = () => {
      const audio = new Audio("./click.wav")
      audio.play()
    }


    const music = new Audio("./music.mp3")
    music.volume = 0.1
    music.loop = true
    visible ? music.play() : music.pause()

    document.addEventListener("click", handleClick)
    return () => {
      document.removeEventListener("click", handleClick)
    }
  }, [])

  return (
    <div className="App transition-all delay-300">
      {visible && (
        <>
          <header className='fixed top-4 left-1/2 -translate-x-1/2 w-full max-w-5xl z-50'>
            <div className='rounded-xl px-6 py-2 flex items-center justify-center gap-10 bg-gradient-to-br from-zinc-900 to-zinc-800'>
              <Button
                variant={'default'}
                glow={true}
                onClick={() => setPage("gamemode")}
              >
                Gamemode
              </Button>

              <img src="logo.png" alt="DMF Logo" className='size-14 scale-150 cursor-pointer' onClick={() => setPage("mainmenu")} />

              <Button
                variant={'default'}
                glow={true}
                onClick={() => ToggleMatchmake()}
              >
                Matchmaking
              </Button>
            </div>
          </header>

          {/* PlayerStats */}
          <div className={`${(page === "mainmenu" && player) ? "flex items-center justify-end h-screen pr-10" : "hidden"} w3-animate-right`}>
            {player ? <PlayerCard player={player} /> : <div></div>}
          </div>

          <div id='content' className={`${page === "mainmenu" ? "hidden" : "block"} min-h-screen flex items-center justify-center pt-32`}>
            <div className='w-full max-w-7xl  w3-animate-top'>

              {/* gamemode section */}
              <section className={`${page === "gamemode" ? "block" : "hidden"} transition-opacity duration-300`}>
                {
                  GameModes ? (
                    <div className='grid grid-cols-6 gap-4 p-8 overflow-y-auto max-h-[76vh]'>
                      {
                        GameModes.map((mode) => (
                          <div key={mode.id} className='col-span-2'>
                            <GameLobbyCard data={mode} onJoin={(id) => HandleJoinGamemode(id)} />
                          </div>
                        ))
                      }
                    </div>
                  ) : <Loading />
                }
              </section>
            </div>
          </div>
        </>
      )}
    </div>
  )
}

export default App

debugData([
  {
    action: "loadGamemodes",
    data: MakeGames(50)
  },
])

debugData([
  {
    action: "loadPlayer",
    data: { death: 12, headshots: 9, kill: 25, name: "MateHUN", playTime: (12 * 60 * 60 * 1000), imageURL: PFP } as Player
  }
])

debugData([
  {
    action: "open",
    data: {}
  }
])