ETT.ns 'events'
ETT.events =
  main:
    'ett-app-generic-func': (cbfunc) ->
      cb = cbfunc or () ->
        true
      
      $project_copydecks_content = $ '#project-copydecks-content'
      $project_copydecks_group_items = $ '<div id="project-copydecks-group-items"></div>'
      $project_copydecks_group_items.append $project_copydecks_content.children()
      $project_copydecks_content.append $project_copydecks_group_items
      $project_copydecks_content
        .css({overflow:'hidden'})
        .scrollable({items:'#project-copydecks-group-items',item:'.project-copydecks-group',touch:false})
        .navigator({navi:'#project-copydecks-navigation'})
      cb()
    'li#sample a':
      events:
        'click.sample': (e) ->
          e.preventDefault()
          $this = $(this)
          # load copydeck tpl
          ETT.ui.load 'copydeck', ETT.events.copydeck, () ->
            ETT.copydeck.load 'sample'
          false
    'li#add-project a':
      events:
        'click.add-project': (e) ->
          e.preventDefault()
          $this = $(this)
          $container = $ '#project-folders-container'
          $last_group = $container.find('.project-folders-group').last()
          $folders = $last_group.find('.project-folders')
          if $folders.length < 4
            # get the next project id
            # focus and select the new project name
            #$last_group 
          else
            #$next = $ '<div class="project-folders-group"></div>'
            
          console.log 'do something'
          false
    '#logo':
      events:
        'click.logo': (e) ->
          e.preventDefault()
          ETT.ui.load 'main'
          false
    '#inspect-code a':
      events:
        'click.inspect-code': (e) ->
          e.preventDefault()
          ETT.ui.inspect()
          false
  copydeck_postload:    
    '.copydeck-entries':
      events_not: '#copydeck-entry'
      events:
        'focus.copydeck-entries': (e) ->
          ETT.copydeck.add_resize this
          true
        'blur.copydeck-entries': (e) ->
          ETT.copydeck.remove_resize this
          if !(jwerty.is 'enter', e) and !(jwerty.is 'tab', e)
            $this = $ this
            key = $this.prop 'id'
            entry = ETT.models.entries.find key
            if null != entry
              html = $this.html()
              revision = 1 + entry.get('revision')
              data = 
                value: html
                revision: revision
              entry.set data
            else
              console.log 'couldnt save anything for: ' + key
  copydeck:
    '#copydeck-collection-name':
      events:
        'blur.copydeck-collection-name': (e) ->
          e.preventDefault()
          $this = $(this)
          $('#copydeck-entry').focus()
          false
    '#copydeck-entry':
      events: 
        'focus.copydeck-entry': (e) ->
          ETT.copydeck.add_resize this
          true
        'blur.copydeck-entry': (e) ->
          ETT.copydeck.remove_resize this
          true