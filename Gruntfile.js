module.exports = function(grunt) {

    grunt.initConfig({
        // Package
        pkg: grunt.file.readJSON("package.json"),
        // CoffeeScript
        coffee: {
            compile: {
                files: {
                    "dist/js/jquery.colormatrix.js": "source/coffee/jquery.colormatrix.coffee",
                    "dist/js/functions.js": "source/coffee/functions.coffee",
                },
                options: {
                    bare: true
                }
            }
        },
        // Minify Javascript
        uglify: {
            my_target: {
                files: {
                    "dist/js/functions.min.js": "dist/js/functions.js",
                    "dist/js/jquery.colormatrix.min.js": "dist/js/jquery.colormatrix.js"
                }
            }
        },
        // LESS
        less: {
            development: {
                files: {
                    "dist/css/jquery.colormatrix.css": "source/less/jquery.colormatrix.less"
                },
                options: {
                    compress: false,
                    yuicompress: false,
                    cleancss: true,
                    optimization: 1,
                    sourceMap: true,
                    sourceMapURL: "jquery.colormatrix.css.map"
                }
            }
        },
        // Watch
        watch: {
            scripts: {
                files: ["source/coffee/*.coffee"],
                tasks: ["coffee", "uglify"]
            },
            styles: {
                files: ["source/less/**/*.less"],
                tasks: ["less"],
                options: {
                    nospawn: true
                }
            }
        }
    });

    grunt.loadNpmTasks("grunt-contrib-coffee");
    grunt.loadNpmTasks("grunt-contrib-uglify");
    grunt.loadNpmTasks("grunt-contrib-less");
    grunt.loadNpmTasks("grunt-contrib-watch");

    grunt.registerTask("default", ["coffee", "uglify", "less", "watch"]);

}
