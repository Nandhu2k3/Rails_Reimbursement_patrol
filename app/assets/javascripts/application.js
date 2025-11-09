// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require rails-ujs
//= require turbolinks
//= require_tree .

document.addEventListener('turbolinks:load', function () {
    var openBtn    = document.getElementById('open-logout-confirm');
    var modal      = document.getElementById('logout-modal');
    var cancelBtn  = document.getElementById('logout-cancel');
    var confirmBtn = document.getElementById('logout-confirm');
    var form       = document.getElementById('logout-form');
  
    // If any piece is missing on this page, do nothing.
    if (!openBtn || !modal || !cancelBtn || !confirmBtn || !form) return;
  
    // Open modal
    openBtn.addEventListener('click', function (e) {
      e.preventDefault();
      modal.classList.remove('hidden');
    });
  
    // Cancel -> just hide
    cancelBtn.addEventListener('click', function () {
      modal.classList.add('hidden');
    });
  
    // Confirm -> submit real logout form
    confirmBtn.addEventListener('click', function () {
      form.submit();
    });
  
    // Optional: click on dark overlay closes modal
    modal.addEventListener('click', function (e) {
      if (e.target === modal) {
        modal.classList.add('hidden');
      }
    });
  });