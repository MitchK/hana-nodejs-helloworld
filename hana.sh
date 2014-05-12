
if [ -z "$HANA_HOST" ]; then
    echo "HANA_HOST is not defined"
    exit 1
fi

if [ -z "$HANA_PORT" ]; then
    echo "HANA_PORT is not defined"
    exit 1
fi

if [ -z "$HANA_USER" ]; then
    echo "HANA_USER is not defined"
    exit 1
fi

if [ -z "$HANA_PASS" ]; then
    echo "HANA_PASS is not defined"
    exit 1
fi

if [ $HANA_HOST = "hanatrial.ondemand.com" ]; then

    if [ -z "$HANA_ACCOUNT" ]; then
        echo "HANA_ACCOUNT is not defined"
        exit 1
    fi

    if [ -z "$HANA_PACKAGE" ]; then
        echo "HANA_PACKAGE is not defined"
        exit 1
    fi

    exec 3< <(neo.sh open-db-tunnel -h $HANA_HOST -u $HANA_USER -p $HANA_PASS -a $HANA_ACCOUNT -i $HANA_PACKAGE < /dev/null &)

    while read <&3 line; do

        if [ "$line" = "Press ENTER to close the tunnel now." ]; then 
            break 
        fi

        if [ -n "$(echo $line | grep "Host name")" ]; then 
            TMP_HANA_HOST=$(echo "$line" | grep "Host name" | cut -d':' -f2 | tr -d ' ')
        fi
    
        if [ -n "$(echo $line | grep "User")" ]; then 
            TMP_HANA_USER=$(echo "$line" | grep "User" | cut -d':' -f2 | tr -d ' ')
        fi

        if [ -n "$(echo $line | grep "Password")" ]; then 
            TMP_HANA_PASS=$(echo "$line" | grep "Password" | cut -d':' -f2 | tr -d ' ')
        fi

        echo "$line"
    
    done

    TMP_HANA_PORT=$HANA_PORT

else

    TMP_HANA_HOST=$HANA_HOST
    TMP_HANA_PORT=$HANA_PORT
    TMP_HANA_USER=$HANA_USER
    TMP_HANA_PASS=$HANA_PASS

fi

echo ""
echo "HANA.IO Executing $@"
echo "HANA_HOST $TMP_HANA_HOST"
echo "HANA_PORT $TMP_HANA_PORT"
echo "HANA_USER $TMP_HANA_USER"
echo "HANA_PASS $TMP_HANA_PASS"

HANA_HOST=$TMP_HANA_HOST HANA_PORT=$TMP_HANA_PORT HANA_USER=$TMP_HANA_USER HANA_PASS=$TMP_HANA_PASS "$@"