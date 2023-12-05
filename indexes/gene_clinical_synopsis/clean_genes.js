const fs = require('fs')
const { exit } = require('process')

let geneData = fs.readFileSync('genes.json', 'utf-8').replace(/\r|\r\n|\n/g, '\n').split('\n')

let exportData = geneData.filter(item => item).map(item => JSON.parse(item))

fs.writeFileSync('gene_result.json', JSON.stringify(exportData), 'utf-8')