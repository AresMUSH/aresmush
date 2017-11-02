function toggleButtonPlayer_YbTEp(buttonobj) {
    buttonobj.style.display = "none";
    var splits = buttonobj.id.split("-");
    var playerId = splits[0];
    var buttonType = splits[1];
    
    if (buttonType == "playbutton") {
        document.getElementById(playerId + "-pausebutton").style.display = "inline";
    } else {
        document.getElementById(playerId + "-playbutton").style.display = "inline";
    }
}