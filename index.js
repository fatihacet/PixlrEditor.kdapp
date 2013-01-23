// Compiled by Koding Servers at Tue Jan 22 2013 06:36:38 GMT-0800 (PST) in server time

(function() {

/* KDAPP STARTS */

/* BLOCK STARTS /Source: /Users/fatihacet/Applications/Pixlr.kdapp/index.coffee */

var Pixlr, PixlrSettings, nickname,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

KD.enableLogs();

nickname = KD.whoami().profile.nickname;

PixlrSettings = {
  src: "https://pixlr.com/editor",
  image: "https://dl.dropbox.com/u/31049236/nat-geo.jpeg",
  saveIcon: "https://dl.dropbox.com/u/31049236/koding16.png",
  targetPath: "https://fatihacet.koding.com/responses.php"
};

Pixlr = (function(_super) {

  __extends(Pixlr, _super);

  function Pixlr(options) {
    if (options == null) {
      options = {};
    }
    options.cssClass = "pixlr-container";
    Pixlr.__super__.constructor.call(this, options);
    this.container = new KDView;
    this.init();
  }

  Pixlr.prototype.init = function() {
    var _this = this;
    this.container.setPartial(this.buildIframe());
    return KD.getSingleton("windowController").registerListener({
      KDEventTypes: "DragExitOnWindow",
      listener: this,
      callback: function(pubInst, event) {
        var image, path, timestamp;
        timestamp = +new Date();
        path = "/Users/fatihacet/Applications/WordPress.kdapp/resources/scr.2.png";
        image = "/Users/" + nickname + "/Sites/" + nickname + ".koding.com/website/" + timestamp;
        return _this.doKiteRequest("cp " + path + " " + image, function() {
          _this.image = "http://" + nickname + ".koding.com/" + timestamp;
          _this.refreshIframe();
          return KD.utils.wait(6000, function() {
            return _this.doKiteRequest("rm " + image);
          });
        });
      }
    });
  };

  Pixlr.prototype.buildIframe = function() {
    return "<iframe id=\"pixlr\" type=\"text/html\" width=\"100%\" height=\"100%\" frameborder=\"0\" \n        src=\"" + PixlrSettings.src + "/?image=" + PixlrSettings.image + "&target=" + PixlrSettings.targetPath + "&icon=" + PixlrSettings.saveIcon + "&referer=Koding&redirect=false\"\n></iframe>";
  };

  Pixlr.prototype.refreshIframe = function() {
    return this.container.updatePartial(this.buildIframe());
  };

  Pixlr.prototype.doKiteRequest = function(command, callback) {
    var _this = this;
    return KD.getSingleton('kiteController').run(command, function(err, res) {
      if (!err) {
        if (callback) {
          return callback(res);
        }
      } else {
        return new KDNotificationView({
          title: "An error occured while processing your request, try again please!",
          type: "mini",
          duration: 3000
        });
      }
    });
  };

  Pixlr.prototype.pistachio = function() {
    return "{{> this.container}}";
  };

  return Pixlr;

})(JView);

(function() {
  return appView.addSubView(new Pixlr);
})();


/* BLOCK ENDS */

/* KDAPP ENDS */

}).call();