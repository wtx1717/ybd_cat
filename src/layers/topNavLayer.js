function renderMeter(label, value, max) {
  const percent = Math.round((value / max) * 100);

  return `
    <div class="top-nav-meter">
      <span>${label}</span>
      <div class="meter-track" aria-hidden="true">
        <span class="meter-fill" style="width: ${percent}%"></span>
      </div>
      <strong>${value}/${max}</strong>
    </div>
  `;
}

export function renderTopNavLayer(container, { player, navigationItems, appState }) {
  const state = appState.getState();

  container.innerHTML = `
    <div class="player-card">
      <div class="player-avatar" aria-hidden="true">${player.avatar}</div>
      <div>
        <p class="player-name">${player.name}</p>
        <p class="player-title">Lv.${player.level} ${player.title}</p>
      </div>
    </div>

    <div class="player-status">
      <div class="top-nav-meter">
        <span>EXP</span>
        <div class="meter-track" aria-hidden="true">
          <span class="meter-fill exp-fill" style="width: ${Math.round((player.experience.current / player.experience.next) * 100)}%"></span>
        </div>
        <strong>${player.experience.current}/${player.experience.next}</strong>
      </div>
      ${renderMeter("HP", player.hp.current, player.hp.max)}
      ${renderMeter("体力", player.stamina.current, player.stamina.max)}
    </div>

    <nav class="nav-entries" aria-label="主要导航">
      ${navigationItems.map((item) => `
        <button class="nav-entry" type="button" data-target="${item.target}" aria-pressed="${state.selectedBuilding === item.target}">
          ${item.label}
        </button>
      `).join("")}
    </nav>

    <div class="wallet-status" aria-label="资源状态">
      <span>金币 ${player.coins}</span>
      <span>宝石 ${player.gems}</span>
    </div>

    <p class="current-task">当前任务：${player.currentTask}</p>
  `;

  container.querySelectorAll("[data-target]").forEach((button) => {
    button.addEventListener("click", () => {
      const target = button.dataset.target;

      if (target === "town-day") {
        appState.setState({ currentScene: target, selectedBuilding: null });
        return;
      }

      appState.selectBuilding(target);
    });
  });
}
