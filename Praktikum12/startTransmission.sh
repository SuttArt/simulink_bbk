#!/bin/sh

#parameters
gnr=$1
tx_file=$2
txGain=$3
scenario=$4

userDemoPc=jointlabb
ipAddrDemoPc=141.20.33.142
pathDemoPc=/home/jointlabb/bbk_demo/WiSe23-24

if [ "${gnr}" = "" ]; then
	echo "The first parameter must be your group number"
	exit
fi

if [ "${tx_file}" = "" ]; then
	echo "The second parameter must be your binary file"
	exit
fi

if [ ! -f ${tx_file} ]; then
	echo "File ${tx_file} not found."
	exit
fi

if [ "${txGain}" = "" ]; then
	echo "The third parameter must be the current antenna gain"
	exit
fi

if [ "${scenario}" = "" ]; then
	echo "The fourth parameter must be the current scenario"
	exit
fi

ssh $userDemoPc@$ipAddrDemoPc <<EOF
cd $pathDemoPc/
if [ ! -d "G_${gnr}" ]; then
	mkdir G_$gnr
fi
cd G_$gnr
exit
EOF
echo "Folder G_${gnr} was created"

scp ${tx_file} $userDemoPc@$ipAddrDemoPc:$pathDemoPc/G_$gnr/TX.bin

ssh $userDemoPc@$ipAddrDemoPc $pathDemoPc/transmissionClient.sh ${gnr}

scp $userDemoPc@$ipAddrDemoPc:$pathDemoPc/G_$gnr/RX_${txGain}db_${scenario}.bin RX_${txGain}dB_${scenario}.bin

