"use client"

import { Card, CardContent } from "@/components/ui/card"
import { cn } from "@/lib/utils"
import { Gamemode } from "@/types/gamemodes"
import { ChevronRight } from "lucide-react"

interface GameLobbyCardProps {
     data: Gamemode
     onJoin?: (gameId: string) => void
     className?: string
}

export function GameLobbyCard({ data, onJoin, className }: GameLobbyCardProps) {
     const handleJoin = (id: string) => {
          if (onJoin) {
               onJoin(id)
          }
     }
     const getCapacityPercentage = (current = 0, max: number) => {
          return (current / max) * 100
     }

     const getCapacityColor = (current = 0, max: number) => {
          const percentage = getCapacityPercentage(current, max)
          if (percentage < 50) return "bg-emerald-500"
          if (percentage < 80) return "bg-amber-500"
          return "bg-rose-500"
     }
     return (
          <Card className="w-full max-w-md overflow-hidden bg-gradient-to-br from-zinc-900 to-zinc-800 text-white border-zinc-700">
               <CardContent className="p-3">
                    <div
                         key={data.id}
                         className="bg-zinc-800/50 rounded-lg p-4 transition-all duration-200 border border-transparent hover:bg-zinc-800/80 hover:border-zinc-700 flex flex-wrap"
                         onClick={() => handleJoin(data.id)}
                    >
                         <div className="flex flex-row items-center justify-between w-full">
                              <div className="">
                                   <h3 className="font-medium text-white">{data.label}</h3>
                                   <div className="flex items-center mt-1 w-full">
                                        <div className="bg-zinc-700 h-1.5 rounded-full overflow-hidden mr-3 w-24">
                                             <div
                                                  className={cn(
                                                       "h-full rounded-full",
                                                       getCapacityColor(data.currentPlayers, data.maxPlayers),
                                                  )}
                                                  style={{
                                                       width: `${getCapacityPercentage(data.currentPlayers, data.maxPlayers)}%`,
                                                  }}
                                             />
                                        </div>
                                        <div className="flex flex-row gap-3">

                                             <span className="text-xs text-zinc-400 whitespace-nowrap">
                                                  {data.currentPlayers || 0}/{data.maxPlayers}
                                             </span>
                                             <span className="text-xs text-zinc-400 whitespace-nowrap">
                                                  {data.restrictLabel}
                                             </span>
                                        </div>
                                   </div>
                              </div>

                              <div className="p-2 rounded-lg bg-zinc-700/25">
                                   <ChevronRight className="size-8 text-zinc-600 cursor-pointer" />
                              </div>
                         </div>

                    </div>
               </CardContent>
          </Card >
     )
}
