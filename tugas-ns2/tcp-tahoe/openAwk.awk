BEGIN {
countcwnd = 0
sendsize = 0
recvdSize = 0
startTime = 0.1
stopTime = 200
num_sample = 0;
total_delay = 0;
sent_1 = 0;
drop_tcp1 =0;
tcp1=0;
}
{
event = $1
time = $2
Node_id = $3
layer = $4
flags = $5
sequence_number = $6
cwnd = $6
cwndvalue = $7
packet_type = $7
packet_size = $8;
timecwnd=$1
fromNode = $3
toNode = $4
#avgcwnd
if ($2=="0" && $4=="4" && $6=="cwnd_" && $7=="1.000") {
css1=css1+1;
}
if ($1 =="+" && $3 =="0"){
sizetcp1=sizetcp1+$6;
}
if ($2=="1" && $4=="5" && $6=="cwnd_" && $7=="1.000") {
css2=css2+1;
}
if ($1 =="+" && $3 =="1"){
sizetcp2=sizetcp2+$6;
}
#throughput
if ($1=="r" && $4==4){
tcp1=tcp1+$6; }
#packetsent
if (Node_id == 0 && layer == 2 && event == "+")
sent_1++;
#packetdrop
if (packet_size ==1 && event == "d")
drop_tcp1++;
#e2edelay
if (event == "+" && time >=0.1 && Node_id == 0 &&
flags =="tcp" && packet_size==1){
p_id==$12
t_dep[$12] = time
}
if (event == "r" && time >=0.1 && layer == 4 && flags == "tcp" && packet_size==1){
if (p_id = $12){
t_arr[$12] = time
num_sample++
delay = t_arr[$12] - t_dep[$12]
total_delay += delay
} }
}
END {
print "\n----------------------------------------"
print " Throughput TCP = " (tcp1*8/1024/1024) " Mbit";
print " Avg throughput TCP = " tcp1*8/1024/1024/500 " Mbps";
#print" Total cwnd = " sizetcp1/1024" kB"
#print" Avg Byte per cwnd = "(sizetcp1/1024)/css1 " KB/cwnd"
print "----------------------------------------"
print " Packet Delivery Ratio = " ((sent_1-drop_tcp1)/sent_1)*100 "%";
print "----------------------------------------"
print " TCP Sent Packet = " (sent_1)
print " TCP Packet Drop = " (drop_tcp1)
avg_delay = total_delay/num_sample;
print "----------------------------------------"
print " Avg end to end delay = " avg_delay " s";
print "----------------------------------------\n"
}

