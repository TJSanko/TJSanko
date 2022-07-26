<head>
<b>########################################################################</b><br>
<b>&emsp;&emsp;&emsp;&emsp;&nbsp;
<i>Script for automatic upload of FASTq files to BaseSpace server/-s</i></b><br>
<b>DATE:</b>&emsp;&emsp;22.03.2022<br>
<b>VERSION:</b>&nbsp;1.0<br>
<b>CREATOR:</b>&nbsp;T.J.SANKO<br>
<b>ADDRESS:</b>&nbsp;Stellenbosch University, Tygerberg Campus,<br>&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;
Francie van Zijl Drive, Cape Town, South Africa<br>
<b>CONTACT:</b>&nbsp;tjsanko@sun.ac.za<br>
<b>########################################################################</b><br>
</head>
<p ><b>1. Requirements</b></p>
 Script is design to work on any linux machine with bash/shell language. It was tested on CentOS7 and Ubuntu SMP 20.04.1.
 Requires active BasespaceCLI program on the machine with
 a) Installation of BasespaceCLI on linux machines
   i) download:<br>
   <code>
     mkdir -p ~/.local
     wget "https://launch.basespace.illumina.com/CLI/latest/amd64-linux/bs" -O ~/.local/bscmd</code>

     you might be required to use "sudo" infront and type the super user password (root permissions)

   ii) adding alternative name and changing permissions to execute:<br><code>
      ln -s ~/.local/bscmd ~/.local/bs && chmod +x ~/.local/bs*</code>

   iii) creating authentication token (just 1st time per server).
       By default, the token is created for USA server when the website address is not given.<br><code>
       ~/.local/bscmd auth</code>

       or with alias <b>'usa'</b><br><code>
       ~/.local/bscmd auth -c usa --api-server https://api.basespace.illumina.com</code>

       if you want to authenticate connection to the <b>European (EUC1)</b> server:<br><code>
       ~/.locla/bscmd auth -c eu --api-server https://api.euc1.sh.basespace.illumina.com</code>

    !!! Option '-c' allows to add alias/name for the server.
        Allowed are names: "eu", "usa" or "us" (case insensitive).
        Not using "-c" option sets the server address to default (USA server)

   iv) setup of aliases and PATHs for the program<br><code><pre>
      echo 'alias bs="~/.local/bs"        >> ~/.bashrc
      echo 'alias bscmd="~/.local/bscmd"' >> ~/.bashrc</pre></code><br>

      and for the script:<br><code>
      echo 'export PATH=$PATH:'/path_to_script_bs_upload/' >> ~/.bash_profile</code>

more on installations  (eg. Mac or Windows) on Illumina website:<br><a>https://developer.basespace.illumina.com/docs/content/documentation/cli/cli-overview</a>

 <p><b>2. Syntax:</b></p>
     <code>bs_upload.sh [-l|L|s|p|t|T|P|h|help]</code>
   
   eg.<br>
<code>     bs_upload.sh -l run222.lst -s eu -p /path_to_fastq_files/ -t 20 -T 48h</code>
   
   or alternative<br>
     <code>bs_upload.sh -l run222.lst -s eu -p /path_to_fastq_files/ -t 20 -P XXXXXXX</code>

 <p><b>3. Options:</b></p><pre>
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

    h         prints this help
    help      prints this help
</pre>

