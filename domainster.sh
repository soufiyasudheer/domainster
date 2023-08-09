#!/bin/bash

# Autor : Soufiya sudheer

#Creating temporary file for saving data
maketmp(){
    mkdir -p tmp_domain
    touch tmp_domain/tmp_subdomains.txt
    touch tmp_domain/tmp_alive.txt
    touch tmp_domain/tmp_sorted.txt
}

read -p "Enter the domain: " domain
maketmp

# Collecting subdomains
echo "Collecting subdomains"
assetfinder -subs-only "$domain" | tee tmp_domain/tmp_subdomains.txt | bar
count=$(cat tmp_domain/tmp_subdomains.txt | wc -l)
echo "########################################"

# Collecting alive subdomains
echo "Collecting alive subdomains"
cat tmp_domain/tmp_subdomains.txt | httprobe | tee tmp_domain/tmp_alive.txt | bar
count1=$(cat tmp_domain/tmp_alive.txt | wc -l)
echo "########################################"


#Collecting sorted subdomains
cat tmp_domain/tmp_alive.txt | sort -u | tee tmp_domain/tmp_sorted.txt | bar
count2=$(cat tmp_domain/tmp_sorted.txt | wc -l)
echo "########################################"


#File saving options
read -p "Do you want to save the subdomains [ENTER = Y/N]? " save
case $save in
    [yY]|[Yy][eE][sS])
        read -p "Enter the directory name to save subdomains: " dom
        if [[ ! -d "$domain" ]]; then
            mkdir "$domain"
        fi
        cp tmp_domain/tmp_subdomains.txt "$dom/subdomains.txt"
        echo "Subdomains saved."
        ;;
      *)
        echo "Subdomains not saved."
        ;;
esac

read -p "Do you want to save the 'alive subdomains' [ENTER = Y/N]? " save
case $save in
    [yY]|[Yy][eE][sS])
        read -p "Enter the directory name to save alive subdomains: " dom
        if [[ ! -d "$domain" ]]; then
            mkdir "$domain"
        fi
        mv tmp_domain/tmp_alive.txt "$dom/alive_subdomains.txt"
        echo "Alive subdomains saved."
        ;;
      *)
        echo "Alive subdomains not saved."
        ;;
esac

read -p "Do you want to save the 'sorted subdomains' [ENTER = Y/N]? " save
case $save in
    [yY]|[Yy][eE][sS])
        read -p "Enter the directory name to save sorted subdomains: " dom
        if [[ ! -d "$domain" ]]; then
            mkdir "$domain"
        fi
        mv tmp_domain/tmp_sorted.txt "$dom/sorted_subdomains.txt"
        echo "Sorted subdomains saved."
        ;;
      *)
        echo "Sorted subdomains not saved."
        ;;
esac

#Display counts
echo "########################################"
echo "Total $count Subdomains found."
echo "Total $count1 Alive subdomains found."
echo "Total $count2 sorted subdomains found."


#Cleaning Temporary files
clean_tmp(){
rm -r tmp_dom
echo "Script execution completed "
}

