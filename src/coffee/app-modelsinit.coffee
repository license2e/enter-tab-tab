ETT.ns 'models.projects'
ETT.models.projects = ETT.models.extend()
ETT.models.projects.init = () ->
  this.add_columns name: null, copydecks: {}
  this.type = 'projects'
  true
ETT.models.projects.add_copydeck = (data) ->
  copydeck = ETT.models.copydecks.find_or_create data
  copydeck_key = copydeck.get 'key'
  copydecks = this.get 'copydecks'
  copydecks[copydeck_key] = active:true, name:copydeck.get 'name'
  this.set copydecks:copydecks
  this.save()
  copydeck
  
ETT.ns 'models.copydecks'
ETT.models.copydecks = ETT.models.extend()
ETT.models.copydecks.init = () ->
  this.add_columns name: null, categories: {}, entries: {}
  this.type = 'copydecks'
  true
ETT.models.copydecks.add_category = (data) ->
  category = ETT.models.categories.find_or_create data
  category_key = category.get 'key'
  categories = this.get 'categories'
  categories[category_key] = active:true
  this.set categories:categories
  this.save()
  category_key
ETT.models.copydecks.add_entry = (data) ->
  if data.hasOwnProperty 'revision'
    data['revision'] = 1
  entry = ETT.models.entries.find_or_create data
  entry_key = entry.get 'key'
  entries = this.get 'entries'
  entries[entry_key] = active:true, revision:entry.get('revision')
  this.set entries:entries
  this.save()
  entry_key

ETT.ns 'models.categories'
ETT.models.categories = ETT.models.extend()
ETT.models.categories.init = () ->
  this.add_columns category: null, name: null
  this.type = 'categories'
  true

ETT.ns 'models.entries'
ETT.models.entries = ETT.models.extend()
ETT.models.entries.init = () ->
  this.add_columns category: null, value: null, revision: null
  this.type = 'entries'
  true
  
ETT.ns 'models.entry_archive'
ETT.models.entry_archive = ETT.models.extend()
ETT.models.entry_archive.init = () ->
  this.add_columns revisions:{}
  this.type = 'entry_archive'
  true