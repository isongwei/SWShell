#!/bin/bash

#蒲公英上传脚本



#FIR 秘钥
FIRTOKEN="5558b26ae383df7390b880bexxxxxxx"
#蒲公英aipKey
PAPIKEY="406daf9470fe9589cb55993d25c02742"
#蒲公英uKey
PUKEY="b7ae97e875ce35f5717ce33760008d5e"



#桌面路径
deskTopPath="/Users/mac/Desktop"
#真机编译包路径
# 我的来借钱
packagePath="/Users/mac/Library/Developer/Xcode/DerivedData/Bumblebee-giguxkemnebngsfvsavznqxbqbno/Build/Products/Debug-iphoneos"
# packagePath="/Users/mac/Library/Developer/Xcode/DerivedData/SWFrame-exalkccitggdcuddqjeqlywmmuhc/Build/Products/Debug-iphoneos"
# packagePath="/Users/Sven/Library/Developer/Xcode/DerivedData/SWFrame-gorosqppssbkhldfmxtohnbvxdtd/Build/Products/Debug-iphoneos/"

#项目名称
# scheme_name="Bumblebee"
scheme_name=$( echo $packagePath | awk -F'-' '{print$1}' | awk -F'/' '{print$(NF-0)}')

dire="$deskTopPath/Payload"
if [ -d "$dire" ];
  then
    rm -r "$dire"
    mkdir "$dire"
  else
    mkdir "$dire"
fi

cd $packagePath
cp -r $scheme_name.app $dire/$scheme_name.app


cd $deskTopPath
zip -r $scheme_name.zip Payload


if [ -f "$scheme_name.ipa" ];
  then
    rm -r "$scheme_name.ipa"
fi


# datename=$(date +%Y%m%d-%H%M%S)
# mv $scheme_name.zip ${scheme_name}${datename}.ipa
mv $scheme_name.zip $scheme_name.ipa


echo "\033[31;1m导出 ${scheme_name}.ipa包成功     🚀🚀🚀🚀🚀    \033[0m"

echo "\033[36;1m 打包上传到蒲公英?(y/n)(输入,按回车即可) \033[0m"
echo "\033[33;1m1. y  上传       \033[0m"
echo "\033[33;1m2. n  结束  \033[0m"

read resultBool
if [[ $resultBool != y ]]; then
  exit 1
fi


#上传到测试平台 -> fir.im
# echo "-------------------->fir.im"
#fir p "${deskTopPath}/${scheme_name}.ipa" -T "${FIRTOKEN}"



echo "------->蒲公英---------"
# ->  蒲公英

(curl -o appInfo -F "file=@${deskTopPath}/${scheme_name}.ipa" -F "uKey=${PUKEY}" -F "_api_key=${PAPIKEY}" "http://www.pgyer.com/apiv1/app/upload") && cat appInfo \
| awk -F'appQRCodeURL' '{print$2}'\
| awk -F'"' '{print $3}'


echo "\033[31;1m复制上面链接扫描下载  \033[0m"
echo "\033[31;1m上传 ${scheme_name}.ipa包成功  \033[0m"
