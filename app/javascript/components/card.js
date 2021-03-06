function jsCardPlayer () {

var player
var onTimer
var offTimer
var card = document.querySelector('.card')

// Player funtions
function onPlayerReady (event) {
  player.setVolume(500)
  player.playVideo()
}

function onPlayerStateChange (event) {
  if (event.data === 1) {
    card.classList.add('--active')
  }
  if (event.data === 0) {
    card.classList.remove('--active')
  }
}

function initPlayer () {
  player = new YT.Player('player', {
    height: 280,
    width: 440,
    videoId: 'zatM_LInqBk',
    playerVars: {
      modestbranding: 1,
      origin: window.location.href,
      color: 'white',
      showinfo: 0,
      iv_load_policy: 3,
      playsinline: 1,
      disablekb: 0,
      fs: 0,
      controls: 0,
      start: 35,
      enablejsapi: 1
    },
    events: {
      onReady: onPlayerReady,
      onStateChange: onPlayerStateChange
    }
  })
}


// Hover
if (card)
  {card.addEventListener('mouseenter', function (event) {
    clearTimeout(offTimer)
    onTimer = setTimeout(function () {
      initPlayer()
    }, 300)
  })}

if (card)
{card.addEventListener('mouseleave', function (event) {
  clearTimeout(onTimer)
  card.classList.remove('--active')
  offTimer = setTimeout(function () {
    player.destroy()
    player = ''
  }, 300)
})}
}

export { jsCardPlayer };