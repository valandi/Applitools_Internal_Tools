#!/bin/bash
# Applitools logs formatter (For internal use only)
# Author: Chris Allulis
# Run ./applitools_log_formatter.sh --help for more info

# Currently only really useful for Java logs with JSON formatting. 
# Will work on making this more robust in the future

########################
### Global Variables ###
########################
is_silent=false
denoise=false
version=1.0.0

#################
### Functions ###
#################

# Echo that handles silent mode
function echo_with_flag() {
	! $is_silent && echo "$1"
}

# Removes timestamps and less useful content from logs
function clean_up_noise() {
	if $denoise 
	then

		echo "Cleaning up noise"


		TMPFILE1=$(mktemp) || exit 1
		perl -pe 's/(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}:\d{3} - [[]\w*[]])//g' $1 >> $TMPFILE1
		cat $TMPFILE1 > $1

		#perl -pe 's/(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)//g' >> $TMPFILE1
		#cat $TMPFILE1 > $1

		rm -rf TMPFILE1
	fi
}


##################
### Main logic ###
##################

### Argument parsing 
optspec=":hv-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                silent)
                    is_silent=true
                    ;;
                denoise)
					denoise=true
					;;
	
                help)
					echo "###################################################################################"
					echo "############################  Applitools Logs formatter ###########################"
					echo "###################################################################################"
					echo ""
					echo "To use, run something like: './applitools_log_formatter <path/to/logs/test_log.log>"
					echo ""
					echo "Optional arguments:"
					echo ""
					echo " Silent Mode"
					echo "--silent: Run without any output"
					echo " Example with silent: ./applitools_log_formatter --silent test_log.logs"
					echo ""
					echo "Denoise Mode"
					echo "--denoise: Removes timestamp noise from certain log formats"
					echo "Example with denoise: ./applitools_log_formatter --denoise test_log.logs"
					echo ""
					echo "Help"
					echo "--help:   Learn about this app"
					echo "Example with help:   ./applitools_log_formatter --help"
					echo ""
					echo "Get Version"
					echo "-v:       Get current versions"
					echo "Example with -v: .applitools_log_formatter -v"
					exit 0
					;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        v)
            echo "Current Version: $version " && exit 0
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done

### Move arguments back
shift $(($OPTIND - 1))

echo_with_flag "Reading from: $1"

clean_up_noise $1

### Create a temporary file to write to and read from 
TMPFILE=$(mktemp) || exit 1

### Check to see if jq is installed. Install if not installed. 
echo_with_flag "Checking to see if jq package is installed..."
if brew ls --versions jq > /dev/null; then
	echo_with_flag "jq package is installed!"
else
	echo_with_flag "jq package is not installed. Installing..."
	brew install jq
fi

### Check to see if logs are in JSON format, then
### Read log file to prettify the JSON
if [ "$(head -n 1 $1 | cut -c 1)" = "{" ];
then
	jq . $1 > TMPFILE
	cat TMPFILE > $1
	rm -rf TMPFILE
fi

### Replace \n escape characters
perl -pi -e 's/\\n/\n\t\t/g' $1


### Replace any other \t escape characters if they exist
perl -pi -e 's/\\t/\t\t/g' $1


echo_with_flag "Log file $1 formatted"

