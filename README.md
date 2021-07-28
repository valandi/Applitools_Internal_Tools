# Applitools_Internal_Tools
A growing collection of my own scripts. 

## Applitools Log Formatter: Usage
Used for formatting Applitools logs. A continuing work in progress!
This is a shell script used to prettify some types of Applitools logs (including logs with timestamps, and JSON logs).

### To install:

1. Clone the repo:
`git clone https://github.com/valandi/Applitools_Internal_Tools.git`

2. Change directory to Applitools_Internal_Tools
`cd Applitools_Internal_Tools`

3. Run the log formatter with the help flag
`./applitools_log_formatter.sh --help`


### Simple usage
Exampe usage:
`./applitools_log_formatter.sh PATH/TO/file.log`

### Usage with arguments

#### Usage instructions:
`./applitools_log_formatter.sh --help PATH/TO/file.log`

#### Get version:`
`./applitools_log_formatter.sh -v`

#### Run silently with no output:
`./applitools_log_formatter.sh --silent PATH/TO/file.log`

#### Denoise (performs a pattern matching to remove timestamps and less useful info from beginning of lines)
`./applitools_log_formatter.sh --denoise PATH/TO/file.log`

