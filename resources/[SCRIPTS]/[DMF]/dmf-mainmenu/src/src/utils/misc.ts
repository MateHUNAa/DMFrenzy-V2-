import { Gamemode } from "@/types/gamemodes";

export const isEnvBrowser = (): boolean => !(window as any).invokeNative;
export const noop = () => {};

export function MakeGames(amount: number): Gamemode[] {
  const gamemodes: Gamemode[] = [];

  for (let i = 0; i < amount; i++) {
    gamemodes.push({
      id: `gm-${i + 1}`,
      label: `Gamemode ${i + 1}`,
      currentPlayers: Math.floor(Math.random() * 10),
      maxPlayers: 10 + Math.floor(Math.random() * 41),
      restrictLabel: ["minden", "pistol", "nagykali"][Math.floor(Math.random() * 3)],
    });
  }

  return gamemodes;
}

export function FormatPlayTime(ms: number): string {
  const hours = Math.floor(ms / 3600000);
  const minutes = Math.floor((ms % 3600000) / 60000);
  const seconds = Math.floor((ms % 60000) / 1000);

  return `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;
}
