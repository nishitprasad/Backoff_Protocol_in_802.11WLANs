#Defining Simulation Options

#Channel Type
set val(chan)	Channel/WirelessChannel;

#Radio-Propagation Model
set val(prop)	Propagation/TwoRayGround;

#Network-Interface Type
set val(netif)	Phy/WirelessPhy;

#MAC type
set val(mac)	Mac/802_11;

#Interface Queue Type
set val(ifq)	Queue/DropTail/PriQueue;

#Link Layer Type
set val(ll)	LL;

#Antenna Model
set val(ant)	Antenna/OmniAntenna;

#Maximum packet in ifq
set val(ifqlen)	50;

#Number of mobile nodes
set val(nn)	55;

#Routing Protocol
set val(rp)	DSDV;

#X Dimension of The Topography
set val(x)	500;

#Y Dimension of The Topography
set val(y)	400;

#End Time of the Simulation
set val(stop)	150;


#Create a Simulator Object
set ns	[new Simulator]

#Trace Overall Simulation log
set WLANTrace		[open WLANTrace.tr w]

#NS-2 Simulator Network Model Visualization
set WLANVisual		[open WLANVisual.nam w]


$ns trace-all $WLANTrace
$ns namtrace-all-wireless $WLANVisual $val(x) $val(y)


#Set Up Topography Object
set WLAN_topography [new Topography]
$WLAN_topography load_flatgrid $val(x) $val(y)


#Create General Operations Director (GOD) object.
#Used to store global information about the state of the network environment.
create-god $val(nn)


#Creating nn mobile nodes and attaching them to channel.

#Configure these nodes
        $ns node-config -adhocRouting $val(rp) \
			-llType $val(ll) \
			-macType $val(mac) \
			-ifqType $val(ifq) \
			-ifqLen $val(ifqlen) \
			-antType $val(ant) \
			-propType $val(prop) \
			-phyType $val(netif) \
			-channelType $val(chan) \
			-topoInstance $WLAN_topography \
			-agentTrace ON \
			-routerTrace ON \
			-macTrace OFF \
			-movementTrace ON


#Create Nodes
	for {set i 0} {$i < $val(nn) } { incr i } {

		set node_($i) [$ns node]
		$node_($i) set X_ [ expr 10+round(rand()*480) ]
		$node_($i) set Y_ [ expr 10+round(rand()*380) ]
		$node_($i) set Z_ 0.0

  		set mac_($i) [$node_($i) getMac 0]

#Attaching UDP Connection Agent to each node.
		set udp_send($i) [new Agent/UDP]
		$ns attach-agent $node_($i) $udp_send($i)

#Attaching Constant Bit-Rate (CBR) Traffic Constraint to each node
		set cbr($i) [new Application/Traffic/CBR]
		$cbr($i) attach-agent $udp_send($i)
	}

#Setting up Access Points
#Setting First Node and Last Node (By Number) as two Access Points
set ACCESS_POINT_ADDR_1 [$mac_(0) id]
$mac_(0) ap $ACCESS_POINT_ADDR_1
set ACCESS_POINT_ADDR_2 [$mac_([expr $val(nn) - 1]) id]
$mac_([expr $val(nn) - 1]) ap $ACCESS_POINT_ADDR_2

#Setting up the Traffic - Packet Size and Constant Bit-Rate
Application/Traffic/CBR set packetSize_ 256
Application/Traffic/CBR set rate_ 512Kb


#Set random motion of each node as they are considered as mobile nodes
#Also Attaching Receiving Agents to the mobile nodes

	for {set i 1} {$i < $val(nn) - 1} { incr i } {
		$ns at [ expr 1+round(rand()*50) ] "$node_($i) setdest [ expr 5+round(rand()*480) ] [ expr 7+round(rand()*380) ] [ expr 9+round(rand()*15) ]"
		set recv($i) [new Agent/Null]
		$ns attach-agent $node_($i) $recv($i)
	}


#Connecting some sender and receiver mobile nodes
$ns connect $udp_send(5) $recv(10)
$ns connect $udp_send(15) $recv(20)
$ns connect $udp_send(25) $recv(30)
$ns connect $udp_send(35) $recv(40)
$ns connect $udp_send(45) $recv(50)



#Starting transmission from the sender nodes
$ns at 1.0 "$cbr(5) start"
$ns at 1.0 "$cbr(15) start"
$ns at 1.0 "$cbr(25) start"
$ns at 1.0 "$cbr(35) start"
$ns at 1.0 "$cbr(45) start"


# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at $val(stop) "puts \"End simulation\" ; $ns halt"

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}


proc stop {} {
	global ns WLANTrace
# Reset Trace File
	$ns flush-trace
	close $WLANTrace
	exit 0
}


puts "Starting Simulation..."
$ns run
