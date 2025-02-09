// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("turbolinks:load", function() {
// ↪︎ windowがロードされた時にアクションを実行するように設定
  if (document.getElementById("area")) {
    // ↪︎ areaのIDがある場合に処理を実行させる（これがないとチャット画面がなくても常にJavaScriptが動いてしまいます）
    var scrollPosition = document.getElementById("area").scrollTop;
    // ↪︎ area要素のスクロールされた時の最も高い場所を取得
    var scrollHeight = document.getElementById("area").scrollHeight;
    // ↪︎ area要素自体の最も高い場所を取得
    document.getElementById("area").scrollTop = scrollHeight;
    // ↪︎ area要素のスクロールされた時の最も高い場所をarea要素自体の最も高い場所として指定してあげる
  }
});