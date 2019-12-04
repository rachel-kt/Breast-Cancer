system("ls")
system("kallisto")
Sys.getenv()
Sys.setenv(PATH=paste("/home/mkumar/.aspera/connect/bin/", Sys.getenv("PATH"),sep=":"))
Sys.setenv(PATH=paste("/opt/sratoolkit/bin/", Sys.getenv("PATH"),sep=":"))

source("http://bioconductor.org/biocLite.R")
biocLite("Biobase")
biocLite("SRAdb")
library(SRAdb)
library(Biobase)
system("fastq-dump")
# Project Directory path
project_dir = "/home/mkumar/Downloads/PTP-OvCa/"
# Download Directory path
download_dir = "/home/mkumar/Downloads/PTP-OvCa/SRA_files"
# project ids to download
project_nos = scan("/home/mkumar/Downloads/PTP-OvCa/project_numbers.txt", what = character())
# example url : anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/pre2_sra/pre_sra/sra_id
ncbi_url = "anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra"
# fastq-dump filepath
fastq_dump_path = "/opt/sratoolkit/bin/fastq-dump"
# index file path
transcript_index = "/Users/manoj/Downloads/Rachels_work/athaliana_network/TAIR10_kallisto.idx"
sra_count = 0

project_details_list = list.files(path = project_dir, pattern = "*SraRunTable.txt")
project_details_list

#Size estimation
MBytes = 0
for (p_id_file in project_details_list) {
  p_id_table = read.csv(file.path(project_dir, p_id_file), sep = "\t")
  MBytes = MBytes + sum(p_id_table$MBytes)
}
MBytes = MBytes/1024
print(paste("Estimated download size :", MBytes, "GB", sep = " "))

for (p_id_file in project_details_list[1]) 
{
  #  print(p_id_file)
  mainDir = unlist(strsplit(p_id_file, "_"))[1]
  dir.create(file.path(download_dir, mainDir))
  p_id_table = read.csv(file.path(project_dir, p_id_file), sep = "\t")
  query_table = data.frame(p_id_table$BioProject, p_id_table$Run, p_id_table$Assay_Type, p_id_table$LibraryLayout)
  query_table = subset(query_table, query_table$p_id_table.Assay_Type == "ChIP-Seq")
  p_id = levels(factor(query_table$p_id_table.BioProject))
  for (direc in p_id) 
  {
    #dir.create(file.path(download_dir, mainDir, direc))
    sra_id_list = subset(query_table$p_id_table.Run, query_table$p_id_table.BioProject == direc)
    sra_id_list = as.character(factor(sra_id_list))
    #    print(direc)
    print(sra_id_list)
    for (sra_id in sra_id_list[3:18])
    {
      pre2_sra =  substr(sra_id, 0, 3)
      pre_sra = substr(sra_id, 0, 6)
      download_url = file.path(ncbi_url, pre2_sra, pre_sra, sra_id)
      print(download_url) 
      ascpCMD = "ascp -i /home/mkumar/.aspera/connect/etc/asperaweb_id_dsa.openssh -QT -l 50m --partial-file-suffix=.partial"
      ascpSource = download_url
      destDir = file.path(download_dir, mainDir)
      print(destDir)
      write(c(ascpCMD, ascpSource, destDir), file = paste(file.path(download_dir, mainDir, sra_id),"txt", sep = "."))
      #sra_count = sra_count + 1
      ascpR( ascpCMD, ascpSource, destDir = destDir )
      sra_file_status = list.files(path = file.path(destDir, sra_id), pattern = "partial")
      while(length(sra_file_status))
      {
        print("File download failed")
        print("Attempting to download again")
        ascpR( ascpCMD, ascpSource, destDir = destDir )
        sra_file_status = list.files(path = file.path(destDir, sra_id), pattern = "partial")
      }
      sra_file_path = file.path(destDir, sra_id)
      fastq_command = paste("fastq-dump"," -O ", sra_file_path, " ", sra_file_path, "/",sra_id,".sra", sep = "")
      system(fastq_command)
      fastq_file = file.path(sra_file_path,sra_id)
      return_path = getwd()
      setwd("/usr/local/bin/")
      fastqc_cmd = paste("./fastqc ", fastq_file, "*.fastq", " -o ", sra_file_path, sep = "")
      system(fastqc_cmd)
      setwd(return_path)
    }
  }
  
}







