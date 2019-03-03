#!/bin/bash
# set -xv
espeak "Hi Rob! Who is with you today?";
read line;
echo $line;
espeak "Hi $line ! Nice to meet you!";
