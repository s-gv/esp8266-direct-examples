#include "ets_sys.h"
#include "osapi.h"
#include "gpio.h"
#include "pwm.h"
#include "os_type.h"

#include "user_interface.h"


static os_timer_t some_timer;

void some_timerfunc(void *arg)
{
    uint32 duty = pwm_get_duty(0);
    duty += 7500UL;
    if(duty > 220000UL) {
        duty = 0;
    }
    pwm_set_duty(duty, 0);
    pwm_start();
}

void ICACHE_FLASH_ATTR user_init()
{
    uint32 pwm_period = 10000; // 10000us or 10ms
    uint32 pwm_duty[1] = {0}; // duty cycle in [0, pwm_period*1000/45]
    uint32 pwm_channel_num = 1;
    uint32 pwm_io_info[][3] = {{PERIPHS_IO_MUX_GPIO2_U, FUNC_GPIO2, 2}}; // GPIO2 (see "eagle_soc.h") is wired to LED
    pwm_init(pwm_period, pwm_duty, 1, pwm_io_info);
    pwm_start();

    // setup timer (50ms, repeating)
    os_timer_setfn(&some_timer, some_timerfunc, NULL);
    os_timer_arm(&some_timer, 50, 1);
}

