export function renderBuildingLayer(container, { buildings, appState }) {
  const { selectedBuilding } = appState.getState();

  container.innerHTML = buildings.map((building) => `
    <button
      class="building-hotspot${selectedBuilding === building.id ? " is-selected" : ""}"
      type="button"
      data-building-id="${building.id}"
      style="left: ${building.x}%; top: ${building.y}%; width: ${building.width}%; height: ${building.height}%"
      aria-label="进入${building.name}"
    >
      <span>${building.name}</span>
    </button>
  `).join("");

  container.querySelectorAll("[data-building-id]").forEach((button) => {
    button.addEventListener("click", () => {
      appState.selectBuilding(button.dataset.buildingId);
    });
  });
}
