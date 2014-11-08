ETT.ns 'copydeck'
ETT.copydeck = 
  _entry_container: null
  _entry_wrap: null
  _entry_categories_container: null
  _entry_categories: null
  _copydeck: null
  _adjust_height_delete: 16
  _adjust_height: 9
  get_copydeck: (key, proj) ->
    if null == this._copydeck
      $('#copydeck-copydeck-key').val key
      this._copydeck = ETT.models.copydecks.find key
    this._copydeck
  get_entry_container: () ->
    if null == this._entry_container
      this._entry_container = $ '#copydeck-entries'
    this._entry_container
  get_entry_wrap: () ->
    if null == this._entry_wrap
      $container = this.get_entry_container()
      this._entry_wrap = $container.find '#copydeck-entry-wrap'
    this._entry_wrap
  get_entry_categories_container: () ->
    if null == this._entry_categories_container
      this._entry_categories_container = $ '#entry-categories-container'
    this._entry_categories_container
  get_entry_categories: () ->
    if null == this._entry_categories
      this._entry_categories = $ '#entry-categories'
    this._entry_categories
  load: (copydeck_key, project_key) ->
    this.clear_entries()
    copydeck = this.get_copydeck copydeck_key, project_key
    copydeck_name = copydeck.get 'name'
    # load the categories
    this.load_categories()
    # load the entries
    this.load_entries()
    # bind the post events
    ETT.ui.bind ETT.events.copydeck_postload
    # if copydeck name is empty, then focus on that
    if null == copydeck_name
      $('#copydeck-copydeck-name').focus()
    else
      $('#copydeck-copydeck-name').html copydeck_name
      $('#copydeck-entry').focus()
      top = $('#copydeck-section').height()+170
      $(ETT.settings.body).scrollTop top
    true
  load_entries: (cbfunc) ->    
    cb = cbfunc or () ->
      true
    copydeck = this.get_copydeck()
    copydeck_entries = copydeck.get 'entries'
    for key, obj of copydeck_entries
      entry = ETT.models.entries.find key
      entry_value = entry.get 'value'
      entry_category = entry.get 'category'
      category = ETT.models.categories.find entry_category
      category_name = category.get 'name'
      this.display_entry key, entry_value, category_name
    cb()
  load_categories: (cbfunc) ->    
    cb = cbfunc or () ->
      true
    copydeck = this.get_copydeck()
    $categories = this.get_entry_categories()
    $categories.html ''
    copydeck_categories = copydeck.get 'categories'
    copydeck_categories_length = copydeck_categories.length
    ct = 0
    console.log copydeck_categories_length
    for key, cat of copydeck_categories
      category = ETT.models.categories.find key
      name = category.get 'name'
      cls = ''
      if ct < (copydeck_categories_length - 1)
        cls = 'last'
      $categories.append '<li class="'+cls+'"><a id="category-key" href="#category-'+key+'">'+name+'</a></li>'
      ct++
    cb()
  clear_entries: (cbfunc) ->    
    cb = cbfunc or () ->
      true
    $container = this.get_entry_container()
    $container.find('.copydeck-entries-wrap').not('#copydeck-entry-wrap').remove()
    cb()
  display_entry: (key, html, category, cbfunc) ->    
    cb = cbfunc or () ->
      true
    $wrap = this.get_entry_wrap()
    # add a new entry to type in, with smart content tag (base on AI)
    $wrap.before '<div class="copydeck-entries-wrap"><textarea id="'+key+'" class="copydeck-entries">'+html+'</textarea><div class="copydeck-entry-category">'+category+'</div></div>'
    cb()
  textarea_desize: (e,ele) ->
    ###
    if e.keyCode == 8
      $temp = $ '#temp-debug'
      if $temp.length < 1
        $temp = $ '<div id="temp-debug"></div>'
      $body = $ document.body
      $ele = $ ele
      ele_html = $ele.val()
      $temp.css position:'absolute',top:'110px',left:'110px'
      $body.append $temp
      $temp.html ele_html.replace /\n/g,'<br />'
      ele.style.height = ($temp.outerHeight() + this._adjust_height_delete) + 'px'
      $temp.remove()
    ###
    if e.keyCode == 8
      ele.style.height = 0
      ETT.copydeck.textarea_resize e,ele
    true
  textarea_resize: (e,ele) ->
    #ele.style.height = 'auto'
    ele.style.height = (ele.scrollHeight - this._adjust_height)+'px'
    true
  textarea_resize_delayed: (e,ele) ->
    delayed = window.setTimeout -> 
      ETT.copydeck.textarea_resize e,ele
    , 0
    true
  add_resize: (ele) ->
    $this = $(ele)
    $this.on {
      'change.resize': (e) -> ETT.copydeck.textarea_resize e,ele
      'cut.resize': (e) -> ETT.copydeck.textarea_resize_delayed e,ele
      'paste.resize': (e) -> ETT.copydeck.textarea_resize_delayed e,ele
      'drop.resize': (e) -> ETT.copydeck.textarea_resize_delayed e,ele
      'keydown.resize': (e) -> ETT.copydeck.textarea_resize_delayed e,ele
      'keyup.resize': (e) -> ETT.copydeck.textarea_desize e,ele
    }
    true
  remove_resize: (ele) ->
    $this = $(ele)
    $this.off 'change.resize cut.resize paste.resize drop.resize keydown.resize keyup.resize'
    true