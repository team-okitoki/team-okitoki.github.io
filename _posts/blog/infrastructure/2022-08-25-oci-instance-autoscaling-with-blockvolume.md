---
layout: page-fullwidth
#
# Content
#
subheadline: "Compute"
title: "OCI Instance Auto Scaling with Block Volume - Block Volume 이 연결된 Instance 오토스케일링 하기"
teaser: "OCI 에서 제공하는 Storage 서비스인 Block Volume이 Paravirtualized 방식으로 연결된 인스턴스를 자동으로 스케일링하기 위한 방법에 대해 알아봅니다."
author: "yhcho"
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, compute, instance, autoscaling, Paravirtualized]
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

### 실습에 필요한 서비스에 대해 간단히 알아보기
이번 실습에서는 Compute Instance를 이용하여 인스턴스 구성, 인스턴스 풀, 자동 확장 설정을 진행할 예정입니다. 각 서비스별 간단한 개념은 아래 내용을 참고해주세요.<br>
![Compute Auto Scaling](/assets/img/infrastructure/2022/oci-compute-autoscaling.png)

#### Instance Configuration (인스턴스 구성)
인스턴스 구성은 기본 이미지, 모양 및 메타데이터와 같은 세부 정보를 포함하여 컴퓨팅 인스턴스를 생성할 때 사용할 설정을 정의합니다. 
또한 블록 볼륨 연결 및 네트워크 구성과 같은 인스턴스에 대한 연결된 리소스를 지정할 수 있으며 인스턴스를 용량 예약 과 연결할 수 있습니다.

#### Instance Pool (인스턴스 풀)
인스턴스 풀을 사용하면 그룹과 동일한 지역 내에서 여러 컴퓨팅 인스턴스를 만들고 관리할 수 있습니다. 
또한 로드 밸런싱 서비스 및 IAM 서비스와 같은 다른 서비스와의 통합을 가능하게 합니다.
인스턴스 풀 구성에는 인스턴스 구성이 필요합니다. 인스턴스 구성은 인스턴스를 생성할 때 사용할 설정을 정의하는 템플릿입니다.

#### Auto Scaling (오토 스켈링)
OCI 에서는 Instance Pool에 있는 Compute Instance 를 설정된 조건에 의해 자동으로 스케일 In-Out 할 수 있는 Auto Scaling 서비스를 제공합니다.
이러한 서비스를 통해 수요가 많은 기간동안 최종 사용자에게 일관된 성능을 제공할 뿐만 아니라, 수요가 적은 기간동안 비용을 절감할 수 있는 구성을 할 수 있습니다.<br>
- 메트릭 기반 자동 크기 조정 : 성능 지표가 임계값을 충족하거나 초과하면 자동으로 크기 조정 작업이 실행되는 유형
- 일정 기반 자동 크기 조정 : 특정 날짜 또는 시간에 크기 조정 작업을 예약하여 자동으로 크기를 조정하는 유형

### 실습 순서
1. Custom Image 생성 - Block Volume 연결을 위한 설정이 포함된 이미지를 생성합니다.
2. Instance Configuration 생성 - Custom Image로 생성된 인스턴스를 이용하여 인스턴스 구성을 생성합니다.
3. Instance Pool 생성 - 인스턴스 구성을 사용하여 인스턴스 풀을 생성합니다.
4. Auto Scaling 설정 생성 - CPU 임계치를 사용하여 Auto Scaling 설정을 생성합니다.
5. Stress Tool을 사용하여 Auto Scaling이 실행되도록 하고, Block Volume이 자동으로 연결되는지 확인합니다.

### 1.Custom Image 생성
Custom 이미지를 생성하기 위한 인스턴스 구성을 위해서 먼저 OCI VCN이 생성되어 있어야 합니다. OCI VCN 생성 방법은 아래 포스팅을 참고해주세요
> [OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](/getting-started/create-vcn/){:target="_blank" rel="noopener"} 

#### 1-1. Compute Instance 만들기
이 실습에서는 Instance 생성 및 관리 방법에 대해 자세히 다루지 않습니다. 자세한 내용은 [OCI에서 리눅스 인스턴스 생성 튜토리얼](/getting-started/launching-linux-instance/){:target="_blank" rel="noopener"} 포스팅을 참고해주세요

1. 전체 메뉴에서 **"컴퓨트 > 컴퓨트 > 인스턴스"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
2. 이동한 화면에서 인스턴스 생성 버튼을 클릭합니다.
3. 아래 설정을 참고하여 인스턴스를 생성합니다. <mark>(접속을 위한 SSH Key는 개인에 맞게 신규다운로드, 업로드 등 설정해주세요.)</mark>

인스턴스 생성 화면에서 다음과 같이 입력합니다.

* 이름 (Name): instance_bv_demo
* 구획 (Create in compartment): <mark>개인별 테스트를 진행할 구획을 지정합니다.</mark>
* 배치 (Placement)의 가용 도메인 (Availability domain): AD 1
   * 가용 도메인은 데이터 센터를 의미합니다. 서울은 1개의 가용 도메인으로 운영됩니다.
* 이미지(Image): Oralce Linux 8
   * 이미지는 기본 플랫폼 이미지(Ubuntu, CentOS, Oracle Linux, Windows 등), 오라클 이미지, 파트너 이미지, 커뮤니티 이미지, 커스텀 이미지등으로 분류되어 있으며, [https://docs.oracle.com/en-us/iaas/images/](https://docs.oracle.com/en-us/iaas/images/)에서 기본 플랫폼 이미지 목록을 확인할 수 있습니다.
* 쉐입 (Shape): VM.Standard.E4.Flex (가상 머신, 1 core OCPU, 16 GB memory, 1 Gbps network bandwidth)
   * 쉐입에서는 **가상 머신(Virtual machine)**과 **베어메탈(Bare metal machine)** 인스턴스 유형으로 나눠져 있으며, **가상 머신** 유형에서는 **AMD**, **Intel**, **Ampere (Arm 기반 프로세서)**로 구분되어 있습니다. 모든 쉐입은 Flex 타입으로 제공되는데, CPU와 메모리를 사용자가 선택하여 구성할 수 있습니다. 여기서는 **가상 머신** 유형에서 AMD 쉐입인 **VM.Standard.E4.Flex**으로 선택하고 CPU는 1개, 메모리는 16 GB로 선택합니다.
   * OCI 쉐입에 대한 상세한 정보는 [https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm) 링크에서 확인할 수 있습니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-4.png " ")

**네트워킹**에서는 앞서 생성한 VCN과 공용 서브넷(Public Subnet)을 선택하고 **(공용 IP 주소) Public IP address**를 **공용 IPv4 주소 지정 (Assign a public IPv4 address)**으로 선택합니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-5.png " ")

**SSH 키 추가**에서는 **자동으로 키 쌍 생성(Generate a key pair for me)**을 선택하고 **전용 키 저장 (Save Private Key)**를 클릭하여 생성된 키를 다운로드 받을 수 있습니다.

> 다운로드 받은 키는 OpenSSH가 구성된 클라이언트에서만 사용 가능합니다. UNIX 기반 환경 (Linux 또는 MacOS), Windows 10, Windows Server 2019의 경우는 OpenSSH를 설치하여 다운로드 받은 키로 인스턴스에 접속이 가능합니다.

기존에 가지고 있는 키가 있는 경우 **공용 키**를 **공용 키 파일(.pub) 업로드(Upload public key files (.pub))** 혹은 **공용 키 붙여넣기(Paste public keys)** 기능을 활용하여 인스턴스에 업로드 할 수 있습니다. 앞서 생성한 Putty 키를 사용하는 경우에는 Putty 공용 키를 업로드 합니다.

**부트 볼륨 (Boot volume)**의 경우는 기본 옵션 상태로 둡니다.

마지막으로 **생성 (Create)** 버튼을 클릭합니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-6.png " ")
#### 1-2. Instance 설정하기
1. 생성된 인스턴스에 접속합니다.
   * 접속 방법을 모르시는 경우 [리눅스 인스턴스 접속으르 위한 준비](/getting-started/launching-linux-instance/#리눅스-인스턴스-접속을-위한-준비){:target="_blank" rel="noopener"} 내용을 참조 해주세요.

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-custom-image-1.png " ")
2. 아래 명령어를 입력하여 마운트 대상이 될 디렉토리를 생성합니다.
   ```
   $ sudo mkdir /mnt/disk1
   ```

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-custom-image-2.png " ")
3. <mark>/etc/fstab</mark> 파일에 아래 내용을 추가 후 저장합니다.
   * **명령어 구조**
     * `[연결할 Volume의 경로 (BV생성시 지정가능)]` <mark>[마운트할 타겟 Dir]</mark> `(disk 포멧 형식)` defaults,_netdev,nofail 0 2 
     
   ```
   $ sudo vi /etc/fstab

   # 마지막 줄 아래 라인 추가
   /dev/oracleoci/oraclevdb /mnt/disk1 ext4 defaults,_netdev,nofail 0 2
   ```

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-custom-image-3.png " ")
4. 아래 명령어를 입력하여 오토스켈링 테스트에서 사용할 Stress Tool을 다운로드 하고 설치 합니다.
   ```
   $ wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/s/stress-1.0.4-16.el7.x86_64.rpm
   $ sudo yum install -y stress-1.0.4-16.el7.x86_64.rpm
   ```

#### 1-3. Custom Image 생성하기
1. OCI 콘솔에서 **"사용자 정의 이미지 생성"** 버튼을 클릭하여 아래와 같이 입력하여 사용자 정의 이미지를 생성합니다.
 * **구획에 생성** : <mark>각자 테스트를 진행하는 구획 선택</mark>
 * **이름** : custom-image-bv-demo
 * **"사용자정의 이미 생성"** 버튼을 클릭하여 이미지를 생성합니다.

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-custom-image-4.png " ")
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-custom-image-5.png " ")

### 2. Instance Configuration 생성하기
앞 단계에서 생성한 Custom Image를 사용하여 신규 인스턴스를 생성하고 Block Volume 연결등 설정을 진행한 후 인스턴스 구성을 생성합니다.

#### 2-1. Custom Image 로  새로운 Instance 생성하기
1. 인스턴스 생성 버튼을 클릭합니다.
2. 생성화면에서 **"이미지 > 이미지 변경"** 버튼을 클릭합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-1.png " ")
3. 팝업에서 이미지 소스를 **"사용자정의 이미지"**로 변경합니다.
4. (1) 단계에서 생성한 Custom Image를 선택 후 하단 **"이미지 선택"** 버튼을 클릭합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-2.png " ")
5. Shape 및 네트워크 등 기타 설정 부분은 상단의 Instance 생성하기 내용을 참고하여 설정합니다.
6. 화면 최하단 **"고급 옵션 표시"** 를 클릭합니다.
7. 초기화 스크립트 섹션에서 **"Cloud-init 스크립트 붙여넣기"** 를 선택 후 아래 내용을 복사하여 붙여넣기 합니다. (Block Volume 포멧 및 마운트 명령 추가)
   ```
   #!/bin/bash
   sudo mkfs -t ext4 /dev/oracleoci/oraclevdb
   sudo mount -a
   ```
8. **"생성"** 버튼을 클릭하여 인스턴스를 생성합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-3.png " ")

#### 2-2. 연결할 Block Volume 생성 및 인스턴스에 연결하기
1. 전체 메뉴에서 **"스토리지 > 블록 스토리지 > 블록 볼륨"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-4.png " ")
2. **"블록 볼륨 생성"** 버튼을 클릭하여 아래 내용을 입력 및 선택하여 블록 볼륨을 생성합니다.
 * 이름 : demoAutoScalingBV
 * 구획에 생성 : <mark>각자 테스트를 진행하는 구획 선택</mark>
 * 가용성 도메인 : 기본값
 * 볼륨 크기 및 성능 : <mark>각자 사용하고자 하는 크기 및 성능 지정 (실습에서는 기본값 선택)</mark>
 * 백업 정책 : 실습 에서는 선택 하지 않음 (필요한 경우 각자 상황에 맞게 선택)
 * 영역 간 복제 : 실습 에서는 선택 하지 않음 (필요한 경우 각자 상황에 맞게 선택)
 * 암호화 : 오라클 관리 키를 사용하여 암호화
 * **"블록 볼륨 생성"** 버튼 클릭하여 생성

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-5.png " ")
3. (2-1) 단계에서 생성한 인스턴스 상세보기 화면으로 이동합니다.
4. 화면 왼쪽 하단 **"연결된 블록 볼륨"** 메뉴를 클릭하고 **"블록 볼륨 연결"** 버튼을 클릭합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-6.png " ")
5. 아래와 같이 입력 및 선택하여 블록 볼륨을 연결 합니다.
 * [구획]의 볼륨 : **demoAutoScalingBV**
 * 장치 경로 : **/dev/oracleoci/oraclevdb** <mark>(선택 옵션중 최상단 값 선택)</mark>
 * **이 경로를 변경하고 싶은 경우 위 단계에서 /etc/fstab에 입력한 경로도 동일하게 변경해야 합니다.**
 * 연결 유형 : **매개변수 가상화 (Paravirtualized) 선택**
 * 액세스 : **읽기/쓰기**
 * **"연결"** 버튼을 클릭합니다.

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-7.png " ")

#### 2-3. 인스턴스에 접속하여 Block Volume 연결 확인하기
1. (2-1)에서 생성한 인스턴스의 공용 IP를 확인하고 해당 인스턴스에 접속합니다.<br>
    `$ ssh -i [키파일 경로] opc@[instance Public IP]`
2. 아래 명령어를 입력하여 현재 연결된 볼륨을 확인합니다. <mark>(앞서 연결한 블록 볼륨이 /dev/sdb 경로로 추가 되어있습니다.)</mark>
    ```
    $ sudo fdisk -l

   Disk /dev/sda: 46.6 GiB, 50010783744 bytes, 97677312 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 4096 bytes
    I/O size (minimum/optimal): 4096 bytes / 1048576 bytes
    Disklabel type: gpt
    Disk identifier: A8418B96-255F-48FE-B1CE-202327C3148C

    Device       Start      End  Sectors  Size Type
    /dev/sda1     2048   206847   204800  100M EFI System
    /dev/sda2   206848  2303999  2097152    1G Linux filesystem
    /dev/sda3  2304000 97675263 95371264 45.5G Linux LVM


    Disk /dev/mapper/ocivolume-root: 35.5 GiB, 38088474624 bytes, 74391552 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 4096 bytes
    I/O size (minimum/optimal): 4096 bytes / 1048576 bytes


    Disk /dev/mapper/ocivolume-oled: 10 GiB, 10737418240 bytes, 20971520 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 4096 bytes
    I/O size (minimum/optimal): 4096 bytes / 1048576 bytes


    Disk /dev/sdb: 1 TiB, 1099511627776 bytes, 2147483648 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 4096 bytes
    I/O size (minimum/optimal): 4096 bytes / 1048576 bytes
    ```
3. 아래 명령어를 입력하여 초기 포멧 작업 및 마운트 명령어를 수행합니다.
    ```
    $ sudo /sbin/mkfs.ext4 /dev/sdb
    ```
   위에서 지정한 장치 경로 (Device path)를 통해서도 포멧이 가능합니다.
    ```
    $ sudo /sbin/mkfs.ext4 /dev/oracleoci/oraclevdb
    ```

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-8.png " ")

   마운트 명령어 실행
    ```
    $ sudo mount -a
    ```

   
4. 연결된 디스크를 확인합니다.
    ```
    $ df -h
    ```

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-9.png " ")

#### 2-4. Instance Configuration(인스턴스 구성) 생성하기
1. 위 단계 까지 문제없이 완료되었다면, 인스턴스 상세보기 화면에서 **"인스턴스 구성 생성하기"** 버튼을 클릭합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-10.png " ")
2. 아래와 같이 입력 후 "인스턴스 구성 생성" 버튼을 클릭합니다.
 * 구획에 생성 : <mark>각자 테스트를 진행하는 구획 선택</mark>
 * 이름 : instance-config-blockvolume-demo

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-config-11.png " ")

### 3. Instance Pool 생성하기
1. 인스턴스 구성이 생성된 후 상세보기 화면에서 **"인스턴스 풀 생성"** 버튼을 클릭 합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-pool-1.png " ")
2. **기본 세부정보 추가** 단계에서 아래와 같이 입력 및 선택 후 **"다음"** 버튼을 클릭합니다.
 * 이름 : instance-pool-blockvolume-demo
 * 구획에 생성 : <mark>각자 테스트를 진행하는 구획 선택</mark>
 * [구획]의 인스턴스 구성 : **2 단계에서 생성한 인스턴스 구성 선택** / `instance-config-blockvolume-demo`
 * 인스턴스 수 : **1**

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-pool-2.png " ")
3. 풀 배치 구성 단계에서 아래와 같이 입력 및 선택 후 "다음" 버튼을 클릭합니다.
 * 가용성 도메인 : 기본값
 * 결함 도메인 : 선택안함
 * 기본 VNIC (VCN 선택) : <mark>각자 테스트를 진행하는 VCN 선택</mark>
 * 기본 VNIC (Subnet 선택) : <mark>각자 테스트를 진행하는 Public Subnet 선택</mark>

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-pool-3.png " ")
4. 입력 및 선택한 정보 확인 후 "생성" 버튼을 클릭하여 인스턴스 풀을 생성합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-pool-4.png " ")
5. 인스턴스 풀이 프로비전 완료되면 자동으로 동일한 구성의 인스턴스가 함께 프로비전 됩니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-instance-pool-5.png " ")

### 4. Auto Scaling 설정 생성하기
1. 인스턴스 풀이 생성되면 **"작업 더 보기"** 드롭 다운을 클릭하여 **"자동 스케일링 구성 생성"** 기능을 통해 Auto Scaling 설정을 생성할 수 있습니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-scale-config-1.png " ")
2. 자동 스케일링 구성 생성 화면에서 아래와 같이 입력합니다.
 * 이름 : **autoscaling-config-blockvolume-demo**
 * 구획에 생성 : <mark>각자 테스트를 진행하는 구획 선택</mark>
 * **"다음"** 버튼을 클릭합니다.

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-scale-config-2.png " ")
3. **자동 스케일링 정책 구성** 단계에서 아래와 같이 선택 및 입력 후 **"다음"** 버튼을 클릭합니다.
 * **측정항목 기준 자동 스케일링** 선택
 * 자동 스케일링 정책 구성
   * 자동 스케일링 정책 이름 : **autoscaling-policy-blockvolume-demo**
   * 쿨타임(초) : **300 (최소 값 300초)**
   * 성능 측정항목 : **CPU 활용률**
   * 스케일 아웃 규칙
     * 연산자 : 보다 큼(>)
     * 임계값 백분율 : 80
     * 추가할 인스턴스 수 : 1
   * 스케일 인 규칙
      * 연산자 : 보다 작음(<)
      * 임계값 백분율 : 20
      * 제거할 인스턴스 수 : 1
   * 스케일링 제한
      * 최소 인스턴스 수 : 1
      * 최대 인스턴스 수 : 3
      * 초기 인스턴스 수 : 1

   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-scale-config-3.png " ")
4. 입력한 내용을 검토 후 이상이 없을 시 **"생성"** 버튼을 클릭하여 자동 스케일링 구성을 생성합니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-create-scale-config-4.png " ")

### 5. Stress Tool을 사용하여 Auto Scaling 확인 및 Block Volume 연결 확인하기
1. (2-1) 에서 생성한 인스턴스에 접속하여 아래와 같이 입력하여 해당 VM의 CPU에 부하를 줍니다.
    ```
    $ stress -c 8
    ```
   * 명령어 실행 전 CPU 활용률
     ![](/assets/img/infrastructure/2022/oci-autoscaling-test-1.png " ")
   * 명령어 실행 후 CPU 활용률
     ![](/assets/img/infrastructure/2022/oci-autoscaling-test-2.png " ")
   
2. Auto Scaling은 최소 300초의 간격으로 작업이 수행되기 때문에 최대 5분간 부하를 주며 Auto Scaling 작업이 수행되기 기다립니다.
3. Auto Scaling 작업이 수행되면 자동으로 설정한 수 만큼 인스턴스가 추가 됩니다.
   ![](/assets/img/infrastructure/2022/oci-autoscaling-test-3.png " ")
4. 추가된 인스턴스에 접속하여 블록볼륨이 연결되어 있는지 확인합니다. (인스턴스 생성이 완료되었더라도, 블록볼륨 포멧 및 연결에 추가로 시간이 필요하여 너무 빨리 확인하면 블록볼륨이 연결되어있지 않을 수 있습니다.)
   ![](/assets/img/infrastructure/2022/oci-autoscaling-test-4.png " ")
   ![](/assets/img/infrastructure/2022/oci-autoscaling-test-5.png " ")
    


