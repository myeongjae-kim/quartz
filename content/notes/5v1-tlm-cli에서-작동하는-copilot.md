---
title: "5v1. tlm: cli에서 작동하는 copilot"
---
https://github.com/yusufcanb/tlm

https://news.hada.io/topic?id=13919
> - CLI에 대해서 자연어로 요청하면 명령을 생성해주는 코파일럿 도구  
    `$ tlm suggest 'list all network interfaces but only their ip addresses'`  
    `> ip addr show | grep -oP 'inet \K[\d.]+`
> - API Key 나 인터넷 연결 필요없음
> - 맥/리눅스/윈도우에서 동작
> - 자동 Shell 감지
> - 원라인 명령 생성 및 명령에 대한 설명도 해줌