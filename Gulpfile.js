"use strict";

var gulp = require('gulp')

const fetchAndWrite = require("./node_modules/respec/tools/respecDocWriter.js").fetchAndWrite;

gulp.task('express', function() {
  var express = require('express');
  var app = express();
  app.use(require('connect-livereload')({port: 35729}));
  app.use(express.static(__dirname));
  app.use(express.static(__dirname + "/respec")) ; //Respec dev mode
  app.listen(4000, '0.0.0.0');
});

var tinylr;
gulp.task('livereload', function() {
  tinylr = require('tiny-lr')();
    tinylr.listen(35729);
});

function notifyLiveReload(event) {
  var fileName = require('path').relative(__dirname, event.path);

  console.log("Changed: " + fileName);

  tinylr.changed({
    body: {
      files: [fileName]
    }
  });
}

function notifyEditorsDraft() {
  console.log("Changed: Editor's Draft");

  tinylr.changed({
    body: {
      files: ["EditorsDraft/edit.html"]
    }
  });
}

gulp.task('editorsdraft', function() {
  var fs = require('fs'),
      path = require('path');

  var thisDir = path.dirname(fs.realpathSync(__filename));

  const src = `file://${thisDir}/EditorsDraft/edit.html`;
  console.log(src);
  const out = "./EditorsDraft/index.html";
  const whenToHalt = {
    haltOnError: false,
    haltOnWarn: false,
  };
  const timeout = 30000;

  return fetchAndWrite(src, out, whenToHalt, {timeout})
    .catch(err => {console.error(err.stack);})
    .then(notifyEditorsDraft);
});

gulp.task('watch', function() {
  gulp.watch('EditorsDraft/edit.html', ['editorsdraft']);
});

gulp.task('default', ['editorsdraft', 'express', 'livereload', 'watch'], function() {
});
