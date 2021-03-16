#!/bin/bash

#declare global variables
word=0
incorrectGuesses=0
alphabet=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z") 
alphabetindex=0
wordindex=0
guessedletter=0
correctguess=0
goodguesses=0
triesremaining=11
declare -a word_guessed
declare -a alphabet_guessed


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
                    #Check if the input is an alphabetic value
                    while [ ! "$e" == "26" ] 
                    do
                        
                        if [ "$input" == "${alphabet[$e]}" ]
                        then                  
                            valid=1                    
                        fi
                        e=$((e+1))
                    done
                    
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
        else
            echo "Incorrect, you already guessed that letter"
            triesremaining=$((triesremaining-1))      
        fi

    else
        echo "Incorrect"
        triesremaining=$((triesremaining-1))     
    fi
}


function printAlphabet {
    echo "Already guessed: "
    alphabet_guessed[$alphabetindex]="$guessedletter"
    
    echo "${alphabet_guessed[*]}"
    alphabetindex=$((alphabetindex+1))
}

function printWord {
    echo "$word"
}


#the main program starts here
selectWord;
word_length=${#word}
printWord;

playing=1
while [ "$playing" == "1" ]
do
    userGuess;
    checkGuess;


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
        echo ""
        echo "The word so far: "$word""
        echo ""
        echo ""
        printAlphabet;
        echo ""
        echo ""
        echo ""
        echo "You have "$triesremaining" tries remaining"
        echo ""
        echo ""
        echo ""
    fi
done







