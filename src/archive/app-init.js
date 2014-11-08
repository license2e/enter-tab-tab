var App = App || {
  ns: function (namespaces) {
		var names = namespaces.split('.'), len, ns = App, i;
		if (names[0].toUpperCase() == 'App') {
			names.splice(0,1);
		}
		len = names.length;
		for (i = 0; i < len; i++) {
			( !ns[names[i]] && (ns[names[i]] = {}) );
			ns = ns[names[i]];
		}
	},
};
/* -------------------------------------------------- */
App.ns("ui");
App.ui = {
  gui: require('nw.gui')
  , win: function(url){
    var self = this;
    
    return self.gui.Window.get();
  }
  , show: function(cbfunc){
    var self = this
      , win = self.win()
      , cb = cbfunc || function(){ return true; }
    win.show();
    cb();
  }
  , init: function(cbfunc){
    var self = this
      , cb = cbfunc || function(){ return true; }
    self.show();
    cb();
  }
}