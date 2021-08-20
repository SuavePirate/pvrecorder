#!/bin/bash
#
# A script to get the platform and architecture the system is running.

kernel=$(uname -s)
arch=$(uname -m)

case $kernel in
  "Darwin")
    kernel="mac"
    case $arch in
      "x86_64") ;;
      *) exit 1;;
    esac;;
  "Linux")
    kernel="linux"
    case $arch in
      "x86_64") ;;
      "arm*" | "aarch64")
        arch_info=''
        if [[ $arch == "aarch64" ]]; then
          arch_info=$arch
        fi
        IFS=$'\n'
        read -r cpu_part_list <<< "$(cat /proc/cpuinfo)"
        for line in "${cpu_part_list[@]}"; do
          if [[ $line == *"CPU Part"* ]]; then
            cpu_part=${line##*'\s'}
            case $cpu_part in
              "0xb76") kernel="raspberry-pi" arch="arm11"+$arch_info;;
              "0xc07") kernel="raspberry-pi" arch="cortex11"+$arch_info ;;
              "0xd03") kernel="raspberry-pi" arch="cortex-a53"+$arch_info ;;
              "0xd07") kernel="jetson" arch="cortex-a57"+$arch_info ;;
              "0xd08") kernel="raspberry-pi" arch="cortex-a72"+$arch_info ;;
              "0xc08") kernel="beaglebone" arch=$arch_info ;;
              *) exit 1;;
            esac
          fi
        done
    esac
    ;;
  *) exit 0;;
esac

echo -n "$kernel $arch"
exit 0