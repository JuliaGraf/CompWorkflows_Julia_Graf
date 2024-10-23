#!/usr/bin/env nextflow

process SPLITLETTERS {

    input:
    tuple val(meta), val(input)

    output:
    path '*.txt', emit: block_files

    script:
    """
    string="${input.input_str}"
    length=\${#string}
    block_size=${meta.block_size}

    for ((i=0; i<length; i+=block_size)); do
        block_number=\$((i / block_size))
        echo "\${string:i:block_size}" >> ${input.out_name}_\${block_number}.txt
    done
    """
}

process CONVERTTOUPPER {

    input:
    path block_file

    output:
    stdout

    script:
    """
    cat $block_file | tr '[:lower:]' '[:upper:]'
    """
}


workflow { 
    // 1. Read in the samplesheet (samplesheet_2.csv) into a channel. The block_size will be the meta-map
    channel.fromPath('samplesheet_2.csv')
                   .splitCsv( header: true )
                   .map { it -> [[block_size: it.block_size], [input_str: it.input_str, out_name: it.out_name]]}
                   .set { in_ch }
    // in_ch.view()

    // 2. Create a process that splits the "in_str" into sizes with size block_size.
    // The output will be a file for each block, named with the prefix as seen in the samplesheet_2
    block_ch = SPLITLETTERS(in_ch).block_files
    block_ch.collect().dump(tag: 'block_files')

    // 3. Feed these files into a process that converts the strings to uppercase.
    // The resulting strings should be written to stdout
    upper_ch = CONVERTTOUPPER(block_ch)
    upper_ch.view()
}