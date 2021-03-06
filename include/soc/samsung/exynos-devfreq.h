/* linux/arch/arm64/mach-exynos/include/mach/exynos-devfreq.h
 *
 * Copyright (c) 2015 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#ifndef __EXYNOS_DEVFREQ_H_
#define __EXYNOS_DEVFREQ_H_

#include <linux/devfreq.h>
#include <linux/pm_qos.h>
#include <linux/clk.h>
#include <soc/samsung/exynos-devfreq-dep.h>
#ifdef CONFIG_EXYNOS_DVFS_MANAGER
#include <soc/samsung/exynos-dm.h>
#endif

#define EXYNOS_DEVFREQ_MODULE_NAME	"exynos-devfreq"
#define VOLT_STEP			25000
#define MAX_NR_CONSTRAINT		DM_TYPE_END
#define DATA_INIT			5
#define SET_CONST			1
#define RELEASE				2

/* DEVFREQ GOV TYPE */
#define SIMPLE_INTERACTIVE 0

struct exynos_devfreq_opp_table {
	u32 idx;
	u32 freq;
	u32 volt;
};

struct um_exynos {
	struct list_head node;
	void __iomem **va_base;
	u32 *pa_base;
	u32 *mask_v;
	u32 *mask_a;
	u32 *channel;
	unsigned int um_count;
	u64 val_ccnt;
	u64 val_pmcnt;
};

struct exynos_devfreq_freq_infos {
	/* Basic freq infos */
	// min/max frequency
	u32 max_freq;
	u32 min_freq;
	// cur_freq pointer
	const u32 *cur_freq;
	// min/max pm_qos node
	u32 pm_qos_class;
	u32 pm_qos_class_max;
	// num of freqs
	u32 max_state;
};

struct exynos_devfreq_profile {
	int num_stats;
	/* Total time in state */
	ktime_t *time_in_state;
	ktime_t last_time_in_state;

	/* Active time in state */
	ktime_t *active_time_in_state;
	ktime_t last_active_time_in_state;

	u64 **freq_stats;
	u64 *last_freq_stats;
};

struct exynos_devfreq_data {
	struct device				*dev;
	struct devfreq				*devfreq;
	struct mutex				lock;
	struct clk				*clk;

	bool					devfreq_disabled;

	u32		devfreq_type;

	struct exynos_devfreq_opp_table		*opp_list;

	u32					default_qos;

	u32					max_state;
	struct devfreq_dev_profile		devfreq_profile;

	u32		gov_type;
	const char				*governor_name;
	u32					cal_qos_max;
	void					*governor_data;
#if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_INTERACTIVE)
	struct devfreq_simple_interactive_data	simple_interactive_data;
#endif
	u32					dfs_id;
	s32					old_idx;
	s32					new_idx;
	u32					old_freq;
	u32					new_freq;
	u32					min_freq;
	u32					max_freq;
	u32					reboot_freq;
	u32					boot_freq;

	u32					old_volt;
	u32					new_volt;

	u32					pm_qos_class;
	u32					pm_qos_class_max;
	struct pm_qos_request			sys_pm_qos_min;
#ifdef CONFIG_ARM_EXYNOS_DEVFREQ_DEBUG
	struct pm_qos_request			debug_pm_qos_min;
	struct pm_qos_request			debug_pm_qos_max;
#endif
	struct pm_qos_request			default_pm_qos_min;
	struct pm_qos_request			default_pm_qos_max;
	struct pm_qos_request			boot_pm_qos;
	u32					boot_qos_timeout;

	struct notifier_block			reboot_notifier;

	u32					ess_flag;

	s32					target_delay;

#ifdef CONFIG_EXYNOS_DVFS_MANAGER
	u32		dm_type;
	u32		nr_constraint;
	struct exynos_dm_constraint		**constraint;
#endif
	void					*private_data;
	bool					use_acpm;
	bool					bts_update;
	bool					update_fvp;
	bool					use_get_dev;
	bool					use_dtm;

	struct devfreq_notifier_block		*um_nb;
	struct um_exynos			um_data;
	u64					last_monitor_period;
	u64					last_monitor_time;
	u32					last_um_usage_rate;

	struct exynos_pm_domain *pm_domain;
	struct exynos_devfreq_profile		*profile;
};

s32 exynos_devfreq_get_opp_idx(struct exynos_devfreq_opp_table *table,
				unsigned int size, u32 freq);
#if defined(CONFIG_ARM_EXYNOS_DEVFREQ) && defined(CONFIG_EXYNOS_DVFS_MANAGER)
u32 exynos_devfreq_get_dm_type(u32 devfreq_type);
u32 exynos_devfreq_get_devfreq_type(int dm_type);
struct devfreq *find_exynos_devfreq_device(void *devdata);
int find_exynos_devfreq_dm_type(struct device *dev, int *dm_type);
#endif

#ifdef CONFIG_EXYNOS_ALT_DVFS
extern int exynos_devfreq_alt_mode_change(unsigned int devfreq_type, int new_mode);
#endif

#if defined(CONFIG_ARM_EXYNOS_DEVFREQ)
extern unsigned long exynos_devfreq_get_domain_freq(unsigned int devfreq_type);
void exynos_devfreq_get_profile(unsigned int devfreq_type, ktime_t **time_in_state, u64 **tables);
extern void exynos_devfreq_get_freq_infos(unsigned int devfreq_type, struct exynos_devfreq_freq_infos *infos);
#else
static inline unsigned long exynos_devfreq_get_domain_freq(unsigned int devfreq_type)
{
	return 0;
}
#endif
#endif	/* __EXYNOS_DEVFREQ_H_ */
