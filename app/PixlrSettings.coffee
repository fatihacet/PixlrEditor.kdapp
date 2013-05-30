{nickname} = KD.whoami().profile

appName       = "PixlrEditor"
appKeyword    = "editor"
appSlug       = "pixlr-editor"
hookSuffix    = KD.utils.getRandomNumber()

PixlrSettings =
  hookSuffix : hookSuffix
  appName    : appName
  appSlug    : appSlug
  src        : "https://pixlr.com/#{appKeyword}"
  image      : "https://app.koding.com/fatihacet/Pixlr%20Editor/latest/resources/default/istanbul.png"
  saveIcon   : "https://app.koding.com/fatihacet/Pixlr%20Editor/latest/resources/default/koding16.png"
  targetPath : "https://#{nickname}.#{KD.config.userSitesDomain}/.applications/#{appSlug}/PixlrHook/PixlrHook#{hookSuffix}.php"
  savePath   : "Documents/#{appName}/"
  imageName  : "Default"
  fileExt    : "jpg"
  