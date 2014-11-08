setup = (window) ->
  start = (new Date()).getTime()
  fs = require "fs"
  crypto = require "crypto"
  head = window.document.querySelector("head")
  body = window.document.querySelector("body")
  appdom = window.document.querySelector("#app")
  appcore = "./app/"
  appload = ""
  appversion = null
  localhome = ""
  localcore = ""
  localversion = null
  root = ""
  version = null
  current = false
  localFile = false

  uncaughtException = (e) ->
    console.log "### EXCEPTION: " + e
    console.log e.stack
    true
  process.on "uncaughtException", uncaughtException
  window.onerror = uncaughtException

  addJavaScript = (path, localFile, cbfunc) ->
    cb = cbfunc or () ->
      true
    () ->
      jscontents = fs.readFileSync path, encoding:'utf8'
      if path.indexOf('enc') != -1
        decipher = crypto.createDecipher ette.algorithm, ette.password
        out = decipher.update jscontents, 'base64', 'utf8'
        out = out + decipher.final 'utf8'
      else
        out = jscontents
      script = document.createElement("script")
      script.type = "text/javascript"
      script.innerHTML = out
      body.appendChild script
      cb()
  addCSSFile = (path, localFile, cbfunc) ->
    cb = cbfunc or () ->
      true
    (cbfunc2) ->
      cb2 = cbfunc2 or () ->
        true
      path = "file://" + path  if localFile
      csscontents = fs.readFileSync path, encoding:'utf8'
      css = document.createElement("style")
      css.innerHTML = csscontents
      head.appendChild css
      cb(cb2)
  ext = (path) ->
    i = path.lastIndexOf(".")
    ext = path.substring(i + 1)
    ext
  hasExt = (path, exts) ->
    e = ext(path)
    for i of exts
      return true  if e is exts[i]
    false
  try
    if process.env.ETTHOME
      localhome = process.env.ETTHOME
    else if process.platform is "win32"
      localhome = process.env.USERPROFILE
    else
      localhome = process.env.HOME
    localcore = localhome + "/.entertabtab/"

    appversion = require(appcore + "js/app-version.json")
    if current
      root = localcore
      localFile = true
    else
      root = appcore
      localFile = false

    appload = require root + "js/app-lazyload.json"

    if appload
      scriptLoad = () ->
        ETT.settings.head = head
        ETT.settings.body = body
        ETT.settings.appdom = appdom
        ETT.settings.$app = jQuery(app)
        ETT.settings.root = root
        ETT.settings.$msg = $('#msg')
        ETT.settings.version = appversion.setup
        ETT.ui.init()
        true
      cssLoad = (cbfunc) -> 
        cb = cbfunc or () ->
          true
        cb()
      if appload.js && appload.js != [] && appload.js.length > 0
        appload.js.reverse()
        for j in appload.js
          scriptLoad = addJavaScript j, localFile, scriptLoad     
      if appload.css && appload.css != [] && appload.css.length > 0
        appload.css.reverse()
        for c in appload.css
          cssLoad = addCSSFile c, localFile, cssLoad
      if typeof scriptLoad == "function"
        cssLoad () ->
          setTimeout scriptLoad, 500
          true
      else
        cssLoad()

    window.setup =
      version: appversion.setup
      startTime: start
      current: current
      localhome: localhome
      root: root
      uncaughtException: uncaughtException

    #console.log "WINDOW.SETUP root:" + window.setup.root
    true
  catch e
    uncaughtException e
ette =
  "algorithm":"aes-256-cbc"
  "password":"√∞¨≠¢§¶•∞§∞£≤˜˜≥£®´ß∂ƒ∆©˚¡•¡¬ JUST because I canT do this mys3lf"
get_ette = () ->
  ette