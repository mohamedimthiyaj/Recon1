#################################################################
#			reconFTW config file			#
#################################################################
domain=testphp.vulnweb.com
mkdir -p ~/$domain/.tmp
mkdir -p ~/$domain/.log
mkdir -p ~/$domain/osint
mkdir -p ~/$domain/gf
mkdir -p ~/$domain/js
mkdir -p ~/$domain/nuclei_output
mkdir -p ~/$domain/subdomains
mkdir -p ~/$domain/hosts
mkdir -p ~/$domain/webs

NOWT=$(date +"%T")
LOGFILE="$HOME/$domain/.log/${NOW}_${NOWT}.txt"
NOW=$(date +"%F")
sudo touch $HOME/$domain/.log/${NOW}_${NOWT}.txt

# General values
tools=~/Tools
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
profile_shell=".$(basename $(echo $SHELL))rc"
reconftw_version=$(git branch --show-current)-$(git describe --tags)
update_resolvers=true
proxy_url="http://127.0.0.1:8080/"
#dir_output=/custom/output/path

# Golang Vars (Comment or change on your own)
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

# Tools config files
#NOTIFY_CONFIG=~/.config/notify/notify.conf # No need to define
#SUBFINDER_CONFIG=~/.config/subfinder/config.yaml # No need to define
AMASS_CONFIG=~/.config/amass/config.ini
GITHUB_TOKENS=${tools}/.github_tokens

# APIs/TOKENS - Uncomment the lines you set removing the '#' at the beginning of the line
#SHODAN_API_KEY="XXXXXXXXXXXXX"
XSS_SERVER="https://imthiyaj.xss.ht"
#COLLAB_SERVER="6ovf5rtlpjg4ggoztmal05638uek29.burpcollaborator.net"
#findomain_virustotal_token="XXXXXXXXXXXXXXXXX"
#findomain_spyse_token="XXXXXXXXXXXXXXXXX"
#findomain_securitytrails_token="XXXXXXXXXXXXXXXXX"
#findomain_fb_token="XXXXXXXXXXXXXXXXX"
#slack_channel="XXXXXXXX"
#slack_auth="xoXX-XXX-XXX-XXX"

# File descriptors
DEBUG_STD="&>/dev/null"
DEBUG_ERROR="2>/dev/null"

# Osint
OSINT=true
GOOGLE_DORKS=true
GITHUB_DORKS=true
METADATA=true
EMAILS=true
DOMAIN_INFO=true
METAFINDER_LIMIT=20 # Max 250

# Subdomains
SUBCRT=true
SUBANALYTICS=true
SUBBRUTE=true
SUBSCRAPING=true
SUBPERMUTE=true
SUBTAKEOVER=true
SUBRECURSIVE=true
SUB_RECURSIVE_PASSIVE=false # Uses a lot of API keys queries
ZONETRANSFER=true
S3BUCKETS=true

# Web detection
WEBPROBESIMPLE=true
WEBPROBEFULL=true
WEBSCREENSHOT=true
UNCOMMON_PORTS_WEB="81,300,591,593,832,981,1010,1311,1099,2082,2095,2096,2480,3000,3128,3333,4243,4567,4711,4712,4993,5000,5104,5108,5280,5281,5601,5800,6543,7000,7001,7396,7474,8000,8001,8008,8014,8042,8060,8069,8080,8081,8083,8088,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8443,8500,8834,8880,8888,8983,9000,9001,9043,9060,9080,9090,9091,9200,9443,9502,9800,9981,10000,10250,11371,12443,15672,16080,17778,18091,18092,20720,32000,55440,55672"
# You can change to aquatone if gowitness fails, comment the one you don't want
AXIOM_SCREENSHOT_MODULE=webscreenshot # Choose between aquatone,gowitness,webscreenshot

# Host
FAVICON=true
PORTSCANNER=true
PORTSCAN_PASSIVE=true
PORTSCAN_ACTIVE=true
CLOUD_IP=true

# Web analysis
WAF_DETECTION=true
NUCLEICHECK=true
URL_CHECK=true
URL_GF=true
URL_EXT=true
JSCHECKS=true
PARAMS=true
FUZZ=true
CMS_SCANNER=true
WORDLIST=true

# Vulns
XSS=true
CORS=true
TEST_SSL=true
OPEN_REDIRECT=true
SSRF_CHECKS=true
CRLF_CHECKS=true
LFI=true
SSTI=true
SQLI=true
BROKENLINKS=true
SPRAY=true
BYPASSER4XX=true
COMM_INJ=true

# Extra features
NOTIFICATION=false
DEEP=false
DIFF=false
REMOVETMP=false
REMOVELOG=false
PROXY=false
SENDZIPNOTIFY=false
PRESERVE=false      # set to true to avoid deleting the .called_fn files on really large scans

# HTTP options
HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0"

# Threads
FFUF_THREADS=40
HTTPX_THREADS=50
HTTPX_UNCOMMONPORTS_THREADS=100
GOSPIDER_THREADS=50
GITDORKER_THREADS=5
BRUTESPRAY_THREADS=20
BRUTESPRAY_CONCURRENCE=10
ARJUN_THREADS=20
GAUPLUS_THREADS=10
DALFOX_THREADS=200
PUREDNS_PUBLIC_LIMIT=0 # Set between 2000 - 10000 if your router blows up, 0 is unlimited
PUREDNS_TRUSTED_LIMIT=400
DIRDAR_THREADS=200
WEBSCREENSHOT_THREADS=200
RESOLVE_DOMAINS_THREADS=150

# Timeouts
CMSSCAN_TIMEOUT=3600
FFUF_MAXTIME=900                # Seconds
HTTPX_TIMEOUT=10                # Seconds
HTTPX_UNCOMMONPORTS_TIMEOUT=10  # Seconds

# lists
fuzz_wordlist=${tools}/fuzz_wordlist.txt
lfi_wordlist=${tools}/lfi_wordlist.txt
ssti_wordlist=${tools}/ssti_wordlist.txt
subs_wordlist=${tools}/subdomains.txt
subs_wordlist_big=${tools}/subdomains_big.txt
resolvers=${tools}/resolvers.txt
resolvers_trusted=${tools}/resolvers_trusted.txt

# Axiom Fleet
# Will not start a new fleet if one exist w/ same name and size (or larger)
AXIOM_FLEET_LAUNCH=false
AXIOM_FLEET_NAME="reconFTW"
AXIOM_FLEET_COUNT=5
AXIOM_FLEET_REGIONS=""
AXIOM_FLEET_SHUTDOWN=true
# This is a script on your reconftw host that might prep things your way...
#AXIOM_POST_START="$HOME/bin/yourScript"

# TERM COLORS
bred='\033[1;31m'
bblue='\033[1;34m'
bgreen='\033[1;32m'
yellow='\033[0;33m'
red='\033[0;31m'
blue='\033[0;34m'
green='\033[0;32m'
reset='\033[0m'
