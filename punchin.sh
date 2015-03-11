#!/bin/bash
DEFAULT_USERNAME="lokkesmoej"

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
   echo $res | awk '{ if (match($0, /\"message\":\"[^\"]*\"/)) print substr($0, RSTART+11, RLENGTH-12); else print "Unknown error punching in." }'
else
   printf "Punched in to CSSE Hub successfully\n"
fi

printf "\nLog in to IO? (y/n):"
read doIo

if [[ $doIo == *y* ]]; then
   sshpass -p $password ssh $username@io.uwplatt.edu
fi
