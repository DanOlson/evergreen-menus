function applyConfirmToForm(element) {
  var message = element.getAttribute('data-confirm');
  if (message) {
    element.form.addEventListener('submit', function submitHandler(event) {
      if (!confirm(message)) {
        event.preventDefault();
      }
    });
  }
}

function applyConfirm() {
  const confirmNodes = document.querySelectorAll('[data-confirm]');

  for (let i = 0; i < confirmNodes.length; i++) {
    applyConfirmToForm(confirmNodes[i]);
  }
}

(function() {
  if (document.readyState === 'complete') {
    applyConfirm()
  }

  document.onreadystatechange = function onReadyChange() {
    if (document.readyState === 'complete') {
      applyConfirm()
    }
  }
})();
