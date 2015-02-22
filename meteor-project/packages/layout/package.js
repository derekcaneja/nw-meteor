Package.describe({
  summary: 'Layout templates.'
});

Package.onUse(function (api) {
  api.use([
    'templating'
  ], 'web');

  api.addFiles([
    'head.html',
    'layout.html'
  ], 'web');
});
