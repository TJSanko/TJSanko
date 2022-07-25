
### Automatic upload FASTq files to BaseSpace server
### DATE: 22.03.2022   by Sathom

### program parameters & help menu
function help(){
  echo -e "Automatic upload FASTq files to BaseSpace server.\n"
  echo -e "Syntax: ./bs_upload.sh [-l|L|s|p|t|T|P|h|help]\n"
  echo -e "options:"
  echo -e " required: l         list with files (LIMS numbers) in format: "
  echo -e "                     RUNXXX,K0YYYYY"
  echo -e " optional: s         server name [eu|us|usa] (default: USA)"
  echo -e "           L         List all projects available"
  echo -e "           p         path to FASTq files (default: current location)"
  echo -e "           t         number of threds to use (default: t=4)"
  echo -e "           T         time frame to look for project ID in hours"
  echo -e "                     (default: 24h)"
  echo -e "           P         project ID number (default: obtained from the"
  echo -e "                     server based on the time frame in -t parameter)."
  echo -e "                     ! only 1st from the list will be used"
  echo -e "           h|help    prints this help\n"
}
export -f help

### reading options
while getopts l:s:p:t:T:P:h:help option; do
  case "${option}" in
    l)      LIST=${OPTARG};;
    s)    SERVER=${OPTARG};;
    L)   LISTPRJ=${OPTARG};;
    p)   WORKDIR=${OPTARG};;
    t)       THR=${OPTARG};;
    T)      TIME=${OPTARG};;
    P)     PRJID=${OPTARG};;
    h)   help && exit;;
    help)help && exit;;
    \?) echo -e "\nError: Invalid option\n"; help && exit;;
  esac
done

###############
### PROGRAM
###############
### checking system for BS programs
#BASHRC=(`cat ~/.bashrc | grep 'bs' | cut -d ' ' -f2 | cut -d '=' -f2`)
BASHRC=(`cat ~/.bashrc | grep 'bs' | cut -d ' ' -f2 ` `compgen -c | grep -P "\bbs\b"` `compgen -c | grep -P "\bbscmd\b"`)
if [ ${#BASHRC[@]} -eq 0 ]; then echo -e "\nNo BaseSpace program installed\n" && exit; fi;

errors=0
for B in ${BASHRC[@]}; do
  if [[ $(eval $(echo ${B} | sed -r 's/.*="(.*)".*/\1/') -V) == "BaseSpaceCLI"* ]]; then #"
    BS=`echo ${B} | sed -r 's/.*"(.*)".*/\1/;  s/\\b//g'`; break; fi;
  ((errors++));
done
if [ ${errors} -eq ${#BASHRC[@]} ]; then echo -e "\nPath to BaseSpace does not exist\n"; exit; fi;

### checking list file
if [[ $# -lt 1 ]]; then echo -e "\nNot enough arguments.\n";    help && exit; fi;
if [[ ! -e ${LIST} || -z ${LIST} || ${LIST} == ^$ ]]; then echo -e "\nRequired List file is empty or does not exist\n"; exit; fi;
FILE=`echo ${LIST} | sed -r 's/.*\///; s/\.lst//'`
STARTDIR=$(pwd)

### checking the working directory
if [[ ! -e ${WORKDIR} || -z ${WORKDIR} || ${WORKDIR} == ^$ ]]; then echo -e "\nInvalid PATH.\nSetting current location: "$(pwd); WORKDIR=$(pwd); fi;

### activating the ENV VARIABLES
declare -A SRV
SRV=(['eu']=1  ['EU']=1  ['Eu']=1  ['europe']=1  ['Europe']=1  ['EUROPE']=1
     ['us']=0  ['US']=0  ['Us']=0  ['america']=0 ['America']=0 ['AMERICA']=0
     ['USA']=0 ['Usa']=0 ['usa']=0 ['america']=0 ['America']=0 ['AMERICA']=0
                                   ['default']=0 ['Default']=0 ['DEFAULT']=0)
if [[ ${SERVER} == "" || ${SERVER} == .$ || ${SRV[$SERVER]} -eq 0 ]]; then
  ~/.local/bscmd load config    1 >> /dev/null ; export BASESPACE_API_SERVER="https://api.basespace.illumina.com";         export BASESPACE_ACCESS_TOKEN="f32f10396ef346fdbb471ec7291bd367"; fi;
if [[ ${SRV[$SERVER]} -eq 1 ]]; then
  ~/.local/bscmd load config eu 1 >> /dev/null ; export BASESPACE_API_SERVER="https://api.euc1.sh.basespace.illumina.com"; export BASESPACE_ACCESS_TOKEN="735f1633dc8d4716b69c56e7728be452"; fi;

### Listing projects
if [[ -e ${LISTPRJ} ]]; then ~/.local/bscmd list projects --api-server=$BASESPACE_API_SERVER --access-token=$BASESPACE_ACCESS_TOKEN; exit; fi;

### checking the threads parameter
if [[ ${THR} -eq 0 || -z ${THR} || ${THR} == ^$ || ${THR} != \d+ ]]; then THR=4; fi;

### checking the time frame paramter
if [[ ${TIME} -eq 0 || -z ${TIME} || ${TIME} == ^$ || ${TIME} != \d+ ]]; then TIME=24; fi;

### checking for project
if [[ -z ${PRJID} || ${PRJID} == ^$ ]]; then
  PRJ=(`~/.local/bscmd list projects --newer-than=${TIME}h --api-server=$BASESPACE_API_SERVER --access-token=$BASESPACE_ACCESS_TOKEN | sed -r 's/.*Name.*//g; s/^\+.*//g' | cut -d '|' -f3`)
  PRJID=${PRJ[0]}
  echo -e "\nProjects IDs found: "`echo ${PRJ[@]} | sed -r 's/\s+/,/g'`
fi
echo -e "Uploading to project ID: ${PRJID}\n"

### running the upload"

function upload() {
 RUN=`echo $1 | cut -d ',' -f1`
   X=`echo $1 | cut -d ',' -f2`
  Xf=`ls ${X}_S*_R1*`
  Xr=`ls ${X}_S*_R2*`

 if [[ $(ls -Fal ${Xf} | sed -r 's/\s+/|/g' | cut -d '|' -f5 ) -le 20 ]]; then echo "skipping empty file ${X}"; return 1; fi;

 F=`echo ${X} | sed -r 's/_/-/'`_S1_L001_R1_001.fastq.gz ; ln -s ${Xf} ${F}
 R=`echo ${X} | sed -r 's/_/-/'`_S1_L001_R2_001.fastq.gz ; ln -s ${Xr} ${R}

 ~/.local/bscmd upload dataset --biosample-name=${X} --library-name=${RUN} -p $2 --name="UPLOAD" --allow-invalid-readnames ${F} ${R}
 rm -f ${F} ${R}
}
export -f upload

cd ${WORKDIR}
### removing old links
LINKS=(`ls -Fal *.gz | grep  ">" | sed -r 's/\s+/|/g' | cut -d '|' -f9`)
for L in ${LINKS[@]}; do if [ -e ${L} ]; then rm ${L}; fi; done;

### running the program
cat ${LIST} | parallel -j ${THR} -I%  "upload % ${PRJID}"

#UPNUM=$(`~/.local/bscmd list biosample --project-id ${PRJID} | grep 'New' | sed -r 's/^\+.*//g; s/.*Name.*//g; s/\s+//g' | cut -d '|' -f2`)
UPNUM=(`~/.local/bscmd list biosample --project-id ${PRJID} | grep 'New' | cut -d '|' -f2`)
FNUM=`cat ${LIST} | wc -l`
echo -e "\n"'+-------------------------+'
echo -e "| Uploaded ${#UPNUM[@]} files out of ${FNUM} |"
echo -e "\n"'+-------------------------+'

cd ${STARTDIR}


exit

### search for empty files
#for L in $(ls \*.gz); do if [[ `ll $L | sed -r \'s/\s+/|/g\' | cut -d '|' -f5` -le 20 ]]; then echo $L; fi; done;

