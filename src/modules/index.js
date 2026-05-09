import { renderProjectTavern } from "./projectTavern.js";
import { renderNotesHouse } from "./notesHouse.js";
import { renderTaskCabin } from "./taskCabin.js";
import { renderRunningField } from "./runningField.js";
import { renderLogStation } from "./logStation.js";
import { renderGithubHall } from "./githubHall.js";
import { renderMailbox } from "./mailbox.js";

export const moduleRenderers = {
  projectTavern: renderProjectTavern,
  notesHouse: renderNotesHouse,
  taskCabin: renderTaskCabin,
  runningField: renderRunningField,
  logStation: renderLogStation,
  githubHall: renderGithubHall,
  mailbox: renderMailbox,
};
