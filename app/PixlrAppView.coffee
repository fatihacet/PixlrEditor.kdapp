{nickname} = KD.whoami().profile

class PixlrAppView extends JView

  constructor: (options = {}) ->
    
    options.cssClass = "pixlr-container"
    
    super options
  
    @appStorage = new AppStorage PixlrSettings.appName, '0.1'
    
    @container = new KDView
      cssClass: "pixlr-container"
      
    @container.addSubView @dropTarget = new KDView
      cssClass   : "pixlr-drop-target"
      bind       : "dragstart dragend dragover drop dragenter dragleave"
      
    @dropTarget.hide()
    
    @container.addSubView @resizeMask = new KDView
      cssClass : "pixlr-resize-mask"
      
    @resizeMask.hide()
    @isResizeMaskVisible = no
    
    @appStorage.fetchStorage (storage) =>
      if @appStorage.getValue('isTermsAccepted') is yes
        @init()
      else 
        termsView = new KDView
          cssClass : "pixlr-terms-view"
          partial  : """
            <p class="pixlr-terms-header">Warning</p>
            <p>This app can access and modify your files and also opens unencrypted connection to a third party web service, Pixlr. If you don't want to use the application you can safely close the tab.</p>
            <p class="confirmation">Do you still want to use this application?</p>
          """
          
        termsView.addSubView termsCheckboxLabel = new KDLabelView
         title     : "Don't show this again"
         cssClass  : "pixlr-terms-label"
        
        termsView.addSubView @termsCheckbox = new KDInputView
          type     : "checkbox"
          cssClass : "pixlr-terms-checkbox"
          label    : termsCheckboxLabel
          
        termsView.addSubView warningConfirmButton = new KDButtonView
          title    : "Yes, I know the risk"
          cssClass : "clean-gray pixlr-terms-button"
          callback : =>
            @appStorage.setValue 'isTermsAccepted', yes if @termsCheckbox.$().is ":checked"
            termsView.destroy()
            @init()
            
        @container.addSubView termsView
    
    @dropTarget.on "drop", (e) =>
      @openImage e.originalEvent.dataTransfer.getData 'Text'
      
    @lastContainerWidth = @container.getWidth()
    
    KD.utils.repeat 100, =>
      width = @container.getWidth()
      if width != @lastContainerWidth
        @resizeMask.show()
        @lastContainerWidth = width
        @isResizeMaskVisible = yes
      else if @isResizeMaskVisible is yes
        @resizeMask.hide()
        @isResizeMaskVisible = no
  
  
  init: ->
    @mem = +new Date() + KD.utils.getRandomNumber()
    @container.setPartial @buildIframe()
    
    KD.getSingleton("windowController").registerListener
      KDEventTypes : ["DragEnterOnWindow", "DragExitOnWindow"]
      listener : @
      callback : (pubInst, event) =>
        @dropTarget.show()
        @dropTarget.hide() if event.type is "drop"
        
    spath       = "/Users/#{nickname}/Applications/#{PixlrSettings.appName}.kdapp/app/PixlrHook.php" # source path of hook file
    dpath       = "/Users/#{nickname}/Sites/#{nickname}.koding.com/website/.applications/#{PixlrSettings.appSlug}/PixlrHook/" # destination path that hook file will be copied
    preparation = """rm -rf #{dpath} ; mkdir -p #{dpath} ; mkdir -p #{PixlrSettings.savePath} ; sed 's/SECRETKEY/#{@mem}/' #{spath} > #{dpath}PixlrHook#{PixlrSettings.hookSuffix}.php"""
    healthCheck = "curl 'http://#{nickname}.koding.com/.applications/#{PixlrSettings.appSlug}/PixlrHook/PixlrHook#{PixlrSettings.hookSuffix}.php?ping=1&key=#{@mem}'"
    
    @doKiteRequest "#{preparation}", =>
      @doKiteRequest "#{healthCheck}", (res) =>
        @warnUser() unless res is "OK"
  
    @appStorage.fetchStorage (storage) =>
      return if @appStorage.getValue('disableNotification') is yes
      
      content = new KDView
        partial: """
          <div class="pixlr-how-to">
            <p><strong>How to use Pixlr Editor</strong></p>
            <p>1- You can drag and drop an image over pixlr, and when you save it, it will overwrite the original file.</p>
            <p>2- If you change the name, it will save it to where it came from, with the new name.</p>
            <p>3- If you open random images, and save, you can find them at e.g. ./Documents/Pixlr/yourImage.jpg"</p>
            
            <p class="last">Enjoy! Please clone and make it better :)</p>
          </div>
        """
      content.addSubView notificationCheckboxLabel = new KDLabelView
       title     : "Don't show this again"
       cssClass  : "pixlr-notification-label"
      
      content.addSubView @notificationCheckbox = new KDInputView
        type     : "checkbox"
        cssClass : "pixlr-notification-checkbox"
        label    : notificationCheckboxLabel
      
      content.addSubView disableNotificationButton = new KDButtonView
        title    : "Close"
        cssClass : "clean-gray"
        callback : =>
          @appStorage.setValue 'disableNotification', yes if @notificationCheckbox.$().is ":checked"
          modal.destroy()
      
      modal = new KDModalView
        title    : "How to use Pixlr Editor"
        cssClass : "pixlr-how-to-modal"
        overlay  : yes
      
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
          

  buildIframeSrc : (useEscape, isSplashView) -> 
    amp = if useEscape then '&amp;' else '&'
    img = if isSplashView then "" else "image=#{PixlrSettings.image}"
    """#{PixlrSettings.src}/?#{img}&title=#{PixlrSettings.imageName}&target=#{PixlrSettings.targetPath}#{amp}meta=#{PixlrSettings.savePath}&icon=#{PixlrSettings.saveIcon}&referer=Koding&redirect=false&type=#{PixlrSettings.fileExt}&key=#{@mem}"""


  buildIframe: ->
    """
      <iframe id="pixlr" type="text/html" width="100%" height="100%" frameborder="0" 
        src="#{@buildIframeSrc yes, yes}"
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
    