// Compiled by Koding Servers at Mon Feb 11 2013 20:03:47 GMT-0800 (PST) in server time

(function() {

/* KDAPP STARTS */

/* BLOCK STARTS /Source: /Users/fatihacet/Applications/Pixlr.kdapp/app/PixlrSettings.coffee */

var PixlrSettings, nickname;

nickname = KD.whoami().profile.nickname;

PixlrSettings = {
  src: "https://pixlr.com/editor",
  image: "https://dl.dropbox.com/u/31049236/nat-geo.jpeg",
  saveIcon: "https://dl.dropbox.com/u/31049236/koding16.png",
  targetPath: "https://" + nickname + ".koding.com/PixlrHook/PixlrHook.php",
  savePath: "/Users/" + nickname + "/Documents/Pixlr/",
  imageName: "Default",
  fileExt: "jpg"
};


/* BLOCK ENDS */



/* BLOCK STARTS /Source: /Users/fatihacet/Applications/Pixlr.kdapp/app/PixlrAppView.coffee */

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
    this.container = new KDView;
    this.container.addSubView(this.dropTarget = new KDView({
      cssClass: "pixlr-drop-target",
      bind: "dragstart dragend dragover drop dragenter dragleave"
    }));
    this.dropTarget.hide();
    this.init();
    this.dropTarget.on("drop", function(e) {
      return _this.openImage(e.originalEvent.dataTransfer.getData("Text"));
    });
  }

  PixlrAppView.prototype.init = function() {
    var command, path,
      _this = this;
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
    path = "/Users/" + nickname + "/Sites/" + nickname + ".koding.com/website/PixlrHook/";
    command = "mkdir -p " + path + " ; mkdir -p " + PixlrSettings.savePath + " ; ln -s /Users/" + nickname + "/Applications/Pixlr.kdapp/app/PixlrHook.php " + path;
    this.doKiteRequest("" + command);
    this.doKiteRequest("curl http://" + nickname + ".koding.com/PixlrHook/PixlrHook.php?ping=1", function(res) {
      if (res !== "OK") {
        return _this.warnUser();
      }
    });
    return new KDModalView({
      title: "How to use Pixlr",
      overlay: true,
      content: "<div class=\"pixlr-how-to\">\n  <p>1- You can drag and drop an image over pixlr, and when you save it, it will overwrite the original file.</p>\n  <p>2- If you change the name, it will save it to where it came from, with the new name.</p>\n  <p>3- If you open random images, and save, you can find them at e.g. ./Documents/Pixlr/yourImage.jpg\"</p>\n  \n  <p class=\"last\">Enjoy! Please clone and make it better :)</p>\n</div>"
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
    return "" + PixlrSettings.src + "/?image=" + PixlrSettings.image + "&title=" + PixlrSettings.imageName + "&target=" + PixlrSettings.targetPath + amp + "meta=" + PixlrSettings.savePath + "&icon=" + PixlrSettings.saveIcon + "&referer=Koding&redirect=false&type=" + PixlrSettings.fileExt;
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
      content: "Pixlr cannot access the little php file it needs \nto be able to save files (./website/PixlrHook/pixlrHook.php)\nYou either deleted it, or made it inaccessible somehow (think .htaccess)\n\nReinstalling Pixlr might fix it, but not guaranteed.\n\nIf you want this be fixed, you should convince someone to continue developing Pixlr.kdapp :)"
    });
  };

  PixlrAppView.prototype.doKiteRequest = function(command, callback) {
    var _this = this;
    return KD.getSingleton('kiteController').run(command, function(err, res) {
      if (!err) {
        if (callback) {
          return callback(res);
        }
      } else {
        if (callback) {
          return callback(res);
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



/* BLOCK STARTS /Source: /Users/fatihacet/Applications/Pixlr.kdapp/index.coffee */


(function() {
  return appView.addSubView(new PixlrAppView);
})();


/* BLOCK ENDS */

/* KDAPP ENDS */

}).call();