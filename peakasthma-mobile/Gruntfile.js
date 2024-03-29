/*jslint node: true */
'use strict';

var pkg = require('./package.json');

//Using exclusion patterns slows down Grunt significantly
//instead of creating a set of patterns like '**/*.js' and '!**/node_modules/**'
//this method is used to create a set of inclusive patterns for all subdirectories
//skipping node_modules, bower_components, www, and any .dirs
//This enables users to create any directory structure they desire.
var createFolderGlobs = function(fileTypePatterns) {
  fileTypePatterns = Array.isArray(fileTypePatterns) ? fileTypePatterns : [fileTypePatterns];
  var ignore = ['node_modules','bower_components','www','temp'];
  var fs = require('fs');
  return fs.readdirSync(process.cwd())
          .map(function(file){
            if (ignore.indexOf(file) !== -1 ||
                file.indexOf('.') === 0 ||
                !fs.lstatSync(file).isDirectory()) {
              return null;
            } else {
              return fileTypePatterns.map(function(pattern) {
                return file + '/**/' + pattern;
              });
            }
          })
          .filter(function(patterns){
            return patterns;
          })
          .concat(fileTypePatterns);
};

module.exports = function (grunt) {
  const sass = require('node-sass');

  // load all grunt tasks
  require('load-grunt-tasks')(grunt);

  // Project configuration.
  grunt.initConfig({
    connect: {
      main: {
        options: {
          port: 9001,
          hostname: '0.0.0.0'
        }
      }
    },
    watch: {
      main: {
        options: {
            livereload: true,
            livereloadOnError: false,
            spawn: false
        },
        files: [createFolderGlobs(['*.js','*.scss','*.html']),'!_SpecRunner.html','!.grunt'],
        tasks: [] //all the tasks are run dynamically during the watch event handler
      }
    },
    jshint: {
      main: {
        options: {
            jshintrc: '.jshintrc'
        },
        src: createFolderGlobs('*.js')
      }
    },
    clean: {
      before:{
        src:['www','temp']
      },
      after: {
        src:['temp']
      }
    },
    sass: {
      production: {
        options: {
          implementation: sass
        },
        files: {
          'temp/app.css': 'src/app.scss'
        }
      }
    },
    ngconstant: {
      main: {
        options: {
          name: 'willowApi',
          dest: 'src/willowApi/config.js',
          deps: false,
          constants: {
            apiConfig: grunt.file.readJSON('configs/' + (grunt.option('env') || 'dev') + '.json')
          }
        }
      }
    },
    ngtemplates: {
      main: {
        options: {
            module: pkg.name,
            htmlmin:'<%= htmlmin.main.options %>'
        },
        src: [createFolderGlobs('*.html'),'!index.html','!_SpecRunner.html'],
        dest: 'temp/templates.js'
      }
    },
    copy: {
      main: {
        files: [
          {src: ['assets/**'], dest: 'www/', expand: true},
          {src: ['bower_components/font-awesome/fonts/**'], dest: 'www/',filter:'isFile',expand:true},
          {src: ['bower_components/bootstrap/fonts/**'], dest: 'www/',filter:'isFile',expand:true}
        ]
      }
    },
    dom_munger:{
      read: {
        options: {
          read:[
            {selector:'script[data-concat!="false"]',attribute:'src',writeto:'appjs'},
            {selector:'link[rel="stylesheet"][data-concat!="false"]',attribute:'href',writeto:'appcss'}
          ]
        },
        src: 'index.html'
      },
      update: {
        options: {
          remove: ['script[data-remove!="false"]','link[data-remove!="false"]'],
          append: [
            {selector:'body',html:'<script src="app.full.min.js"></script>'},
            {selector:'head',html:'<link rel="stylesheet" href="app.full.min.css">'}
          ]
        },
        src:'index.html',
        dest: 'www/index.html'
      }
    },
    cssmin: {
      main: {
        src:['temp/app.css','<%= dom_munger.data.appcss %>'],
        dest:'www/app.full.min.css'
      }
    },
    concat: {
      main: {
        src: ['<%= dom_munger.data.appjs %>','<%= ngtemplates.main.dest %>'],
        dest: 'temp/app.full.js'
      }
    },
    ngAnnotate: {
      main: {
        src:'temp/app.full.js',
        dest: 'temp/app.full.js'
      }
    },
    browserify: {
      dist: {
        files: {
          // destination for transpiled js : source js
          'temp/app.full.js': 'temp/app.full.js'
        },
        options: {
          transform: [
            ['babelify', {
              presets: ["@babel/preset-env"]
            }]
          ],
          browserifyOptions: {
            debug: true
          }
        }
      }
    },
    uglify: {
      main: {
        src: 'temp/app.full.js',
        dest:'www/app.full.min.js'
      }
    },
    htmlmin: {
      main: {
        options: {
          collapseBooleanAttributes: true,
          collapseWhitespace: true,
          removeAttributeQuotes: true,
          removeComments: true,
          removeEmptyAttributes: true,
          removeScriptTypeAttributes: true,
          removeStyleLinkTypeAttributes: true
        },
        files: {
          'www/index.html': 'www/index.html'
        }
      }
    },
    //Imagemin has issues on Windows.  
    //To enable imagemin:
    // - "npm install grunt-contrib-imagemin"
    // - Comment in this section
    // - Add the "imagemin" task after the "htmlmin" task in the build task alias
    // imagemin: {
    //   main:{
    //     files: [{
    //       expand: true, cwd:'www/',
    //       src:['**/{*.png,*.jpg}'],
    //       dest: 'www/'
    //     }]
    //   }
    // },
    karma: {
      options: {
        frameworks: ['jasmine'],
        files: [  //this files data is also updated in the watch handler, if updated change there too
          '<%= dom_munger.data.appjs %>',
          '<%= ngtemplates.main.dest %>',
          'bower_components/angular-mocks/angular-mocks.js',
          createFolderGlobs('*-spec.js'),
          './node_modules/phantomjs-polyfill/bind-polyfill.js'
        ],
        logLevel:'ERROR',
        reporters:['mocha','progress','coverage'],
        autoWatch: false, //watching is handled by grunt-contrib-watch
        singleRun: true,
        preprocessors: {
          'src/**/!(*-spec).js': ['coverage']
        },
        coverageReporter: {        
          dir: './coverage/',
          reporters: [
            { type: 'html', subdir: 'report-html' }
          ]
        }
      },
      all_tests: {
        browsers: ['PhantomJS']
      },
      during_watch: {
        browsers: ['PhantomJS']
      },
    }
  });

  grunt.registerTask('build', ['clean:before', 'ngconstant', 'sass', 'dom_munger', 'ngtemplates', 'cssmin', 'concat', 'ngAnnotate', 'uglify', 'copy', 'htmlmin', 'clean:after']);
  // grunt.registerTask('build', ['clean:before', 'ngconstant', 'sass', 'dom_munger', 'ngtemplates', 'cssmin', 'concat', 'ngAnnotate', 'browserify:dist', 'uglify', 'copy', 'htmlmin', 'clean:after']);
  grunt.registerTask('serve', ['dom_munger:read', 'ngconstant', 'sass', 'cssmin', 'connect', 'watch']);
  grunt.registerTask('test',['dom_munger:read', 'ngtemplates', 'ngconstant','karma:all_tests']);

  grunt.event.on('watch', function(action, filepath) {
    //https://github.com/gruntjs/grunt-contrib-watch/issues/156

    var tasksToRun = [];

    if (filepath.lastIndexOf('.scss') !== -1 && filepath.lastIndexOf('.scss') === filepath.length - 5) {
      tasksToRun.push('sass', 'cssmin');
    }

    if (filepath.lastIndexOf('.js') !== -1 && filepath.lastIndexOf('.js') === filepath.length - 3) {

      //lint the changed js file
      grunt.config('jshint.main.src', filepath);
      tasksToRun.push('jshint');

      //find the appropriate unit test for the changed file
      var spec = filepath;
      if (filepath.lastIndexOf('-spec.js') === -1 || filepath.lastIndexOf('-spec.js') !== filepath.length - 8) {
        spec = filepath.substring(0,filepath.length - 3) + '-spec.js';
      }

      //if the spec exists then lets run it
      if (grunt.file.exists(spec)) {
        var files = [].concat(grunt.config('dom_munger.data.appjs'));
        files.push('bower_components/angular-mocks/angular-mocks.js');
        files.push(spec);
        grunt.config('karma.options.files', files);
        tasksToRun.push('karma:during_watch');
      }
    }

    //if index.html changed, we need to reread the <script> tags so our next run of karma
    //will have the correct environment
    if (filepath.lastIndexOf('.html') !== -1 && filepath.lastIndexOf('.html') === filepath.length - 5) {
      tasksToRun.push('build');
    }

    grunt.config('watch.main.tasks',tasksToRun);

  });
};
