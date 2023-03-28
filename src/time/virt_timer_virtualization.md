虚拟机中看到的关于时间的硬件都是假的，rtc/pit/hpet/tsc/lapic local timer都是假的，那么guest读clock当前时间就会导致exit出来，exit出来后kvm计算出一个值返回给guest。guest写timer的超时时间就会导致exit出来，exit出来后kvm给一个软件定时器设置超时时间，等这个软件定时器超后，kvm生成一个时间虚拟中断，把这个中断注入给虚拟机。看这台虚拟机，模拟rtc和pit，没有hpet。




