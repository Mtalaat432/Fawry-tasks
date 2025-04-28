#!/bin/bash

# Function to show help
show_help() {
    echo "Usage: $0 [options] search_string filename"
    echo "Options:"
    echo "  -n    Show line numbers for matches"
    echo "  -v    Invert match (show lines that do not match)"
    echo "  --help Show this help message"
}

# Check for --help
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

show_line_numbers=false
invert_match=false

while getopts ":nv" opt; do
  case $opt in
    n)
      show_line_numbers=true
      ;;
    v)
      invert_match=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      show_help
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ $# -lt 2 ]; then
    echo "Error: Missing search string or filename."
    show_help
    exit 1
fi

search_string="$1"
file="$2"

if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Build grep options
grep_options="-i"  # case insensitive

if $invert_match; then
    grep_options="$grep_options -v"
fi

if $show_line_numbers; then
    grep_options="$grep_options -n"
fi

grep $grep_options -- "$search_string" "$file"
