#Sys.setenv(PATH=paste("/opt/sratoolkit/bin/", Sys.getenv("PATH"),sep=":"))
index_ad = "/home/mkumar/Downloads/PTP-OvCa/SRA_files/bowtie_index/index/hg19"
parent_dir = "/home/mkumar/Downloads/PTP-OvCa/SRA_files/PRJNA311514"
for(sra_id in sra_id_list[10])
{
  sra_path = file.path(parent_dir, sra_id)
  setwd(sra_path)
  #bowtie2 -x /home/mkumar/Downloads/PTP-OvCa/SRA_files/bowtie_index/index/hg19 -U ./SRR3159914.fastq -S SRR3159914.sam -p 6
  bowtie_cmd = paste("bowtie2 -x ", index_ad, " -U ./", sra_id,".fastq -S ", sra_id, ".sam -p 6", sep = "")
  system(bowtie_cmd)
  #samtools view -bo SRR3159914.bam SRR3159914.sam
  samtools_cmd = paste("samtools view -bo ", sra_id, ".bam ", sra_id, ".sam", sep = "")
  system(samtools_cmd)
  #samtools sort SRR3159914.bam -o SRR3159914.sorted.bam
  samtools_sort_cmd = paste("samtools sort ", sra_id, ".bam -o ", sra_id, ".sorted.bam", sep = "")
  system(samtools_sort_cmd)
  #samtools index SRR3159914.sorted.bam 
  samtools_index_cmd = paste("samtools index ", sra_id, ".sorted.bam", sep = "")
  system(samtools_index_cmd)
  #bamCoverage -b SRR3159914.sorted.bam --normalizeUsing RPKM -p 5 --extendReads 200 -o SRR3159914.bw
  bamCov_cmd = paste(
   "bamCoverage -b ",
   sra_id, ".sorted.bam --normalizeUsing RPKM -p 5 --extendReads 200 -o ",
   sra_id, ".bw", sep = ""
  )
  system(bamCov_cmd)
  system("rm *.sam *.fastq")
}

system("macs2 callpeak -t SRR3159913.bam -c ./../SRR3159917/SRR3159917.bam --format=BAM --name=SRR3159913 -g hs")

