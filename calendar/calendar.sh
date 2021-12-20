#!/bin/bash

# 달력 연도가 너무 광범위한것을 막기 위해 최소연도, 최대연도를 정함
min_year=1900
max_year=2200
# 1900년 1월 1일 기준으로 일수 체크용 변수
days=0
# 월마다 며칠까지 있는지 배열로 담아두기
#       1  2  3  4  5  6  7  8  9 10 11 12
month=(31 28 31 30 31 30 31 31 30 31 30 31)
# 입력받은 월 인자
monthInput=$2
# 출력될 월
monthOutput=0

# 달력에 표시될 월이 10 미만이면 "01월" 같은 형태가 되도록 0 붙여줌
if [ $monthInput -lt 10 ]; then
    monthOutput=0$monthInput
else
    monthOutput=$monthInput
fi

# 입력한 연도와 월이 문제가 없는지 거르기
if [ $1 -lt $min_year ] || [ $1 -gt 2200 ]; then
    echo "연도는 1900~2200 값을 입력하세요"
elif [ $2 -ge 13 ] || [ $2 -lt 1 ]; then
    echo "월은 1~12 값을 입력하세요"
else
    # ▼ 시작연도(1900년)부터 입력한 연도까지 차이만큼 일수 계산하기 ▼
    # 시작연도가 입력한 연도보다 작으면 반복실행
    while [ $min_year -lt $1 ]; do
        # ▼ 1년을 윤년은 366일, 평년은 365일로 만들기 위해 조건문 만들기 ▼
        # 4로 나눠떨어지면(나머지가 0이면) 윤년임
        if [ $(expr $1 % 4) -eq 0 ]; then
            # 그중 400으로 나눠떨어지면 윤년,
            if [ $(expr $1 % 400) -eq 0 ]; then
                days=$(expr $days + 366)
            # 100으로 나눠떨어지면 평년
            elif [ $(expr $1 % 100) -eq 0 ]; then
                days=$(expr $days + 365)
            # 4로 나눠떨어지고 400,100이랑 관계없는 나머지 윤년들
            else
                days=$(expr $days + 366)
            fi
        # 평년
        else
            days=$(expr $days + 365)
        fi
        # 1년치 일수 계산 끝났으면 시작연도 +1
        min_year=$(expr $min_year + 1)
    done

    # ▼ 윤년이면 2월을 29일로 바꿔주기 ▼
    if [ $(expr $1 % 4) -eq 0 ]; then
        if [ $(expr $1 % 400) -eq 0 ]; then
            month[1]=29
        elif [ $(expr $1 % 100) -eq 0 ]; then
            month[1]=28
        else
            month[1]=29
        fi
    else
        month[1]=28
    fi

    # ▼ 입력한 월이 시작월인 1월보다 크면 차이만큼 일수로 계산하기 ▼
    while [ $monthInput -gt 1 ]; do
        # 총 일수에 입력한 월에 해당하는 일수 더하기
        days=$(expr $days + ${month[$monthInput - 2]})
        # 입력한 월에서 1월까지 가기 위해 1씩 빼주기
        monthInput=$(expr $monthInput - 1)
    done

    # 달력 틀 출력
    echo
    echo "          $1년 $monthOutput월"
    echo "일   월   화   수   목   금   토"
    echo "================================"

    # 일 출력할 때 요일에 따라 공백과 줄바꿈을 만들기 위한 변수
    dayAndBlank=$(expr $days + 1)
    dayAndBlank=$(expr $dayAndBlank % 7)

    blankTemp=0
    # 해당 월의 1일부터 출력을 시작하기위해 공백 넣기
    while [ $blankTemp -lt $dayAndBlank ]; do
        echo -n "     "
        blankTemp=$(expr $blankTemp + 1)
    done

    dayTemp=1
    # 1일부터 해당 월의 마지막날까지 1씩 더해가며 출력하기
    while [ $dayTemp -le ${month[$2 - 1]} ]; do
        # 토요일에서 일요일로 넘어가면 한줄 내리기 && 처음부터 0이면 달력 첫줄이 통으로 빈줄이 되는것 방지
        if [ $(expr $dayAndBlank % 7) -eq 0 ] && [ ! $dayAndBlank -eq 0 ]; then
            echo
        fi
        # 이번 출력할 일자가 십의자리수면
        if [ $dayTemp -ge 10 ]; then
            # 공백 없이,
            echo -n "$dayTemp"
        else
            # 일의자리면 앞에 공백 한개 주기
            echo -n " $dayTemp"
        fi
        # 다음요일 칸으로 가기 위한 공백 출력
        echo -n "   "
        # 다음날로 만들기 위해 +1
        dayTemp=$(expr $dayTemp + 1)
        dayAndBlank=$(expr $dayAndBlank + 1)
    done
    echo
fi
