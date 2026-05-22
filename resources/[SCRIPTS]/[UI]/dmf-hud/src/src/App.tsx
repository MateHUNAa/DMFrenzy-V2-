import { Heart, ShieldPlusIcon, Skull } from 'lucide-react';
import { useState, useEffect } from 'react'
import useNuiEvent from './hooks/useNuiEvent';

function App() {
  const [visible, setVisibility] = useState<boolean>(true)
  const [stats, setStats] = useState<{ shield: number, health: number, ks: number }>({ health: 88, shield: 60, ks: 0 })

  useNuiEvent("toggleVisibility", (data: boolean) => setVisibility(data))

  useNuiEvent("refreshStats", (data) => {
    setStats(data)
  })

  return (
    <>
      {
        visible ? (
          <div className="App">
            <section id='HUD' className='fixed bottom-0 left-1/2 transform -translate-x-1/2'>
              <div className='flex space-x-2 p-4'>
                {/* HP */}
                <div className='flex items-center space-x-2 bg-gray-800 rounded-md px-3 py-2'>
                  <div className='p-2 bg-gray-700/60 rounded-sm'>
                    <Heart className='size-5 text-white' />
                  </div>
                  <div className='w-44 h-[12px] bg-gray-700 rounded-sm'>
                    <div className='w-1/2 h-full bg-gray-400 rounded-sm' style={{ width: `${stats.health}%` }} /> {/* BAR */}
                  </div>
                </div>

                <div className='flex flex-col items-center justify-center font-bold text-xl text-white'>
                  <Skull /> {stats.ks}
                </div>

                {/* Armor */}
                <div className='flex items-center space-x-2 bg-blue-600 rounded-md px-4 py-3'>
                  <div className='p-2 bg-blue-500/60 rounded-sm'>
                    <ShieldPlusIcon className='size-5 text-white' />
                  </div>
                  <div className='w-44 h-[12px] bg-blue-700 rounded-sm'>
                    <div className='w-1/2 h-full bg-blue-400 rounded-sm' style={{ width: `${stats.shield}%` }} /> {/* BAR */}
                  </div>
                </div>
              </div>
            </section>
          </div>
        ) : <></>
      }
    </>
  )
}

export default App
