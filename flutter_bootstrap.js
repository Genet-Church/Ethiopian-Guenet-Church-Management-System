window.addEventListener('load', function(ev) {
  var loadingText = document.getElementById("loading-text");

  _flutter.loader.load({
    onProgress: function(event) {
      if (event.total) {
        var percent = Math.round(event.loaded / event.total * 100);
        loadingText.innerText = "Downloading (" + percent + "%)...";
      } else {
        loadingText.innerText = "Downloading...";
      }
    },
    engineInitializer: async function(engineInitializer) {
      loadingText.innerText = "Initializing Engine...";
      const appRunner = await engineInitializer.initializeEngine({
        // Let Flutter choose the best renderer (skwasm for Wasm, CanvasKit otherwise)
      });
      loadingText.innerText = "Running App...";
      appRunner.runApp();
    }
  });
});

function hideLoadingIndicator() {
  var loadingContainer = document.getElementById("loading-container");
  if (loadingContainer) {
    loadingContainer.style.opacity = '0';
    setTimeout(() => { loadingContainer.remove(); }, 500);
  }
}