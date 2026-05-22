import { Player } from '@/types/player'
import { FC } from 'react'
import { Card, CardContent, CardHeader } from './ui/card'
import { Clock, Skull, Target, User } from 'lucide-react'
import { FormatPlayTime } from '@/utils/misc'
import { Progress } from './ui/progress'


const PlayerCard: FC<{ player: Player }> = ({ player }) => {

     const kdRatio = player.death > 0 ? (player.kill / player.death).toFixed(2) : player.kill.toFixed(2)

     return (
          <Card className="w-full max-w-md overflow-hidden bg-gradient-to-br from-zinc-900 to-zinc-800 text-white border-zinc-700 ">
               <CardHeader className="pb-2 pt-6 px-6">
                    <div className="flex items-center gap-2">
                         <div className="h-10 w-10 rounded-full bg-emerald-500 flex items-center justify-center">
                              {
                                   player.imageURL ? <img src={player.imageURL} alt="Player Image" className='rounded-full scale-125 mr-2 ring-2 ring-[var(--secondary-color)]' />:<User className="h-5 w-5 text-emerald-950" />
                              }
                         </div>
                         <div>
                              <h2 className="text-xl font-bold tracking-tight">{player.name}</h2>
                              <p className="text-sm text-zinc-400">Player Stats</p>
                         </div>
                    </div>
               </CardHeader>
               <CardContent className="p-6">
                    <div className="grid grid-cols-2 gap-4 mb-4">
                         <div className="bg-zinc-800/50 shadow-lg backdrop-blur-md rounded-lg p-3">
                              <div className="flex items-center gap-2 mb-1">
                                   <Target className="size-6 text-emerald-400" />
                                   <span className="text-xs font-semibold text-white/90">Kills</span>
                              </div>
                              <p className="text-2xl font-bold">{player.kill}</p>
                         </div>

                         <div className="bg-zinc-800/50 shadow-lg backdrop-blur-md rounded-lg p-3">
                              <div className="flex items-center gap-2 mb-1">
                                   <Skull className="size-6 text-rose-400" />
                                   <span className="text-xs font-semibold text-white/90">Deaths</span>
                              </div>
                              <p className="text-2xl font-bold">{player.death}</p>
                         </div>

                         <div className="bg-zinc-800/50 shadow-lg backdrop-blur-md rounded-lg p-3">
                              <div className="flex items-center gap-2 mb-1">
                                   <Target className="size-6 text-amber-400" />
                                   <span className="text-xs font-semibold text-white/90">Headshots</span>
                              </div>
                              <p className="text-2xl font-bold">{player.headshots}</p>
                         </div>

                         <div className="bg-zinc-800/50 shadow-lg backdrop-blur-md rounded-lg p-3">
                              <div className="flex items-center gap-2 mb-1">
                                   <Clock className="size-6 text-sky-400" />
                                   <span className="text-xs font-semibold text-white/90">Play Time</span>
                              </div>
                              <p className="text-2xl font-bold">{FormatPlayTime(player.playTime)}</p>
                         </div>
                    </div>

                    <div className="space-y-4">
                         <div>
                              <div className="flex justify-between mb-1">
                                   <span className="text-sm font-medium text-zinc-400">K/D Ratio</span>
                                   <span className="text-sm font-medium">{kdRatio}</span>
                              </div>
                              <Progress value={Math.min(Number.parseFloat(kdRatio) * 33.3, 100)} className="h-2 bg-[var(--secondary-color-dark)]" />
                         </div>

                         <div>
                              <div className="flex justify-between mb-1">
                                   <span className="text-sm font-medium text-zinc-400">Headshot %</span>
                                   <span className="text-sm font-medium">{((player.headshots / player.kill) * 100).toFixed(1)}%</span>
                              </div>
                              <Progress value={(player.headshots / player.kill) * 100} className="h-2 bg-[var(--secondary-color-dark)]" />
                         </div>
                    </div>
               </CardContent>
          </Card>
     )
}

export default PlayerCard