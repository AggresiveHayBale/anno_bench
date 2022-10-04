#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
* Nextflow -- Annotation Benchmark Pipeline 
* Author: CaSe-group
*/

/************************** 
* HELP messages & checks
**************************/

//header()

/* 
Nextflow version check  
Format is this: XX.YY.ZZ  (e.g. 20.07.1)
change below
*/

XX = "21"
YY = "04"
ZZ = "0"

if ( nextflow.version.toString().tokenize('.')[0].toInteger() < XX.toInteger() ) {
println "\033[0;33mgenome_to_json requires at least Nextflow version " + XX + "." + YY + "." + ZZ + " -- You are using version $nextflow.version\u001B[0m"
exit 1
}
else if ( nextflow.version.toString().tokenize('.')[1].toInteger() == XX.toInteger() && nextflow.version.toString().tokenize('.')[1].toInteger() < YY.toInteger() ) {
println "\033[0;33mgenome_to_json requires at least Nextflow version " + XX + "." + YY + "." + ZZ + " -- You are using version $nextflow.version\u001B[0m"
exit 1
}


// Log infos based on user inputs
if ( params.help ) { exit 0, helpMSG() }


// profile helps
if (params.profile) { exit 1, "--profile is WRONG use -profile" }

/************************** 
* INPUT
**************************/

// csv input 
if (params.csv) {
csv_ch = Channel 
    .fromPath(params.csv, checkIfExists:true)
    .splitCsv(header: true)
//   .view(csv_data -> "$csv_data.Accession")
    .map {csv_data -> tuple( csv_data.Accession, csv_data.Path)
    }
}else{
    exit 1, "'csv' parameter not found "
}
//csv_ch.view()
///REFERENCE
//process check {
//    publishDir "res", mode: 'copy', pattern: "*"
//    input: 
//    tuple val(accession), val(N50), path(fasta)
//    output: 
//    path("test.txt")
//    script:
//"""
//head -n 1 ${fasta} > test.txt
//"""
//}
//workflow{
//check(csv_ch)
//}






/************************** 
* Log-infos
**************************/

//defaultMSG()

/************************** 
* Workflows
**************************/
include {fasta_mod_wf} from './workflows/fasta_mod_wf.nf'
include {annotation_wf} from './workflows/annotation_wf.nf'
//include {filter_wf} from './workflows/filter_wf.nf'



/************************** 
* MAIN WORKFLOW
**************************/
workflow {
//annotation_wf(csv_ch)
fasta_mod_wf(csv_ch)
annotation_wf(fasta_mod_ch)
}


/*************  
* --help
*************/