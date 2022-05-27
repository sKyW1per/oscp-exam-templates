#!/bin/bash

if [ "$#" -ne 1 ]; then
        echo "usage: $0 <input.md>"
        exit
fi

INPUT="$1"
OSID="12345"
EXAM_REPORT="OSCP-OS-$OSID-Exam-Report.pdf"
ZIP_PACKAGE="OSCP-OS-$OSID-Exam-Report.7z"

echo "Generating exam report..."
./generate_report.sh $INPUT $EXAM_REPORT

echo "Creating 7z package..."
7z a $ZIP_PACKAGE -pOS-$OSID $EXAM_REPORT

echo "Done! The result is saved as $ZIP_PACKAGE"
