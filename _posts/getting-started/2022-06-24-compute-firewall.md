---
layout: page
#
# Content
#
subheadline: "Compute"
title: "OCI Oracle Linux 7이상에서 방화벽 설정하기"
teaser: "OCI에서 제공하는 여러 이미지중에서 Oracle Linux 7이상 버전에 대한 방화벽 구성하는 방법에 대해서 알아봅니다."
author: dankim
breadcrumb: true
categories:
  - getting-started
tags:
  - oci
  - compute
  - firewall
#
# Styling
#
header: no
# image:
#     title: mediaplayer_js-title.jpg
#     thumb: mediaplayer_js-thumb.jpg
#     homepage: mediaplayer_js-home.jpg
#     caption: Photo by Corey Blaz
#     caption_url: https://blaz.photography/
# mediaplayer: true

# -------------- 내용 필독 -------------------
# 작성할 내용은 아래부터 작성
# 작성 방법
# 각 챕터별 제목은 "###"로 시작한다.
# 하위 제목은 "####"로 시작한다.
# 이미지는 images 폴더안에 Category(getting-started, infrastructure, platform, database, aiml)에 넣고 사용 시 "../../images/카테고리명/이미지" 형태로 참조한다.
# Bold는 **글자**
# Bold + Italic은 ***글자***
# ------------------------------------------
---

### VCN 생성
우선 VCN을 준비합니다. VCN 생성은 아래 포스팅을 참고합니다.

> [OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/)

### Compute 생성
VM Compute Instace를 하나 생성합니다. **Compute > Instances > Create Instances**를 클릭합니다.

![](./images/compute-firewall-1.png)

기본 선택화면에서 인스턴스 이름을 입력하고 이미지 (여기서는 Oracle Linux 8)를 선택하며, 인스턴스에서 사용하기 위한 VCN과 Subnet (Public)을 선택합니다.
![](./images/compute-firewall-2.png)

인스턴스에 접속하기 위해서는 SSH 키가 필요합니다. 사용하고 있는 키가 있다면, 해당 Public Key를 Copy & Paste하고, 그렇지 않은 경우 **Generate a key pair for me**를 선택하여 키를 다운로드 받습니다. 마지막으로 **Create** 버튼을 클릭하여 인스턴스를 생성합니다.

![](./images/compute-firewall-3.png)

### Security List 설정
특정 포트를 오픈하기 위해서는 OCI에서 관리하는 Security List와 Instance의 OS에서 관리하는 Firewall 두 부분에 모두 추가해줘야 합니다. 우선 Security List에 오픈하기 위한 포트를 추가하여야 하는데, 인스턴스를 생성할 때 선택한 Subnet을 선택한 후 Security List를 선택합니다. (VCN Wizard를 통해 생성한 경우 Private Subnet을 위한 Security List와 Public Subnet을 위한 Security List 두 개가 생성되며, 네이밍이 **Default Security List for {VCN명}**으로 생성된 것이 Public Subnet의 Security List입니다.)

![](./images/compute-firewall-4.png)

**Add Ingress Rules**을 선택합니다.

![](./images/compute-firewall-5.png)

다음과 같이 **Source CIDR**와 **Destination Port Range**를 입력합니다.

- Source CIDR: 0.0.0.0/0 (모든 IP를 허용)
- Destination Port Range: 8080 (인스턴스에서 오픈할 포트)

![](./images/compute-firewall-6.png)

### Instance Firewall 설정
iptables을 활용하여 관리할 수 있지만, Oracle Linux 7이상부터는 firewalld 라고 하는 데몬 서비스로 관리하며, 명령어는 firewall-cmd 명령어를 활용합니다.

우선 ssh로 해당 인스턴스에 접속합니다.

```
$ ssh -i {ssh key} opc@{ip address}
```

다음과 같이 Firewall을 설정합니다. 참고로 --permanent 옵션은 영구적으로 설정하는 옵션이지만, 반드시 --reload를 방화벽을 재시작해줘야 합니다.
```
$ sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
$ sudo firewall-cmd --reload
```

다음 명령어로 열린 포트를 확인합니다.
```
$ sudo firewall-cmd --list-all
```

이 외에 추가적으로 다음과 같은 명령어를 사용할 수 있습니다.

**방화벽 실행 상태**
```
$ sudo firewall-cmd --state 
```

**존 목록을 출력**
```
$ sudo firewall-cmd --get-zones
```

**기본 존 출력**
```
$ sudo firewall-cmd --get-active-zones
```

**zone을 지정해서 출력**
```
firewall-cmd --zone=public --list-all
```
**임시로 포트 추가 / reload 없이 바로 반영되나 서버가 재부팅되면 설정도 사라짐**
```
$ sudo firewall-cmd --add-port=8080/tcp
```

**포트 제거**
```
$ sudo firewall-cmd --remove-port=8080/tcp (포트 제거)
```

**서비스 추가**
```
$ sudo firewall-cmd --add-service=ftp (서비스 추가)
```

**서비스 제거**
```
$ sudo firewall-cmd --remove-service=ftp
```

**존을 지정해서 추가**
```
$ sudo firewall-cmd --zone=trusted --add-service=ftp (존을 지정해서 추가)
```

**permanent 옵션으로 서비스 추가 / 영구적으로 추가되나 --reload 옵션으로 방화벽 재시작 필요**
```
$ sudo firewall-cmd --permanent --zone=public --add-service=ftp (permanent 옵션으로 추가)
```

**permanent 옵션으로 포트 추가 / 영구적으로 추가되나 --reload 옵션으로 방화벽 재시작 필요**
```
$ sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp (permanent 옵션으로 추가)
```

방화벽을 완전히 해제하고 모든 포트를 오픈하는 경우에는 다음과 같이 명령어를 사용합니다.
```
$ sudo systemctl stop firewalld.service
$ sudo systemctl disable firewalld.service
```