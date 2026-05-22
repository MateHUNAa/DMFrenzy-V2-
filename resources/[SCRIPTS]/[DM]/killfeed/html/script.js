let showTime = 8000;
let maxLines = 5;
let colours = {
  killer_player: { r: 125, g: 160, b: 215 },
  victim_player: { r: 219, g: 66, b: 66 },
  killer_npc: { r: 125, g: 160, b: 215 },
  victim_npc: { r: 219, g: 66, b: 66 },
  joinLeave: { r: 30, g: 100, b: 210 },
  killDist: { r: 255, g: 255, b: 255 },
};

window.onload = (e) => {
  window.addEventListener("message", onEventRecieved);
};

function AppendToFeed(id, string) {
  if ($("#killfeed-container").children().length >= maxLines) {
    $("#killfeed-container").children().first().remove();
  }

  $("#killfeed-container").append(string);

  let lineContainer = $(".kill-container[data-id=" + id + "]");
  let killLine = $(".kill-line[data-line-id=" + id + "]");

  lineContainer.hide().fadeIn(100).delay(showTime).fadeOut();
  setTimeout(function () {
    killLine.remove();
  }, 600 + showTime); // 500 (+ 100 for margin) + time it lasts
}

function AddKillToFeed(data) {
  const id = data.id;
  const image = data.image;
  const border = data.border;
  const background = data.background;
  const noScoped = data.noScoped;
  const headshot = data.headshot;
  const driveBy = data.driveBy;
  const dist = data.dist;
  let killstreak = data.killstreak;

  if (!killstreak) killstreak = 1;
  let victim = data.victim;
  let killer = data.killer;

  victim.colour = colours.victim;
  if (victim.group != undefined) {
    if (victim.group.tag != undefined) {
      victim.tag = victim.group.tag;

      if (victim.group.tagColour != undefined) {
        victim.tagColour = victim.group.tagColour;
      } else {
        victim.tagColour = { r: 255, g: 255, b: 255 };
      }
    }
    if (victim.group.colour != undefined) {
      victim.colour = victim.group.colour;
    }
  }

  if (victim.colour == undefined) {
    if (victim.type == "player") {
      victim.colour = colours.victim_player;
    } else {
      victim.colour = colours.victim_npc;
    }
  }

  if (killer.group != undefined) {
    if (killer.group.tag != undefined) {
      killer.tag = killer.group.tag;

      if (killer.group.tagColour != undefined) {
        killer.tagColour = killer.group.tagColour;
      } else {
        killer.tagColour = { r: 255, g: 255, b: 255 };
      }
    }
    if (killer.group.colour != undefined) {
      killer.colour = killer.group.colour;
    }
  }

  if (killer.colour == undefined) {
    if (killer.type == "player") {
      killer.colour = colours.killer_player;
    } else {
      killer.colour = colours.killer_npc;
    }
  }

  let duplicate = $(`.kill-line[data-line-id=${id}]`);
  if (duplicate.length > 0) {
    duplicate.remove();
  }

  // string creation
  let appendString = `<div data-line-id="${id}" class="kill-line"><div data-id="${id}" class="kill-container ${border} ${background}">`;

  if (killer.name != undefined) {
    if (killer.tag != undefined) {
      appendString =
        appendString +
        `<p class="text tag" style="color: rgb(${killer.tagColour.r}, ${killer.tagColour.g}, ${killer.tagColour.b});">${killer.tag}</p>`;
    }
    appendString =
      appendString +
      `<p class="text line-clamp name" style="color: rgb(${killer.colour.r}, ${killer.colour.g}, ${killer.colour.b});">x${killstreak} ${killer.name}</p>`;
  } else {
    appendString = appendString + '<p class="none"></p>';
  }

  if (image != undefined) {
    appendString =
      appendString +
      `<img src="images/${image}.png" alt="${image}" class="weapon-image">`;
  }

  if (noScoped == true) {
    appendString =
      appendString +
      '<img src="images/noscoped.png" alt="noscoped" class="icon-image">';
  }

  if (driveBy != false && driveBy != undefined) {
    appendString =
      appendString +
      `<img src="images/${driveBy}.png" alt="driveBy" class="icon-image">`;
  }

  if (headshot == true) {
    appendString =
      appendString +
      '<img src="images/headshot.png" alt="headshot" class="icon-image">';
  }

  if (victim.name != undefined) {
    if (victim.tag != undefined) {
      appendString =
        appendString +
        `<p class="text tag" style="color: rgb(${victim.tagColour.r}, ${victim.tagColour.g}, ${victim.tagColour.b});">${victim.tag}</p>`;
    }
    appendString =
      appendString +
      `<p class="text line-clamp name" style="color: rgb(${victim.colour.r}, ${victim.colour.g}, ${victim.colour.b});">${victim.name}</p>`;

    if (dist != false && dist != undefined) {
      appendString =
        appendString +
        `<p class="text dist" style="color: rgb(${colours.killDist.r}, ${colours.killDist.g}, ${colours.killDist.b});">(${dist})</p>`;
    }
  }

  appendString = appendString + "</div></div>";

  AppendToFeed(id, appendString);
}

function AddJoinLeaveToFeed(id, name, message) {
  let string = `<div data-line-id="${id}" class="kill-line"><div data-id="${id}" class="kill-container black-border black-background"><p class="text name" style="color: rgb(${colours.joinLeave.r}, ${colours.joinLeave.g}, ${colours.joinLeave.b});">${name}</p><p class="text message">${message}</p></div></div>`;
  AppendToFeed(id, string);
}

function AddMessageToFeed(id, message) {
  let string = `<div data-line-id="${id}" class="kill-line"><div data-id="${id}" class="kill-container black-border black-background"><p class="none"></p><p class="text message">${message}</p></div></div>`;
  AppendToFeed(id, string);
}

function onEventRecieved(info) {
  let event = info.data;
  if (event.data == undefined) {
    console.error("event.data was nil!");
    return;
  }

  switch (event.action) {
    case "addKillToFeed":
      AddKillToFeed(event.data);
      break;
    case "addJoinLeaveToFeed":
      AddJoinLeaveToFeed(event.data.id, event.data.name, event.data.message);
      break;
    case "addMessageToFeed":
      AddMessageToFeed(event.data.id, event.data.message);
      break;
    case "toggleKillfeed":
      if (event.data.state == true) {
        $("#killfeed-container").show();
      } else {
        $("#killfeed-container").hide();
      }
      break;
    case "setConfig":
      showTime = event.data.showTime;
      maxLines = event.data.maxLines;
      colours.killer_player = event.data.killerColourP;
      colours.victim_player = event.data.victimColourP;
      colours.killer_npc = event.data.killerColourN;
      colours.victim_npc = event.data.victimColourN;
      colours.joinLeave = event.data.joinLeaveColour;
      colours.killDist = event.data.killDistColour;
      break;
    default:
      console.error("event.action was not spesifed!");
  }
}
