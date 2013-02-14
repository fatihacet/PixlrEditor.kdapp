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
    @mem = +new Date() + Math.floor(Math.random() * 90000) + 10000
    @container.setPartial @buildIframe()
    
    KD.getSingleton("windowController").registerListener
      KDEventTypes : ["DragEnterOnWindow", "DragExitOnWindow"]
      listener : @
      callback : (pubInst, event) =>
        @dropTarget.show()
        @dropTarget.hide() if event.type is "drop"
        
    spath   = "/Users/#{nickname}/Applications/#{PixlrSettings.appName}.kdapp/app/PixlrHook.php"
    dpath   = "/Users/#{nickname}/Sites/#{nickname}.koding.com/website/PixlrHook/"
    command = """mkdir -p #{dpath} ; mkdir -p #{PixlrSettings.savePath} ; sed 's/SECRETKEY/#{@mem}/' #{spath} > #{dpath}PixlrHook.php"""
    KD.enableLogs()
    console.log command
    
    @doKiteRequest "#{command}", =>
      cmd = "curl 'http://#{nickname}.koding.com/PixlrHook/PixlrHook.php?ping=1&key=#{@mem}'"
      @doKiteRequest cmd, (res) =>
        @warnUser() unless res is "OK"
  
    @appStorage = new AppStorage PixlrSettings.appName, '1.0'
    
    @appStorage.fetchStorage (storage) =>
      return if @appStorage.getValue 'disableNotification'
      
      content = new KDView
        partial: """
          <div class="pixlr-how-to">
            <p>1- You can drag and drop an image over pixlr, and when you save it, it will overwrite the original file.</p>
            <p>2- If you change the name, it will save it to where it came from, with the new name.</p>
            <p>3- If you open random images, and save, you can find them at e.g. ./Documents/Pixlr/yourImage.jpg"</p>
            
            <p class="last">Enjoy! Please clone and make it better :)</p>
          </div>
        """
      content.addSubView disableNotificationButton = new KDCustomHTMLView
        tagName  : "a"
        partial  : "Don't show it again!"
        cssClass : "pixlr-disable-notification"
        click    : =>
          @appStorage.setValue 'disableNotification', yes
          modal.destroy()
      
      modal = new KDModalView
        title  : "How to use Pixlr"
        overlay: yes
      
      modal.addSubView content

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
    """#{PixlrSettings.src}/?image=#{PixlrSettings.image}&title=#{PixlrSettings.imageName}&target=#{PixlrSettings.targetPath}#{amp}meta=#{PixlrSettings.savePath}&icon=#{PixlrSettings.saveIcon}&referer=Koding&redirect=false&type=#{PixlrSettings.fileExt}&key=#{@mem}"""

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
        <div class="pixlr-cannot-save">
          Pixlr cannot access the little php file it needs 
          to be able to save files (./website/PixlrHook/PixlrHook.php)
          You either deleted it, or made it inaccessible somehow (think .htaccess)
          
          Reinstalling Pixlr might fix it, but not guaranteed.
          
          If you want this be fixed, you should convince someone to continue developing Pixlr.kdapp :)
        </div>
      """
    
    
  doKiteRequest: (command, callback) ->
    KD.getSingleton('kiteController').run command, (err, res) =>
      console.log err, res
      unless err
        callback? res
      else
        callback? res 
        new KDNotificationView
          title    : "An error occured while processing your request, try again please!"
          type     : "mini"
          duration : 3000
    
  pistachio: ->
    """
      {{> @container }}
    """
    