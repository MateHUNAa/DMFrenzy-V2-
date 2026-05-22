export interface KillerPlayer {
  discordName: string;
  discordId: string;
  imageURL: string;

  kills: number;
  deaths: number;
  rank: string;

  killerWeapon: string;

  health: number;
  armour: number;
}
