document.addEventListener("DOMContentLoaded", function () {
  var modal = document.getElementById("calendarModal");

  modal.addEventListener("show.bs.modal", function (event) {
    var button = event.relatedTarget; // クリックされた要素
    var date = button.getAttribute("data-date"); // 日付を取得
    var events = JSON.parse(button.getAttribute("data-events")); // イベントを取得

    // モーダルに日付を表示
    document.getElementById("modalDate").textContent = date;

    // イベントリストを更新
    var eventList = document.getElementById("modalEvents");
    eventList.innerHTML = "";

    if (events.length > 0) {
      events.forEach(function (event) {
        var li = document.createElement("li");
        li.className = "list-group-item";
        li.innerHTML = `<a href="/events/${event.id}" class="text-decoration-none">${event.title}</a>`;
        eventList.appendChild(li);
      });
    } else {
      var li = document.createElement("li");
      li.className = "list-group-item text-muted";
      li.textContent = "イベントはありません";
      eventList.appendChild(li);
    }

    // 新規投稿ボタンのリンクを設定
    var newEventLink = document.getElementById("newEventLink");
    newEventLink.href = `/events/new?date=${date}`;
  });
});