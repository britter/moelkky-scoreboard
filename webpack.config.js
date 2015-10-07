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
