const express = require('express')
const app = express()

var path = require('path');
app.use(express.static(path.join(__dirname, 'public')));


app.get('/', function (req, res) {
//   res.send('Hello World')
    console.log(__dirname);
    res.sendFile(__dirname+'/public/index.html');
});
 
app.listen(3009)