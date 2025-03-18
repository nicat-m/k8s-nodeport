

#kubectl get -n orange svc |grep 5005 | awk '{print $5}' | cut -f3 -d":" | sed 's/TCP.*//' | cut -d'/' -f 1 > /var/www/html/ports.txt


#!/usr/bin/bash


run_function () {


########## VARIABLES ##########

namespace=$1
ip_address=$2
a=0
dt=`date '+%d-%m-%Y %H:%M:%S'`

##############################


echo "-------------------------------------------------"

echo "NodePort script is starting..."

sleep 3


kubectl get -n $namespace svc |grep 5005 | awk '{print $5}' | awk -F':' '{print $3}' | cut -d'/' -f1 > /var/www/html/$namespace.port

echo > /var/www/html/$namespace.html

sleep 2

echo "<h2> Nodeports for $namespace </h2>" > /var/www/html/$namespace.html
echo '<h3 style="color:red;">IP ADDRESS IS: '$ip_address' </h3>' >> /var/www/html/$namespace.html

for i in `kubectl get -n $namespace svc |grep 5005 | awk '{print $1}'`
do

   a=$(($a+1))
   nodeports=$(cat /var/www/html/$namespace.port |head -n $a |tail -n 1)

   echo "<p> $i = $nodeports </p>" >> /var/www/html/$namespace.html

done

echo "$namespace.html file is updated successfully..."

sleep 1

echo "NodePort script is stopping..."

echo $dt

echo "-------------------------------------------------"
sleep 3

}

run_function "develop" "10.122.61.58"
run_function "yellow" "10.122.61.58"
run_function "brown" "10.122.61.58"
run_function "green" "10.122.61.58"
run_function "grey" "10.122.61.58"