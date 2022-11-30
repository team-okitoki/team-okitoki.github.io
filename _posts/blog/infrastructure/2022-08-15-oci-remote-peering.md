---
layout: page-fullwidth
#
# Content
#
subheadline: "Networking"
title: "OCI Remote Peering - 서로 다른 리전간의 VCN 연결하기"
teaser: "OCI의 서로 다른 리전간의 VCN을 연결하는 Remote Peering에 대해서 설명합니다."
author: "dankim"
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, networking, remote_peering]
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

### Remote Peering Connection
Remote Peering Connection(이하 RPC)는 서로 다른 리전에 있는 VCN을 연결할 때 사용합니다. 

> DRG는 온-프레미스나 서로 다른 리전의 VCN을 연결할 때 가상 라우터 역할을 하는 게이트웨이입니다.

동일 리전의 서로 다른 VCN을 연결하는 경우에는 **Local Peering Gateway**를 사용합니다. **Local Peering Gateway**에 대해서는 다음 포스트를 참고합니다.

[OCI Local Peering - 동일 리전에서 서로 다른 VCN간 연결하기](https://team-okitoki.github.io/infrastructure/oci-local-peering/)

다음 다이어그램은 **RPC**를 사용하여 동일 리전의 서로 다른 VCN을 연결하는 다이어그램입니다. 연결하고자 하는 각 VCN에 Dynamic Routing Gateway(이하 DRG)를 붙이고, DRG에 Remote Peering Connection을 구성하여 연결하는 구성입니다.
![](/assets/img/infrastructure/2022/network_remote_peering_basic.png)

> 주의: Peering을 연결하는 두 VCN은 서로 CIDR이 겹치지 않아야 합니다.

Peering은 일반적으로 두 개의 VCN을 연결하는 단일 Peering 관계이지만, 하나의 VCN(ex. VCN-1)과 여러개의 VCN(ex. VCN-1-1, VCN-1-2, VCN-1-3)을 연결하는 1:n 관계로 구성도 할 수 있습니다. 이 때 VCN-1과 Peering되는 3개의 VCN은 서로 겹치는 CIDR를 가질 수 있습니다.

### 수락자 및 요청자
만일 두 개의 VCN을 관리하는 관리자가 서로 다른 경우에는 수락자는 수락자의 구획에 있는 LPG에 연결할 수 있는 권한을 요청자에게 부여 하는 특정 IAM 정책을 생성해야 합니다. 해당 정책이 없으면 요청자의 연결 요청이 실패합니다. IAM 설정과 관련해서는 다음 링크를 참고합니다.

[https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/remoteVCNpeering.htm#Step1](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/remoteVCNpeering.htm#Step1)

> 여기서는 한 명의 관리자가 모든 VCN을 관리한다는 전제하에 구성할 예정이므로, 별도의 IAM 정책을 구성하지 않습니다.

### 두 개의 VCN 생성
실습을 위한 두 개의 VCN을 준비합니다. **VCN 마법사**를 활용하여 다음과 같이 VCN을 생성합니다.

VCN 생성은 다음 가이드를 참고합니다.

[OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/)

* **Region:** Seoul
* **VCN 이름:** oci-hubvcn
* **VCN CIDR 블록:** 172.16.0.0/16
* **공용 서브넷 CIDR 블록:** 172.16.0.0/24
* **전용 서브넷 CIDR 블록:** 172.16.1.0/24

* **Region:** Tokyo
* **VCN 이름:** oci-hubvcn2
* **VCN CIDR 블록:** 173.16.0.0/16
* **공용 서브넷 CIDR 블록:** 173.16.0.0/24	
* **전용 서브넷 CIDR 블록:** 173.16.1.0/24	

### Dynamic Routing Gateway(DRG) 및 Remote Peering Connection 생성

#### DRG 생성
먼저 각 리전에 DRG를 생성합니다. DRG를 생성하기 위해서는 **메뉴 > 네트워킹(Networking) >> Customer Connectivity(고객 접속) Dynamic Routing Gateways(동적 경로 지정 게이트웨이)**로 이동합니다.

![](/assets/img/infrastructure/2022/oci-remote-peering-1.png)

**동적 경로 지정 게이트웨이 생성(Create Dynamic Routing Gateway)** 버튼을 클릭한 후 다음 이름으로 DRG를 생성합니다. 

* **Region:** Seoul
* **DRG 이름:** DRG-OCI-HUB

* **Region:** Tokyo
* **DRG 이름:** DRG-OCI-HUB2

#### 가상 클라우드 네트워크 연결 생성(Create Virtual Cloud Network Attachment)
생성한 DRG를 VCN에 연결하여야 합니다. 생성된 각 DRG를 클릭한 후 **가상 클라우드 네트워크 연결 생성** 버튼을 클릭하여 다음과 같이 연결 생성을 합니다.

* **Region:** Seoul
* **DRG 이름:** DRG-OCI-HUB-ATT
* **VCN:** oci-hubvcn

* **Region:** Tokyo
* **DRG 이름:** DRG-OCI-HUB2-ATT
* **VCN:** oci-hubvcn2

**Seoul**
![](/assets/img/infrastructure/2022/oci-remote-peering-2.png)

**Tokyo**
![](/assets/img/infrastructure/2022/oci-remote-peering-3.png)

#### Remote Peering Connection(RPC) 생성
**원격 피어링 접속 연결(Remote Peering Connections Attachments)**을 생성합니다. 생성한 각 DRG를 클릭한 후 다음과 같이 RPC 연결을 생성합니다.

* **Region:** Seoul
* **RPC 이름:** RPC-1

* **Region:** Tokyo
* **RPC 이름:** RPC-2

**RPC-1** 또는 **RPC-2**의 OCID 값을 복사하여 다른 쪽의 RPC에서 연결 작업을 수행합니다. 여기서는 **RPC-2**의 OCID 값을 활용하여 **RPC-1**에서 연결 작업을 수행하도록 합니다.

**RPC-2**의 OCID값을 얻기 위해서는 먼저 앞서 생성한 **RPC-2 연결**의 **Remote Peering Connection(원격 피어링 접속)** 항목의 **RPC-2**를 선택합니다.

![](/assets/img/infrastructure/2022/oci-remote-peering-4.png)

다음과 같이 OCID 값을 복사합니다.
![](/assets/img/infrastructure/2022/oci-remote-peering-4-1.png)

다시 **RPC-1 연결**로 이동한 후 **원격 피어링 접속(Remote Peering Connection)** 항목에 있는 **RPC-1**을 선택합니다.

![](/assets/img/infrastructure/2022/oci-remote-peering-5.png)

**연결 설정**을 선택한 후 지역을 **ap-tokyo-1(도쿄)**, **원격 피어링 접속 OCID**를 앞서 복사한 OCID로 입력한 후 **연결 설정**을 클릭합니다.
![](/assets/img/infrastructure/2022/oci-remote-peering-6.png)

연결이 되면 다음과 같이 피어링 상태가 **피어링됨**으로 변경됩니다.
![](/assets/img/infrastructure/2022/oci-remote-peering-7.png)

### 경로 테이블(Routing Table)과 보안 목록(Security List) 설정
#### 경로 테이블 설정
테스트를 위한 VM 인스턴스는 각 VCN의 공용 서브넷(Public Subnet)을 사용할 것입니다. 따라서 공용 서브넷에 구성된 경로 테이블(Routing Table)을 활용할 것입니다. 먼저 각 리전의 VCN을 선택한 후에 다음과 같이 기본 생성된 경로 테이블을 선택한 후 경로 규칙(Routing Rule)을 추가합니다.

* **Region:** Seoul
* **Routing Table:** Default Route Table for oci-hubvcn
* **Routing Rule:**
    * **Destination(대상):** 173.16.0.0/16
    * **Target Type(대상 유형):** 173.16.0.0/16
    * **Target(대상):** DRG-OCI-HUB

---

* **Region:** Tokyo
* **Routing Table:** Default Route Table for oci-hubvcn2
* **Routing Rule:**
    * **Destination(대상):** 172.16.0.0/16
    * **Target Type(대상 유형):** 172.16.0.0/16
    * **Target(대상):** DRG-OCI-HUB2

**Seoul**
![](/assets/img/infrastructure/2022/oci-remote-peering-8.png)

**Tokyo**
![](/assets/img/infrastructure/2022/oci-remote-peering-9.png)

#### 보안 목록 설정
보안 목록에서는 테스트를 위해 서로 모든 프로토콜에 대해 모든 포트를 오픈하도록 하겠습니다. 각 VCN의 **보안 목록**에서 다음과 같이 **수신 규칙(Ingress Rules)**를 추가합니다.

* **Region:** Seoul
* **보안 목록(Security List):** Default Security List for oci-hubvcn
* **소스 유형(Source Type):** CIDR
* **소스 CIDR(Source CIDR):** 173.16.0.0/16
* **IP 프로토콜:** 모든 프로토콜

* **Region:** Tokyo
* **보안 목록(Security List):** Default Security List for oci-hubvcn2
* **소스 유형(Source Type):** CIDR
* **소스 CIDR(Source CIDR):** 172.16.0.0/16
* **IP 프로토콜:** 모든 프로토콜


**Seoul**
![](/assets/img/infrastructure/2022/oci-remote-peering-10.png)

**Tokyo**
![](/assets/img/infrastructure/2022/oci-remote-peering-11.png)

### 접속 테스트
이제 각 리전의 공용 서브넷에 VM 인스턴스를 하나씩 생성한 후에 연결을 테스트해보도록 하겠습니다. 리눅스 인스턴스 생성 및 접속 방법은 아래 포스팅을 참고합니다.

[OCI에서 리눅스 인스턴스 생성 튜토리얼](http://localhost:4000//getting-started/launching-linux-instance/)

* **Region:** Seoul
* **인스턴스 Public IP:** 130.162.137.87
* **인스턴스 Private IP:** 172.16.0.208

* **Region:** Tokyo
* **인스턴스 IP:** 158.101.138.220
* **인스턴스 Private IP:** 173.16.0.156

**Seoul -> Tokyo**
```terminal
$ ssh -i <private_key_file> opc@130.162.137.87

$ ping 173.16.0.156
PING 173.16.0.156 (173.16.0.156) 56(84) bytes of data.
64 bytes from 173.16.0.156: icmp_seq=1 ttl=62 time=33.2 ms
64 bytes from 173.16.0.156: icmp_seq=2 ttl=62 time=33.2 ms
```

**Tokyo -> Seoul**
```terminal
$ ssh -i <private_key_file> opc@158.101.138.220

$ ping 172.16.0.208
PING 172.16.0.208 (172.16.0.208) 56(84) bytes of data.
64 bytes from 172.16.0.208: icmp_seq=1 ttl=62 time=33.10 ms
64 bytes from 172.16.0.208: icmp_seq=2 ttl=62 time=33.10 ms
```