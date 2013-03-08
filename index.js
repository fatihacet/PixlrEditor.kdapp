// Compiled by Koding Servers at Thu Mar 07 2013 18:27:38 GMT-0800 (PST) in server time

(function() {

/* KDAPP STARTS */

/* BLOCK STARTS /Source: /Users/fatihacet/Applications/PixlrEditor.kdapp/app/PixlrSettings.coffee */

var PixlrSettings, appKeyword, appName, appSlug, hookSuffix, nickname;

nickname = KD.whoami().profile.nickname;

appName = "PixlrEditor";

appKeyword = "editor";

appSlug = "pixlr-editor";

hookSuffix = KD.utils.getRandomNumber();

PixlrSettings = {
  hookSuffix: hookSuffix,
  appName: appName,
  appSlug: appSlug,
  src: "https://pixlr.com/" + appKeyword,
  image: "https://app.koding.com/fatihacet/Pixlr%20Editor/latest/resources/default/istanbul.png",
  saveIcon: "https://app.koding.com/fatihacet/Pixlr%20Editor/latest/resources/default/koding16.png",
  targetPath: "https://" + nickname + ".koding.com/.applications/" + appSlug + "/PixlrHook/PixlrHook" + hookSuffix + ".php",
  savePath: "/Users/" + nickname + "/Documents/" + appName + "/",
  imageName: "Default",
  fileExt: "jpg"
};


/* BLOCK ENDS */



/* BLOCK STARTS /Source: /Users/fatihacet/Applications/PixlrEditor.kdapp/app/PixlrAppView.coffee */

var PixlrAppView, nickname,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

nickname = KD.whoami().profile.nickname;

PixlrAppView = (function(_super) {

  __extends(PixlrAppView, _super);

  function PixlrAppView(options) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = "pixlr-container";
    PixlrAppView.__super__.constructor.call(this, options);
    this.appStorage = new AppStorage(PixlrSettings.appName, '0.1');
    this.container = new KDView({
      cssClass: "pixlr-container"
    });
    this.container.addSubView(this.dropTarget = new KDView({
      cssClass: "pixlr-drop-target",
      bind: "dragstart dragend dragover drop dragenter dragleave"
    }));
    this.dropTarget.hide();
    this.container.addSubView(this.resizeMask = new KDView({
      cssClass: "pixlr-resize-mask"
    }));
    this.resizeMask.hide();
    this.isResizeMaskVisible = false;
    this.appStorage.fetchStorage(function(storage) {
      var termsCheckboxLabel, termsView, warningConfirmButton;
      if (_this.appStorage.getValue('isTermsAccepted') === true) {
        return _this.init();
      } else {
        termsView = new KDView({
          cssClass: "pixlr-terms-view",
          partial: "<p class=\"pixlr-terms-header\">Warning</p>\n<p>This app can access and modify your files and also opens unencrypted connection to a third party web service, Pixlr. If you don't want to use the application you can safely close the tab.</p>\n<p class=\"confirmation\">Do you still want to use this application?</p>"
        });
        termsView.addSubView(termsCheckboxLabel = new KDLabelView({
          title: "Don't show this again",
          cssClass: "pixlr-terms-label"
        }));
        termsView.addSubView(_this.termsCheckbox = new KDInputView({
          type: "checkbox",
          cssClass: "pixlr-terms-checkbox",
          label: termsCheckboxLabel
        }));
        termsView.addSubView(warningConfirmButton = new KDButtonView({
          title: "Yes, understand risks!",
          cssClass: "clean-gray pixlr-terms-button",
          callback: function() {
            if (_this.termsCheckbox.$().is(":checked")) {
              _this.appStorage.setValue('isTermsAccepted', true);
            }
            termsView.destroy();
            return _this.init();
          }
        }));
        return _this.container.addSubView(termsView);
      }
    });
    this.dropTarget.on("drop", function(e) {
      return _this.openImage(e.originalEvent.dataTransfer.getData('Text'));
    });
    this.lastContainerWidth = this.container.getWidth();
    KD.utils.repeat(100, function() {
      var width;
      width = _this.container.getWidth();
      if (width !== _this.lastContainerWidth) {
        _this.resizeMask.show();
        _this.lastContainerWidth = width;
        return _this.isResizeMaskVisible = true;
      } else if (_this.isResizeMaskVisible === true) {
        _this.resizeMask.hide();
        return _this.isResizeMaskVisible = false;
      }
    });
  }

  PixlrAppView.prototype.init = function() {
    var dpath, healthCheck, preparation, spath,
      _this = this;
    this.mem = +new Date() + KD.utils.getRandomNumber();
    this.container.setPartial(this.buildIframe());
    KD.getSingleton("windowController").registerListener({
      KDEventTypes: ["DragEnterOnWindow", "DragExitOnWindow"],
      listener: this,
      callback: function(pubInst, event) {
        _this.dropTarget.show();
        if (event.type === "drop") {
          return _this.dropTarget.hide();
        }
      }
    });
    spath = "/Users/" + nickname + "/Applications/" + PixlrSettings.appName + ".kdapp/app/PixlrHook.php";
    dpath = "/Users/" + nickname + "/Sites/" + nickname + ".koding.com/website/.applications/" + PixlrSettings.appSlug + "/PixlrHook/";
    preparation = "rm -rf " + dpath + " ; mkdir -p " + dpath + " ; mkdir -p " + PixlrSettings.savePath + " ; sed 's/SECRETKEY/" + this.mem + "/' " + spath + " > " + dpath + "PixlrHook" + PixlrSettings.hookSuffix + ".php";
    healthCheck = "curl 'http://" + nickname + ".koding.com/.applications/" + PixlrSettings.appSlug + "/PixlrHook/PixlrHook" + PixlrSettings.hookSuffix + ".php?ping=1&key=" + this.mem + "'";
    this.doKiteRequest("" + preparation, function() {
      return _this.doKiteRequest("" + healthCheck, function(res) {
        if (res !== "OK") {
          return _this.warnUser();
        }
      });
    });
    return this.appStorage.fetchStorage(function(storage) {
      var content, disableNotificationButton, modal, notificationCheckboxLabel;
      if (_this.appStorage.getValue('disableNotification') === true) {
        return;
      }
      content = new KDView({
        partial: "<div class=\"pixlr-how-to\">\n  <p><strong>How to use Pixlr Editor</strong></p>\n  <p>1- You can drag and drop an image over pixlr, and when you save it, it will overwrite the original file.</p>\n  <p>2- If you change the name, it will save it to where it came from, with the new name.</p>\n  <p>3- If you open random images, and save, you can find them at e.g. ./Documents/Pixlr/yourImage.jpg\"</p>\n  \n  <p class=\"last\">Enjoy! Please clone and make it better :)</p>\n</div>"
      });
      content.addSubView(notificationCheckboxLabel = new KDLabelView({
        title: "Don't show this again",
        cssClass: "pixlr-notification-label"
      }));
      content.addSubView(_this.notificationCheckbox = new KDInputView({
        type: "checkbox",
        cssClass: "pixlr-notification-checkbox",
        label: notificationCheckboxLabel
      }));
      content.addSubView(disableNotificationButton = new KDButtonView({
        title: "Close",
        cssClass: "clean-gray",
        callback: function() {
          if (_this.notificationCheckbox.$().is(":checked")) {
            _this.appStorage.setValue('disableNotification', true);
          }
          return modal.destroy();
        }
      }));
      modal = new KDModalView({
        title: "How to use Pixlr Editor",
        cssClass: "pixlr-how-to-modal",
        overlay: true
      });
      return modal.addSubView(content);
    });
  };

  PixlrAppView.prototype.openImage = function(path) {
    var fileExt, image, timestamp,
      _this = this;
    fileExt = KD.utils.getFileExtension(path);
    if (path && KD.utils.getFileType(fileExt === "image")) {
      PixlrSettings.fileExt = fileExt;
      timestamp = +new Date();
      image = "/Users/" + nickname + "/Sites/" + nickname + ".koding.com/website/" + timestamp;
      PixlrSettings.savePath = path;
      PixlrSettings.imageName = FSHelper.getFileNameFromPath(path);
      return this.doKiteRequest("cp " + path + " " + image, function() {
        PixlrSettings.image = "http://" + nickname + ".koding.com/" + timestamp;
        _this.refreshIframe();
        return KD.utils.wait(6000, function() {
          return _this.doKiteRequest("rm " + image);
        });
      });
    } else {
      return new KDNotificationView({
        cssClass: "error",
        title: "Dropped file must be an image!"
      });
    }
  };

  PixlrAppView.prototype.buildIframeSrc = function(useEscape) {
    var amp;
    amp = useEscape ? '&amp;' : '&';
    return "" + PixlrSettings.src + "/?image=" + PixlrSettings.image + "&title=" + PixlrSettings.imageName + "&target=" + PixlrSettings.targetPath + amp + "meta=" + PixlrSettings.savePath + "&icon=" + PixlrSettings.saveIcon + "&referer=Koding&redirect=false&type=" + PixlrSettings.fileExt + "&key=" + this.mem;
  };

  PixlrAppView.prototype.buildIframe = function() {
    return "<iframe id=\"pixlr\" type=\"text/html\" width=\"100%\" height=\"100%\" frameborder=\"0\" \n  src=\"" + (this.buildIframeSrc(true)) + "\"\n></iframe>";
  };

  PixlrAppView.prototype.refreshIframe = function() {
    return document.getElementById("pixlr").setAttribute("src", this.buildIframeSrc(false));
  };

  PixlrAppView.prototype.warnUser = function() {
    return new KDModalView({
      title: "Cannot save!",
      overlay: true,
      content: "<div class=\"pixlr-cannot-save\">\n  Pixlr cannot access the little php file it needs \n  to be able to save files (./website/PixlrHook/PixlrHook.php)\n  You either deleted it, or made it inaccessible somehow (think .htaccess)\n  \n  Reinstalling Pixlr might fix it, but not guaranteed.\n  \n  If you want this be fixed, you should convince someone to continue developing Pixlr.kdapp :)\n</div>"
    });
  };

  PixlrAppView.prototype.doKiteRequest = function(command, callback) {
    var _this = this;
    return KD.getSingleton('kiteController').run(command, function(err, res) {
      if (!err) {
        return typeof callback === "function" ? callback(res) : void 0;
      } else {
        if (typeof callback === "function") {
          callback(res);
        }
        return new KDNotificationView({
          title: "An error occured while processing your request, try again please!",
          type: "mini",
          duration: 3000
        });
      }
    });
  };

  PixlrAppView.prototype.pistachio = function() {
    return "{{> this.container}}";
  };

  return PixlrAppView;

})(JView);


/* BLOCK ENDS */



/* BLOCK STARTS /Source: /Users/fatihacet/Applications/PixlrEditor.kdapp/index.coffee */


(function() {
  return appView.addSubView(new PixlrAppView);
})();


/* BLOCK ENDS */

/* KDAPP ENDS */

}).call();