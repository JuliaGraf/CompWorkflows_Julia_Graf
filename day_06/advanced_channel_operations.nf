params.step = 0


workflow{

    // Task 1 - Read in the samplesheet.
    if (params.step == 1) {
        out_ch = channel.fromPath('samplesheet.csv')
                        .splitCsv( header: true )
        out_ch.view()
    }

    // Task 2 - Read in the samplesheet and create a meta-map with all metadata
    // and another list with the filenames ([[metadata_1 : metadata_1, ...], [fastq_1, fastq_2]]).
    // Set the output to a new channel "in_ch" and view the channel.
    // YOU WILL NEED TO COPY AND PASTE THIS CODE INTO SOME OF THE FOLLOWING TASKS (sorry for that).
    if (params.step == 2) {
        in_ch = channel.fromPath('samplesheet.csv')
                       .splitCsv( header: true )
                       .map { it -> [[sample: it.sample, strandedness: it.strandedness], [it.fastq_1, it.fastq_2]]}
                       .view()
    }

    // Task 3 - Now we assume that we want to handle different "strandedness" values differently. 
    // Split the channel into the right amount of channels and write them all to stdout
    // so that we can understand which is which.
    if (params.step == 3) {
        channel.fromPath('samplesheet.csv')
               .splitCsv( header: true )
               .map { it -> [[sample: it.sample, strandedness: it.strandedness], [it.fastq_1, it.fastq_2]]}
               .branch {
                   forward: it[0].strandedness == 'forward'
                   reverse: it[0].strandedness == 'reverse'
                   auto:    it[0].strandedness == 'auto'
               }
               .set { in_ch }

        in_ch.forward.collect().view { "Forward: $it" }
        in_ch.reverse.collect().view { "Reverse: $it" }
        in_ch.auto.collect().view { "Auto: $it" }
    }

    // Task 4 - Group together all files with the same sample-id and strandedness value.
    if (params.step == 4) {
        channel.fromPath('samplesheet.csv')
                   .splitCsv( header: true )
                   .map { it -> [[sample: it.sample, strandedness: it.strandedness], [it.fastq_1, it.fastq_2]]}
                   .groupTuple()
                   .view()
    }
}