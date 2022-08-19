---
layout: page-fullwidth
#
# Content
#
subheadline: "Compute"
title: "OCI에서 윈도우즈 인스턴스 생성 튜토리얼"
teaser: "Oracle Cloud Infrastructure (OCI)에서 윈도우즈 인스턴스를 생성하는 과정을 설명합니다."
author: dankim
date: 2022-06-23 00:00:01
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, compute, windows_instance]
#published: false

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

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

### 튜토리얼에서 다룰 내용
튜토리얼에서 다룰 내용은 다음과 같습니다.

* 클라우드 네트워크 및 인터넷 접속이 가능한 서브넷 생성
* 인스턴스 생성 및 시작
* 인스턴스에 접속
* 블록 볼륨 스토리지 추가

아래 그림은 튜토리얼을 통해서 생성된 리소스들을 보여줍니다.
![](/assets/img/getting-started/2022/gsg-instance-windows.png " ")

### 구획 (Compartment) 생성
모든 리소스들을 특정 구획에 생성할 것입니다. 우선 **Sandbox**라는 이름의 구획을 생성해 보도록 하겠습니다. 메뉴에서 **ID & 보안 (Identity & Security) > 구획(Compartment)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-iam-7.png " ")

**구획 생성** 버튼을 클릭하고, 입력창에 다음과 같이 입력합니다.
* 구획명: Sandbox
* 설명: Sandbox 사용자를 위한 구획

![](/assets/img/getting-started/2022/oci-iam-8.png " ")

### 가상 클라우드 네트워크 (Virtual Cloud Network: VCN) 생성
인스턴스에서 사용할 VCN을 생성합니다. VCN 생성은 아래 링크를 참고하여 생성합니다.

> [OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/)

VCN을 생성할 때 앞서 생성한 구획인 SandBox를 선택하여야 합니다.
![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-1.png " ")

### 윈도우즈 인스턴스 접속 허용을 위해 Security List에 3389 포트 추가
VCN 목록에서 생성된 VCN을 선택한 후 왼쪽 **리소스(Resources)**의 **보안 목록(Security Lists)**탭을 선택하고, **기본 보안 목록(Default Security List for {VCN이름})**을 선택합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-2.png " ")

**수신 규칙 추가(Add Ingress Rules)** 버튼을 클릭한 후 다음과 같이 입력하여 수신 규칙을 추가 합니다.
* **소스 유형(Source Type):** CIDR
* **소스 CIDR(Source CIDR):** 0.0.0.0/0
* **IP 프로토콜(IP Protocol):** RDP (TCP/3389)
* **소스 포트 범위(Source Port Range):** All
* **대상 포트 범위(Destination Port Range):** 3389

![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-3.png " ")

### 윈도우즈 인스턴스 생성 및 시작하기
이제 윈도우즈 인스턴스를 하나 생성해보겠습니다. 메뉴에서 **컴퓨트(Compute) > 인스턴스(Instances)**를 차례로 클릭합니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-2.png " ")

구획으로 **Sandbox**를 선택한 후 **인스턴스 생성(Create Instance)**를 클릭합니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-3.png " ")

인스턴스 생성 화면에서 다음과 같이 입력합니다.

* 이름 (Name): my_first_windows_instance
* 구획 (Create in compartment): Sandbox
* 배치 (Placement)의 가용 도메인 (Availability domain): AD 1
  * 가용 도메인은 데이터 센터를 의미합니다. 서울은 1개의 가용 도메인으로 운영됩니다.
* 이미지(Image): Windows (Server 2019 Standard)
  * 이미지는 기본 플랫폼 이미지(Ubuntu, CentOS, Oracle Linux, Windows 등), 오라클 이미지, 파트너 이미지, 커뮤니티 이미지, 커스텀 이미지등으로 분류되어 있으며, [https://docs.oracle.com/en-us/iaas/images/](https://docs.oracle.com/en-us/iaas/images/)에서 기본 플랫폼 이미지 목록을 확인할 수 있습니다.  
  ![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-1.png " ")
* 쉐입 (Shape): VM.Standard.E4.Flex (가상 머신, 1 core OCPU, 16 GB memory, 1 Gbps network bandwidth)
  * 쉐입에서는 **가상 머신(Virtual machine)**과 **베어메탈(Bare metal machine)** 인스턴스 유형으로 나눠져 있으며, **가상 머신** 유형에서는 **AMD**, **Intel**, **Ampere (Arm 기반 프로세서)**로 구분되어 있습니다. 모든 쉐입은 Flex 타입으로 제공되는데, CPU와 메모리를 사용자가 선택하여 구성할 수 있습니다. 여기서는 **가상 머신** 유형에서 AMD 쉐입인 **VM.Standard.E4.Flex**으로 선택하고 CPU는 1개, 메모리는 16 GB로 선택합니다.
  * OCI 쉐입에 대한 상세한 정보는 [https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm) 링크에서 확인할 수 있습니다.
  ![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-4.png " ")

네트워킹에서는 앞서 생성한 VCN과 공용 서브넷(Public Subnet)을 선택하고 (공용 IP 주소) Public IP address를 공용 IPv4 주소 지정 (Assign a public IPv4 address)으로 선택합니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-5.png " ")

**부트 볼륨 (Boot volume)**의 경우는 기본 옵션 상태로 둡니다.

마지막으로 **생성 (Create)** 버튼을 클릭합니다.

### 윈도우즈 인스턴스 접속을 위한 준비
이제 실행중인 윈도우즈 인스턴스에 리모트 데스크탑을 사용하여 접속할 수 있습니다.

인스턴스에 접속하기 위해서는 생성한 인스턴스의 공용 IP와 사용자 이름, 초기 비밀번호를 확인하여야 합니다. 인스턴스 목록에서 생성한 인스턴스를 클릭하면 다음과 같이 공용 IP와 사용자 이름, 초기 비밀번호를 확인할 수 있습니다.

> 여기서는 MacOS 환경에서 Microsoft Remote Desktop 클라이언트 애플리케이션을 활용하였습니다.

![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-4.png " ")

Remote Desktop 클라이언트를 사용하여 접속을 합니다. 위에서 확인한 사용자 이름과 초기 비밀번호를 입력합니다.

![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-5.png " ")

초기 비밀번호를 변경합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-6.png " ")

윈도우즈 데스크탑에 정상적으로 연결되었습니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-7.png " ")

### 블록 볼륨 추가
블록 볼륨 은 Oracle Cloud Infrastructure 컴퓨트 인스턴스에 사용할 수 스토리지입니다. 볼륨을 생성, 연결(Attach) 및 인스턴스에 탑재(Mount)한 후에는 인스턴스에서 물리적인 하드 드라이브처럼 사용할 수 있습니다. 볼륨은 한 번에 하나의 인스턴스에 연결할 수 있지만, 기존 인스턴스에서 볼륨을 분리하고 데이터를 유지한 상태에서 다른 인스턴스에 연결을 할 수 있습니다.

이 작업에서는 볼륨을 생성하고 인스턴스에 연결한 다음 해당 볼륨을 인스턴스에 연결하는 방법을 보여줍니다.

#### 블록 볼륨 생성
메뉴에서 **스토리지(Stroage) > 블록 볼륨(Block Volumes)**을 차례로 클릭합니다.

![](/assets/img/getting-started/2022/oci-bv-1.png " ")

다음과 같이 입력 및 선택합니다.
* 이름 (Name): my-block-volume-1
* 구획에 생성 (Create In Compartment): Sandbox
* 가용성 도메인 (Availability Domain): 데이터센터를 선택합니다. (서울은 1개)
* 볼륨 크기 및 성능 (Volume Size and Performance)
  * 사용자정의 선택 (Custom)
  * 볼륨 크기(GB) (Volume Size (in GB)) : 256
  * 대상 볼륨 성능 (Target Volume Performance): VPU (Volume Performance Units)값으로 10
    * VPU에 대한 자세한 정보는 [https://docs.oracle.com/en-us/iaas/Content/Block/Concepts/blockvolumeperformance.htm](https://docs.oracle.com/en-us/iaas/Content/Block/Concepts/blockvolumeperformance.htm) 에서 확인
* 성능 자동 조정 (Auto-tune Performance): 설정 (On)
  * 성능 자동 조정은 해당 볼륨이 분리된 상태에서는 가장 낮은 성능 옵션으로 자동 변경되어 비용이 절감됩니다. 다시 연결되면 이전에 설정된 성능 옵션으로 자동 조정됩니다.
* 백업 정책 (Backup Policies): 선택하지 않음
  * 백업 정책을 설정하면 특정 시점에 자동으로 Object Storage에 백업이 이뤄집니다. 백업 정책 기본 Gold (가장 빈번하게 백업 발생), Silver, Bronze 정책이 제공되며, 사용자가 임의로 정의할 수 있습니다.
* 영역 간 복제 (Cross Region Replication): 해제 (OFF)
  * 영역 간 복제는 현재 블록 볼륨을 생성하는 리전과 매핑되는 리전으로 자동 비동기 복제를 하는 기능입니다.
  * 영역 간 복제에 대한 설명과 매핑된 리전은 [https://docs.oracle.com/en-us/iaas/Content/Block/Concepts/volumereplication.htm](https://docs.oracle.com/en-us/iaas/Content/Block/Concepts/volumereplication.htm)에서 확인할 수 있습니다.
* 암호화 (Encryption): Encrypt using Oracle-managed keys (기본 설정 유지)

미지막으로 **블록 볼륨 생성 버튼 (Create Block Volume)**을 클릭합니다.
![](/assets/img/getting-started/2022/oci-bv-2.png " ")
![](/assets/img/getting-started/2022/oci-bv-3.png " ")

#### 인스턴스에 볼륨 연결 (Attach & Connect)
iSCSI 방식으로 볼륨을 인스턴스에 연결해보도록 하겠습니다. 메뉴에서 **컴퓨트 (Compute) > 인스턴스 (Instances)**를 차례로 선택한 후에 앞서 생성한 인스턴스를 선택합니다. 인스턴스 상세 페이지에서 아래와 같이 좌측 **리소스 (Resources)** 메뉴에서 **연결된 블록 볼륨 (Attached block volumes)**을 선택합니다.

![](/assets/img/getting-started/2022/oci-bv-4.png " ")

**블록 볼륨 연결 (Attach block volume)**버튼을 클릭하고 다음과 같이 입력/선택 합니다.
* **블록 볼륨 선택 (Select volume):** 앞서 생성한 블록 볼륨을 선택합니다.
* **장치 경로 (Device path):** 선택하지 않습니다. (사용할 수 없는 옵션)
* **연결 유형 (Attachment type):** ISCSI
* **액세스 (Access):** 읽기/쓰기(Read/write)

![](/assets/img/getting-started/2022/oci-bv-5-1.png " ")

연결을 클릭합니다.

이제 iSCSI 연결을 구성할 수 있습니다. 우선 **연결된 블록 볼륨** 메뉴에서 연결된 블록 볼륨의 우측 아이콘을 선택한 후 **iSCSI 명령 및 정보 (iSCSI commands and inforamtion)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-bv-6.png " ")

다음과 같이 **iSCSI 명령 및 정보** 대화창에서 IP 주소 및 포트를 확인합니다.

![](/assets/img/getting-started/2022/oci-bv-7-1.png " ")

윈도우즈 데스크탑에서 서버 매니저 (Server Manager)를 실행합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-8.png " ")

**Tools > iSCSI Initiator** 를 선택합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-9.png " ")

**Discovery**탭을 선택한 후 **Discover Portal** 버튼을 클릭합니다. 다음과 같이 위에서 확인한 블록 볼륨의 IP 주소와 포트를 입력하고 **OK** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-10.png " ")

**Targets**탭을 선택한 후 **Connect** 버튼을 클릭하고 **OK** 버튼을 클릭합니다.

![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-11.png " ")

**File and Storage Services > Volumes > Disks**를 차례로 선택하여 추가된 스토리지를 확인합니다.

![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-12.png " ")

해당 스토리지를 선택한 후 마우스 오른쪽 클릭하여 **New Volume**을 클릭합니다. 다음과 같이 **New Volume Wizard**가 오픈됩니다. **Next** 버튼을 클릭합니다.

![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-13.png " ")

Disk를 확인한 후 **Next** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-14.png " ")

Volume size를 확인한 후 **Next** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-15.png " ")

Drive letter 확인한 후 **Next** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-16.png " ")

File system, Allocation unit size, Volume label을 확인한 후 **Next** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-17.png " ")

**Create** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-18.png " ")

모든 과정이 완료된 것을 확인할 수 있습니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-19.png " ")

파일 탐색기를 통해서 추가된 볼륨과 볼륨 정보를 확인합니다.
![](/assets/img/getting-started/2022/oci-lanunch-windows-instance-20.png " ")

### 모든 리소스 정리
튜토리얼을 통해서 생성한 리소스에 대한 삭제는 다음 순서대로 진행합니다.

#### 블록 볼륨 분리 및 삭제
메뉴에서 **컴퓨트 (Compute) > 인스턴스 (Instances)**에서 실습에서 사용한 인스턴스를 선택합니다. 인스턴스 세부 정보 화면에서 좌측 **리소스 (Resources)** 세션의 **연결된 블록 볼륨**을 선택합니다. 목록에서 실습에서 사용한 볼륨 오른쪽 아이콘을 선택하고 **분리 (Detach)**를 선택하여 인스턴스를 분리합니다.

![](/assets/img/getting-started/2022/oci-bv-8-1.png " ")

이제 볼륨을 삭제할 수 있습니다. 메뉴에서 **스토리지 (Storage) > 블록 볼륨 (Block Volumes)**를 차례로 선택한 후에 실습에서 사용한 블록 볼륨의 오른쪽 아이콘을 클릭하고 **종료 (Terminate)**를 선택하여 볼륨을 삭제합니다.

![](/assets/img/getting-started/2022/oci-bv-9-1.png " ")

#### 인스턴스 종료
메뉴에서 **컴퓨트 (Compute) > 인스턴스 (Instances)**를 차례로 선택한 후 목록에서 실습에서 사용한 인스턴스의 오른쪽 아이콘을 클릭하고 **종료 (Terminate)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-bv-10-1.png " ")

삭제 대화창에서 **부팅 볼륨을 영구적으로 삭제 (Permanently delete the attached boot volume)**를 선택한 후 **인스턴스 종료** 버튼을 클릭하여 인스턴스와 부트볼륨을 모두 삭제합니다.

![](/assets/img/getting-started/2022/oci-bv-11-1.png " ")

#### 가상 클라우드 네트워크 (Virtual Cloud Network) 삭제
메뉴에서 **네트워킹 (Networking) > 가상 클라우드 네트워크 (Virtual Cloud Network)** 을 차례로 선택한 후 실습에서 사용한 VCN 오른쪽 메뉴를 클릭하고 **종료 (Terminate)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-bv-12.png)

VCN과 연관된 모든 리소스들이 나열됩니다. **모두 종료**를 클릭하여 VCN과 관련된 모든 리소스를 삭제합니다.

![](/assets/img/getting-started/2022/oci-bv-13.png)

> VCN의 리소스들을 다른 자원에서 사용중인 경우라면 VCN 자원을 삭제할 수 없습니다. 이 경우에는 연관된 자원을 삭제 한 후에 다시 VCN 리소스를 정리하여야 합니다.
