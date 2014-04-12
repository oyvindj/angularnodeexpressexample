angularnodeexpressexample
=========================

Sample project integrating an Angular JS client (using ui.router) with a Node backend (using Express) and MongoDb (using Mongo Client) 

RUNNING LOCALLY
1) Make sure Mongo DB is running
2) run command <code>coffee -wc *.coffee server/*.coffee client/js/*.coffee</code>
3) run command "nodemon localserver.js"
4) open "http://localhost:3000" in a browser

RUNNING ON CLOUD9
1) Open the project on Cloud 9: https://c9.io/oyvindj_1/angularnodeexpressexample
1b) If necessary run command "git pull" to get the latest updates
2) From a terminal run command ". ./mongod" to start Mongo DB
3) Run command "coffee -wc client/js/*.coffee"
4) Select the "server.js" file and click the "Run" button
5) Select "Preview" from the menu
