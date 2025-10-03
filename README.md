# 利用iptables设置端口转发的shell脚本

> ✨ **增强版本**: 这是基于 [arloor/iptablesUtils](https://github.com/arloor/iptablesUtils) 的 fork 版本，新增了**备注功能**，支持为转发规则添加描述信息，方便管理和识别。

## 项目作用

1. 便捷地设置iptables流量转发规则
2. 当域名解析的地址发生变化时，自动更新流量转发规则，不需要手动变更（适用于ddns域名）
3. 支持为转发规则添加备注，方便管理和识别规则用途

## 用法

### 方式一：直接运行（推荐）

```shell
# 使用本 fork 版本(支持备注功能)
bash <(curl -fsSL https://raw.githubusercontent.com/occamrazor1492/iptablesUtils/master/natcfg.sh)
```

或使用原版（不支持备注功能）：
```shell
# 原版 - 如果vps不能访问 raw.githubusercontent.com 推荐使用这个
bash <(curl -fsSL https://www.arloor.com/sh/iptablesUtils/natcfg.sh)
# 原版 - GitHub直连
bash <(curl -fsSL https://raw.githubusercontent.com/arloor/iptablesUtils/master/natcfg.sh)
```

### 方式二：下载后运行

如果你希望先下载脚本文件到本地再运行：

```shell
# 下载增强版本(支持备注功能)
wget https://raw.githubusercontent.com/occamrazor1492/iptablesUtils/master/natcfg.sh
# 或使用 curl
curl -fsSL https://raw.githubusercontent.com/occamrazor1492/iptablesUtils/master/natcfg.sh -o natcfg.sh

# 然后运行
bash natcfg.sh
```

下载原版（不支持备注功能）：
```shell
# 下载原版
wget https://raw.githubusercontent.com/arloor/iptablesUtils/master/natcfg.sh
# 或使用 curl
curl -fsSL https://raw.githubusercontent.com/arloor/iptablesUtils/master/natcfg.sh -o natcfg.sh

# 然后运行
bash natcfg.sh
```

输出如下：

```
#############################################################
# Usage: setup iptables nat rules for domian/ip             #
# Website:  http://www.arloor.com/                          #
# Author: ARLOOR <admin@arloor.com>                         #
# Github: https://github.com/arloor/iptablesUtils           #
#############################################################

你要做什么呢（请输入数字）？Ctrl+C 退出本脚本
1) 增加转发规则          3) 列出所有转发规则
2) 删除转发规则          4) 查看当前iptables配置
#?
```

此时按照需要，输入1-4中的任意数字，然后按照提示即可

### 备注功能使用说明

增强版本在原有功能基础上新增了备注功能，使用流程如下：

#### 添加转发规则（新增备注步骤）

1. 选择 `1) 增加转发规则`
2. 输入本地端口号
3. 输入远程端口号
4. 输入目标域名/IP
5. **✨ 新增步骤**: 输入备注(可选，直接回车跳过)

**实际交互示例：**
```
你要做什么呢（请输入数字）？Ctrl+C 退出本脚本
1) 增加转发规则          3) 列出所有转发规则
2) 删除转发规则          4) 查看当前iptables配置
#? 1

本地端口号:8080
远程端口号:80
目标域名/IP:example.com
备注(可选):网站代理服务

成功添加转发规则 8080>example.com:80 (备注: 网站代理服务)
```

#### 查看转发规则（增强显示）

选择 `3) 列出所有转发规则` 时，会显示：
```
转发规则： 8080>example.com:80 备注: 网站代理服务
转发规则： 9090>google.com:443
```

ℹ️ **注意：**
- 如果不需要备注，在“备注(可选)”提示时直接按回车即可
- 没有备注的规则在列表中不会显示备注部分
- 删除规则时会自动清理对应的备注信息

## 卸载

```shell
# 使用本 fork 版本的卸载脚本
wget --no-check-certificate -qO uninstall.sh https://raw.githubusercontent.com/occamrazor1492/iptablesUtils/master/dnat-uninstall.sh && bash uninstall.sh
```

或使用原版卸载脚本：
```shell
wget --no-check-certificate -qO uninstall.sh https://raw.githubusercontent.com/arloor/iptablesUtils/master/dnat-uninstall.sh && bash uninstall.sh
```

卸载脚本会自动清理所有配置文件，包括主配置文件和备注文件

## 查看日志

```shell
journalctl -exu dnat
```

## 配置文件备份和导入导出

### 主配置文件
```shell
/etc/dnat/conf
```
存储所有转发规则，格式：`本地端口>目标域名:目标端口`

### 备注文件
```shell
/etc/dnat/notes
```
存储规则对应的备注信息，格式：`本地端口>目标域名:目标端口#备注内容`

**注意**：备份配置时请同时备份两个文件以保持完整性

## trojan转发

总是有人说，不能转发trojan，这么说的人大部分是证书配置不对。最简单的解决方案是：客户端选择不验证证书。复杂一点是自己把证书和中转机的域名搭配好。

小白记住一句话就好：客户端不验证证书。

-----------------------------------------------------------------------------

## 推荐新项目——使用nftables实现nat转发

iptables的后继者nftables已经在debain和centos最新的操作系统中作为生产工具提供，nftables提供了很多新的特性，解决了iptables很多痛点。

因此创建了一个新的项目[/arloor/nftables-nat-rust](https://github.com/arloor/nftables-nat-rust)。该项目使用nftables作为nat转发实现，相比本项目具有如下优点：

1. 支持端口段转发
2. 转发规则使用配置文件，可以进行备份以及导入
3. 更加现代

所以**强烈推荐**使用[/arloor/nftables-nat-rust](https://github.com/arloor/nftables-nat-rust)。不用担心，本项目依然可以正常稳定使用。

PS: 新旧两个项目并不兼容，切换到新项目时，请先卸载此项目

## 电报交流群

[https://t.me/popstary](https://t.me/popstary)

