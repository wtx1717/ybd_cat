function getClockText(timezone) {
  return new Intl.DateTimeFormat("zh-CN", {
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
    timeZone: timezone,
  }).format(new Date());
}

export function renderOverviewLayer(container, { overview, appState }) {
  const { overviewOpen } = appState.getState();

  container.classList.toggle("is-collapsed", !overviewOpen);
  container.innerHTML = `
    <button class="overview-toggle" type="button" aria-expanded="${overviewOpen}">
      ${overviewOpen ? "收起书本" : "展开书本"}
    </button>
    <div class="overview-book">
      <div class="overview-section">
        <h2>最近动态</h2>
        <ul>
          ${overview.recentActivity.map((item) => `<li>${item}</li>`).join("")}
        </ul>
      </div>
      <div class="overview-section">
        <h2>本周训练</h2>
        <p>${overview.weeklyTraining.runs} 次 / ${overview.weeklyTraining.distance}</p>
        <p>${overview.weeklyTraining.focus}</p>
      </div>
      <div class="overview-section">
        <h2>天气与时钟</h2>
        <p>${overview.weather.text} ${overview.weather.temperature}</p>
        <p data-clock>${getClockText(overview.clock.timezone)}</p>
      </div>
    </div>
  `;

  container.querySelector(".overview-toggle").addEventListener("click", () => {
    appState.toggleOverview();
  });
}
