// Create an osc.js UDP Port listening on port 57121.
var udpPort = new osc.UDPPort({
    localAddress: "0.0.0.0",
    localPort: 57121,
    metadata: true
});

// Listen for incoming OSC messages.
udpPort.on("message", function (oscMsg, timeTag, info) {
    console.log("An OSC message just arrived!", oscMsg);
    console.log("Remote info is: ", info);
switch (oscMsg.address){
    case '/volume':
        let vol = oscMsg.args ;
        console.log(vol[0].value);
        
        break;
        case '/frequency':
            let b = oscMsg.args ;
            console.log(b);
        break;

}
});

// Open the socket.
udpPort.open();


// When the port is read, send an OSC message to, say, SuperCollider
udpPort.on("ready", function () {
    udpPort.send({
        address: "/s_new",
        args: [
            {
                type: "s",
                value: "default"
            },
            {
                type: "i",
                value: 100
            }
        ]
    }, "127.0.0.1", 57110);
});