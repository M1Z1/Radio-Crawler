import fs from 'fs'
import fetch from 'node-fetch'
import unisafe from 'unisafe'

const getLabels = async () => {
	const response = await fetch('http://websdr.ewi.utwente.nl:8901/~~labels?min=0&max=30000')
	let text = await response.text() //get as text
	text = unisafe(text) // remove unsupported characters
	text = text.replace(/<[^>]*>/g, "") // remove <br> and other HTML tags
	const radiolist = JSON.parse(text) // parse to JSON

	const formatted = radiolist.reduce((accum, item) => {
		accum[parseInt(item.freq)] = item // convert to int (ignore fractional part)
		// accum[item.freq] = item
		return accum
	}, {})
	
	fs.writeFileSync('radiolist.json', JSON.stringify(formatted))
}

getLabels()