<b>########################################################################</b><br>
<p><b>&emsp;&emsp;&emsp;&emsp;&nbsp;
<i>Script for automatic upload of FASTq files to BaseSpace server/-s</i></b></p>
<b>DATE:</b>&emsp;&emsp;22.03.2022<br>
<b>VERSION:</b>&nbsp;1.0<br>
<b>CREATOR:</b>&nbsp;T.J.SANKO<br>
<b>ADDRESS:</b>&nbsp;Stellenbosch University, Tygerberg Campus,<br>&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;
Francie van Zijl Drive, Cape Town, South Africa<br>
<b>CONTACT:</b>&nbsp;tjsanko@sun.ac.za<br>
<b>########################################################################</b><br>
<br>
<ol>
<p><b><li>Requirements</li></b></p>
Script is design to work on any linux machine with bash/shell language. It was tested on CentOS7 and Ubuntu SMP 20.04.1.<br>
<u>Requires active BasespaceCLI program on the machine with</u><br><br>

Installation of BasespaceCLI on linux machines
<ol start='i'>
<li> download:</li>
<i>you might be required to use "sudo" infront and type the super user password (root permissions)</i><br><br>
<code>mkdir -p ~/.local</code><br>
<code>wget "https://launch.basespace.illumina.com/CLI/latest/amd64-linux/bs" -O ~/.local/bscmd</code><br><br>

<li> adding alternative name and changing permissions to execute:</li>
<code>ln -s ~/.local/bscmd ~/.local/bs && chmod +x ~/.local/bs*</code><br><br>

<li> creating authentication token (just 1st time per server).</li>
By default, the token is created for USA server when the website address is not given.<br>
<code> ~/.local/bscmd auth</code><br><br>

or with alias "<i>usa</i>"<br><br>
<code> ~/.local/bscmd auth -c usa --api-server https://api.basespace.illumina.com</code><br><br>

if you want to authenticate connection to the <i>European (EUC1)</i> server:<br>
<code> ~/.locla/bscmd auth -c eu --api-server https://api.euc1.sh.basespace.illumina.com</code><br><br>

<b>!!!</b> Option "<i>-c</i>" allows to add alias/name for the server. Allowed are names: "<b>eu</b>", "<b>usa</b>" or "<b>us</b>" (case insensitive).<br>
Not using "<i>-c</i>" option sets the server address to default (USA server)<br><br>

<li> setup of aliases and PATHs for the program</li>
<code>echo 'alias bs=" ~/.local/bs"'       >> ~/.bashrc</code><br>
<code>echo 'alias bscmd=" ~/.local/bscmd"' >> ~/.bashrc</code><br><br>

and for the script:<br>
<code>echo 'export PATH=$PATH:'/path_to_script_bs_upload/' >> ~/.bash_profile</code><br><br></ol>

More on installation (eg. on Mac or Windows) is available on Illumina website:<br>
<a>https://developer.basespace.illumina.com/docs/content/documentation/cli/cli-overview</a><br>

<p><b><li> Syntax:</li></b></p>
<code>bs_upload.sh [options]</code><br><br>

eg.<br>
<code>bs_upload.sh -l run222.lst -s eu -p /path_to_fastq_files/ -t 20 -T 48h</code><br><br>

or alternative<br>
<code>bs_upload.sh -l run222.lst -s eu -p /path_to_fastq_files/ -t 20 -P XXXXXXX</code>

<p><b><li>Options:</li></b></p>
required:<pre>
    l         list with files (run & LIMS numbers) in format: "RUNXXX,K0YYYYY"</pre>
optional:<pre>
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
