
function close {

    echo ""
    echo "Closing tunnel..."
    echo ""

    pkill java
}

trap close EXIT

if [ -z "$HANAIO_HOST" ]; then
    echo "HANAIO_HOST is not defined"
    exit 1
fi

if [ -z "$HANAIO_PORT" ]; then
    echo "HANAIO_PORT is not defined"
    exit 1
fi

if [ -z "$HANAIO_USER" ]; then
    echo "HANAIO_USER is not defined"
    exit 1
fi

if [ -z "$HANAIO_PASS" ]; then
    echo "HANAIO_PASS is not defined"
    exit 1
fi

if [ $HANAIO_HOST = "hanatrial.ondemand.com" ]; then

    if [ -z "$HANAIO_ACCOUNT" ]; then
        echo "HANAIO_ACCOUNT is not defined"
        exit 1
    fi

    if [ -z "$HANAIO_PACKAGE" ]; then
        echo "HANAIO_PACKAGE is not defined"
        exit 1
    fi

    coproc neo.sh open-db-tunnel -h $HANAIO_HOST -u $HANAIO_USER -p $HANAIO_PASS -a $HANAIO_ACCOUNT -i $HANAIO_PACKAGE

    while read <&"${COPROC[0]}" line; do

        if [ "$line" = "Press ENTER to close the tunnel now." ]; then 
            break 
        fi

        if [ -n "$(echo $line | grep "Host name")" ]; then 
            TMP_HANAIO_HOST=$(echo "$line" | grep "Host name" | cut -d':' -f2 | tr -d ' ')
        fi
    
        if [ -n "$(echo $line | grep "User")" ]; then 
            TMP_HANAIO_USER=$(echo "$line" | grep "User" | cut -d':' -f2 | tr -d ' ')
        fi

        if [ -n "$(echo $line | grep "Password")" ]; then 
            TMP_HANAIO_PASS=$(echo "$line" | grep "Password" | cut -d':' -f2 | tr -d ' ')
        fi

        echo "$line"

    done

    TMP_HANAIO_PORT=$HANAIO_PORT

else

    TMP_HANAIO_HOST=$HANAIO_HOST
    TMP_HANAIO_PORT=$HANAIO_PORT
    TMP_HANAIO_USER=$HANAIO_USER
    TMP_HANAIO_PASS=$HANAIO_PASS

fi

echo ""
echo "HANA.IO Executing $@"
echo "HANAIO_HOST $TMP_HANAIO_HOST"
echo "HANAIO_PORT $TMP_HANAIO_PORT"
echo "HANAIO_USER $TMP_HANAIO_USER"
echo "HANAIO_PASS $TMP_HANAIO_PASS"
echo ""

HANAIO_HOST=$TMP_HANAIO_HOST HANAIO_PORT=$TMP_HANAIO_PORT HANAIO_USER=$TMP_HANAIO_USER HANAIO_PASS=$TMP_HANAIO_PASS "$@"
