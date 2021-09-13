#!/system/bin/sh
# 
# Init TSKernel
#

TS_DIR="/data/.tskernel"
LOG="$TS_DIR/tskernel.log"

## VARIABLES
BL=`getprop ro.bootloader`
MODEL=${BL:0:5}
MODEL1=G980F
MODEL1_DESC="SM980F"
MODEL2=G985F
MODEL2_DESC="SM985F"
MODEL3=G981B
MODEL3_DESC="SM981B"
MODEL4=G986B
MODEL4_DESC="SM986B"
MODEL5=G988B
MODEL5_DESC="SM988B"

sleep 10

rm -f $LOG

    # Create ThunderStormS and init.d folder
    if [ ! -d $TS_DIR ]; then
	    mkdir -p $TS_DIR;
    fi

    # Create init.d folder
        mkdir -p /vendor/etc/init.d;
	chown -R root.root /vendor/etc/init.d;
	chmod 755 /vendor/etc/init.d;

	echo $(date) "TS-Kernel LOG" >> $LOG;
	echo " " >> $LOG;

	# SafetyNet
	# SELinux (0 / 640 = Permissive, 1 / 644 = Enforcing)
	echo "## -- SafetyNet permissions" >> $LOG;
	chmod 644 /sys/fs/selinux/enforce;
	chmod 440 /sys/fs/selinux/policy;
        echo "1" > /sys/fs/selinux/enforce
	echo " " >> $LOG;

	# deepsleep fix
	echo "## -- DeepSleep Fix" >> $LOG;

    dmesg -n 1 -C
	echo "N" > /sys/kernel/debug/debug_enabled
	echo "N" > /sys/kernel/debug/seclog/seclog_debug
	echo "0" > /sys/kernel/debug/tracing/tracing_on
	#echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
    echo "0" > /sys/module/alarm_dev/parameters/debug_mask
    echo "0" > /sys/module/binder/parameters/debug_mask
    echo "0" > /sys/module/binder_alloc/parameters/debug_mask
    #echo "0" > /sys/module/powersuspend/parameters/debug_mask
    echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask
    echo "0" > /sys/module/kernel/parameters/initcall_debug

    # disable cpuidle log
    echo "0" > /sys/module/cpuidle_exynos64/parameters/log_en

    debug="/sys/module/*" 2>/dev/null
    for i in \$debug
    do
	    if [ -e \$DD/parameters/debug_mask ]
	    then
		    echo "0" >  \$i/parameters/debug_mask
	    fi
    done
	
    for i in `ls /sys/class/scsi_disk/`; do
	    cat /sys/class/scsi_disk/$i/write_protect 2>/dev/null | grep 1 >/dev/null
	    if [ $? -eq 0 ]; then
		    echo 'temporary none' > /sys/class/scsi_disk/$i/cache_type
	    fi
    done

	echo " " >> $LOG;

    # Initial ThundeRStormS settings
	echo "## -- Initial settings by ThundeRStormS" >> $LOG;

    # Kernel Panic off (0 = Disabled, 1 = Enabled)
    echo "0" > /proc/sys/kernel/panic
     
    # POWER EFFCIENT WORKQUEUE (0/N = Disabled, 1/Y = Enabled)
    echo "N" > /sys/module/workqueue/parameters/power_efficient

    # FINGERPRINT BOOST (0 = Disabled, 1 = Enabled)
    # echo "1" > /sys/kernel/fp_boost/enabled

    # CPU set at max/min freq
    # Little CPU
    #echo "ts_schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo "442000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
    echo "2002000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    #echo "2000" > /sys/devices/system/cpu/cpu0/cpufreq/ts_schedutil/down_rate_limit_us
    #echo "4000" > /sys/devices/system/cpu/cpu0/cpufreq/ts_schedutil/up_rate_limit_us
    #echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/ts_schedutil/iowait_boost_enable
    #echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/ts_schedutil/fb_legacy

    # Midle CPU
    #echo "ts_schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
    echo "377000" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
    echo "2504000" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
    #echo "2000" > /sys/devices/system/cpu/cpu4/cpufreq/ts_schedutil/down_rate_limit_us
    #echo "4000" > /sys/devices/system/cpu/cpu4/cpufreq/ts_schedutil/up_rate_limit_us
    #echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/ts_schedutil/iowait_boost_enable
    #echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/ts_schedutil/fb_legacy

    # BIG CPU
    #echo "ts_schedutil" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
    echo "546000" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
    echo "2730000" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
    #echo "2000" > /sys/devices/system/cpu/cpu6/cpufreq/ts_schedutil/down_rate_limit_us
    #echo "4000" > /sys/devices/system/cpu/cpu6/cpufreq/ts_schedutil/up_rate_limit_us
    #echo "0" > /sys/devices/system/cpu/cpu6/cpufreq/ts_schedutil/iowait_boost_enable
    #echo "1" > /sys/devices/system/cpu/cpu6/cpufreq/ts_schedutil/fb_legacy

    # Wakelock settigs
    echo "N" > /sys/module/wakeup/parameters/enable_sensorhub_wl
    echo "N" > /sys/module/wakeup/parameters/enable_ssp_wl
    echo "Y" > /sys/module/wakeup/parameters/enable_bcmdhd4359_wl
    echo "Y" > /sys/module/wakeup/parameters/enable_bluedroid_timer_wl
    echo "Y" > /sys/module/wakeup/parameters/enable_wlan_wake_wl
    echo "Y" > /sys/module/wakeup/parameters/enable_wlan_ctrl_wake_wl
    echo "N" > /sys/module/wakeup/parameters/enable_wlan_rx_wake_wl
    echo "N" > /sys/module/wakeup/parameters/enable_wlan_wd_wake_wl
    echo "Y" > /sys/module/wakeup/parameters/enable_mmc0_detect_wl
    echo "3" > /sys/module/sec_battery/parameters/wl_polling
    echo "1" > /sys/module/sec_nfc/parameters/wl_nfc

    # Entropy
    echo "256" > /proc/sys/kernel/random/write_wakeup_threshold
    echo "64" > /proc/sys/kernel/random/read_wakeup_threshold

    # VM
    echo "95" > /proc/sys/vm/vfs_cache_pressure
    echo "60" > /proc/sys/vm/swappiness
    echo "800" > /proc/sys/vm/dirty_writeback_centisecs
    echo "500" > /proc/sys/vm/dirty_expire_centisecs
    echo "50" > /proc/sys/vm/overcommit_ratio

    # ZRAM
    # for another SM-G97x - ZRAM is OFF because RAM is 8GB (no needed)
    swapoff /dev/block/zram0 > /dev/null 2>&1
    echo "1" > /sys/block/zram0/reset
    # echo "1073741824" > /sys/block/zram0/disksize  # 1,0 GB
    echo "1610612736" > /sys/block/zram0/disksize  # 1,5 GB
    # echo "2147483648" > /sys/block/zram0/disksize  # 2,0 GB
    # echo "2684354560" > /sys/block/zram0/disksize  # 2,5 GB
    # echo "3221225472" > /sys/block/zram0/disksize  # 3,0 GB
    chmod 644 /dev/block/zram0
    mkswap /dev/block/zram0 > /dev/null 2>&1
    swapon /dev/block/zram0 > /dev/null 2>&1

    # GPU set at max/min freq
    echo "800000" > /sys/kernel/gpu/gpu_max_clock
    echo "156000" > /sys/kernel/gpu/gpu_min_clock
    echo "coarse_demand" > /sys/devices/platform/18500000.mali/power_policy
    echo "1" > /sys/devices/platform/18500000.mali/dvfs_governor
    echo "260000" > /sys/devices/platform/18500000.mali/highspeed_clock
    echo "95" > /sys/devices/platform/18500000.mali/highspeed_load
    echo "1" > /sys/devices/platform/18500000.mali/highspeed_delay

   # Misc settings : bbr2, bbr, cubic or westwood
   echo "bbr" > /proc/sys/net/ipv4/tcp_congestion_control
   echo "N" > /sys/module/mmc_core/parameters/use_spi_crc
   echo "1" > /sys/module/sync/parameters/fsync_enabled
   echo "0" > /sys/kernel/sched/gentle_fair_sleepers

   # I/O sched settings
   echo "cfq" > /sys/block/sda/queue/scheduler
   # echo "256" > /sys/block/sda/queue/read_ahead_kb
   echo "cfq" > /sys/block/mmcblk0/queue/scheduler
   # echo "256" > /sys/block/mmcblk0/queue/read_ahead_kb
   echo "0" > /sys/block/sda/queue/iostats
   echo "0" > /sys/block/mmcblk0/queue/iostats
   echo "1" > /sys/block/sda/queue/rq_affinity
   echo "1" > /sys/block/mmcblk0/queue/rq_affinity
   echo "256" > /sys/block/sda/queue/nr_requests
   echo "256" > /sys/block/mmcblk0/queue/nr_requests

    # Initial ThundeRStormS Stune and CPU set settings
	echo "## -- Initial Stune settings by ThundeRStormS" >> $LOG;

   ## Kernel Stune											DEFAULT VALUES
   # GLOBAL
   echo "5" > /dev/stune/schedtune.boost					# 0
   #echo "0" > /dev/stune/schedtune.band					# 0
   echo "0" > /dev/stune/schedtune.prefer_idle				# 0
   echo "0" > /dev/stune/schedtune.prefer_perf				# 0
   #echo "1" > /dev/stune/schedtune.util_est_en				# 0
   #echo "0" > /dev/stune/schedtune.ontime_en				# 0
   
   # TOP-APP
   echo "5" > /dev/stune/top-app/schedtune.boost			# 0
   #echo "0" > /dev/stune/top-app/schedtune.band			# 0
   echo "0" > /dev/stune/top-app/schedtune.prefer_idle		# 1
   echo "0" > /dev/stune/top-app/schedtune.prefer_perf		# 0
   #echo "1" > /dev/stune/top-app/schedtune.util_est_en		# 0
   #echo "1" > /dev/stune/top-app/schedtune.ontime_en		# 0
   
   # RT
   echo "0" > /dev/stune/rt/schedtune.boost					# 0
   #echo "0" > /dev/stune/rt/schedtune.band					# 0
   echo "0" > /dev/stune/rt/schedtune.prefer_idle			# 0
   echo "0" > /dev/stune/rt/schedtune.prefer_perf			# 0
   #echo "0" > /dev/stune/rt/schedtune.util_est_en			# 0
   #echo "0" > /dev/stune/rt/schedtune.ontime_en			# 0
 
   # FOREGROUND-APP
   echo "0" > /dev/stune/foreground/schedtune.boost			# 0
   #echo "0" > /dev/stune/foreground/schedtune.band			# 0
   echo "0" > /dev/stune/foreground/schedtune.prefer_idle	# 0
   echo "0" > /dev/stune/foreground/schedtune.prefer_perf	# 0
   #echo "0" > /dev/stune/foreground/schedtune.util_est_en	# 0
   #echo "0" > /dev/stune/foreground/schedtune.ontime_en	# 0
 
   # BACKGROUND-APP
   echo "0" > /dev/stune/background/schedtune.boost		    # 0
   #echo "0" > /dev/stune/background/schedtune.band			# 0
   echo "0" > /dev/stune/background/schedtune.prefer_idle	# 0
   echo "0" > /dev/stune/background/schedtune.prefer_perf	# 0
   #echo "1" > /dev/stune/background/schedtune.util_est_en	# 0
   #echo "1" > /dev/stune/background/schedtune.ontime_en	# 0

   # CPU SET
   # RESTRICKTED 
   echo "0-7" >   /dev/cpuset/restricted/cpus				# 0-7
   # ABNORMAL 
   echo "0-3" >   /dev/cpuset/abnormal/cpus					# 0-3
   # GLOBAL
   echo "0-7" > /dev/cpuset/cpus							# 0-7
   # TOP-APP
   echo "0-7" > /dev/cpuset/top-app/cpus					# 0-7
   # FOREGROUND
   echo "0-3,4-6" > /dev/cpuset/foreground/cpus				# 0-2,4-7
   # BACKGROUND
   echo "0-2" > /dev/cpuset/background/cpus				    # 0-2
   # SYSTEM-BACKGROUND
   echo "0-2" > /dev/cpuset/system-background/cpus		    # 0-2
   # MODERATE
   echo "0-2,4-6" > /dev/cpuset/moderate/cpus				# 0-2,4-6
   # DEXOPT
   echo "0-5" > /dev/cpuset/dexopt/cpus					    # 0-3

   ## CPU Fluid RT
   #echo "5" > sys/kernel/ems/frt/coregroup0/active_ratio
   #echo "10" > sys/kernel/ems/frt/coregroup0/active_ratio_boost
   #echo "15" > sys/kernel/ems/frt/coregroup0/coverage_ratio
   #echo "20" > sys/kernel/ems/frt/coregroup0/coverage_ratio_boost

   #echo "20" > sys/kernel/ems/frt/coregroup1/active_ratio
   #echo "30" > sys/kernel/ems/frt/coregroup1/active_ratio_boost
   #echo "5" > sys/kernel/ems/frt/coregroup1/coverage_ratio
   #echo "10" > sys/kernel/ems/frt/coregroup1/coverage_ratio_boost

   #echo "20" > sys/kernel/ems/frt/coregroup2/active_ratio
   #echo "30" > sys/kernel/ems/frt/coregroup2/active_ratio_boost
   #echo "10" > sys/kernel/ems/frt/coregroup2/coverage_ratio
   #echo "15" > sys/kernel/ems/frt/coregroup2/coverage_ratio_boost


   ## Kernel Scheduler
   #echo "2000000" > /proc/sys/kernel/sched_wakeup_granularity_ns
   #echo "10000000" > /proc/sys/kernel/sched_latency_ns
   #echo "950000" > /proc/sys/kernel/sched_min_granularity_ns
   #echo "1000000" > /proc/sys/kernel/sched_migration_cost_ns
   #echo "1000000" > /proc/sys/kernel/sched_rt_period_us

   # CPU EFF_mode
   #echo "0" > /sys/kernel/ems/eff_mode						# 0

   # CPU Energy Aware
   #echo "1" > /proc/sys/kernel/sched_energy_aware			# 0
   #echo "0" > /proc/sys/kernel/sched_tunable_scaling		# 0

   # Thermal Governors
   # BIG Cluster
   echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone0/policy
   # MID Cluster
   echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone1/policy
   # LITTLE Cluster
   echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone2/policy
   # GPU
   echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone3/policy
   # ISP
   echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone4/policy
   # NPU
   echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone5/policy
   # AC
   echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone6/policy
   # BATTERY
   echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone7/policy

   # Boeffla wakelocks
   chmod 0644 /sys/devices/virtual/misc/boeffla_wakelock_blocker/wakelock_blocker
   echo 'wlan_pm_wake;wlan_rx_wake;wlan_wake;wlan_ctrl_wake;wlan_txfl_wake;BT_bt_wake;BT_host_wake;nfc_wake_lock;rmnet0;nfc_wake_lock;bluetooth_timer;event0;GPSD;umts_ipc0;NETLINK;ssp_comm_wake_lock;epoll_system_server_file:[timerfd4_system_server];epoll_system_server_file:[timerfd7_system_server];epoll_InputReader_file:event1;epoll_system_server_file:[timerfd5_system_server];epoll_InputReader_file:event10;epoll_InputReader_file:event0;epoll_InputReader_epollfd;epoll_system_server_epollfd' > /sys/devices/virtual/misc/boeffla_wakelock_blocker/wakelock_blocker
	echo " " >> $LOG;

	# echo "## -- Sched features Fix" >> $LOG;

    ## Enhanched SlickSleep
    echo "NO_NORMALIZED_SLEEPER" > /sys/kernel/debug/sched_features
    echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
    echo "NO_NORMALIZED_SLEEPER" > /sys/kernel/debug/sched_features
    echo "NO_NEW_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
    echo "NO_START_DEBIT" > /sys/kernel/debug/sched_features
    echo "NO_HRTICK" > /sys/kernel/debug/sched_features
    echo "NO_CACHE_HOT_BUDDY" > /sys/kernel/debug/sched_features
    echo "NO_LB_BIAS" > /sys/kernel/debug/sched_features
    echo "NO_OWNER_SPIN" > /sys/kernel/debug/sched_features
    echo "NO_DOUBLE_TICK" > /sys/kernel/debug/sched_features
    echo "NO_AFFINE_WAKEUPS" > /sys/kernel/debug/sched_features
    echo "NO_NEXT_BUDDY" > /sys/kernel/debug/sched_features
    echo "NO_WAKEUP_OVERLAP" > /sys/kernel/debug/sched_features
	
	## Kernel no debugs
    echo "NO_AFFINE_WAKEUPS" >> /sys/kernel/debug/sched_features
    echo "NO_ARCH_POWER" >> /sys/kernel/debug/sched_features
    echo "NO_CACHE_HOT_BUDDY" >> /sys/kernel/debug/sched_features
    echo "NO_DOUBLE_TICK" >> /sys/kernel/debug/sched_features
    echo "NO_FORCE_SD_OVERLAP" >> /sys/kernel/debug/sched_features
    echo "NO_GENTLE_FAIR_SLEEPERS" >> /sys/kernel/debug/sched_features
    echo "NO_HRTICK" >> /sys/kernel/debug/sched_features
    echo "NO_LAST_BUDDY" >> /sys/kernel/debug/sched_features
    echo "NO_LB_BIAS" >> /sys/kernel/debug/sched_features
    echo "NO_LB_MIN" >> /sys/kernel/debug/sched_features
    echo "NO_NEW_FAIR_SLEEPERS" >> /sys/kernel/debug/sched_features
    echo "NO_NEXT_BUDDY" >> /sys/kernel/debug/sched_features
    echo "NO_NONTASK_POWER" >> /sys/kernel/debug/sched_features
    echo "NO_NORMALIZED_SLEEPERS" >> /sys/kernel/debug/sched_features
    echo "NO_OWNER_SPIN" >> /sys/kernel/debug/sched_features
    echo "NO_RT_RUNTIME_SHARE" >> /sys/kernel/debug/sched_features
    echo "NO_START_DEBIT" >> /sys/kernel/debug/sched_features
    echo "NO_TTWU_QUEUE" >> /sys/kernel/debug/sched_features
	echo " " >> $LOG;

	# Init.d support
	echo "## -- Start Init.d support" >> $LOG;
	if [ ! -d /vendor/etc/init.d ]; then
	    	mkdir -p /vendor/etc/init.d;
	fi

	chown -R root.root /vendor/etc/init.d;
	chmod 755 /vendor/etc/init.d;

	# remove detach script
	rm -f /vendor/etc/init.d/*detach* 2>/dev/null;
	rm -rf /data/magisk_backup_* 2>/dev/null;

	if [ "$(ls -A /vendor/etc/init.d)" ]; then
		chmod 755 /vendor/etc/init.d/*;

		for FILE in /vendor/etc/init.d/*; do
			echo "## -- Executing init.d script: $FILE" >> $LOG;
			sh $FILE >/dev/null;
	    	done;
	else
		echo "## -- No files found" >> $LOG;
	fi
	echo "## -- End Init.d support" >> $LOG;
	echo " " >> $LOG;

chmod 777 $LOG;

