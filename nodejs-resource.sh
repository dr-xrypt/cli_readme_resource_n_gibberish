#NODEJS ON LINUX

#IMPLEMENTING NODEJS
sudo yum -y install nodejs
sudo yum -y install npm

sudo apt -y install nodejs
sudo apt -y install npm


npm init -y

#Create full react project 
npx create-react-app <appname>
npm install --save-dev web-vitals
npm start

#Create vite react project 
npm create vite@latest

#Create webpack react project 
mkdir newapp && cd newapp
npm install react react-dom
npm install react-router-dom
Npm i -D --save-dev webpack webpack-dev-server webpack-cli babel-loader @babel/core @babel/preset-env @babel/preset-react html-webpack-plugin css-loader style-loader file-loader clean-webpack-plugin
mkdir src public
touch src/index.js src/App.jsx public/index.html webpack.config.js .babelrc

create and edit .babelrc in newapp directory
# add this to the file
'
{
  "presets": ["@babel/preset-env", "@babel/preset-react"]
}
'

create and edit webpack.config.js
# add this to the file
"
const webpack = require('webpack');
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

const config = {
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'front', 'dist'),
    filename: 'bundle.js',
    publicPath: '/'
  },
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    static: path.resolve(__dirname, 'dist'),
    historyApiFallback: true,
    open: true,
    hot: true,
    port: 3000
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: 'babel-loader'
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.(png|jpg|jpeg|gif|svg)$/,
        type: 'asset/resource'
      }
    ]
  },
  plugins: [
    new CleanWebpackPlugin(),
    new HtmlWebpackPlugin({
      template: './public/index.html',
      filename: 'index.html'
    })
  ],
  resolve: {
    extensions: ['.js', '.jsx', '.css']
  }
};
module.exports = config;
"

edit package.json and add the script dict


"scripts": {
"build": "webpack  --mode production --progress --config webpack.config.js",
"dev": "webpack-dev-server --mode development --config webpack.config.js",
"dev-watch": "webpack-dev-server --mode development --config webpack.config.js --watch",
"test": "echo \"Error: no test specified\" && exit 1"
},