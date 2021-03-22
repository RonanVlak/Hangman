#!/bin/bash

#declare global variables
word=0
incorrectGuesses=0
alphabetindex=0
wordindex=0
guessedletter=0
goodguesses=0
wordlength=0
wordspath="/usr/share/dict/words" #The default path to the words
triesremaining=11

declare -a word_guessed
declare -a alphabet_guessed
declare -a word_array
alphabet="abcdefghijklmnopxrstuvwxyz" 

trap interruptHandler SIGINT;  

#Select a word from the entered words path
function selectWord {
    if [ -f "$wordspath" ]
    then    
        echo "A random word will be selected for you"    
        word=$(shuf -n 1 "$wordspath")
        play;
    else 
        echo "That path doesn't exit, program will exit"
        exit 1;
    fi
}

#Let a user enter a word and check if it is valid 
function enterWord {
    valid=0
    correctInput=0
    read input
    while [ "$correctInput" == "0" ]
    do              
         #Convert the input to all lowercase
         input=`echo $input | tr "[:upper:]" "[:lower:]"`

         while [ "$valid" == "0" ]
         do

             #Check if the input is a alphabetic character
             if [[ "${input//[A-Za-z]/}" = "" ]]
             then                     
                 valid=1                     
             fi

             if [ "$valid" == "0" ]
             then
                 echo "Wrong input, please enter a new word"
                 read input
             fi
         done
        word="$input"       
        correctInput=1
    done
    printf "\ec"
    play;
}

#let the user enter a character and check if its valid and in the word
function userGuess {
    valid=0
    correctInput=0
    echo "Enter a letter: "
    read input
    while [ "$correctInput" == "0" ]
    do              
         #Convert the input to all lowercase
         input=`echo $input | tr "[:upper:]" "[:lower:]"`

         while [ "$valid" == "0" ]
         do

            #Check if the input is a alphabetic character
             if [[ "${input//[A-Za-z]/}" = "" ]] && [[ ${#input} -eq 1 ]]
             then
                     
                 valid=1                     
             fi

             if [ "$valid" == "0" ]
             then
                 echo "Wrong input, please enter a new letter"
                 read input
             fi
         done
        guessedletter=$input       
        correctInput=1
    done
}


#check if the entered letter is in the word or entered before
function checkGuess {
    new=1
    
    #If the letter is in the word
    if [[ $word == *"$guessedletter"* ]]
    then
        occurances=0
        index=0

        #Check if the letter was already guessed
        while [ ! "$index" == "$alphabetindex" ]
        do
           if [ "$guessedletter" == "${alphabet_guessed[$index]}" ]
           then                  
               new=0                    
           fi
           index=$((index+1))
        done
        
        #The letter was not guessed before
        if [ "$new" == "1" ]
        then
            echo "Correct!"
            
            #Update the word_guessed array with the correctly guessed letter
            i=0
            while [[ $i -le $word_length ]]
            do
                if [ "$guessedletter" == "${wordarray[$i]}" ]
                then
                    word_guessed[$i]="$guessedletter"
                    occurances=$((occurances+1))
                fi
            i=$((i+1))
            done

            #update the alphabet with the letter you guessed
            alphabet=$(echo ""$alphabet"" | tr -d "$guessedletter")

            goodguesses=$((goodguesses+occurances))
        else
            echo "Incorrect, you already guessed that letter"

            triesremaining=$((triesremaining-1))      
        fi

    else
        echo "Incorrect"
        #update the alphabet with the letter you guessed
        alphabet=$(echo ""$alphabet"" | tr -d "$guessedletter")
          
        triesremaining=$((triesremaining-1))     
    fi
}


#Print the letters you already guessed
function printAlphabetGuessed {
    echo "Already guessed: "
    alphabet_guessed[$alphabetindex]="$guessedletter"
    echo "${alphabet_guessed[*]}"
    alphabetindex=$((alphabetindex+1))
}

#Print the alphabet of letters yet to guess
function printAlphabetNotGuessed {
    echo "Letters you have not guessed yet: "
    echo "$alphabet"
}

#Fill the word array with dots for the letters
function fillWordArray {
    i=0
    while [[ $i -lt $word_length ]]
    do
    word_guessed+=(.)
    i=$((i+1))  
    done
    echo "The word so far: "${word_guessed[@]}""
}

#If the user exits the script with ctrl+c
function interruptHandler {
    echo ""
    echo "You aborted the game"
    echo ""
    echo "The word should have been: "$word""
    exit 1
}

function mistake_1 {
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo "__________________"
}

function mistake_2 {
    echo ""
    echo "              |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "______________|__"
}

function mistake_3 {
    echo "      _________"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "______________|__"
}

function mistake_4 {
    echo "      _________"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "_____________/|\_"
}

function mistake_5 {
    echo "      _________"
    echo "        |     |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "_____________/|\_"
}

function mistake_6 {
    echo "      _________"
    echo "        |     |"
    echo "        O     |"
    echo "              |"
    echo "              |"
    echo "              |"
    echo "_____________/|\_"
}

function mistake_7 {
    echo "      _________"
    echo "        |     |"
    echo "        O     |"
    echo "        |     |"
    echo "              |"
    echo "              |"
    echo "_____________/|\_"
}

function mistake_8 {
    echo "      _________"
    echo "        |     |"
    echo "        O     |"
    echo "        |     |"
    echo "       /      |"
    echo "              |"
    echo "_____________/|\_"
}

function mistake_9 {
    echo "      _________"
    echo "        |     |"
    echo "        O     |"
    echo "        |     |"
    echo "       / \    |"
    echo "              |"
    echo "_____________/|\_"
}

function mistake_10 {
    echo "      _________"
    echo "        |     |"
    echo "        O     |"
    echo "       -|     |"
    echo "       / \    |"
    echo "              |"
    echo "_____________/|\_"
}

function mistake_11 {
    echo "      _________"
    echo "        |     |"
    echo "        O     |"
    echo "       -|-    |"
    echo "       / \    |"
    echo "              |"
    echo "_____________/|\_"
}




#the main program starts here
function play {
    word_length=${#word}
    fillWordArray;
    wordarray=( $(echo $word | grep -o .) )
    echo "${wordarray[@]}"

    playing=1

    echo ""
    printAlphabetNotGuessed
    echo ""

    while [ "$playing" == "1" ]
    do
        userGuess;
        checkGuess;

        if [ "$playing" == "1" ]
        then
            echo ""
            printAlphabetNotGuessed
            echo ""
            printAlphabetGuessed
            echo ""
            echo "The word so far: "${word_guessed[@]}""
            echo ""
            echo ""
        fi

        if [ "$triesremaining" -lt "1" ]
        then
            mistake_11;
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
            if [ "$triesremaining" == "10" ]
            then
                mistake_1;
            fi
            if [ "$triesremaining" == "9" ]
            then
                mistake_2;
            fi
            if [ "$triesremaining" == "8" ]
            then
                mistake_3;
            fi
            if [ "$triesremaining" == "7" ]
            then
                mistake_4;
            fi
            if [ "$triesremaining" == "6" ]
            then
                mistake_5;
            fi
            if [ "$triesremaining" == "5" ]
            then
                mistake_6;
            fi
            if [ "$triesremaining" == "4" ]
            then
                mistake_7;
            fi
            if [ "$triesremaining" == "3" ]
            then
                mistake_8;
            fi
            if [ "$triesremaining" == "2" ]
            then
                mistake_9;
            fi
            if [ "$triesremaining" == "1" ]
            then
                mistake_10;
            fi
            echo "You have "$triesremaining" tries remaining"
            echo ""
            echo ""
            echo ""
        fi
    done
}

#Check the arguments given to the script using getopts    
while getopts :wd:h opt
do 
case $opt in 
    w)
        echo "Please enter a word: "
        enterWord;
        ;;
    d)       
        wordspath="$OPTARG"
        selectWord;
        ;;
    h)
        echo "Options:"
        echo "-w    : With this option, you can enter a word for the game"
        echo "-d    : With this option, a random word will be selected for you, takes a path to a document with playing words"
        echo "        Example: /home/ronan/bin/galgjewoorden"
        echo "-h    : The options of this program will be displayed"
        ;;
    \?)
        echo "invalid option: -$OPTARG, enter -h to see the list of options" >&2
        exit;
        ;;
    :)
        echo "-$OPTARG needs parameter, enter -h to see the list of options" >&2
        ;;
    esac
done
shift $((OPTIND-1))







