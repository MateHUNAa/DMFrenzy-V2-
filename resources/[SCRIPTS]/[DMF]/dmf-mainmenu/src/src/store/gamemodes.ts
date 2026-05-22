import { Gamemode } from "@/types/gamemodes";
import { createSlice, PayloadAction } from "@reduxjs/toolkit";

const GameModeSlice = createSlice({
  initialState: {
    gamemodes: null as Gamemode[] | null,
  },
  name: "GameMode",
  reducers: {
    load: (state, action: PayloadAction<null | Gamemode[]>) => {
      state.gamemodes = action.payload;
    },
  },
});

export const { load } = GameModeSlice.actions;
export default GameModeSlice.reducer;
