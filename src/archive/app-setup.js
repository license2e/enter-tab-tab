(function(window) {
  
  var start = (new Date()).getTime()
    , fs = require("fs")
    , head = window.document.querySelector("head")
    , body = window.document.querySelector("body")
    , localhome = ""
    , localcore = ""
    , appcore = "./app/"
    , appinit = ""
    , appversion = null
    , localversion = null
    , root = ""
    , version = null
    , current = false
    , isFile = false;
  
  process.on("uncaughtException", uncaughtError);
  window.onerror = uncaughtError;
  
  function uncaughtError(e) {
    console.log("### EXCEPTION: " + e);
    console.log(e.stack);
  }
  
  function appendScript(path, isFile) {
    script = document.createElement('script');
    script.type = 'text/javascript';
    script.async = false;
    if(isFile) {
      path = "file://" + path;
    }
    script.src = path;
    body.appendChild(script);
    return script;
  }
  
  function appendCss(path, isFile) {
    css = document.createElement('link');
    css.type = 'text/css';
    if(isFile) {
      path = "file://" + path;
    }
    css.rel = "stylesheet";
    css.href = path;
    head.appendChild(css);
    return css;
  }
  
  function ext(path) {
    var i = path.lastIndexOf(".");
    var ext = path.substring(i+1);
    return ext;
  }
  
  function hasExt(path, exts) {
    var e = ext(path);
    for(var i in exts) {
      if ( e == exts[i] ) return true;
    }
    return false;
  }
  
  try {
    
    if (process.env.ETTHOME) {
      localhome = process.env.ETTHOME;
    } else if (process.platform == "win32") {
      localhome = process.env.USERPROFILE;
    } else {
      localhome = process.env.HOME;
    }
    
    localcore = localhome + "/.entertabtab/";
    //localversion = require(localcore + "app-version.json");
    appversion = require(appcore + "app-version.json");
  
    if(current) {
      root = localcore;
      isFile = true;
    } else {
      root = appcore;
      isFile = false;
    }
    
    appinit = root + "app-init.js";
  
    /* * /
    if(process.env.LOCAL) {
      root = process.env.LOCAL;
      isFile = true;
      current = false;
    }
    /* */
    
    if(fs.existsSync(appinit)) {
      var script = appendScript(appinit, isFile);
      script.onload = function() {
        try {
          App.ui.init();
        } catch (e) {
          uncaughtError(e);
        }
      }
    }
    
    window.setup = {
      version: appversion.setup
      , startTime: start
      , current: current
      , localhome: localhome
      , root: root
      , uncaughtError: uncaughtError
    };
    
    console.log('WINDOW.SETUP root:' + window.setup.root);
    
  } catch (e) {
    uncaughtError(e);
  }
  
})(window);