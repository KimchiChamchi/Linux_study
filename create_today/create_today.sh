#!/bin/bash
# date에서 연월일6자리만 출력
today=$(date "+%y%m%d")
# 매일 바뀌는 파일명을 변수로 저장
dateFile=Date_$today.txt
# 긴 경로명을 변수로 저장
directory=/home/leessangmin/date_log

# 경로에 해당하는 디렉토리가 없으면
if [ ! -d $directory ]; then
    # 해당 경로에 디렉토리 생성해주기
    mkdir $directory
fi

# 해당 경로에 오늘자 파일이 있으면
if [ -e /home/leessangmin/date_log/$dateFile ]; then
    # 아무것도 하지 않기
    echo "이미 파일이 있네요. 아무것도 안 할게요"
# 없으면
else
    echo "현재 날짜와 시간을 기록한 파일을 생성합니다"
    # 해당경로에 파일 만들고
    touch $directory/$dateFile
    # date 명령어로 나온 오늘 날짜,시간값을 해당 파일에 덮어쓰기
    date >$directory/$dateFile
fi
