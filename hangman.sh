#!/bin/bash

#declare global variables
word=0
incorrectGuesses=0
alphabetindex=0
wordindex=0
guessedletter=0
correctguess=0
goodguesses=0
wordlength=0
triesremaining=11
declare -a word_guessed
declare -a alphabet_guessed
declare -a word_array
    

#select a word from the "galgjewoorden file"
function selectWord {
    word=$(shuf -n 1 /home/ronan/bin/galgjewoorden)
}


#let the user enter a character and check if its valid and in the word
function userGuess {

    valid=0
    correctInput=0
    echo "Enter a letter: "
    read input
    while [ "$correctInput" == "0" ]
    do
        if [ ${#input} -eq "1" ]
            correctInput=1
            then
                e=0

                while [ "$valid" == "0" ]
                do
                    if [[ "${input//[A-Za-z]/}" = "" ]]
                    then
                        valid=1
                    fi

                    if [ "$valid" == "0" ]
                    then
                       echo "Wrong input, please enter a new letter"
                       read input

                       if [ ${#input} -eq "1" ]
                       then                 
                           e=0
                       fi
                    fi
                done
          guessedletter=$input
        fi
    done
}


#check if the entered letter is in the word or entered before
function checkGuess {
    new=1
    
    if [[ $word == *"$guessedletter"* ]]
    then
        occurances=$(echo "${word}" | awk -F"${guessedletter}" '{print NF-1}')
        i=0
        while [ ! "$i" == "$alphabetindex" ]
        do
           if [ "$guessedletter" == "${alphabet_guessed[$i]}" ]
           then                  
           new=0                    
           fi
           i=$((i+1))
        done
        
        if [ "$new" == "1" ]
        then
            correctguess=1
            goodguesses=$((goodguesses+occurances))
            echo "Correct!"
            
            i=0
            while [[ $i -le $word_length ]]
            do
                if [ "$guessedletter" == "${wordarray[$i]}" ]
                then
                    word_guessed[$i]="$guessedletter"
                fi
            i=$((i+1))
            done
        else
            echo "Incorrect, you already guessed that letter"
            triesremaining=$((triesremaining-1))      
        fi

    else
        echo "Incorrect"
        triesremaining=$((triesremaining-1))     
    fi
}


#Print the letters you already guessed
function printAlphabet {
    echo "Already guessed: "
    alphabet_guessed[$alphabetindex]="$guessedletter"
    echo "${alphabet_guessed[*]}"
    alphabetindex=$((alphabetindex+1))
}


#Fill the word array with dots
function printWord {
    i=0
    while [[ $i -lt $word_length ]]
    do
    word_guessed+=(.)
    i=$((i+1))  
    done
    echo "The word so far: "${word_guessed[@]}""
}

#Update the word array with the letters the user guessed
function updateWord {
    echo "The word so far: "${word_guessed[@]}""  
}


#the main program starts here
selectWord;
word_length=${#word}
printWord;
wordarray=( $(echo $word | grep -o .) )
echo "${wordarray[@]}"

playing=1


while [ "$playing" == "1" ]
do
    userGuess;
    checkGuess;

    if [ "$playing" == "1" ]
    then
        
        echo ""
        printAlphabet
        echo ""
        updateWord
        echo ""
        echo ""
    fi

    if [ "$triesremaining" -lt "1" ]
    then
        echo "Game over, you lost"
        playing=0
    fi

    if [ "$goodguesses" == "$word_length" ]
    then
        echo "You won!"
        echo "The word was "$word"!"
        playing=0
    fi
    
    if [ "$playing" == "1" ]
    then
        echo "You have "$triesremaining" tries remaining"
        echo ""
        echo ""
        echo ""
    fi
done







