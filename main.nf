#!/usr/bin/env nextflow

// Define the QC process
process virscan_qc {
    container "${params.container__R}"
    publishDir "${params.output_dir}", mode: 'copy', overwrite: true

    input:
    file zscores
    file counts
    file sample_table
    file peptide_table
    file organism_summary

    output:
    path "*"

    script:
    """#!/bin/bash
set -e
virscan_qc.R \
    "${zscores}" \
    "${counts}" \
    "${sample_table}" \
    "${peptide_table}" \
    "${organism_summary}"
"""

}

workflow {
    // Raise an error if input_dir or output_dir are not defined in the params scope
    if (!params.output_dir){error "Must provide parameter 'output_dir'"}
    if (!params.input_dir){error "Must provide parameter 'input_dir'"}

    zscores = file("${params.input_dir}/wide_data/virscan_zscore.ebs.csv.gz", checkIfExists: true)
    counts = file("${params.input_dir}/wide_data/virscan_counts.ebs.csv.gz", checkIfExists: true)
    sample_table = file("${params.input_dir}/wide_data/virscan_sample_annotation_table.ebs.csv.gz", checkIfExists: true)
    peptide_table = file("${params.input_dir}/wide_data/virscan_peptide_annotation_table.ebs.csv.gz", checkIfExists: true)
    organism_summary = file("${params.input_dir}/aggregated_data/organism.summary.csv.gz", checkIfExists: true)

    virscan_qc(zscores, counts, sample_table, peptide_table, organism_summary)

}