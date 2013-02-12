{nickname} = KD.whoami().profile

appName       = 'PixlrEditor'
appKeyword    = 'editor'

PixlrSettings =
  appName    : appName
  src        : "https://pixlr.com/#{appKeyword}"
  image      : "https://dl.dropbox.com/u/31049236/nat-geo.jpeg"
  saveIcon   : "https://dl.dropbox.com/u/31049236/koding16.png"
  targetPath : "https://#{nickname}.koding.com/PixlrHook/PixlrHook.php"
  savePath   : "/Users/#{nickname}/Documents/#{appName}/"
  imageName  : "Default"
  fileExt    : "jpg"
  