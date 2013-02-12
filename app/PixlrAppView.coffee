{nickname} = KD.whoami().profile

class PixlrAppView extends JView

  constructor: (options = {}) ->
    
    options.cssClass = "pixlr-container"
    
    super options
  
    @container = new KDView
    
    @container.addSubView @dropTarget = new KDView
      cssClass : "pixlr-drop-target"
      bind     : "dragstart dragend dragover drop dragenter dragleave"
      
    @dropTarget.hide()
    
    @init()
    
    @dropTarget.on "drop", (e) =>
      @openImage e.originalEvent.dataTransfer.getData 'Text'
      
  init: ->
    @container.setPartial @buildIframe()
    
    KD.getSingleton("windowController").registerListener
      KDEventTypes : ["DragEnterOnWindow", "DragExitOnWindow"]
      listener : @
      callback : (pubInst, event) =>
        @dropTarget.show()
        @dropTarget.hide() if event.type is "drop"
        
    path    = "/Users/#{nickname}/Sites/#{nickname}.koding.com/website/PixlrHook/"
    command = "mkdir -p #{path} ; mkdir -p #{PixlrSettings.savePath} ; ln -s /Users/#{nickname}/Applications/#{PixlrSettings.appName}.kdapp/app/PixlrHook.php #{path}"
    @doKiteRequest "#{command}", (req) ->
      
    
    @doKiteRequest "curl http://#{nickname}.koding.com/PixlrHook/PixlrHook.php?ping=1", (res) =>
      @warnUser() unless res is "OK"
      
    new KDModalView
      title  : "How to use Pixlr"
      overlay: yes
      content: """
        <div class="pixlr-how-to">
          <p>1- You can drag and drop an image over pixlr, and when you save it, it will overwrite the original file.</p>
          <p>2- If you change the name, it will save it to where it came from, with the new name.</p>
          <p>3- If you open random images, and save, you can find them at e.g. ./Documents/Pixlr/yourImage.jpg"</p>
          
          <p class="last">Enjoy! Please clone and make it better :)</p>
        </div>
      """
        
        
  openImage: (path) ->
    fileExt = KD.utils.getFileExtension path 
    if path and KD.utils.getFileType fileExt is "image"
      PixlrSettings.fileExt = fileExt
      timestamp  = +new Date()
      image      = "/Users/#{nickname}/Sites/#{nickname}.koding.com/website/#{timestamp}"
      
      PixlrSettings.savePath = path
      PixlrSettings.imageName = FSHelper.getFileNameFromPath path
      
      @doKiteRequest "cp #{path} #{image}", =>
        PixlrSettings.image = "http://#{nickname}.koding.com/#{timestamp}"
        @refreshIframe()
        KD.utils.wait 6000, =>
          @doKiteRequest "rm #{image}"
    else 
        new KDNotificationView
          cssClass : "error"
          title    : "Dropped file must be an image!"
          

  buildIframeSrc : (useEscape) -> 
    amp = if useEscape then '&amp;' else '&'
    """#{PixlrSettings.src}/?image=#{PixlrSettings.image}&title=#{PixlrSettings.imageName}&target=#{PixlrSettings.targetPath}#{amp}meta=#{PixlrSettings.savePath}&icon=#{PixlrSettings.saveIcon}&referer=Koding&redirect=false&type=#{PixlrSettings.fileExt}"""
    

  buildIframe: ->
    """
      <iframe id="pixlr" type="text/html" width="100%" height="100%" frameborder="0" 
        src="#{@buildIframeSrc yes}"
      ></iframe>
    """
    
    
  refreshIframe: ->
    document.getElementById("pixlr").setAttribute "src", @buildIframeSrc no
    
  
  warnUser: ->
    new KDModalView
      title  : "Cannot save!"
      overlay: yes
      content: """
        Pixlr cannot access the little php file it needs 
        to be able to save files (./website/PixlrHook/pixlrHook.php)
        You either deleted it, or made it inaccessible somehow (think .htaccess)
        
        Reinstalling Pixlr might fix it, but not guaranteed.
        
        If you want this be fixed, you should convince someone to continue developing Pixlr.kdapp :)
      """
    
    
  doKiteRequest: (command, callback) ->
    KD.getSingleton('kiteController').run command, (err, res) =>
      unless err
        callback res if callback
      else
        if callback
          return callback res 
        new KDNotificationView
          title    : "An error occured while processing your request, try again please!"
          type     : "mini"
          duration : 3000
    
  pistachio: ->
    """
      {{> @container }}
    """
    