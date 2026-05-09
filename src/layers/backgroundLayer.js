export function renderBackgroundLayer(container) {
  container.innerHTML = `
    <div class="town-stage">
      <div class="sky-band" aria-hidden="true"></div>
      <div class="mountain-band" aria-hidden="true"></div>
      <div class="river-path" aria-hidden="true"></div>
      <div class="grass-field" aria-hidden="true"></div>
      <div class="town-stage-label">
        <strong>BackgroundLayer</strong>
        <span>小镇背景图、地图舞台比例、瀑布/草地/树木动画预留</span>
      </div>
    </div>
  `;
}
