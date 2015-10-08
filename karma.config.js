'use strict';

var webpack = require('webpack');

module.exports = function (config) {
    config.set({

        // base path that will be used to resolve all patterns (eg. files, exclude)
        //basePath: __dirname,


        // frameworks to use
        // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
        frameworks: ['jasmine'],


        // list of files / patterns to load in the browser
        files: [
            'node_modules/jquery/dist/jquery.js',
            'node_modules/jasmine-expect/dist/jasmine-matchers.js',
            'app/all-tests.es6'
        ],


        // list of files to exclude
        exclude: [],


        // preprocess matching files before serving them to the browser
        // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
        preprocessors: {
            'app/all-tests.es6' : ['webpack', 'sourcemap']
        },

        webpack: {
            devtool: 'eval-source-map',
            module: {
                preLoaders : [
                    {
                        test: /\.es6$/,
                        exclude: /node_modules/,
                        loader: "eslint-loader"
                    }
                ],
                loaders: [
                    {
                        test: /\.es6$/,
                        loader: "babel-loader"
                    },
                    {
                        test: /\.html$/,
                        loader: "html-loader"
                    }
                ]
            },
            plugins: [
                new webpack.ProvidePlugin({
                    "window.jQuery": "jquery"
                })
            ],
            eslint: {
                configFile: './.eslintrc'
            },
            resolve: {
                extensions: ['', '.js', '.es6']
            }
        },

        // test results reporter to use
        // possible values: 'dots', 'progress'
        // available reporters: https://npmjs.org/browse/keyword/karma-reporter
        reporters: ['spec'],


        // web server port
        port: 9876,


        // enable / disable colors in the output (reporters and logs)
        colors: true,


        // level of logging
        // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        logLevel: config.LOG_INFO,


        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: true,


        // start these browsers
        // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
        browsers: ['PhantomJS'],


        // Continuous Integration mode
        // if true, Karma captures browsers, runs the tests and exits
        singleRun: true
    });
};
