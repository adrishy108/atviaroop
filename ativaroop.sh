#!/bin/bash

# Function to display usage information
display_usage() {
  echo "Usage: $0 [-o <output_directory>] [-m] [-t] [-c] <website_url>"
  echo "Options:"
  echo "  -o <output_directory>: Specify the output directory (default: website)"
  echo "  -m: Convert HTML to Markdown (default: plain text)"
  echo "  -t: Convert plain text to Markdown (default: no conversion)"
  echo "  -c: Keep HTML files after conversion (default: remove)"
}

# Function to perform cleanup and exit
cleanup_and_exit() {
  local exit_code=$1
  local log_file=$2

  # Log end time
  echo "Script completed at: $(date +'%Y-%m-%d %H:%M:%S')" >> "${log_file}"

  echo "Scraping and conversion completed."

  # Display log file if there are errors
  if [ "${exit_code}" -ne 0 ]; then
    echo "Check the log file '${log_file}' for details."
  fi

  exit "${exit_code}"
}

# Function to print progress
print_progress() {
  local current=$1
  local total=$2
  local progress=$((current * 100 / total))
  printf "Progress: %3d%% [%d/%d]\r" "${progress}" "${current}" "${total}"
}

# Initialize variables with default values
OUTPUT_DIRECTORY="website"
PANDOC_OPTIONS="--from=html"
LOG_FILE="scrape_log_$(date +'%Y%m%d_%H%M%S').txt"
CONVERT_TO_MARKDOWN=0
CONVERT_TEXT_TO_MARKDOWN=0
KEEP_HTML=0

# Parse command-line options
while getopts ":o:mtc" opt; do
  case $opt in
    o)
      OUTPUT_DIRECTORY="${OPTARG}"
      ;;
    m)
      CONVERT_TO_MARKDOWN=1
      ;;
    t)
      CONVERT_TEXT_TO_MARKDOWN=1
      ;;
    c)
      KEEP_HTML=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      display_usage
      exit 1
      ;;
  esac
done

# Shift option index so that $1 now refers to the website URL
shift $((OPTIND-1))

# Check if URL is provided
if [ -z "${1}" ]; then
  display_usage
  exit 1
fi

# Validate URL format
if ! [[ "${1}" =~ ^https?:// ]]; then
  echo "Error: Invalid URL format. Please provide a valid URL."
  exit 1
fi

# Create a directory to store the scraped content
mkdir -p "${OUTPUT_DIRECTORY}" || { echo "Error: Unable to create the output directory '${OUTPUT_DIRECTORY}'."; cleanup_and_exit 1 "${LOG_FILE}"; }

# Log start time
echo "Script started at: $(date +'%Y-%m-%d %H:%M:%S')" >> "${LOG_FILE}"

# Download the website
echo "Downloading website..."
wget --recursive --no-clobber --convert-links --adjust-extension --restrict-file-names=windows --no-parent -N -P "${OUTPUT_DIRECTORY}" "${1}" >> "${LOG_FILE}" 2>&1

# Check if wget encountered any errors
if [ $? -ne 0 ]; then
  echo "Error: Downloading failed."
  cleanup_and_exit 1 "${LOG_FILE}"
fi

# Get total number of HTML files
total_files=$(find "${OUTPUT_DIRECTORY}" -type f -name '*.html' | wc -l)
current_file=0

# Convert HTML files to text or Markdown using pandoc in parallel
echo "Converting HTML to $( [ ${CONVERT_TO_MARKDOWN} -eq 1 ] && echo "Markdown" || echo "Plain Text" )..."
find "${OUTPUT_DIRECTORY}" -type f -name '*.html' -print0 | \
xargs -0 -n 1 -P 4 bash -c '
  output_file="${1%.html}.'$( [ ${CONVERT_TO_MARKDOWN} -eq 1 ] && echo "md" || echo "txt" )'"
  echo "Converting $1 to ${output_file}..." >> "${LOG_FILE}"
  pandoc -s "$1" '"${PANDOC_OPTIONS}"' -o "${output_file}" && ((current_file++)) && print_progress "${current_file}" "${total_files}" >> "${LOG_FILE}"
' _


# Convert plain text to Markdown if specified
if [ ${CONVERT_TEXT_TO_MARKDOWN} -eq 1 ]; then
  echo "Copying plain text to Markdown..."
  find "${OUTPUT_DIRECTORY}" -type f -name '*.txt' -print0 | \
  xargs -0 -n 1 -I {} bash -c 'cp "$1" "${1%.txt}.md"' _ {}
fi




# Remove HTML files if specified
if [ "${KEEP_HTML}" -eq 0 ]; then
  echo "Removing HTML files..."
  find "${OUTPUT_DIRECTORY}" -type f -name '*.html' -delete
fi

# Cleanup and exit successfully
cleanup_and_exit 0 "${LOG_FILE}"
