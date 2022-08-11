---
layout: page-fullwidth
#
# Content
#
subheadline: "Networking"
title: "OCI Local Peering - 동일 리전에서 서로 다른 VCN 연결하기"
teaser: "OCI 동일 리전에서 서로 다른 VCN을 연결하는 Local Peering에 대해서 설명합니다."
author: kisu.kim
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, networking, local_peering]
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

---

### Local Peering Gateway
Local Peering Gateway(이하 LPG) 은 동일한 리전에서 서로 다른 VCN을 연결할 때 사용하는 Gateway입니다. 클라우드 계정 (OCI에서는 Tenancy라 부름)이 서로 다르더라도 동일한 리전의 경우 연결을 위해서는 **Local Peering Gateway**를 사용합니다.

서로 다른 리전의 VCN을 연결하는 경우에는 **Remote Peering Gateway**를 사용합니다. **Remote Peering Gateway**에 대해서는 다음에 다루도록 하겠습니다.

다음 다이어그램은 **LPG**를 사용하여 동일 리전의 서로 다른 VCN을 연결하는 다이어그램입니다.
![](https://docs.oracle.com/en-us/iaas/Content/Resources/Images/network_local_peering_basic.png)

> 주의: Peering을 연결하는 두 VCN은 서로 CIDR이 겹치지 않아야 합니다.

Peering은 일반적으로 두 개의 VCN을 연결하는 단일 Peering 관계이지만, 하나의 VCN(ex. VCN-1)과 여러개의 VCN(ex. VCN-1-1, VCN-1-2, VCN-1-3)을 연결하는 1:n 관계로 구성도 할 수 있습니다. 이 때 VCN-1과 Peering되는 3개의 VCN은 서로 겹치는 CIDR를 가질 수 있습니다.

### 수락자 및 요청자
만일 두 개의 VCN을 관리하는 관리자가 서로 다른 경우에는 수락자는 수락자의 구획에 있는 LPG에 연결할 수 있는 권한을 요청자에게 부여 하는 특정 IAM 정책을 생성해야 합니다. 해당 정책이 없으면 요청자의 연결 요청이 실패합니다. IAM 설정과 관련해서는 다음 링크를 참고합니다.

[https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/localVCNpeering.htm](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/localVCNpeering.htm)

> 여기서는 한 명의 관리자가 모든 VCN을 관리한다는 전제하에 구성할 예정이므로, 별도의 IAM 정책을 구성하지 않습니다.

### 두 개의 VCN 생성
실습을 위한 두 개의 VCN을 준비합니다. **VCN 마법사**를 활용하여 다음과 같이 VCN을 생성합니다.

VCN 생성은 다음 가이드를 참고합니다.

[OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/)

* **VCN 이름:** VCN-1
* **VCN CIDR 블록:** 10.0.0.0/16
* **공용 서브넷 CIDR 블록:** 10.0.0.0/24
* **전용 서브넷 CIDR 블록:** 10.0.1.0/24

* **VCN 이름:** VCN-2
* **VCN CIDR 블록:** 192.168.0.0/16
* **공용 서브넷 CIDR 블록:** 192.168.0.0/24
* **전용 서브넷 CIDR 블록:** 192.168.1.0/24

### Local Peering Gateway(LPG) 생성
생성한 두 개의 VCN 모두 LPG를 생성합니다. 먼저 다음과 같이 **VCN-1**에 **LPG-1**을 하나 생성합니다.

![](/assets/img/infrastructure/2022/oci-local-peering-1.png)

**VCN-2**에도 마찬가지로 **LPG-2**를 생성합니다.

![](/assets/img/infrastructure/2022/oci-local-peering-2.png)

### 라우팅 규칙 추가
두 개의 VCN에서 사용할 서브넷 (여기서는 Public Subnet)의 기본 라우팅 테이블에 다음과 같이 라우팅 규칙을 추가합니다.

***VCN-1***
* **대상 유형:** 로컬 피어링 게이트웨이
* **대상 CIDR 블록:** 192.168.0.0/16 (VCN-2의 CIDR)
* **대상 로컬 피어링 게이트웨이:** LPG-1 (VCN-1에 생성한 LPG)

![](/assets/img/infrastructure/2022/oci-local-peering-3.png)

***VCN-2***
* **대상 유형:** 로컬 피어링 게이트웨이
* **대상 CIDR 블록:** 10.0.0.0/16 (VCN-1의 CIDR)
* **대상 로컬 피어링 게이트웨이:** LPG-2 (VCN-2에 생성한 LPG)

![](/assets/img/infrastructure/2022/oci-local-peering-4.png)

### 보안 목록 (Security List)에 수신(Ingress) 규칙 추가
두 개의 VCN에서 사용할 서브넷 (여기서는 Public Subnet)의 보안 목록에 각 VCN의 CIDR를 수신 규칙으로 추가합니다.

먼저 **VCN-1**의 Public Subnet에 있는 보안 목록에 다음과 같이 추가합니다.
* **소스 유형:** CIDR
* **소스 CIDR:** 192.168.0.0/16 (VCN-2의 CIDR)

![](/assets/img/infrastructure/2022/oci-local-peering-5.png)


**VCN-2**의 Public Subnet에 있는 보안 목록에 다음과 같이 추가합니다.
* **소스 유형:** CIDR
* **소스 CIDR:** 10.0.0.0/16 (VCN-2의 CIDR)
![](/assets/img/infrastructure/2022/oci-local-peering-6.png)

### Peering 접속 설정

LPG를 서로 연결합니다. 연결 작업은 어느쪽에서든 한 번만 작업하면 됩니다. 여기서는 **LPG-1**에서 연결을 하도록 합니다. **LPG-1**에서 연결을 위해서는 먼저 **LPG-2**의 OCID를 확인하여야 합니다. 다음과 같이 **VCN-2**의 **LPG-2**의 OCID를 확인합니다.

![](/assets/img/infrastructure/2022/oci-local-peering-7.png)

다시 **VCN-1**의 **LPG-1**로 이동하여 다음과 같이 **피어링 접속 설정**을 선택 후 앞서 복사한 **LPG-2**의 OCID를 입력하고 **피어링 접속 설정**을 클릭합니다.

![](/assets/img/infrastructure/2022/oci-local-peering-8.png)

약간의 시간(1-2분)이 지나면 자동으로 **피어링됨** 상태로 변경됩니다. 마찬가지로 **LPG-2**의 상태도 **피어링됨** 상태로 변경됩니다.

**LPG-1 상태**
![](/assets/img/infrastructure/2022/oci-local-peering-9.png)

**LPG-2 상태**
![](/assets/img/infrastructure/2022/oci-local-peering-10.png)

### 두 개의 VCN에 생성한 인스턴스에서의 연결 테스트
먼저 VCN-1에 있는 인스턴스에서 핑 테스트 수행 결과입니다.

```
[opc@instance-vcn-1 ~]$ ping 192.168.0.235
PING 192.168.0.235 (192.168.0.235) 56(84) bytes of data.
64 bytes from 192.168.0.235: icmp_seq=1 ttl=64 time=0.238 ms
64 bytes from 192.168.0.235: icmp_seq=2 ttl=64 time=0.194 ms
64 bytes from 192.168.0.235: icmp_seq=3 ttl=64 time=0.248 ms
64 bytes from 192.168.0.235: icmp_seq=4 ttl=64 time=0.232 ms
```

VCN-2에 있는 인스턴스에서 핑 테스트 수행 결과입니다.

```
[opc@instance-vcn-2 ~]$ ping 10.0.0.103
PING 10.0.0.103 (10.0.0.103) 56(84) bytes of data.
64 bytes from 10.0.0.103: icmp_seq=1 ttl=64 time=0.242 ms
64 bytes from 10.0.0.103: icmp_seq=2 ttl=64 time=0.255 ms
64 bytes from 10.0.0.103: icmp_seq=3 ttl=64 time=0.190 ms
64 bytes from 10.0.0.103: icmp_seq=4 ttl=64 time=0.227 ms
```

정상적으로 연결이 된 것을 확인할 수 있습니다.