"use client"

import { KillerPlayer } from "@/types/killer"
import { Star, Droplet } from "lucide-react"

export default function PlayerCard({ data }: { data: KillerPlayer }) {
     console.log(data.armour, data.health)
     return (
          <div className="w-full max-w-lg bg-gradient-to-br from-zinc-700 to-zinc-800 rounded-md overflow-hidden shadow-lg text-white">
               <div className="p-4">
                    <div className="flex items-start gap-3">
                         {/* Avatar and player info */}
                         <div className="relative w-20 h-20 rounded-md overflow-hidden">
                              <img
                                   src={data.imageURL}
                                   alt="Player avatar"
                                   width={80}
                                   height={80}
                                   className="object-cover"
                              />
                         </div>

                         <div className="flex-1">
                              {/* Player name section */}
                              <div className="text-gray-400 text-xs uppercase font-semibold tracking-wider">KILLER NAME</div>
                              <div className="text-white text-2xl font-bold">{data.discordName}</div>

                              {/* Stats badge */}

                              {/* <div className="inline-block bg-rose-600 text-white text-xs px-2 py-0.5 rounded mt-1 font-medium">
                                   200HP OAP in 1
                              </div> */}

                              {/* Score indicators */}
                              <div className="flex items-center gap-4 mt-2">
                                   <div className="flex items-center">
                                        <span className="text-rose-500 font-bold text-lg">{data.health}</span>
                                        <Star className="w-4 h-4 text-rose-500 ml-1 fill-rose-500" />
                                   </div>

                                   <div className="flex items-center">
                                        <span className="text-blue-400 font-bold text-lg">{data.armour}</span>
                                        <Droplet className="w-4 h-4 text-blue-400 ml-1 fill-blue-400" />
                                   </div>
                              </div>
                         </div>
                    </div>

                    {/* Progress bar */}
                    <div className="mt-3 h-8 w-full overflow-hidden">
                         <div className="flex flex-col h-full space-y-2">
                              <div className={`bg-rose-600 h-full rounded-md`} style={{width: data.health+"%"}}></div>
                              <div className={`bg-blue-600 h-full rounded-md`} style={{width: data.armour+"%"}}></div>
                         </div>
                    </div>

                    {/* Kill message */}
                    {/* <div className="mt-3 text-sm">
                         <span className="text-rose-500 font-medium">KILLED YOU WITH</span>
                         <span className="text-white font-semibold ml-1">{data.killerWeapon}</span>
                    </div> */}
               </div >
          </div >
     )
}
