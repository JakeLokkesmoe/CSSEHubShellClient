#!/bin/bash
DEFAULT_USERNAME="YOUR_USERNAME_HERE"

# IMPORTANT *************
# Set the Defualt username to your username and the IO_REPO_PATH (line 44) to the path to your project repo on IO.

#clean up session file on exit
trap "rm -f cookiefile" EXIT

printf "Login to CSSE Hub:\n"
printf "Username: "
read username

# if no username is provided, use the defualt one
if [ -z "$username" ]; then
   username=$DEFAULT_USERNAME
fi

printf "Password: " 
read -s password
printf "\n"

# Log in to CSSE hub
res=$(curl -silent -L -c cookiefile -d "username=$username&password=$password&remember=false" https://xray.ion.uwplatt.edu/CSSE/Account/Login?returnUrl=)

# if the response contains the word "incorrect"
if [[ $res == *incorrect* ]]; then
   printf "\nError: The username or password provided is incorrect\n"; exit 1
fi

res=$(curl -silent -L -b cookiefile -d "courseName=se4730&projectName=Project&inComment=&inPhase=Coding" http://xray.ion.uwplatt.edu/CSSE/Home/PunchIn)
printf "\n"

#if error punching
if [[ $res != *\"status\":\"ok\"* ]]; then
   printf "Error: "
   echo $res | awk '{ if (match($0, /\"message\":\"[^\"]*\"/)) print substr($0, RSTART+11, RLENGTH-12); else print "Unknown error punching out." }'
else
   printf "Punched in to CSSE Hub successfully\n"
fi

#Now logs into IO by default
printf "\nLogging into IO... (Exit ssh to punch out)\n"
sshpass -p $password ssh $username@io.uwplatt.edu -t 'cd IO_REPO_PATH; pwd; svn update; ls; $SHELL'

printf "\nEnter punch out message or leave blank to remain punched in:\n"
read message

if [ -z "$message" ]; then # if the message is null
   printf "You are still punched in.\n"; exit 0
fi

phase="NO_PHASE"

while [ "$phase" = "NO_PHASE" ]; do
   printf "\nPhases:\n  C  - Coding\n  D  - Debugging\n  De - Design\n  I  - Integration\n  M  - Meeting\n  Mi - Misc\n  R  - Research\n  T  - Testing\nEnter Phase: "
   read phase

   if [ "$phase" = "C" -o "$phase" = "c" ]; then
      phase="Coding"
   elif [ "$phase" = "D" -o "$phase" = "d" ]; then
      phase="Debugging"
   elif [ "$phase" = "De" -o "$phase" = "de" ]; then
      phase="Design"
   elif [ "$phase" = "I" -o "$phase" = "i" ]; then
      phase="Integration"
   elif [ "$phase" = "M" -o "$phase" = "m" ]; then
      phase="Meeting"
   elif [ "$phase" = "Mi" -o "$phase" = "mi" ]; then
      phase="Misc"
   elif [ "$phase" = "R" -o "$phase" = "r" ]; then
      phase="Research"
   elif [ "$phase" = "T" -o "$phase" = "t" ]; then
      phase="Testing"
   else
      phase="NO_PHASE"
   fi
done

res=$(curl -silent -L -b cookiefile -d "courseName=se4730&projectName=Project&inComment=$message&inPhase=$phase" http://xray.ion.uwplatt.edu/CSSE/Home/punchout)
printf "\n"

#if error punching
if [[ $res != *\"status\":\"ok\"* ]]; then
   printf "Error: "
   echo $res | awk '{ if (match($0, /\"message\":\"[^\"]*\"/)) print substr($0, RSTART+11, RLENGTH-12); else print "Unknown error punching in." }'
else
   printf "Punched out of CSSE Hub successfully\n"
fi
