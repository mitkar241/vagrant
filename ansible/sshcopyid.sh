#!/usr/bin/env bash
# chmod +x sshcopyid.sh
#./sshcopyid.sh control-01.ctrl.mitkar241.io control-02.ctrl.mitkar241.io

USER="mitkar241"
PWDLOC="/home/$USER/password.txt"

function retry() {
  local n=1
  local max=15
  local delay=1
  local msg=
  local MGMTIP=
  while true; do
    local OUT=$($@ 2>&1)
    #echo "OUT="$OUT
    printf "%s: " "$5"
    if [[ $OUT =~ "Number of key(s) added" ]]; then
      echo "success: key addition successful"
      break
    elif [[ $OUT =~ "WARNING" ]]; then
      echo "warning: key already present"
      break
    elif [[ $OUT =~ "Name or service not known" ]]; then
      msg="error: dns resolution failed"
      printf "%s: " "$msg"
    elif [[ $OUT =~ "ERROR" ]]; then
      msg="error: key addition failed"
      printf "%s: " "$msg"
    else
      msg="unknown: unknown case"
      printf "%s: " "$msg: output: [$OUT]"
    fi
    if [[ $n -lt $max ]]; then
      echo "attempt: ($n/$max)"
      sleep $delay;
      ((n++))
    else
      echo "max attempt reached: [$max]: command: [$@]"
      break
    fi
  done
}

ssh-keygen -b 2048 -t rsa -f /home/$USER/.ssh/id_rsa -q -N ""
for HOST in $@; do
  MGMTIP="$HOST"
  #MGMTIP=$(nslookup $HOST | grep -i "address" | tail -1| cut -d' ' -f2)
  #echo $MGMTIP
  retry sshpass -f $PWDLOC ssh-copy-id $USER@$MGMTIP
  #echo "$USERPASS" | sshpass ssh-copy-id -f -i $KEYLOCATION "$USER"@"$MGMTIP"
done
