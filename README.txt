Back-off Protocols in 802.11 WLANs
Name – Nishit Prasad

Analysis on LAN performance by making modifications to the back-off procedure used in 802.11 WLANs. Back-off range appears whenever the two frames collide. Possible modifications include changing the exponential nature of the growth of the back-off range for a frame in order to avoid collision. Analysis is based on the Packet-Delivery Ratio and End-To-End Delay.


In 802.11 Wireless Networks, the nodes are mobile, that is, the nodes do not have specific constant location. These nodes transmit data to each other taken in to consideration the status of transmission channel(s). If the channel(s) is/are busy, then there is a random delay of the packets to be delivered. This random delay is known in other words as random back-off access protocol. Each packet or a frame after a collision(due to congestion in the network) experience a back-off range interval which implies a delay for the respective packet to be retransmitted. After every collision, the new back-off range value increases based on the back-off range value, which is defined by the given expression:

                        "New_limit = 2*(Prev_Limit + 1)-1"

For example, if the back-off range for a frame is [0,7] then a new collision will increase the back-off range of that frame to [0,15].
Network Simulator 2(ns-2) is a discrete event network simulator that creates an open simulation environment for computer networking. The network simulator version is ns-2.35. The source code involved are C++ and TCL (stands for - Tool Command Language) - a scripting language which provides abiliy to communicate among the applications.

Before running this project, the main prerequisite is to install ns-2 Simulator, which can be downloaded online.

After successful installation, the following are the steps to run my project:

The files provided are the following:

Backoff_Protocol_Test.tcl, and Performance_Metrics_Calc.awk

Please make sure these files are in same respective desired folder.

Go to Command Line and navigate to this desired directory (where these files are present). Then, type the following:

ns Backoff_Protocol_Test.tcl

After running this command(simulation completed), two files are generated in the same directory namely:

WLANVisual.nam (Visualizing the overall simulation), and
WLANTrace.tr (Containing Traces of overall simulation, in other words, contains logs)

To visualize the simulation scenario, the following command is entered:

nam WLANVisual.nam

Click Play button, and the simulation scenario is played.

In order to calculate the performance metrics, as shown in report, the following command is entered:

gawk -f Performance_Metrics_Calc.awk WLANTrace.tr

This provides the Packet-Delivery-Ratio as well as End-To-End Delay



ONE KIND NOTE:
This scenario is changed by changing the number of nodes in the TCL file "Backoff_Protocol_Test" and also by changing the Contention Window Size expression (Random Backoff Delay expression) present in "mac-802_11.h" file.

This file can be found under the directory ns-your_version/mac/mac-802_11.h"

Rest details are provided in the report.

Thank you.
