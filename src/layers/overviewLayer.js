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
    <button class="overview-book-toggle" type="button" aria-expanded="${overviewOpen}" aria-controls="overview-panel">
      <span class="book-cover" aria-hidden="true">
        <span class="book-emblem">云</span>
      </span>
      <span class="book-ribbon">${overviewOpen ? "点击收起概览" : "点击翻阅概览"}</span>
    </button>

    <div class="overview-panel" id="overview-panel">
      <div class="overview-card overview-card-activity">
        <div class="overview-heading">
          <span aria-hidden="true">♟</span>
          <h2>最近动态</h2>
          <span aria-hidden="true">♣</span>
        </div>
        <ol class="activity-list">
          ${overview.recentActivity.map((item) => `<li><span>${item.time}</span><strong>${item.text}</strong></li>`).join("")}
        </ol>
        <a class="overview-link" href="#logs">查看全部动态</a>
      </div>

      <div class="overview-card overview-card-training">
        <div class="overview-heading">
          <span aria-hidden="true">♙</span>
          <h2>本周训练概览</h2>
          <span aria-hidden="true">♣</span>
        </div>
        <div class="training-distance">
          <strong>${overview.weeklyTraining.distance}</strong>
          <span>/ ${overview.weeklyTraining.goal}</span>
        </div>
        <div class="progress-track" aria-label="本周目标完成 ${overview.weeklyTraining.progress}%">
          <span style="width: ${overview.weeklyTraining.progress}%"></span>
        </div>
        <dl class="training-stats">
          <div><dt>训练频率</dt><dd>${overview.weeklyTraining.runs}</dd></div>
          <div><dt>状态恢复</dt><dd>${overview.weeklyTraining.focus}</dd></div>
        </dl>
      </div>

      <div class="overview-card overview-card-weather">
        <div class="overview-heading">
          <span aria-hidden="true">♙</span>
          <h2>今日天气 + 时钟显示</h2>
          <span aria-hidden="true">♣</span>
        </div>
        <div class="weather-layout">
          <div class="weather-icon" aria-hidden="true">☀</div>
          <div>
            <strong>${overview.weather.temperature}</strong>
            <span>${overview.weather.text}</span>
            <small>${overview.weather.location}</small>
          </div>
          <time data-clock>${getClockText(overview.clock.timezone)}</time>
        </div>
        <p class="weather-note">${overview.weather.note}</p>
      </div>
    </div>
  `;

  container.querySelector(".overview-book-toggle").addEventListener("click", () => {
    appState.toggleOverview();
  });
}
