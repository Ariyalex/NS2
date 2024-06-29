set ns [new Simulator]
$ns color 1 Blue
$ns color 2 Red
set tracefile1 [open out.tr w]
$ns trace-all $tracefile1
set namfile [open out.nam w]
$ns namtrace-all $namfile
proc finish {} {
global ns tracefile1 namfile
$ns flush-trace 
close $tracefile1 
close $namfile 
exec nam out.nam & 
exit 0
}

set n0 [$ns node] 
set n1 [$ns node] 
set n2 [$ns node] 
set n3 [$ns node] 
set n4 [$ns node] 
set n5 [$ns node]
$n0 color Blue
$n1 color Red
$ns duplex-link $n0 $n2 1Mb 50ms DropTail
$ns duplex-link $n1 $n2 1Mb 50ms DropTail
$ns simplex-link $n2 $n3 0.5Mb 30ms RED
$ns simplex-link $n3 $n2 0.5Mb 30ms RED
$ns duplex-link $n3 $n4 1Mb 50ms DropTail
$ns duplex-link $n3 $n5 1Mb 50ms DropTail
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns simplex-link-op $n2 $n3 orient right
$ns simplex-link-op $n3 $n2 orient left
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down
$ns queue-limit $n2 $n3 25 

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp 
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set window_ 30
$tcp set packetSize_ 1000
$tcp set fid_ 1
set ftp [new Application/FTP]
$ftp attach-agent $tcp 
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp 
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1460
$cbr set rate_ 0.01Mb
$cbr set random_ false
$ns at 0.2 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 9.6 "$cbr stop"
$ns at 9.8 "$ftp stop"


#prosedur yang menghasilkan file qm.out untuk mencari nilai queue 
set qmon [$ns monitor-queue $n2 $n3 [open qm.out w] 0.1];
[$ns link $n2 $n3] queue-sample-timeout;
$ns at 0.1
$ns at 300.0 finish
$ns run

