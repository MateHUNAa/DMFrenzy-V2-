import { useExitListener } from '@/hooks/useExitListener';
import { useState, useEffect } from 'react'
import useNuiEvent from './hooks/useNuiEvent';
import { Progress } from './components/ui/progress';

function App() {
  const [visible, setVisibility] = useState<boolean>(false)
  const [currentTime, setCurrentTime] = useState<number>(5)
  let totalTime = 5

  useNuiEvent("setVisibility", (data: boolean) => setVisibility(data))
  useNuiEvent("StartTimer", (data: number) => {
    setVisibility(true)
    setCurrentTime(data)
    totalTime = data
  })
  useNuiEvent("RemoveTime", (data: number) => {
    setCurrentTime((prev) => (prev - data))
  })

  return (
    <div className="App">
      {visible && (
        <div className='fixed bottom-4 right-4 w-64 z-50'>
          <Progress value={(currentTime / totalTime) * 100} />
        </div>
      )}
    </div>
  )
}

export default App
