# 🏥 SICK - Server Info & Check Kit

> **S**erver **I**nfo & **C**heck **K**it - Because knowing your server's health shouldn't make you sick! 😷➡️😎

**🌐 Language / 语言:** [English](README.md) | [中文文档](README_CN.md)

## 🎯 About

SICK is a powerful Linux server hardware information collection tool. The project name comes from the acronym **Server Info & Check Kit**, and also cleverly implies turning "sick" (problematic) server information into something "sick" (awesome)!

### 🤔 Why Called SICK?

- 📊 **S**erver - Hardware servers
- ℹ️ **I**nfo - Information collection  
- ✅ **C**heck - Health checking
- 🛠️ **K**it - Complete toolkit

But more importantly, we want to make the "sick" (frustrating) task of server hardware information collection become "sick" (super cool)!

## ✨ Key Features

### 🌐 Multilingual Support
- 🇺🇸 **English** - Complete English interface
- 🇨🇳 **Chinese** - Complete Chinese interface

### 🖥️ Comprehensive Hardware Detection
- **💻 System Info**: Hostname, OS, kernel version, uptime
- **🧠 CPU Info**: Model, cores, threads, frequency, cache, usage
- **🎯 Memory Info**: Total capacity, usage + detailed memory module table
- **💾 Disk Info**: Disk usage + SMART health status + read/write statistics
- **🌐 Network Info**: Network interfaces + model detection + traffic stats (physical only)
- **🎮 GPU Info**: NVIDIA/AMD/Intel GPU detection
- **🔧 RAID Info**: Software/hardware RAID controllers
- **📋 Motherboard Info**: Vendor, model, BIOS information

### 📊 Smart Data Presentation
- **🎨 Colorful Output**: Beautiful terminal display
- **📋 Table Format**: Neat memory module information tables
- **📏 Perfect Alignment**: Support for mixed Chinese/English display alignment
- **💾 Auto Save**: Simultaneously save as plain text report files

### 🔧 Advanced Features
- **🔍 SMART Detection**: Hard drive health, power-on hours, read/write stats
- **📈 Real-time Data**: CPU usage, IO statistics, network traffic
- **🔌 Auto Installation**: Smart detection and installation of required packages
- **📱 High Compatibility**: Support for mainstream Linux distributions
- **🚫 Virtual Interface Filtering**: Only shows physical network cards (including InfiniBand)

## 🐧 Supported Systems

| Distribution | Package Manager | Test Status |
|--------------|-----------------|-------------|
| **Debian/Ubuntu** | apt | ✅ Fully Supported |
| **CentOS/RHEL** | yum/dnf | ✅ Fully Supported |
| **AlmaLinux/Rocky** | dnf | ✅ Fully Supported |
| **Fedora** | dnf | ✅ Fully Supported |
| **Arch Linux** | pacman | ✅ Fully Supported |
| **openSUSE** | zypper | ✅ Fully Supported |
| **Alpine Linux** | apk | ✅ Fully Supported |

## 🚀 Quick Start

### 📥 Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/SICK.git
cd SICK

# Make executable
chmod +x hardware_info.sh
```

### 🎮 Usage

```bash
# English mode (default)
sudo ./hardware_info.sh

# Chinese mode
sudo ./hardware_info.sh -cn

# Show help
./hardware_info.sh --help

# Show version
./hardware_info.sh --version
```

### 📋 Sample Output

```
════════════════════════════════════════════════════════════════════════════════
                       System Hardware Information Report                       
════════════════════════════════════════════════════════════════════════════════

┌─ Memory (RAM) Information
├──────────────────────────
│ Total               : 30.96 GB
│ Used                : 1.1Gi
│ Available           : 29.87 GB
│
│ Memory Modules:
├────────────────────────────────────────────────────────────────────────────────┤
│ Size     │ Type   │ Frequency    │ Manufacturer │ Serial Number   │ Model                │
├────────────────────────────────────────────────────────────────────────────────┤
│ 16 GB    │ DDR5   │ 5600 MT/s    │ Samsung      │ 4077E4A3        │ M323R2GA3PB0-CWMOD   │
│ 16 GB    │ DDR5   │ 5600 MT/s    │ Samsung      │ 4077E5FC        │ M323R2GA3PB0-CWMOD   │
└────────────────────────────────────────────────────────────────────────────────┘

✓ Report saved to file: hardware_report_server01_20250701_123456.txt
```

## 📊 Output Features

### 🎨 Dual Output
- **🖥️ Screen Display**: Colorful, beautiful real-time display
- **📄 File Save**: Plain text format for easy sharing and archiving

### 📁 File Naming Convention
```
hardware_report_[hostname]_[timestamp].txt
Example: hardware_report_web-server01_20250701_143022.txt
```

## 🔧 Command Options

| Option | Description |
|--------|-------------|
| `-cn, --chinese` | Display in Chinese |
| `-us, --english` | Display in English (default) |
| `-h, --help` | Show help information |
| `-v, --version` | Show version information |

## 🛠️ Dependencies

The script will automatically detect and install the following tools:

| Tool | Purpose | Auto Install |
|------|---------|--------------|
| `dmidecode` | Read hardware information | ✅ |
| `lshw` | Hardware listing tool | ✅ |
| `smartctl` | Disk SMART information | ✅ |
| `iostat` | IO statistics | ✅ |
| `bc` | Mathematical calculations | ✅ |
| `ethtool` | Network card information | ✅ |

## 💡 Usage Tips

### 🔐 Permission Requirements
```bash
# Recommended to run with sudo for complete information
sudo ./hardware_info.sh -cn
```

### 🔧 Troubleshooting
If you encounter issues, please check:
1. Whether you have sudo privileges
2. Whether the system supports required hardware detection commands
3. Whether the network is working (for dependency package installation)


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

Made with ❤️ by Yuri NagaSaki

---

**Make server checking no longer sick (frustrating), but sick (awesome)!** 🚀 
