const fs = require('fs')
const { exit } = require('process')

let omimData = fs.readFileSync('omim.json', 'utf-8').replace(/\r|\r\n|\n/g, '\n').split('\n')
// let geneData = fs.readFileSync('gene.json')

// console.log(geneData)

let omimExport = omimData.filter(item => item).map(item => {
    let data = JSON.parse(item)
    
    let clinicalSynopsis = JSON.parse(data.clinical_synopsis)

    Object.keys(clinicalSynopsis).map(key => {
        if (key.indexOf('Creation Date') != -1 || key.indexOf('Contributor') != -1 || key.indexOf('Edit History') != -1) {
            console.log(key)
            delete clinicalSynopsis[key]
        }
    })

    data.clinical_synopsis = JSON.stringify(clinicalSynopsis)

    return data
})

fs.writeFileSync('omim_result.json', JSON.stringify(omimExport), 'utf-8')