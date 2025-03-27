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
          li.className = "list-group-item d-flex justify-content-between align-items-center";

          var startTime = new Date(event.start_time);

          var japanHours = startTime.getHours();
          var japanMinutes = startTime.getMinutes().toString().padStart(2, '0');

          var formattedTime = `${japanHours}:${japanMinutes}`;

          // 左側に時刻とタイトル
          var leftContent = `
            <span class="text-muted me-2">${formattedTime}</span>
            <a href="/posts/${event.id}" class="text-decoration-none">${event.title}</a>
          `;

          // 右側に編集・削除ボタン
          var rightButtons = `
            <div>
              <a href="/posts/${event.id}/edit" class="btn btn-sm btn-outline-info me-1 rounded-4">編集</a>
              <a href="/posts/${event.id}" data-method="delete" data-confirm="本当に削除しますか？" class="btn btn-sm btn-outline-danger rounded-4">削除</a>
            </div>
          `;

          li.innerHTML = leftContent + rightButtons;
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