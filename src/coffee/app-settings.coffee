ETT.ns 'settings'
ETT.settings = 
  version: null
  gui: require 'nw.gui'
  win: null
  head: null
  body: null
  appdom: null
  root: null
  tpls: {}
  current: null
  msg: 
    alert: 'alert', error: 'error', success: 'success', timeout: null
  $app: null
  $msg: null
  $article: null
  $footer: null
  $inspect: null
  $inspectcontainer: null
  db_model: null
  db: {}
  save_db_settings: () ->
    APP.settings.db_model.set values:APP.settings.db
    true
  get_db_settings: () ->    
    ETT.settings.db_model = ETT.models.settings.find_or_create 'default', values:
      sample_created: false
      sample_deleted: false
    ETT.settings.db = ETT.settings.db_model.get 'values'
    true
  set_db_setting: (key, value) ->
    this.get_db_settings()
    APP.settings.db[key] = value
    this.save_db_settings()
    true