


const express = require('express');
const http = require('http');
const bodyParser = require('body-parser');


const app = express();

const server = http.createServer(app);

const io = require('socket.io')(server);


app.use(bodyParser.json());

app .get('/', (req, res) => {
    res.json({message: "Api working successfully"});
});


// to listen for socket connection
io.on("connection", (client) => {
    console.log(`Client connected ${client.id}`);

    client.on("msg", (data) => {
        console.log(data);

        // send event to the client who sent the message
        client.emit("res",  data);

        // send event to all connected clients including the sender
        // io.emit("res", data);

        // send event to all connected clients without the sender
        client.broadcast.emit("res", data);

        // // send event to specific client
        // io.to(client.id).emit("res", {message: `Hello ${data}, welcome to the socket server2`});
    });
});

// to emit event to all connected clients

io.emit("welcome", {message: "Welcome to the socket server"});




server.listen(8080,() => {
    console.log("Server is running on port 8080");
});








