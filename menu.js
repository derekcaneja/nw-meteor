var gui = require('nw.gui');

var Window = gui.Window.get();

function createMenu () {
  var separator = new gui.MenuItem({ type: 'separator' });

  var menuItem = new gui.MenuItem({
    label: 'Preferences...',
    click: function() {
      alert('Preferences');
    }
  });

  // Setup Menu
  var nativeMenuBar = new gui.Menu({ type: 'menubar' });

  nativeMenuBar.createMacBuiltin("nw-meteor");

  nativeMenuBar.items[0].submenu.insert(menuItem, 2);
  nativeMenuBar.items[0].submenu.insert(separator, 3);

  Window.menu = nativeMenuBar;
}
