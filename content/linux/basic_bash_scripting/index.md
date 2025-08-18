# Basic Bash Scripting

Source: [FreeCodeCamp YT Video](https://www.youtube.com/watch?v=tK9Oc6AEnR4)

## First Executable

```
$ echo Hello
# Output: Hello
```

```
# File: textfile.txt
Hello World!
```

```
$ cat textfile.txt
# Output: Hello World!
```

```
# File: shelltest.sh
echo Hello World!
```

```
$ bash shelltest.sh
# Output: Hello World!
```

```
$ echo $SHELL
# Output: /bin/bash
```

```
# File: shelltest.sh
#!/bin/bash
echo Hello World!
```

```
$ chmod u+x shelltest.sh
$ ./shelltest.sh
# Output: Hello World!
```

## Variables

```
# File: hellothere.sh
#!/bin/bash
FIRST_NAME=Josh
LAST_NAME=Garber
echo Hello $FIRST_NAME $LAST_NAME
```

```
$ ./hellothere.sh
# Output: Hello Josh Garber
```

## Read (Inputs)

```
# File: interactiveshell.sh
#!/bin/bash
echo What is your first name?
read FIRST_NAME
echo What is your last name?
read LAST_NAME
echo Hello $FIRST_NAME $LAST_NAME
```

```
$ ./interactiveshell.sh
# Output: What is your name? ...
#         ...
#         Hello Josh Garber
```

## Positional Arguments

```
# File: posargu.sh
#!/bin/bash
echo Hello $1 $2
```

```
$ ./posargu.sh Josh Garber
# Output: Hello Josh Garber
```

## Output/Input Redirection

```
$ echo Hello World! > hello.txt
$ cat hello.txt
# Output: Hello World!
```

```
$ echo Good day to you! > hello.txt
$ cat hello.txt
# Output: Good day to you!
```

```
$ rm hello.txt
$ echo Hello world >> hello.txt
$ cat hello.txt
# Output: Hello world
$ echo Good day to you >> hello.txt
$ cat hello.txt
# Output:
# Hello world
# Good day to you
```

```
$ wc -w hello.txt
# Output:
# 6 hello.txt
$ wc -w < hello.txt
# Output:
# 6
```

```
$ cat << EOF
> I will
> write some
> text here
> EOF
# Output:
# I will
# write some
# text here
```

```
$ wc -w <<< "Hello there wordcount!"
# Output: 3
# Note: the string must in double-quotes.
```

## Test Operators

```
$ [ hello = hello ]
$ echo $?
# Output: 0
```

```
$ [ 1 = 0 ]
$ echo $?
# Output: 1
```

```
$ [ 1 -eq 1 ]
$ echo $?
# Output: 0
```

## If/Elif/Else

```
# File: ifelifelse.sh
#!/bin/bash
if [ ${1,,} = josh ]; then
    echo "Oh, you're the boss here, Welcome!"
elif [ ${1,,} = help ]; then
    echo "Just enter your username, duh!"
else
    echo "I don't know who you are. But you're not the boss of me!"
fi
```

```
$ ./ifelifelse.sh josh
# Output: Oh, you're the boss here, Welcome!
$ ./ifelifelse.sh jOsH
# Output: Oh, you're the boss here, Welcome!
$ ./ifelifelse help
# Output: Just enter your username, duh!
$ ./ifelifese whatever
# Output: I don't know who you are. But you're not the boss of me!
```

## Case Statements

```
# File: login.sh
#!/bin/bash
case ${1,,} in
    josh | admin)
        echo "Hello, you're the boss here!"
        ;;
    help)
        echo "Just enter your username!"
        ;;
    *)
        echo "Hello there. You're not the boss of me. Enter a valid username!"
esac
```

```
$ ./login.sh josh
# Output:
# Hello, you're the boss here!
$ ./login.sh Josh
# Output:
# Hello, you're the boss here!
$ ./login.sh admin
# Output:
# Hello, you're the boss here!
$ ./login.sh Admin
# Output:
# Hello, you're the boss here!
$ ./login.sh help
# Output:
# Just enter your username!
$ ./login.sh hElP
# Output:
# Just enter your username!
$ ./login.sh anything
# Output:
# Hello there. You're not the boss of me. Enter a valid username!
```

## Arrays

```
$ MY_FIRST_LIST=(one two three four five)
$ echo ${MY_FIRST_LIST[@]}
# Output:
# one two three four five
$ echo ${MY_FIRST_LIST[0]}
# Output:
# one
```

## For Loop

```
$ for item in ${MY_FIRST_LIST[@]}; do echo -n $item | wc -c; done
# Output:
# 3
# 3
# 5
# 4
# 4
```

## Functions

```
# File: firstfunction.sh
#/bin/bash
showuptime(){
    up=$(uptime -p | cut -c4-)
    since=$(uptime -s)
    cat << EOF
-----
This machine has been up for ${up}
It has been running since ${since}
-----
EOF
}
showuptime
```

```
$ ./firstfunction.sh
# Output:
# -----
# This machine has been up for 2 days, 8 hours, 2 minutes
# It has been running since 2025-08-09 06:25:21
# -----
```

```
# File: firstfunctionlocal.sh
#/bin/bash
up="global up"
since="global since"
showuptime(){
    local up=$(uptime -p | cut -c4-)
    local since=$(uptime -s)
    cat << EOF
-----
This machine has been up for ${up}
It has been running since ${since}
-----
EOF
}
showuptime
echo $up
echo $since
```

```
$ ./firstfunctionlocal.sh
# Output:
# -----
# This machine has been up for 2 days, 8 hours, 8 minutes
# It has been running since 2025-08-09 06:25:21
# -----
# global up
# global since
```

```
# File: functionposargu.sh
#!/bin/bash
showname(){
    echo hello $1
}
showname Josh
```

```
$ ./functionposargu.sh
# Output:
# hello Josh
```

## Exit Codes

```
# File: exitcode.sh
#/bin/bash
showname(){
    echo hello $1
    if [ ${1,,} = josh ]; then
        return 0
    else
        return 1
    fi
}
showname $1
if [ $? = 1 ]; then
    echo "Someone unknown called the function!"
fi
```

```
$ ./exitcode.sh josh
# Output:
# hello josh
$ ./exitcode.sh test
# Output:
# hello test
# Someone unknown called the function!
```

## AWK

```
# File: awktext.txt
one two three
```

```
$ awk '{print $1}' awktext.txt
# Output:
# one
$ awk '{print $2}' awktext.txt
# Output:
# two
```

```
# File: awkcsv.csv
one,two,three
```

```
$ awk -F, '{print $1}' awkcsv.csv
# Output:
one
```

```
$ echo "Just get this word: Hello" | awk '{print $5}'
# Output:
# Hello
$ echo "Just get this word: Hello" | awk -F: '{print $2}' | cut -c2-
# Output:
# Hello
```

## SED

```
# File: sedtest.txt
The grasshopper flies like no grasshopper flies.
A grasshopper is an insect that has wings and a grasshopper likes to eat leftovers.
```

```
$ sed 's/grasshopper/fly/g' sedtest.txt
# Output:
# The fly flies like no fly flies.
# A fly is an insect that has wings and a grasshopper likes to eat leftovers.
$ sed -i.ORIGINAL 's/grasshopper/fly/g' sedtest.txt
$ cat sedtest.txt
# Output:
# The fly lies like no fly flies.
# A fly ...
$ cat sedtest.txt.ORIGINAL
# Output:
# A grasshopper flies like no grasshopper flies.
# A grasshopper ...
```
