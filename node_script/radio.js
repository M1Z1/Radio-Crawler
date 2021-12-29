const puppeteer = require('puppeteer')
const osc = require('osc')

let browser, pages = []

const openPage = async () => {
	const page = await browser.newPage()
	await page.goto('http://websdr.ewi.utwente.nl:8901')
	await page.waitForTimeout(2000)
	await page.evaluate(`soundapplet.audioresume()`)
	await page.evaluate(`set_mode('am')`)
	// await browser.close()
	await page.evaluate(`setfreq(${Math.floor(Math.random()*22000)})`)
	return page
}

const init = async () => {
	browser = await puppeteer.launch({
		headless: false,
		ignoreDefaultArgs: ['--mute-audio'],
	})
	let waitForPages = []
	for (let i = 0; i < 4; i++) {
		waitForPages[i] = openPage()
	}

	pages = await Promise.all(waitForPages)
	pages.forEach(page => {
		page.evaluate(`set_volume(${-10})`)
	})
	pages.forEach(page => {
		page.evaluate(`maxorman='max'; if (soundapplet) { soundapplet.setparam('maxgain='+${-18}); document.getElementById('gainval').innerHTML=${-18};}`)
	})
}

const objectFormatting = (oscMsg) => {
	let formatted = {}
	oscMsg.args.forEach((element, index, array) => {
		if (!(index & 1)) { // even 1, odd 0
			formatted[element.value] = array[index + 1].value
		}
	})

	return formatted
}

// Create an osc.js UDP Port listening on port 57121.
var udpPort = new osc.UDPPort({
	localAddress: "0.0.0.0",
	localPort: 57121,
	metadata: true
});
init();

// Listen for incoming OSC messages.
udpPort.on("message", function (oscMsg, timeTag, info) {
	// console.log("An OSC message just arrived!", oscMsg);
	// console.log("Remote info is: ", info);
	const message = objectFormatting(oscMsg)
	for (let [key , value] of Object.entries(message)) {
		switch (key) {
			case 'volume':
				pages[message.voice].evaluate(`set_volume(${value})`)
				
				break;
			case 'frequency':
				pages[message.voice].evaluate(`setfreq(${value})`)
				break;
			case 'mode':
				pages[message.voice].evaluate(`set_mode('${value}')`)
				break;
			case 'mute':
				pages[message.voice].evaluate(`setmute(${!!value})`)
				break;
			case 'limiter':
				pages.forEach(page => {
					page.evaluate(`maxorman='max'; if (soundapplet) { soundapplet.setparam('maxgain='+${value}); document.getElementById('gainval').innerHTML=${value};}`)
				})
				break;
				case 'solo':
					pages.forEach((page, index) => {
						if (message.voice !== index && message.solo == 1)  {
							pages[index].evaluate(`set_volume(-70)`)
						}
				})
		}
	}
});

// Open the socket.s
udpPort.open();


// When the port is read, send an OSC message to, say, SuperCollider
udpPort.on("ready", function () {
	udpPort.send({
		address: "/s_new",
		args: [{
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



// const main = async (freq) => {
// 	await page.evaluate(`setfreq(${freq})`)
// main();
//Max.addHandler(Max.MESSAGE_TYPES.NUMBER, async (num) => {
//	await page.evaluate(`setfreq(${num})`)
//})

//Max.addHandler('volume', async (num) => {
//await page.evaluate(`set_volume(${num})`)
//})

//Max.addHandler('mode', async (mode) => {
//	await page.evaluate(`set_mode('${mode}')`)
//})
//Max.addHandler('mute', async (mode) => {
//	await page.evaluate(`setmute(${mode != 0})`)
//})//