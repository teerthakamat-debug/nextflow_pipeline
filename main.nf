include {MY_NEXTFLOW_PIPELINE} from './Workflows/workflow'

workflow {

     fastq_ch = channel.fromPath(params.fastq, checkIfExists: true)
    ref_ch   = channel.fromPath(params.ref, checkIfExists: true)

    MY_NEXTFLOW_PIPELINE(fastq_ch, ref_ch)

}