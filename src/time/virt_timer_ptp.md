# 
So we're running a virtualized guest on KVM and using kvmclock (which implements the pvclock protocol), or we're running a Hyper-V guest and have Hyper-V TSC page as a clocksource. Is our time-of-day in sync between the guest and the host (or, between different guests on the same host)? We're reading the same TSC value, so the resulting time should be the same, right? Well, not exactly. Both host's and guest's CLOCK_REALTIME clocks are affected by NTP adjustments and may diverge over time.

Red Hat Enterprise Linux 7.5 and later provide a virtual PTP hardware clock (PHC), which enables the guests to synchronize to the host with a sub-microsecond accuracy.

To solve the problem, a solution was introduced in Linux-4.11: PTP devices for KVM and Hyper-V. These devices are not actually related to the PTP time synchronization protocol and don't work with network devices, but they present themselves as PTP (/dev/ptp*) devices, so they're consumable by the existing time synchronization software.

For KVM guest, we need to load ptp_kvm module. To make it load after reboot, we can do something like:
# echo ptp_kvm > /etc/modules-load.d/ptp_kvm.conf
(on Fedora/RHEL7). This is not required for Hyper-V guests, as the module implementing the device loads automatically.

Add /dev/ptp0 as a reference clock to the NTP daemon configuration. In case of chrony, it would be:
# echo "refclock PHC /dev/ptp0 poll 3 dpoll -2 offset 0" >> /etc/chrony.conf
Restart NTP server:
systemctl restart chronyd
Check time synchronization status:
# chronyc sources | grep PHC0

KVM guests are known to produce better results than Hyper-V guests as the mechanism behind the device is very different. Whereas Hyper-V host sends its guests time samples every five seconds, KVM guests have an option to do direct hypercall to the hypervisor to get its time.

Testing results on KVM (idle host, single guest):

# for f in `seq 1 5`; do chronyc sources | grep PHC0 ; sleep 10s; done 
#* PHC0 0 3 377 4 -24ns[ -166ns] +/- 37ns 
#* PHC0 0 3 377 6 +13ns[ +49ns] +/- 32ns 
#* PHC0 0 3 377 8 +49ns[ +182ns] +/- 28ns 
#* PHC0 0 3 377 11 -43ns[ -113ns] +/- 24ns 
#* PHC0 0 3 377 4 +60ns[ +152ns] +/- 18ns

Testing results on Hyper-V (idle host, single guest):

# for f in `seq 1 5`; do chronyc sources | grep PHC0 ; sleep 10s; done 
#* PHC0 0 3 377 7 +287ns[+2659ns] +/- 131ns 
#* PHC0 0 3 377 7 +119ns[-3852ns] +/- 130ns 
#* PHC0 0 3 377 9 +1648ns[+2449ns] +/- 156ns 
#* PHC0 0 3 377 5 +898ns[ +613ns] +/- 142ns 
#* PHC0 0 3 377 7 +288ns[ -403ns] +/- 98ns

Although the Hyper-V PTP device is less accurate than KVM, it still is very accurate compared to NTP. As you can see from the above, guest's system time usually stays within 10us from host's, which is a good result.