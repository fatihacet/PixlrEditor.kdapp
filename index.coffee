KD.enableLogs()

{nickname} = KD.whoami().profile
PixlrSettings =
  src        : "https://pixlr.com/editor"
  image      : "https://dl.dropbox.com/u/31049236/nat-geo.jpeg"
  saveIcon   : "https://dl.dropbox.com/u/31049236/koding16.png"
  targetPath : "https://fatihacet.koding.com/responses.php"
  

class Pixlr extends JView

  constructor: (options = {}) ->
    
    options.cssClass = "pixlr-container"
    
    super options
  
    @container = new KDView
      
    @init()
    
    
  init: ->
    @container.setPartial @buildIframe()
    
    KD.getSingleton("windowController").registerListener
      KDEventTypes : "DragExitOnWindow"
      listener : @
      callback : (pubInst, event) =>
        timestamp  = +new Date()
        path       = "/Users/fatihacet/Applications/WordPress.kdapp/resources/scr.2.png"
        image      = "/Users/#{nickname}/Sites/#{nickname}.koding.com/website/#{timestamp}"
        
        @doKiteRequest "cp #{path} #{image}", =>
          @image = "http://#{nickname}.koding.com/#{timestamp}"
          @refreshIframe()
          KD.utils.wait 6000, =>
            @doKiteRequest "rm #{image}"
        
  
  buildIframe: ->
    """
      <iframe id="pixlr" type="text/html" width="100%" height="100%" frameborder="0" 
              src="#{PixlrSettings.src}/?image=#{PixlrSettings.image}&target=#{PixlrSettings.targetPath}&icon=#{PixlrSettings.saveIcon}&referer=Koding&redirect=false"
      ></iframe>
    """
    
  refreshIframe: ->
    @container.updatePartial @buildIframe()
    
    
  doKiteRequest: (command, callback) ->
    KD.getSingleton('kiteController').run command, (err, res) =>
      unless err
        callback(res) if callback
      else 
        new KDNotificationView
          title    : "An error occured while processing your request, try again please!"
          type     : "mini"
          duration : 3000
    
  
  pistachio: ->
    """
      {{> @container }}
    """
  
do -> appView.addSubView new Pixlr
