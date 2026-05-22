import { useExitListener } from '@/hooks/useExitListener';
import { useState, useEffect } from 'react'

function App() {
  const [visible, setVisibility] = useState<boolean>(false)

  useExitListener(setVisibility)

  return (
    <div className="App">
      {visible && (
        <div className='h-screen flex justify-center items-center  m-0 '>
          <div className='w-1/2 h-2/3 bg-black/70 flex text-center scale-110 p-3 rounded-md'>

          </div>
        </div>
      )}
    </div>
  )
}

export default App
