ETT.ns 'storage'
ETT.storage = 
  find: (key, cbfunc) ->
    cb = cbfunc or (data) ->
      data
    # return the storage
    this.orm.getObject key, cb
  save: (key, data, cbfunc) ->
    cb = cbfunc or (data) ->
      data
    # save to the storage
    this.orm.setObject key, data, cb
  destroy: (key,cbfunc) ->
    cb = cbfunc or (data) ->
      data
    # save to the storage
    this.orm.destroyObject key, cb

#-----------------------------
# ORM
#-----------------------------
ETT.ns 'storage.orm'
ETT.storage.orm = 
  destroyObject: (key, cbfunc) ->
    cb = cbfunc or (data) ->
      data
    localStorage.removeItem(key)
    cb(true)
  # key should be a string for you to get happy results
  setObject: (key, object, cbfunc) ->
    cb = cbfunc or (data) ->
      data
    localStorage.setItem key, JSON.stringify(object)
    cb(object)
  # here, the key is also an object
  setObjectKey: (key_object, object, cbfunc) ->
    cb = cbfunc or (data) ->
      data
    localStorage.setItem JSON.stringify key_object, JSON.stringify object
    cb(object)
  # again, key must be string
  getObject: (key, cbfunc) ->
    cb = cbfunc or (data) ->
      data
    item = localStorage.getItem key
    cb(item and JSON.parse item)
  # key can/should be an object
  getObjectKey: (key_object, cbfunc) ->
    cb = cbfunc or (data) ->
      data
    item = localStorage.getItem JSON.stringify key_object
    cb(item and JSON.parse item)
  generate_key: (len) ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz"
    string_length = len || 10
    randomstring = ''
    string_length++
    while string_length -= 1
      rnum = Math.floor Math.random() * chars.length
      randomstring += chars.substring rnum, rnum+1
    randomstring