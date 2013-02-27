{nickname} = KD.whoami().profile

appName       = 'PixlrEditor'
appKeyword    = 'editor'
hookSuffix    = KD.utils.getRandomNumber()

PixlrSettings =
  hookSuffix : hookSuffix
  appName    : appName
  src        : "https://pixlr.com/#{appKeyword}"
  image      : "https://app.koding.com/fatihacet/Pixlr%20Editor/latest/resources/default/istanbul.png"
  saveIcon   : "https://app.koding.com/fatihacet/Pixlr%20Editor/latest/resources/default/koding16.png"
  targetPath : "https://#{nickname}.koding.com/PixlrHook/PixlrHook#{hookSuffix}.php"
  savePath   : "/Users/#{nickname}/Documents/#{appName}/"
  imageName  : "Default"
  fileExt    : "jpg"
  