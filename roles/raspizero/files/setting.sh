#!/bin/bash

# 設定ファイル読み込み
# bltspk_setting.json
# region.txt
setting=`cat /etc/bath_radio/bltspk_setting.json`
device=`echo $setting | jq -r '.device'`
vol=`echo $setting | jq '.vol'`
region=`cat /etc/bath_radio/region.txt`
stationlist=`cat /opt/radio_core/stationlist.json`

# bluetoothスピーカーのアドレスを設定
# 現在値を表示し変更するかしないかを選択
echo ""
echo "■現在設定されているBDアドレス"
echo $device
echo -n "→変更しますか？(Y/N): "
# 変更する場合は入力受付
read res
if [ $res = "Y" ]; then
  echo -n "BDアドレスを入力してください: "
  read device
fi

# 音量設定
# 現在値を表示し変更するかしないかを選択
echo ""
echo "■現在の音量設定"
echo $vol
echo -n "→変更しますか？(Y/N): "
# 変更する場合は入力受付
read res
if [ $res = "Y" ]; then
  echo -n "音量を入力してください(0〜100): "
  read vol
fi

# 地域設定
# 現在値を表示し変更するかしないかを選択
echo ""
echo "■現在の地域設定"
echo $region
echo -n "→変更しますか？(Y/N): "
# 変更する場合は入力受付
read res
if [ $res = "Y" ]; then
  echo "【地域リスト】"
  echo $stationlist | jq -r 'keys[]'
  echo ---------
  echo -n "リストから地域を選択してください: "
  read region
fi

# 設定ファイル修正
# bltspk_setting.json
echo { > /etc/bath_radio/bltspk_setting.json
echo \"device\": \"$device\", >> /etc/bath_radio/bltspk_setting.json
echo \"vol\": $vol >> /etc/bath_radio/bltspk_setting.json
echo } >> /etc/bath_radio/bltspk_setting.json

# region.txt
echo $region > /etc/bath_radio/region.txt

# now_station.txt
station=`echo $stationlist | jq -r '.'$region'[0]'`
echo $station > /etc/bath_radio/now_station.txt

exit 0