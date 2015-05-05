module.exports = function(grunt) {

    grunt.initConfig({
        // Package
        pkg: grunt.file.readJSON("package.json"),
        // CoffeeScript
        coffee: {
            compile: {
                files: {
                    "includes/js/jquery.colormatrix.js": "includes/coffee/jquery.colormatrix.coffee",
                    "includes/js/functions.js": "includes/coffee/functions.coffee",
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
                    "includes/js/functions.min.js": "includes/js/functions.js",
                    "includes/js/jquery.colormatrix.min.js": "includes/js/jquery.colormatrix.js"
                }
            }
        },
        // LESS
        less: {
            development: {
                files: {
                    "includes/css/jquery.colormatrix.css": "includes/less/jquery.colormatrix.less"
                },
                options: {
                    compress: false,
                    yuicompress: false,
                    cleancss: true,
                    optimization: 1,
                    sourceMap: true
                }
            }
        },
        // Watch
        watch: {
            scripts: {
                files: ["includes/coffee/*.coffee"],
                tasks: ["coffee", "uglify"]
            },
            styles: {
                files: ["includes/less/**/*.less"],
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

    // grunt.registerTask("default", ["coffee", "uglify", "less"]);
    grunt.registerTask("default", ["coffee", "uglify", "less", "watch"]);

}
