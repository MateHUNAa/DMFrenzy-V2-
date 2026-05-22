export interface Gamemode {
  id: string;
  label: string;
  currentPlayers?: number | 0;
  maxPlayers: number;
  restrictLabel: string;
}
