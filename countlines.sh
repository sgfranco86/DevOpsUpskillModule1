#!/bin/bash

# Function to display the help message
show_help() {
    echo "Usage: $0 [-o owner] [-m month]"
    echo "Options:"
    echo "-o <owner> : Select files where the owner is <owner>"
    echo "-m <month> : Select files where the creation month is <month>"
    exit 1
}

# Function to count lines in text files for the given owner and month
count_lines() {
    local owner="$1"
    local month="$2"
    local count=0

    # Loop through all text files in the current directory
    for file in *.txt; do
        if [[ -f "$file" ]]; then
            local file_owner=$(stat -c %U "$file")
            local file_month=$(stat -c %y "$file" | awk '{print $2}')

            # Check if the owner matches, and if month is not empty, check if it matches
            if [[ -z "$owner" || "$file_owner" == "$owner" ]] && [[ -z "$month" || "$file_month" =~ ^$month$ ]]; then
                count=$((count + $(grep -c '.' "$file")))
            fi
        fi
    done

    echo "Selected Month: $month"
    echo "Total lines: $count"
}

# Parse command-line options
while getopts ":o:m:" opt; do
    case $opt in
        o)
            owner="$OPTARG"
            ;;
        m)
            month="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            show_help
            ;;
    esac
done

# Check if owner or month option is provided
if [[ -z "$owner" && -z "$month" ]]; then
    show_help
fi

# Call the count_lines function with the provided owner and month
count_lines "$owner" "$month"
