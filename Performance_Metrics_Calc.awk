BEGIN {
	packet_no = -1; #Total Packet Count
	received_Packets = 0;#Total Number of Received Packets
	count = 0;#Total Count of Delayed Packets
}

{

#######################Packet-Delivery Ratio Calculation#######################################

#If the trace file contains "s" which implies sending packet(s) from application layer ("AGT")
	if(packet_no < $6 && $1 == "s" && $4 == "AGT")
	{
		packet_no = $6;
	}
#If the trace file contains "r" which implies receiving packet(s) to the application layer ("AGT")
	else if(($1 == "r") && ($4 == "AGT"))
	{
		received_Packets++;
	}

#########################End-To-End Delay Calculation##########################################
	
#If the trace file contains "s" which implies sending packet(s) from application layer ("AGT"), then record start the time for that packet
	if($4 == "AGT" && $1 == "s")
	{
		start_time[$6] = $2;
	}

#If the trace file contains "r" which implies receiving packet(s) with Constant Bit-Rate (cbr)
	else if(($7 == "cbr") && ($1 == "r"))
	{
		end_time[$6] = $2;
	}

#If the trace file contains "D" which implies delay of the packets with Constant Bit-Rate (cbr)
	else if($1 == "D" && $7 == "cbr")
	{
		end_time[$6] = -1;
	}
}

END {
	for(i=0; i<=packet_no; i++)
	{
		if(end_time[i] > 0)
		{
			delay[i] = end_time[i] - start_time[i];
			count++;
		}
		else
		{
			delay[i] = -1;
		}
	}

	for(i=0; i<count; i++)
	{
		if(delay[i] > 0)
		{
			end_to_end_delay = end_to_end_delay + delay[i];
		} 
	}
	end_to_end_delay = end_to_end_delay/count;

	print "\n";
	print "Packet Delivery Ratio = " received_Packets/(packet_no+1)
	"%";
	print "Average End-to-End Delay = " end_to_end_delay * 1000 " ms";
	print "\n";
}
