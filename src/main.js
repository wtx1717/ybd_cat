import { createAppState } from "./state.js";
import { player } from "./data/player.js";
import { navigationItems } from "./data/navigation.js";
import { buildings } from "./data/buildings.js";
import { overview } from "./data/overview.js";
import { renderTopNavLayer } from "./layers/topNavLayer.js";
import { renderBackgroundLayer } from "./layers/backgroundLayer.js";
import { renderBuildingLayer } from "./layers/buildingLayer.js";
import { renderOverviewLayer } from "./layers/overviewLayer.js";
import { moduleRenderers } from "./modules/index.js";

const appState = createAppState();

const elements = {
  topNavLayer: document.querySelector("#top-nav-layer"),
  backgroundLayer: document.querySelector("#background-layer"),
  buildingLayer: document.querySelector("#building-layer"),
  overviewLayer: document.querySelector("#overview-layer"),
  modulePanel: document.querySelector("#module-panel"),
};

function renderModulePanel() {
  const { selectedBuilding } = appState.getState();
  const building = buildings.find((item) => item.id === selectedBuilding);

  if (!building) {
    elements.modulePanel.innerHTML = `
      <h2>小镇入口</h2>
      <p>点击建筑热区后，这里会显示对应模块的占位内容。</p>
    `;
    elements.modulePanel.hidden = false;
    return;
  }

  const renderModule = moduleRenderers[building.module];
  const moduleContent = renderModule
    ? renderModule()
    : { title: building.name, body: "模块待开发。" };

  elements.modulePanel.innerHTML = `
    <h2>${moduleContent.title}</h2>
    <p>${moduleContent.body}</p>
  `;
  elements.modulePanel.hidden = false;
}

function renderApp() {
  renderTopNavLayer(elements.topNavLayer, {
    player,
    navigationItems,
    appState,
  });
  renderBackgroundLayer(elements.backgroundLayer);
  renderBuildingLayer(elements.buildingLayer, {
    buildings,
    appState,
  });
  renderOverviewLayer(elements.overviewLayer, {
    overview,
    appState,
  });
  renderModulePanel();
}

appState.subscribe(renderApp);
renderApp();
