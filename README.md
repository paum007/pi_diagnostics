# Pi diagnostics bash file

This file contains a script that writes all of the sensor data that the pi is recieving to a text file every ten seconds. This can be used as a debugging tool.

# Contents

- [Execute instructions](#how-to-execute)
- [How to use](#how-to-use)
- [What does the data mean](#data-contianed-in-the-log_data-file)

# How to execute

To be able to execute the file you first need to make it executable by typing the following command into the linux terminal:

**Make sure you're in the same directory or use the full path.**

```bash
chmod +x ~/pi_diagnostics/pi_diagnostincs.sh
```

`chmod`: change file permissions

`+x`: add executable permission

Then (assuming you're in the correct directory), just type into the terminal:

```bash
./pi_diagnostics.sh
```

# How to use

You will need to input the way you receive the data. So you will need to enter either 1, 2 or 3 into the terminal.

| Number        | Meaning                                             |
| ------------- | --------------------------------------------------- |
| **1**         | Write to the file **only**                          |
| **2**         | Display in the terminal **only**                    |
| **3**         | Both, write to the file and display in the terminal |

# Data contianed in the *log_data* file:

1. Timestamp: Displays the date and time.
2. IP Address: Shows the IP address of the Pi. This is useful if you want to ssh into the Pi via Wi-Fi.
3. CPU Temp: The temperature at the Central Processing Unit.
4. CPU Usage: How busy the CPU is, usually as a percentage. It tells us if the CPU is being overworked or if there are any background processes hogging up system resources

    ### Breakdown:

    Field            | Meaning                           |
    | -------------- | --------------------------------- |
    | **sy**         | System (kernel, drivers)          |
    | **ni**         | Nice (low-priority tasks)         |
    | **id**         | Idle (free CPU time)              |
    | **wa**         | Waiting for I/O (e.g., SD card)   |

5. CPU Frequency: Measures the current speed of the CPU in Hertz (Hz), which adjusts dynamically depending on load and temperature

    You need to take into account that if the CPU is hot or undervolted, the Pi will throttle the clock down to reduce heat or power draw. 

    ### **Lower frequency = lower performance**

6. Throttle Status: Throttling is the deliberate slowing down of a process or resource usage. It can be caused by two main factors: overheating and under-voltage (fancier term for not enough power).

    An output can look like this: `throttled=0x0`

    ### What it means:

     Value           | Meaning                       |
    | -------------- |------------------------------ |
    | **0x0**        | All good                      |
    | **0x50005**    | Overheat and undervolt issues |
    | **0x1**        | Currently undervolted         |
    | **0x2**        | Currently throttled           |

7. Load average: This data will show you how many processes are actively using or waiting for CPU time. It's a rolling average of the past 1, 5, and 15 minutes.
    An example output is as follows: ```load average: 0.3, 0.25, 0.20```.

    The Pi that I am using is a quad-core cpu. You can check the number of cores by typing ```lscpu``` into the terminal.

    For a quad-core Pi:

    - `4.00` is 100% full load
    - `2.00` is 50% load

    If the load average is consistently higher than the number of CPU cores, the Pi is overloaded.

8. GPU Memory: How much RAM is allocated to the graphics processor (GPU)

    On headless systems (no desktop or GUI, common if you are using ssh), you can reduce how much memory the GPU uses to free up RAM for other tasks.

    This can be set via `raspi-config` or by editing `/boot/config.txt` (`gpu_mem=16` is common for headless use).

9. Memory Usage: How much memory has been used and how much memory is free.                                  

10. Disk Space: This refers to the amount of storage available and used on the system files.

    ### What each column means:
    Column           | Meaning                           |
    | -------------- | --------------------------------- |
    | **Filesystem** | The disk or partition name        |
    | **Size**       | Total capacity                    |
    | **Used**       | Space currently used              |
    | **Avail**      | Space still available             |
    | **Use%**       | Percentage of usage               |
    | **Mounted on** | Where it is used in the file tree |




