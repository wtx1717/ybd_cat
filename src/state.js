export const initialState = {
  currentScene: "town-day",
  selectedBuilding: null,
  overviewOpen: true,
};

export function createAppState(overrides = {}) {
  let state = {
    ...initialState,
    ...overrides,
  };

  const listeners = new Set();

  function notify() {
    listeners.forEach((listener) => listener(getState()));
  }

  function getState() {
    return { ...state };
  }

  function setState(partialState) {
    state = {
      ...state,
      ...partialState,
    };
    notify();
  }

  function selectBuilding(buildingId) {
    setState({ selectedBuilding: buildingId });
  }

  function toggleOverview() {
    setState({ overviewOpen: !state.overviewOpen });
  }

  function subscribe(listener) {
    listeners.add(listener);
    return () => listeners.delete(listener);
  }

  return {
    getState,
    setState,
    selectBuilding,
    toggleOverview,
    subscribe,
  };
}
