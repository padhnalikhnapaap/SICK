#!/bin/bash

# Hardware Information Collection Script
# 硬件信息收集脚本
# Compatible with Debian/Ubuntu/CentOS/AlmaLinux/Rocky Linux/CloudLinux/Arch Linux/openSUSE/Fedora/Alpine Linux
# 兼容 Debian/Ubuntu/CentOS/AlmaLinux/Rocky Linux/CloudLinux/Arch Linux/openSUSE/Fedora/Alpine Linux

VERSION="1.0.0"
SCRIPT_NAME="Hardware Info Collector"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Default language
LANG_MODE="en"

# Language definitions
declare -A LABELS_EN=(
    ["title"]="System Hardware Information Report"
    ["system_info"]="System Information"
    ["cpu_info"]="CPU Information"
    ["ram_info"]="Memory (RAM) Information"
    ["disk_info"]="Disk Drive Information"
    ["raid_info"]="RAID Controller Information"
    ["network_info"]="Network Interface Information"
    ["motherboard_info"]="Motherboard Information"
    ["other_hw"]="Other Hardware Information"
    ["hostname"]="Hostname"
    ["os"]="Operating System"
    ["kernel"]="Kernel Version"
    ["uptime"]="System Uptime"
    ["model"]="Model"
    ["cores"]="Cores"
    ["threads"]="Threads"
    ["frequency"]="Frequency"
    ["cache"]="Cache"
    ["usage"]="Usage"
    ["total"]="Total"
    ["used"]="Used"
    ["free"]="Free"
    ["available"]="Available"
    ["speed"]="Speed"
    ["type"]="Type"
    ["size"]="Size"
    ["vendor"]="Vendor"
    ["status"]="Status"
    ["temperature"]="Temperature"
    ["read_io"]="Read I/O"
    ["write_io"]="Write I/O"
    ["manufacturer"]="Manufacturer"
    ["configured_speed"]="Configured Speed"
    ["no_info"]="No information available"
    ["not_detected"]="Not detected"
    ["generating"]="Generating hardware report..."
    ["completed"]="Report generation completed!"
)

declare -A LABELS_CN=(
    ["title"]="系统硬件信息报告"
    ["system_info"]="系统信息"
    ["cpu_info"]="处理器信息"
    ["ram_info"]="内存信息"
    ["disk_info"]="硬盘信息"
    ["raid_info"]="RAID控制器信息"
    ["network_info"]="网卡信息"
    ["motherboard_info"]="主板信息"
    ["other_hw"]="其他硬件信息"
    ["hostname"]="主机名"
    ["os"]="操作系统"
    ["kernel"]="内核版本"
    ["uptime"]="运行时间"
    ["model"]="型号"
    ["cores"]="核心数"
    ["threads"]="线程数"
    ["frequency"]="频率"
    ["cache"]="缓存"
    ["usage"]="使用率"
    ["total"]="总计"
    ["used"]="已用"
    ["free"]="空闲"
    ["available"]="可用"
    ["speed"]="速度"
    ["type"]="类型"
    ["size"]="大小"
    ["vendor"]="厂商"
    ["status"]="状态"
    ["temperature"]="温度"
    ["read_io"]="读取IO"
    ["write_io"]="写入IO"
    ["manufacturer"]="制造商"
    ["configured_speed"]="配置速度"
    ["no_info"]="无可用信息"
    ["not_detected"]="未检测到"
    ["generating"]="正在生成硬件报告..."
    ["completed"]="报告生成完成！"
)

# Function to get label based on current language
get_label() {
    local key="$1"
    if [[ "$LANG_MODE" == "cn" ]]; then
        echo "${LABELS_CN[$key]}"
    else
        echo "${LABELS_EN[$key]}"
    fi
}

# Function to print colored output
print_color() {
    local color="$1"
    local text="$2"
    echo -e "${color}${text}${NC}"
}

# Function to print section header
print_header() {
    local title="$1"
    local width=80
    local padding=$(( (width - ${#title}) / 2 ))
    
    echo
    print_color "$CYAN" "$(printf '═%.0s' $(seq 1 $width))"
    print_color "$WHITE" "$(printf '%*s%s%*s' $padding '' "$title" $padding '')"
    print_color "$CYAN" "$(printf '═%.0s' $(seq 1 $width))"
    echo
}

# Function to print sub-section
print_subsection() {
    local title="$1"
    print_color "$YELLOW" "┌─ $title"
    print_color "$YELLOW" "├$(printf '─%.0s' $(seq 1 $((${#title} + 2))))"
}

# Function to print info line
print_info() {
    local label="$1"
    local value="$2"
    printf "│ %-20s: %s\n" "$label" "$value"
}

# Function to print table header
print_table_header() {
    local cols=("$@")
    local line="├"
    local header="│"
    
    for col in "${cols[@]}"; do
        line+="$(printf '─%.0s' $(seq 1 18))┬"
        header+="$(printf " %-16s │" "$col")"
    done
    
    line="${line%┬}┤"
    print_color "$YELLOW" "$line"
    print_color "$WHITE" "$header"
    
    line="├"
    for col in "${cols[@]}"; do
        line+="$(printf '─%.0s' $(seq 1 18))┼"
    done
    line="${line%┼}┤"
    print_color "$YELLOW" "$line"
}

# Function to print table row
print_table_row() {
    local cols=("$@")
    local row="│"
    
    for col in "${cols[@]}"; do
        row+="$(printf " %-16s │" "$col")"
    done
    
    echo "$row"
}

# Function to detect distribution
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    elif [[ -f /etc/redhat-release ]]; then
        echo "centos"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/alpine-release ]]; then
        echo "alpine"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/SuSE-release ]]; then
        echo "opensuse"
    else
        echo "unknown"
    fi
}

# Function to get package manager
get_package_manager() {
    local distro=$(detect_distro)
    case "$distro" in
        "ubuntu"|"debian"|"linuxmint")
            echo "apt"
            ;;
        "centos"|"rhel"|"almalinux"|"rocky"|"cloudlinux")
            if command -v dnf >/dev/null 2>&1; then
                echo "dnf"
            else
                echo "yum"
            fi
            ;;
        "fedora")
            echo "dnf"
            ;;
        "arch"|"manjaro")
            echo "pacman"
            ;;
        "opensuse"|"sles")
            echo "zypper"
            ;;
        "alpine")
            echo "apk"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Function to install required packages
install_packages() {
    local pkg_manager=$(get_package_manager)
    local packages_needed=()
    
    # Check for required commands
    command -v dmidecode >/dev/null 2>&1 || packages_needed+=("dmidecode")
    command -v lshw >/dev/null 2>&1 || packages_needed+=("lshw")
    command -v smartctl >/dev/null 2>&1 || packages_needed+=("smartmontools")
    command -v iostat >/dev/null 2>&1 || packages_needed+=("sysstat")
    
    if [[ ${#packages_needed[@]} -gt 0 ]]; then
        echo "Installing required packages: ${packages_needed[*]}"
        case "$pkg_manager" in
            "apt")
                sudo apt-get update >/dev/null 2>&1
                sudo apt-get install -y "${packages_needed[@]}" >/dev/null 2>&1
                ;;
            "dnf")
                sudo dnf install -y "${packages_needed[@]}" >/dev/null 2>&1
                ;;
            "yum")
                sudo yum install -y "${packages_needed[@]}" >/dev/null 2>&1
                ;;
            "pacman")
                sudo pacman -S --noconfirm "${packages_needed[@]}" >/dev/null 2>&1
                ;;
            "zypper")
                sudo zypper install -y "${packages_needed[@]}" >/dev/null 2>&1
                ;;
            "apk")
                sudo apk add "${packages_needed[@]}" >/dev/null 2>&1
                ;;
        esac
    fi
}

# Function to get system information
get_system_info() {
    print_subsection "$(get_label "system_info")"
    
    print_info "$(get_label "hostname")" "$(hostname)"
    print_info "$(get_label "os")" "$(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo "$(get_label "no_info")")"
    print_info "$(get_label "kernel")" "$(uname -r)"
    print_info "$(get_label "uptime")" "$(uptime -p 2>/dev/null || uptime | cut -d',' -f1 | sed 's/.*up //')"
    
    echo "└$(printf '─%.0s' $(seq 1 50))"
}

# Function to get CPU information
get_cpu_info() {
    print_subsection "$(get_label "cpu_info")"
    
    local cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')
    local cpu_cores=$(grep "cpu cores" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')
    local cpu_threads=$(grep "processor" /proc/cpuinfo | wc -l)
    local cpu_freq=$(grep "cpu MHz" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')
    local cpu_cache=$(grep "cache size" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')
    
    print_info "$(get_label "model")" "${cpu_model:-$(get_label "no_info")}"
    print_info "$(get_label "cores")" "${cpu_cores:-$(get_label "no_info")}"
    print_info "$(get_label "threads")" "${cpu_threads:-$(get_label "no_info")}"
    print_info "$(get_label "frequency")" "${cpu_freq:+${cpu_freq} MHz}"
    print_info "$(get_label "cache")" "${cpu_cache:-$(get_label "no_info")}"
    
    # CPU usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//' 2>/dev/null)
    print_info "$(get_label "usage")" "${cpu_usage:+${cpu_usage}%}"
    
    echo "└$(printf '─%.0s' $(seq 1 50))"
}

# Function to get RAM information
get_ram_info() {
    print_subsection "$(get_label "ram_info")"
    
    # Memory from /proc/meminfo
    local mem_total=$(grep MemTotal /proc/meminfo | awk '{printf "%.2f GB", $2/1024/1024}')
    local mem_available=$(grep MemAvailable /proc/meminfo | awk '{printf "%.2f GB", $2/1024/1024}')
    local mem_used=$(free -h | grep Mem | awk '{print $3}')
    
    print_info "$(get_label "total")" "$mem_total"
    print_info "$(get_label "used")" "$mem_used"
    print_info "$(get_label "available")" "$mem_available"
    
    # Memory modules table
    if command -v dmidecode >/dev/null 2>&1; then
        echo "│"
        print_color "$GREEN" "│ Memory Modules:"
        
        # Print table header
        print_table_header "$(get_label "size")" "$(get_label "type")" "$(get_label "speed")" "$(get_label "manufacturer")"
        
        # Parse dmidecode output for memory modules
        dmidecode -t memory 2>/dev/null | awk '
        BEGIN { 
            size=""; type=""; speed=""; manufacturer=""; 
            in_memory_device=0
        }
        /Memory Device/ { 
            if (size != "" && size != "No Module Installed") {
                printf "│ %-16s │ %-16s │ %-16s │ %-16s │\n", size, type, speed, manufacturer
            }
            size=""; type=""; speed=""; manufacturer=""
            in_memory_device=1
        }
        /^\s*Size:/ && in_memory_device { 
            size = $2
            for(i=3; i<=NF; i++) size = size " " $i
            if (size == "No Module Installed") size = ""
        }
        /^\s*Type:/ && in_memory_device && type == "" { 
            type = $2
            for(i=3; i<=NF; i++) type = type " " $i
        }
        /^\s*Speed:/ && in_memory_device { 
            speed = $2
            for(i=3; i<=NF; i++) speed = speed " " $i
        }
        /^\s*Manufacturer:/ && in_memory_device { 
            manufacturer = $2
            for(i=3; i<=NF; i++) manufacturer = manufacturer " " $i
        }
        END {
            if (size != "" && size != "No Module Installed") {
                printf "│ %-16s │ %-16s │ %-16s │ %-16s │\n", size, type, speed, manufacturer
            }
        }'
        
        # Print table footer
        print_color "$YELLOW" "└$(printf '─%.0s' $(seq 1 76))┘"
    fi
    
    echo "└$(printf '─%.0s' $(seq 1 50))"
}

# Function to get disk information
get_disk_info() {
    print_subsection "$(get_label "disk_info")"
    
    # Disk usage
    df -h | grep -E '^/dev/' | while IFS= read -r line; do
        echo "│ $line"
    done
    
    echo "│"
    print_color "$GREEN" "│ Physical Disks:"
    
    # Physical disk information with I/O statistics
    for disk in $(lsblk -d -n -o NAME | grep -E '^[sv]d[a-z]$|^nvme[0-9]+n[0-9]+$'); do
        local disk_info=$(lsblk -d -n -o SIZE,MODEL,VENDOR "/dev/$disk" 2>/dev/null)
        echo "│   /dev/$disk: $disk_info"
        
        # Get I/O statistics if iostat is available
        if command -v iostat >/dev/null 2>&1; then
            local io_stats=$(iostat -d "$disk" 1 2 2>/dev/null | tail -1)
            if [[ -n "$io_stats" ]]; then
                local read_kb=$(echo "$io_stats" | awk '{print $3}')
                local write_kb=$(echo "$io_stats" | awk '{print $4}')
                echo "│     $(get_label "read_io"): ${read_kb} KB/s, $(get_label "write_io"): ${write_kb} KB/s"
            fi
        fi
        
        # Temperature monitoring
        if command -v smartctl >/dev/null 2>&1; then
            local temp=$(smartctl -A "/dev/$disk" 2>/dev/null | grep Temperature | head -1 | awk '{print $10}')
            if [[ -n "$temp" ]]; then
                echo "│     $(get_label "temperature"): ${temp}°C"
            fi
        fi
        echo "│"
    done
    
    echo "└$(printf '─%.0s' $(seq 1 50))"
}

# Function to get RAID information
get_raid_info() {
    print_subsection "$(get_label "raid_info")"
    
    local raid_found=false
    
    # Check for software RAID
    if [[ -f /proc/mdstat ]]; then
        local md_info=$(cat /proc/mdstat | grep -E '^md[0-9]')
        if [[ -n "$md_info" ]]; then
            echo "│ Software RAID:"
            echo "$md_info" | while IFS= read -r line; do
                echo "│   $line"
            done
            raid_found=true
        fi
    fi
    
    # Check for hardware RAID controllers
    if command -v lspci >/dev/null 2>&1; then
        local raid_controllers=$(lspci | grep -i raid)
        if [[ -n "$raid_controllers" ]]; then
            echo "│ Hardware RAID Controllers:"
            echo "$raid_controllers" | while IFS= read -r line; do
                echo "│   $line"
            done
            raid_found=true
        fi
    fi
    
    if [[ "$raid_found" == false ]]; then
        print_info "$(get_label "status")" "$(get_label "not_detected")"
    fi
    
    echo "└$(printf '─%.0s' $(seq 1 50))"
}

# Function to get network information
get_network_info() {
    print_subsection "$(get_label "network_info")"
    
    # Network interfaces
    ip link show 2>/dev/null | grep -E '^[0-9]+:' | while IFS= read -r line; do
        local interface=$(echo "$line" | cut -d':' -f2 | sed 's/^ *//')
        local status=$(echo "$line" | grep -o "state [A-Z]*" | cut -d' ' -f2)
        echo "│ $interface - Status: $status"
        
        # Get IP address
        local ip=$(ip addr show "$interface" 2>/dev/null | grep "inet " | head -1 | awk '{print $2}')
        if [[ -n "$ip" ]]; then
            echo "│   IP: $ip"
        fi
        
        # Get MAC address
        local mac=$(ip link show "$interface" 2>/dev/null | grep "link/ether" | awk '{print $2}')
        if [[ -n "$mac" ]]; then
            echo "│   MAC: $mac"
        fi
        
        # Get speed if available
        local speed_file="/sys/class/net/$interface/speed"
        if [[ -r "$speed_file" ]]; then
            local speed=$(cat "$speed_file" 2>/dev/null)
            if [[ "$speed" != "-1" && -n "$speed" ]]; then
                echo "│   Speed: ${speed} Mbps"
            fi
        fi
        echo "│"
    done
    
    echo "└$(printf '─%.0s' $(seq 1 50))"
}

# Function to get motherboard information
get_motherboard_info() {
    print_subsection "$(get_label "motherboard_info")"
    
    if command -v dmidecode >/dev/null 2>&1; then
        local mb_vendor=$(dmidecode -s baseboard-manufacturer 2>/dev/null)
        local mb_product=$(dmidecode -s baseboard-product-name 2>/dev/null)
        local mb_version=$(dmidecode -s baseboard-version 2>/dev/null)
        local bios_vendor=$(dmidecode -s bios-vendor 2>/dev/null)
        local bios_version=$(dmidecode -s bios-version 2>/dev/null)
        
        print_info "$(get_label "vendor")" "${mb_vendor:-$(get_label "no_info")}"
        print_info "$(get_label "model")" "${mb_product:-$(get_label "no_info")}"
        print_info "Version" "${mb_version:-$(get_label "no_info")}"
        print_info "BIOS Vendor" "${bios_vendor:-$(get_label "no_info")}"
        print_info "BIOS Version" "${bios_version:-$(get_label "no_info")}"
    else
        print_info "$(get_label "status")" "$(get_label "no_info") (dmidecode required)"
    fi
    
    echo "└$(printf '─%.0s' $(seq 1 50))"
}

# Function to get other hardware information
get_other_hardware() {
    print_subsection "$(get_label "other_hw")"
    
    # USB devices
    if command -v lsusb >/dev/null 2>&1; then
        print_color "$GREEN" "│ USB Devices:"
        lsusb | while IFS= read -r line; do
            echo "│   $line"
        done
        echo "│"
    fi
    
    # PCI devices
    if command -v lspci >/dev/null 2>&1; then
        print_color "$GREEN" "│ PCI Devices (Major):"
        lspci | grep -E "(VGA|Audio|Ethernet|Network|RAID|USB)" | while IFS= read -r line; do
            echo "│   $line"
        done
    fi
    
    echo "└$(printf '─%.0s' $(seq 1 50))"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Hardware Information Collection Script v$VERSION

OPTIONS:
    -cn, --chinese     Display output in Chinese
    -us, --english     Display output in English (default)
    -h, --help         Show this help message
    -v, --version      Show version information

Supported Distributions:
    - Debian/Ubuntu/Linux Mint
    - CentOS/RHEL/AlmaLinux/Rocky Linux/CloudLinux
    - Fedora
    - Arch Linux/Manjaro
    - openSUSE/SLES
    - Alpine Linux

Examples:
    $0                 # Show hardware info in English
    $0 -cn             # Show hardware info in Chinese
    $0 --chinese       # Show hardware info in Chinese

EOF
}

# Function to show version
show_version() {
    echo "$SCRIPT_NAME v$VERSION"
}

# Main function
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -cn|--chinese)
                LANG_MODE="cn"
                shift
                ;;
            -us|--english)
                LANG_MODE="en"
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check if running as root for some commands
    if [[ $EUID -ne 0 ]]; then
        print_color "$YELLOW" "Note: Some hardware information requires root privileges."
        print_color "$YELLOW" "Run with sudo for complete information."
        echo
    fi
    
    # Install required packages
    print_color "$BLUE" "$(get_label "generating")"
    install_packages
    
    # Print title
    print_header "$(get_label "title")"
    
    # Collect all hardware information
    get_system_info
    get_cpu_info
    get_ram_info
    get_disk_info
    get_raid_info
    get_network_info
    get_motherboard_info
    get_other_hardware
    
    # Footer
    echo
    print_color "$GREEN" "$(get_label "completed")"
    print_color "$CYAN" "Generated on: $(date)"
    echo
}

# Run main function
main "$@"
