function onYouTubeIframeAPIReady() {
  document.querySelectorAll('.youtube-audio-container').forEach(function(div) {
    var element = document.getElementById(div.id);
    var image = document.createElement("img");
    image.setAttribute("id", "youtube-icon");
    image.style.cssText = "cursor:pointer;cursor:hand";
    element.appendChild(image);
    var playerDiv = document.createElement("div");
    playerDiv.setAttribute("id", `${div.id}-player`), element.appendChild(playerDiv);
    var setButtonImage = function(playerActive) {
      var file = playerActive ? "musicplayer-active.png" : "musicplayer-inactive.png";
      image.setAttribute("src", "/game/uploads/theme_images/" + file)
    };
    element.onclick = function() {
      player.getPlayerState() === YT.PlayerState.PLAYING || player.getPlayerState() === YT.PlayerState.BUFFERING ? (player.pauseVideo(), setButtonImage(!1)) : (player.playVideo(), setButtonImage(!0))
    };
    var player = new YT.Player(`${div.id}-player`, {
      height: "0",
      width: "0",
      videoId: element.dataset.video,
      playerVars: {
        autoplay: element.dataset.autoplay,
        loop: element.dataset.loop
      },
      events: {
        onReady: function(e) {
          player.setPlaybackQuality("small"), setButtonImage(player.getPlayerState() !== YT.PlayerState.CUED)
        },
        onStateChange: function(e) {
          e.data === YT.PlayerState.ENDED && setButtonImage(!1)
        }
      }
    })
  });
}