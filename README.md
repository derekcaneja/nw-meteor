Node Webkit (nwjs) Meteor
=============

Meteor run inside a nw.js application.

##Usage
```
git clone https://github.com/derekcaneja/nw-meteor.git
cd nw-meteor
./.scripts/build.sh
```

To build with meteor settings run:

`./.scripts/build.sh --settings METEOR_SETTINGS`

<br>

To package the application for release with a standalone meteor server run:

`./.scripts/build.sh --release`

<br>

For help run:

`./.scripts/build.sh --help`

##Debugging

In order to debug using chrome developer tools, you must change `window.toolbar` to true inside package.json.
