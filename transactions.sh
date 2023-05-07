#!/bin/bash

touch tagJxc4
grep -E -o '[^0-9][A-Z]....' $1  > tagJxc4   #creates a file with tags 

touch uniqTagJxc4
cat tagJxc4 |sort |uniq > uniqTagJxc4        #outputs a file with unique tags
 
while read -r line; do
    touch "unsortedjxc4$line"
    touch "$line"
done < uniqTagJxc4                           #creates a file with tag name for each line in uniqTagJxc

while read -r line; do
    TAG=${line:5:6}
    PRICE=${line:11:5}
    DATE=${line:16:10}
    echo "$DATE $PRICE $TAG" >> "unsortedjxc4$TAG"
done < $1                                    #makes a new file for each tag with lines reformatted

while read -r line; do
    sort -n -t"/" -k3 -k1.2n -k2.4 "unsortedjxc4$line" >> "sortedjxc4$line" #makes a new file for each tag with lines reformatted and sorted
    touch $line
    touch "lastjxc4$line"
    
    prev=0
    TOTAL=0
    while read -r payment; do
        PRICE=${payment:11:5}
        DATE=${payment:0:10}
        TOTAL=$(bc -l <<<"${TOTAL} + ${PRICE}") # adds the sums and prints the dates
        if [[ $prev != $DATE ]] && [[ $prev != 0 ]]; then
            if [[ ${#total} = 4 ]]; then
                echo "$prev,0$total" >> $line
            elif [[ ${#total} < 4 ]]; then
                echo "$prev,00$total" >> $line
            else
                echo "$prev,$total" >> $line
            fi
        fi
        total=$TOTAL
        prev=${payment:0:10}
    done < "sortedjxc4$line"
    
    TOTAL=0
    while read -r payment; do
        PRICE=${payment:11:5}
        DATE=${payment:0:10}
        TOTAL=$(bc -l <<<"${TOTAL} + ${PRICE}")
        if [[ ${#TOTAL} = 4 ]]; then
            echo "$DATE,0$TOTAL" >> "lastjxc4$line"
        elif [[ ${#total} < 4 ]]; then
            echo "$DATE,00$TOTAL" >> "lastjxc4$line"
        else
            echo "$DATE,$TOTAL" >> "lastjxc4$line"
        fi
    done < "sortedjxc4$line"
    tail -n 1 "lastjxc4$line" >> $line #adds last line
done < uniqTagJxc4                          

