
# TODO: add only one footer, and control the content
# TODO: load template only into article tag
# TODO: add msg display to a queue to display one after the other

ETT.ns 'ui'
ETT.ui =
  win: (url) ->
    if ETT.settings.win == null
      ETT.settings.win = ETT.settings.gui.Window.get()
    ETT.settings.win
  inspect: () ->
    win = this.win()
    win.showDevTools()
    true
  show: (cbfunc) ->
    win = this.win()
    cb = cbfunc or ->
      true
    win.show()
    cb()  
  msg: (type, msg, cbfunc) ->
    cb = cbfunc or ->
      true
    if ETT.settings.msg.timeout != null
      clearTimeout ETT.settings.msg.timeout
    if msg == undefined
      msgtmp = type
      type = ETT.settings.msg.alert
      msg = msgtmp
    ETT.settings.$msg.removeClass().html(msg).addClass(type).fadeIn('fast').data('visible','yes')
    ETT.settings.msg.timeout = setTimeout ( -> ETT.settings.$msg.fadeOut('slow', ( -> ETT.settings.$msg.html '' ) ).data('visible','no') ), 2500
    cb()
  footer: (tpl, cbfunc) ->
    cb = cbfunc or ->
      true
    if tpl == 'main'
      ETT.settings.$footer.find('#logo').removeClass()
    else if tpl == 'copydeck'
      ETT.settings.$footer.find('#logo').addClass('back')
    cb()
  switch: (tpl, cbfunc) ->
    cb = cbfunc or ->
      true
    if ETT.settings.current != tpl
      # process footer
      this.footer tpl
      $tplshow = $('.tplshow')
      if $tplshow.length > 0
        $tplshow.removeClass('tplshow')
      ETT.settings.tpls[tpl].addClass('tplshow')
      ETT.settings.current = tpl
    cb()
  load: (tpl, evts, cbfunc) ->
    cb = cbfunc or ->
      true
    # lazyload the tpl
    if !ETT.settings.tpls[tpl]
      # get the template from the json
      tplobj = require ETT.settings.root + "tpl/" + tpl + ".json"
      # create a $ object
      $rndtpl = $(tplobj.tpl)
      # add the class rendered
      $rndtpl.addClass 'rendered'
      # add to the settings templates array
      ETT.settings.tpls[tpl] = $rndtpl
      # add the tpl to the app
      $rndtpl.appendTo ETT.settings.$article
      # bind the events
      this.bind evts
    # show the template
    this.switch tpl
    # callback
    cb()
  bind: (evts, cbfunc) ->
    cb = cbfunc or ->
      true
    # bind the events
    if evts != undefined
      for id, ev of evts
        if id == 'ett-app-generic-func'
          if 'function' == typeof ev
            ev()
        else
          if ev.events
            $items = $(id)
            if ev.events_not
              $items = $items.not(ev.events_not)
            $items.on(ev.events)
          if ev.jwerty
            for keys, func of ev.jwerty
              jwerty.key keys, func, id
          if ev.context and ev.context != []
            ETT.menu.init id, ev.context
    cb()
  debug: () ->
    $insclose = ETT.settings.$inspect.find '#inspect-close'
    $insclose.on({
      click: (e) ->
        e.preventDefault()
        ETT.settings.$inspect.removeClass 'show'
        ETT.settings.$inspectcontainer.html ''
        false
    })
    true
  server: () ->
    http = require 'http'
    ser = http.createServer (req, res) ->
      res.writeHead 200, 'Content-Type':'text/plain'
      res.end 'Hello World\n'
    ser.listen 1337, "127.0.0.1"
    console.log 'Server running at http://127.0.0.1:1337/'
    true
  init: () ->
    self = this
    # setup the items
    ETT.settings.$article = ETT.settings.$app.find '#article'
    ETT.settings.$footer = ETT.settings.$app.find '#footer'
    ETT.settings.$inspect = ETT.settings.$app.find '#inspect'
    ETT.settings.$inspectcontainer = ETT.settings.$inspect.find '#inspect-container'
    ETT.settings.get_db_settings()
    ETT.models.migrate.init()
    #this.debug()
    # process main event
    evts = ETT.events.main
    #this.server()
    this.load('main', evts, () -> 
      self.show())
    true