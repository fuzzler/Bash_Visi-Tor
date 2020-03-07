#!/bin/bash

# URL possibili
url0=http://fuzzlernet.altervista.org/index.html
url1=http://fuzzlernet.altervista.org/chisiamo.html
url2=http://fuzzlernet.altervista.org/contatti.html
url3=http://fuzzlernet.altervista.org/applicazioni.html

# contatore dei cicli
stay=0
# limite dopo il quale deve uscire
if [ $# -eq 0 ]
then
	limit=15
else
	limit=$@
fi

cd /opt/tor905

while [[ $stay -lt limit ]] 
do
	# incremento il contatore
	stay=$((stay+1))
	printf "\n************************************\n"
	printf "Giro Numero $stay di $limit \n"
	
	# sceglie quale url aprire
	url=$(echo $[ 1 + $[ RANDOM % 3 ] ] )

	case $url in
		0) bash Browser/start-tor-browser --detach $url0 ;; # per ora non abilitato
		1) bash Browser/start-tor-browser --detach $url1 ;;
		2) bash Browser/start-tor-browser --detach $url2 ;;
		3) bash Browser/start-tor-browser --detach $url3 ;;
	esac

	# scelgo per quanto deve rimanere aperta la pagina in secondi
	st=$(echo $[ 22 + $[ RANDOM % 34 ] ] )
	#pausa della durata dello sleep-time impostato (60 sec - 120 sec)
	sleep $st

	# chiudo il browser prima di iniziare un nuovo ciclo
	torpid=$(ps aux | pgrep firefox.real)
	kill -9 $torpid

	# Se è l'ultimo giro posso uscire senza resettare il mac e attendere...
	if [ $stay -ne $limit ]
	then
		# cambio il macaddress
		sudo ifconfig wlp0s20f3 down
		sudo macchanger -r wlp0s20f3
		sudo service network-manager restart
		sudo ifconfig wlp0s20f3 up

		# seconda attesa dopo aver cambiato mac
		st=$(echo $[ 9 + $[ RANDOM % 12 ] ] )
		sleep $st
	fi

done

echo
echo "Uscito dal programma dopo $stay giri"
