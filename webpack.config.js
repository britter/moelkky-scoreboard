/*
 * Copyright 2015 Benedikt Ritter
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
module.exports = {
    context: __dirname + "/app",
    entry: "./index.es6",
    output: {
        path: __dirname + "/dist",
        filename: "bundle.js",
        publicPath: '/dist/'
    },
    resolve: {
        extensions: ['', '.js', '.es6']
    },
    module: {
        preLoaders: [
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
    eslint: {
        configFile: './.eslintrc'
    },
    devtool: 'source-map'
};
