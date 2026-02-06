include { FASTQC_RAW }      from '../Modules/fastqc_raw'
include { TRIMMED_READS }      from '../Modules/trimmed_reads'
include { FASTQC_TRIMMED }  from '../Modules/fastqc_trimmed'
include { ALIGNED_READS }     from '../Modules/aligned_reads'
include { SAM_TO_BAM }      from '../Modules/sam_to_bam'
include { SORTING_INDEX_BAM }  from '../Modules/sorting_index_bam'
include { VARIANT_CALLING } from '../Modules/variant_calling'
include { MULTIPLEQC }         from '../Modules/multipleqc'


workflow MY_NEXTFLOW_PIPELINE {
    take:
        fastq_input
        ref_input

    main:
        raw_qc = FASTQC_RAW(fastq_input)
        trimmed_fq = TRIMMED_READS(fastq_input)
        trimmed_qc = FASTQC_TRIMMED(trimmed_fq)
        aligned = ALIGNED_READS(trimmed_fq, ref_input)
        bam = SAM_TO_BAM(aligned)
        sorted_outputs = SORTING_INDEX_BAM(bam)
        VARIANT_CALLING(sorted_outputs.sorted_bam,sorted_outputs.bai, ref_input)

        all_qc_logs = raw_qc.mix(trimmed_qc).collect()
        MULTIPLEQC(all_qc_logs)
}
