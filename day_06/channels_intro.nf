params.step = 0


workflow{

    // =========================================================================== //
    //                                  Examples                                   //                            
    // =========================================================================== //
    
    // Queue channel
    if (params.step == 0) {
        out_ch = channel.of(1,2,3)
    }

    // Value channel
    if (params.step == 00) {
        out_ch = channel.value(1)
    }


    // =========================================================================== //
    //                                  Tasks                                      //                            
    // =========================================================================== //


    // Task 1 - Create a channel that enumerates the numbers from 1 to 10

    if (params.step == 1) {
        out_ch = channel.of(1,2,3,4,5,6,7,8,9,10)
    }

    // Task 2 - Create a channel that gives out the entire alphabet
    
    if (params.step == 2) {
        out_ch = channel.of('a','b','c','d','e','f','g','h','i','j','k','l',
                            'm','n','o','p','q','r','s','t','u','v','w','x',
                            'y','z')
    }

    // Task 3 - Create a channel that includes all files in the "files_dir" directory

    if (params.step == 3) {
        out_ch = channel.fromPath('./files_dir/*')
    }

    // Task 4 - Create a channel that includes all TXT files in the "files_dir" directory
    
    if (params.step == 4) {
        out_ch = channel.fromPath('./files_dir/*.txt')
    }

    // Task 5 - Create a channel that includes the files "fastq_1.fq" and "fastq_2.fq" in the "files_dir" directory

    if (params.step == 5) {
        out_ch = channel.fromPath('./files_dir/fastq_[1|2].fq')
    }

    // Task 6 - go back to the time when you included all files. Are you sure that really ALL files are included? If not, how can you include them?

    if (params.step == 6) {
        out_ch = channel.fromPath('./files_dir/*', hidden: true)
    }

    // Task 7 - get all filepairs in the "files_dir" directory

    if (params.step == 7) {
        out_ch = channel.fromFilePairs(['./files_dir/fastq*_{1,2}.fq', './files_dir/SRR*_{1,2}.fq'])
    }
    
    out_ch.view()

}