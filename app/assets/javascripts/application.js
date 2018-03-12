function applyConfirm(element) {
  var message = element.getAttribute('data-confirm');
  if (message) {
    element.form.addEventListener('submit', function submitHandler(event) {
      if (!confirm(message)) {
        event.preventDefault();
      }
    });
  }
}

(function bootstrapApplication() {
  const confirmNodes = document.querySelectorAll('[data-confirm]');

  for (let i = 0; i < confirmNodes.length; i++) {
    applyConfirm(confirmNodes[i]);
  }
})();
