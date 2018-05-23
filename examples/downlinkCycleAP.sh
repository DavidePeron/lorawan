#!/usr/bin/env bash

# DOWNLINK Network Performances and transmissions required - loop on appPeriod


# Useful variables
# i= number of nDevices
# increment= increment in EDs
gatewayRings=1
nDevices=700
radius=6300
#gwrad=$(echo "10000/(2*($gatewayRings - 1)+1)" | bc -l)
globalrun=1
maxRuns=10
initialPeriod=$1
increment=$2
finalPeriod=$3
periodsToSimulate=$4
transientPeriods=$5
maxNumbTx=$6


# echo "***** DOWNLINK VARYING APP PERIOD *****"
# echo "         INPUT PARAMETERS    "
# echo "End devices = $nDevices"
# echo "initial period = $i"
# echo "increment = $increment"
# echo "maximum App Period = $finalPeriod"
# echo "periodsToSimulate= $periodsToSimulate"
# echo "transientPeriods= $transientPeriods"
# echo "Data Rate adaptation= $DRAdapt"
# echo "max number of transmission= $maxNumbTx"
# echo "***************************"

# Move to the waf directory
cd ../../../

# Configure waf to use the optimized build
# echo "GR:$gatewayRings, r:$radius, gwr:$gwrad, sim:$simTime, runs:$maxRuns"
# echo "Warning: remember to correctly set up the following:"
# echo "- Channels"
# echo "- Receive paths"
# echo "- Path loss"
# echo -n "Configuring and building..."
# ./waf --build-profile=optimized --out=build/optimized configure
# ./waf build
# echo " done."

# Run the script with a fixed period
i=$initialPeriod
while [ $i -le $finalPeriod ]
do
    # echo "period= $i"
    # Perform multiple runs
    currentrun=1

# echo "Done initialization"
    while [ $currentrun -le $maxRuns ]
    do
        # nGateways=$[3*$gatewayRings*$gatewayRings-$[3*$gatewayRings]+1]
        # echo -n "Simulating a system with $i end devices and a transmission period of $simTime seconds...  "
        # START=$(date +%s)
        output="$(./waf --run "RawCompleteNetworkPerformances
            --nDevices=$nDevices
            --gatewayRings=$gatewayRings
            --radius=$radius
            --gatewayRadius=1500
            --appPeriod=$i
            --periodsToSimulate=$periodsToSimulate
	          --transientPeriods=$transientPeriods
            --maxNumbTx=$maxNumbTx
            --RngRun=$globalrun" | grep -v "build" | tr -d '\n')"
        echo "$output"

        currentrun=$(( $currentrun+1 ))
        globalrun=$(( $globalrun+1 ))
    done

    i=$(echo "$i + $increment" | bc -l)
done
