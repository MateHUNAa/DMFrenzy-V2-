import Player from "@/types/Player";

export const isEnvBrowser = (): boolean => !(window as any).invokeNative;

export const noop = () => {};

export const GetCommandPriority = (command: Command, Groups: Group[]) => {
  const group = Groups.find((g) => g.name === command.minGroup);
  return group ? group.priority : 10000;
};

export const GetGroupPriority = (group: string, Groups: Group[]) => {
  const foundGroup = Groups.find((g) => g.name === group);
  return foundGroup ? foundGroup.priority : 0;
};

export const GetGroupPrefix = (group: string, Groups: Group[]) => {
  const foundGroup = Groups.find((g) => g.name === group);

  let g = foundGroup ? foundGroup.groupPrefix : "NAN";

  if (g === "NAN") {
    console.log(foundGroup);
  }
  return g;
};

export const GetVehicleByPlate = (plate: string, Players: Player[]) => {
  for (const player of Players) {
    const vehicle = player.owned_vehicles.find((v) => v.plate === plate);
    if (vehicle) return vehicle;
  }
  return false;
};
