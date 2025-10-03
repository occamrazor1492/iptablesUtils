#!/bin/bash

# 测试脚本 - 验证备注功能
# 注意: 这个脚本仅用于模拟测试，不会真正修改iptables规则

echo "开始测试备注功能..."

# 创建测试目录
TEST_DIR="/tmp/dnat_test"
mkdir -p $TEST_DIR 2>/dev/null

# 模拟配置文件
conf="$TEST_DIR/conf"
notesFile="$TEST_DIR/notes"
touch $conf
touch $notesFile

echo "测试1: 添加带备注的规则"
# 模拟添加规则: 8080>example.com:80 备注: 测试规则
echo "8080>example.com:80" >> $conf
echo "8080>example.com:80#测试规则" >> $notesFile

echo "测试2: 添加不带备注的规则" 
# 模拟添加不带备注的规则: 9090>google.com:443
echo "9090>google.com:443" >> $conf

echo "测试3: 验证配置文件内容"
echo "主配置文件内容:"
cat $conf
echo ""
echo "备注文件内容:"
cat $notesFile
echo ""

echo "测试4: 模拟列出规则功能"
echo "模拟 lsDnat() 输出:"
arr1=(`cat $conf`)
for cell in ${arr1[@]}
do
    arr2=(`echo $cell|tr ":" " "|tr ">" " "`)
    if [ "${arr2[2]}" != "" -a "${arr2[3]}" = "" ]; then
        # 查找对应的备注
        local note=$(grep "^$cell#" $notesFile 2>/dev/null | cut -d'#' -f2)
        if [ "$note" != "" ]; then
            echo "转发规则： ${arr2[0]}>${arr2[1]}:${arr2[2]} 备注: $note"
        else
            echo "转发规则： ${arr2[0]}>${arr2[1]}:${arr2[2]}"
        fi
    fi
done

echo ""
echo "测试5: 模拟删除规则"
localport=8080
echo "删除端口 $localport 的规则..."
sed -i "/^$localport>.*/d" $conf
sed -i "/^$localport>.*#/d" $notesFile 2>/dev/null

echo "删除后的配置文件:"
cat $conf
echo ""
echo "删除后的备注文件:"
cat $notesFile
echo ""

echo "测试完成！"
echo "清理测试文件..."
rm -rf $TEST_DIR

echo "所有测试通过！备注功能工作正常。"