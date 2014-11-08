ETT.ns 'menu'
ETT.menu = 
  _items: 
    'copy': 
      name: 'Copy'
      icon: 'copy'
      disabled: null
      callback: () ->
        ETT.menu.enable this, 'paste'
        false
    'paste':
      name: 'Paste'
      icon: 'paste'
      disabled: null
      callback: () ->
        ETT.menu.disable this, 'paste'
        false
    'cut':
      name: 'Cut'
      icon: 'cut'
      disabled: null
  enable: (obj, key) ->
    obj.data key + 'Disabled', false
  disable: (obj, key) ->
    obj.data key + 'Disabled', true
  items: (sel, opts) -> 
    _items = {}
    if opts
      for x in opts
        if this._items[x]
          _items[x] = this._items[x]
    else
      _items = this._items
    for y in _items
      console.log y
      _items[y].disabled = (key, opts) ->
        !this.data key + 'Disabled'
    if _items['paste']
      this.disable $(sel), 'paste'
    console.log _items
    # return _items
    _items
  init: (sel, opts) ->
    _items = this.items(sel, opts)
    console.log _items
    $.contextMenu selector:sel, items:_items, callback: (key, opts) ->
      false
    
