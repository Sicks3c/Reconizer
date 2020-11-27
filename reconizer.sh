#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
END='\033[0m'

QUOTES=(
        "Activating 1337 mode!"
        "Target uses Equifax-grade security."
        "ᕕ( ᐛ )ᕗ"
        "ᕕ( ᐕ )ᕗ"
        "三三ᕕ( ᐛ )ᕗ"
        "ᐠ( ᐛ )ᐟ"
        "Never gonna give you up."
        "Js pls."
        "Update pls."
        "Sleep is for the weak."
        "Grab a cuppa!"
        "js, js+ on steroids."
        "I am 100 percent natural."
        "A bug is never just a mistake. It represents something bigger. An error of thinking that makes you who you are."
        "You hack people. I hack time."
        "I hope you don't screw like you type."
        "Hack the planet!"
        "Crypto stands for cryptography."
        "PoC||GTFO"
)

rand=$((RANDOM % ${#QUOTES[@]}))
printf "${YELLOW}[i]${END} ${QUOTES[$rand]}\n"
echo

ORG=$1

getrange () {
    printf "${GREEN}[+]${END} Getting IP Range of $ORG\n"
    cat "$ORG-ASN.txt" | metabigor net --asn | tee -a $ORG-range.txt
}

getasn () {
    printf "${GREEN}[+]${END} Getting ASN of $ORG\n"
    amass intel -org "$ORG" | awk -F ',' '{print $1}' | tee -a $ORG-ASN.txt
}

getcert () {
    printf "${GREEN}[+]${END} Getting Cert for $ORG\n"
    for range in $(cat $ORG-range.txt); do amass intel -active -cidr $range;done | tee -a $ORG-domains2.txt
}

getcert2(){
    printf "${GREEN}[+]${END} Getting V2 Cert for $ORG\n"
    for asn in $(cat $ORG-ASN.txt);do amass intel -active -asn $asn;done | tee -a $ORG-domains.txt
}

getdomains(){
    printf "${GREEN}[+]${END} Sorting domains\n"
    cat $ORG-domains* | sort -u | tee -a $ORG-unique
    printf "${GREEN}[+]${END} Getting domains from all\n"
    amass enum -df unique -config /opt/config.ini
    printf "${YELLOW}[+]${END} Cleaning Thrash.\n"
    mkdir $ORG ; mv *.txt $ORG/
    printf "${YELLOW}[+]${END} Script is done.\n"
}
getasn
getrange
getcert
getcert2
getdomains
