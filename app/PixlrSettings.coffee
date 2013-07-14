{nickname} = KD.whoami().profile

appName       = "PixlrEditor"
appKeyword    = "editor"
appSlug       = "pixlr-editor"
hookSuffix    = KD.utils.getRandomNumber()

PixlrSettings =
  hookSuffix : hookSuffix
  appName    : appName
  appSlug    : appSlug
  src        : "http://pixlr.com/#{appKeyword}"
  saveIcon   : "https://app.koding.com/fatihacet/Pixlr%20Editor/latest/resources/default/koding16.png"
  targetPath : "http://#{KD.getSingleton('vmController').defaultVmName}/.applications/#{appSlug}/PixlrHook/PixlrHook#{hookSuffix}.php"
  savePath   : "/tmp/PixlrEditor#{hookSuffix}/"
  saveDir    : "/home/#{nickname}/Documents/#{appName}"
  relSaveDir : "~/Documents/#{appName}"
  imageName  : "Default"
  fileExt    : "jpg"
  