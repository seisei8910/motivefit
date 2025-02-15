document.addEventListener("turbolinks:load", function () {
  var modal = document.getElementById("calendarModal");

  if (modal) {
    modal.addEventListener("show.bs.modal", function (event) {
      var backdrops = document.querySelectorAll('.modal-backdrop');
      backdrops.forEach(function(backdrop) {
        backdrop.remove();
      });

      var button = event.relatedTarget;
      var date = button.getAttribute("data-date");
      var events = JSON.parse(button.getAttribute("data-events"));

      var formattedDate = new Date(date).toLocaleDateString('ja-JP', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });

      document.getElementById("modalDate").textContent = formattedDate;

      var eventList = document.getElementById("modalEvents");
      eventList.innerHTML = "";

      if (events.length > 0) {
        events.forEach(function (event) {
          var li = document.createElement("li");
          li.className = "list-group-item";

          var startTime = new Date(event.start_time); // UTC時間を取得
          startTime.setUTCHours(startTime.getUTCHours() - 9); // UTC時間に9時間を足して日本時間に変換（日本時間はUTC+9）

          var japanHours = startTime.getHours();
          var ampm = (japanHours >= 12) ? '午後' : '午前'; // AM/PMを判定
          japanHours = japanHours % 12 || 12; // 12時間表示に変換
          var japanMinutes = startTime.getMinutes().toString().padStart(2, '0'); // 分を取得し、2桁にゼロ埋め

          var formattedTime = `${ampm} ${japanHours}:${japanMinutes}`; // AM/PM表記と12時間表示のフォーマット

          li.innerHTML = `<span class="text-muted">${formattedTime}</span> - <a href="/posts/${event.id}" class="text-decoration-none">${event.title}</a>`;
          eventList.appendChild(li);
        });
      } else {
        var li = document.createElement("li");
        li.className = "list-group-item text-muted";
        li.textContent = "投稿はありません";
        eventList.appendChild(li);
      }

      var newEventLink = document.getElementById("newEventLink");
      newEventLink.href = `/posts/new?date=${date}`;
    });
  }
});

document.addEventListener("turbolinks:before-cache", function() {
  var modals = document.querySelectorAll('.modal');
  modals.forEach(function(modal) {
    var modalInstance = bootstrap.Modal.getInstance(modal);
    if (modalInstance) {
      modalInstance.hide();
    }
    modal.classList.remove('show');
    modal.style.display = 'none';
    document.body.classList.remove('modal-open');

    document.querySelectorAll('.modal-backdrop').forEach(function(backdrop) {
      backdrop.parentNode.removeChild(backdrop);
    });
  });
});