########################################################################
    Script for automatic upload of FASTq files to BaseSpace server/-s

    DATE:    22.03.2022
 VERSION: 1.0
 CREATOR: T.J.SANKO
 ADDRESS: Stellenbosch University, Tygerberg Campus,
          Francie van Zijl Drive, Cape Town, South Africa
 CONTACT: tjsanko@sun.ac.za
########################################################################

1. Requirements
 Script is design to work on any linux machine with bash/shell language.
 It was tested on CentOS7 and Ubuntu SMP 20.04.1.
 Requires active BasespaceCLI program on the machine with 
 a) Installation of BasespaceCLI on linux machines
   i) download:
     mkdir -p ~/.local
     wget "https://launch.basespace.illumina.com/CLI/latest/amd64-linux/bs" -O ~/.local/bscmd
     
     you might be required to use "sudo" infront and type the super user password (root permissions)
     
   ii) adding alternative name and changing permissions to execute:
      ln -s ~/.local/bscmd ~/.local/bs && chmod +x ~/.local/bs* 

   iii) creating authentication token (just 1st time per server).
       By default, the token is created for USA server when the website address is not given.
       ~/.local/bscmd auth

       or with alias 'usa'
       ~/.local/bscmd auth -c usa --api-server https://api.basespace.illumina.com

       if you want to authenticate connection to the European (EUC1) server:
       ~/.locla/bscmd auth -c eu --api-server https://api.euc1.sh.basespace.illumina.com

    !!! Option '-c' allows to add alias/name for the server.
        Allowed are names: "eu", "usa" or "us" (case insensitive).
        Not using "-c" option sets the server address to default (USA server)

   iv) setup of aliases and PATHs for the program
      echo 'alias bs="~/.local/bs"        >> ~/.bashrc
      echo 'alias bscmd="~/.local/bscmd"' >> ~/.bashrc

      and for the script:
      echo 'export PATH=$PATH:'/path_to_script_bs_upload/' >> ~/.bash_profile

more on installations  (eg. Mac or Windows) on Illumina website:
https://developer.basespace.illumina.com/docs/content/documentation/cli/cli-overview

 2. Syntax:
     bs_upload.sh [-l|L|s|p|t|T|P|h|help]
   
   eg. 
     bs_upload.sh -l run222.lst -s eu -p /path_to_fastq_files/ -t 20 -T 48h
   
   or
     bs_upload.sh -l run222.lst -s eu -p /path_to_fastq_files/ -t 20 -P XXXXXXX

 3. Options:
 required:
    l         list with files (run & LIMS numbers) in format: "RUNXXX,K0YYYYY"

 optional:
    s         server name [eu|us|usa] (default: USA)

    L         List all projects available"

    p         path to FASTq files (default: current location)

    t         number of threds to use (default: t=4)

    T         time frame to look for project ID in hours (default: 24h)

    P         project ID number (default: obtained from the server based on the time frame in -t parameter). 
              ! only 1st entry from the list will be used

    h|help    prints this help

