---
layout: page-fullwidth
#
# Content
#
subheadline: "Compute"
title: "OCI에서 리눅스 인스턴스 생성 튜토리얼"
teaser: "Oracle Cloud Infrastructure (OCI)에서 리눅스 인스턴스를 생성하는 과정을 설명합니다."
author: dankim
date: 2022-06-23 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, compute, linux_instance]
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
* 인스턴스에 SSH 접속
* 블록 볼륨 스토리지 추가

아래 그림은 튜토리얼을 통해서 생성된 리소스들을 보여줍니다.
![](/assets/img/getting-started/2022/gsg-instance-linux.png " ")

### 인스턴스에 SSH 접속을 위한 SSH 키 쌍 생성
OpenSSH로 인스턴스에 접속 혹은 유닉스 기반 클라이언트(MacOS 등)에서 접속하는 경우에는 인스턴스 생성 시에 자동으로 생성된 SSH 키 쌍을 다운로드 받을 수 있기 때문에 이 단계를 건너뜁니다. 또한 이미 [SSH-2 RSA 키 쌍](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#Instance)을 가지고 있는 경우에도 인스턴스 생성할 때 공개 키를 업로드 하거나 붙여넣기하여 추가할 수 있으므로, 마찬가지로 이 단계를 건너뜁니다.  
만일 클라이언트가 OpenSSH가 없는 윈도우 환경이라면, **Putty**를 활용하여 접속하는 경우가 많은데 이 경우에는 **Putty Key Generator**를 다운로드 받아서 Putty에서 사용하는 SSH키로 생성하여야 합니다. **Putty Key Generator**를 활용하면 기존에 사용중이던 [SSH-2 RSA 키 쌍](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#Instance)를 Putty 전용 SSH 키로 변환도 가능합니다. 

#### Putty Key Generator를 활용하여 SSH 키 생성
먼저 [https://www.puttygen.com/](https://www.puttygen.com/)에서 **PuTTYgen**을 다운로드 받고 설치합니다. **puttygen.exe**을 클릭하여 프로그램을 오픈합니다.

다음과 같이 **SSH-2 RSA**를 선택하고 **키 사이즈**를 **2048**로 입력한 후 **Generate** 버튼을 클릭합니다.

![](/assets/img/getting-started/2022/oci-create-sshkey-1.png " ")

생성되는 과정에서 빈 공간을 마우스를 움직이면 키가 랜덤하게 생성됩니다.

![](/assets/img/getting-started/2022/oci-create-sshkey-2.png " ")

**Save private key**를 클릭하여 전용 키를 다운로드 받습니다. 공개키의 경우 **Public key for pasting into OpenSSH authorized_keys file**의 내용을 다운로드 받은 Private Key 이름에 **.pub**라는 파일 확장자를 추가해서 복사 & 붙여넣기 하여 생성합니다.  
예시) Private Key: mykey, Public Key: mykey.pub

> 키 코멘트, passphrase (키를 암호화)는 이 단계에서 건너뜁니다. 

![](/assets/img/getting-started/2022/oci-create-sshkey-3.png " ")

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

### 리눅스 인스턴스 생성 및 시작하기
이제 리눅스 인스턴스를 하나 생성해보겠습니다. 메뉴에서 **컴퓨트(Compute) > 인스턴스(Instances)**를 차례로 클릭합니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-2.png " ")

구획으로 **Sandbox**를 선택한 후 **인스턴스 생성(Create Instance)**를 클릭합니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-3.png " ")

인스턴스 생성 화면에서 다음과 같이 입력합니다.

* 이름 (Name): my_first_linux_instance
* 구획 (Create in compartment): Sandbox
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


### 리눅스 인스턴스 접속을 위한 준비
이제 실행중인 인스턴스에 SSH로 접속할 수 있습니다. 대부분의 리눅스 혹은 유닉스 시스템은 기본 SSH 클라이언트를 통해서 접속이 가능하지만, Windows 10 혹은 Windows 2019의 경우는 [Open SSH Client](https://docs.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse)를 설치하여야 합니다. 그 외 윈도우 환경의 경우 무료 SSH 클라이언트 프로그램인 [Putty](http://www.putty.org)를 사용하여 접속할 수 있습니다.

우선 인스턴스에 접속하기 위해서는 생성한 인스턴스의 공용 IP를 확인하여야 합니다. 생성한 인스턴스 목록에서 바로 공용 IP를 확인할 수 있습니다.

![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-7.png " ")

#### Unix 스타일 시스템에서 Linux 인스턴스에 연결하려면
다운로드 받은 **전용 키** 혹은 **업로드 한 공용 키에 대응하는 전용 키**에 대해서 소유자만 파일을 읽을 수 있는 권한으로 변경합니다.

```
$ chmod 400 <private_key_file>
```

다음 SSH 명령어로 인스턴스에 접속합니다.
```
$ ssh -i <private_key_file> <username>@<public-ip-address>
```

> Oracle Linux 및 CentOS 이미지의 경우 기본 사용자 이름은 opc입니다. Ubuntu 이미지의 경우 기본 사용자 이름은 ubuntu입니다.


#### OpenSSH를 사용하여 Windows 시스템에서 Linux 인스턴스에 연결하려면
1. 다운로드 받은 **전용 키**를 마우스 우 클릭 후 **속성 (Properties)**을 클릭합니다.
2. **보안 (Security)** 탭에서 **고급 (Advanced)**을 클릭합니다.
3. **사용 권한 (Permissions)** 탭 의 **사용 권한 항목 (Permission entries)** 에 대해 **보안 주체**에 **자신의 사용자 계정**이 보이는지 확인합니다.
4. **상속 사용 안함**을 클릭하고, **상속된 사용 권한을 이 개체에 대한 명시적 사용 권한으로 변환**을 선택합니다.

    ![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-8.png " ")

5.  **사용 권한 항목 (Permission entries)**에서 자신의 사용자 계정을 제외한 항목은 모두 삭제합니다.
6. 자신의 사용자 계정에 대한 액세스 권한이 **모든 권한 (Full control)**인지 확인합니다.
7. 이제 Windows PowerShell을 열고 다음 명령을 실행합니다.

    ```
    ssh -i <private_key_file> <username>@<public-ip-address>
    ```

    > Oracle Linux 및 CentOS 이미지의 경우 기본 사용자 이름은 opc입니다. Ubuntu 이미지의 경우 기본 사용자 이름은 ubuntu입니다.

#### PuTTY를 사용하여 Windows 환경에서 Linux 인스턴스에 연결하려면
1. Putty를 오픈합니다.
2. Category에서 Session을 선택한 후 **Host Name (or IP address)**에 생성한 인스턴스의 공용  IP를 입력합니다. Port는 **22** 이고, Connection type은 **SSH**로 선택합니다.

    ![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-9.png " ")

3. Category에서 Connection과 Data를 순서대로 클릭한 후 **Auto-login username**에 사용자를 입력합니다.

    ![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-10.png " ")

    > Oracle Linux 및 CentOS 이미지의 경우 기본 사용자 이름은 opc입니다. Ubuntu 이미지의 경우 기본 사용자 이름은 ubuntu입니다.

4. Category에서 Connection과 SSH, Auth를 순서대로 클릭한 후 **Private key file for authentication**에 앞서 PuttyGen으로 생성한 **전용 키**를 선택하고 **Open**을 클릭하여 세션을 시작합니다.

    ![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-11.png " ")

    > 인스턴스에 처음 연결하는 경우 서버의 호스트 키가 레지스트리에 캐시되지 않는다는 메시지가 표시될 수 있습니다. 연결을 계속 하려면 **예** 를 클릭 합니다.

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
  * 볼륨 크기(GB) (Volume Size (in GB)) : 50
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
* **장치 경로 (Device path):** 목록중에서 하나를 선택합니다. (/dev/oracleoci/oraclevdb)
* **연결 유형 (Attachment type):** ISCSI
* **액세스 (Access):** 읽기/쓰기(Read/write)

![](/assets/img/getting-started/2022/oci-bv-5.png " ")

연결을 클릭합니다.

이제 iSCSI 연결을 구성할 수 있습니다. 우선 **연결된 블록 볼륨** 메뉴에서 연결된 블록 볼륨의 우측 아이콘을 선택한 후 **iSCSI 명령 및 정보 (iSCSI commands and inforamtion)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-bv-6.png " ")

다음과 같이 **iSCSI 명령 및 정보** 대화창에서 접속 (Connect)에 있는 명령어를 복사합니다.

![](/assets/img/getting-started/2022/oci-bv-7.png " ")

인스턴스에 SSH로 접속합니다.

```
$ ssh -i <private_key_file> <username>@<public-ip-address>
```

인스턴스에 SSH로 접속하면, 위에서 복사한 ```iscsiadm```명령어를 실행합니다. 다음은 예시입니다.

```
$ sudo iscsiadm -m node -o new -T iqn.2015-12.com.oracleiaas:ac4b3e1c-1a24-4dc9-88dc-280797acfb14 -p 169.254.2.2:3260
$ sudo iscsiadm -m node -o update -T iqn.2015-12.com.oracleiaas:ac4b3e1c-1a24-4dc9-88dc-280797acfb14 -n node.startup -v automatic
$ sudo iscsiadm -m node -T iqn.2015-12.com.oracleiaas:ac4b3e1c-1a24-4dc9-88dc-280797acfb14 -p 169.254.2.2:3260 -l
```

다음과 같이 fdisk 명령어를 실행해 보면, **/dev/sdb** 디스크가 연결되어 있는 것을 확인할 수 있습니다. 이제 포멧 및 마운트 작업 수행이 가능합니다. 

```
$ sudo fdisk -l

Disk /dev/sdb: 50 GiB, 53687091200 bytes, 104857600 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 1048576 bytes
```

#### 블록 볼륨 포멧
블록 볼륨 포멧을 할 때 원하는 파일 시스템 파일로 포멧할 수 있습니다. 다음은 ext3 파일 시스템으로 포멧하는 명령어 예시입니다.
```
$ sudo /sbin/mkfs.ext3 /dev/sdb
```

위에서 지정한 장치 경로 (Device path)를 통해서도 포멧이 가능합니다.
```
$ sudo /sbin/mkfs.ext3 /dev/oracleoci/oraclevdb
```

> 일관된 장치 경로(Consistent Device Path) 기능은 블록 볼륨이 둘 이상인 상태에서 장치의 이름으로 마운트할 경우 재부팅 시 장치 이름과 실제 장치의 대응 순서가 달라질 수 있는데, 이 순서를 보장하기 위한 기능입니다. 이 기능은 OCI에서 제공되는 특정 이미지에서만 제공되는데, 자세한 내용은 [https://docs.oracle.com/en-us/iaas/Content/Block/References/consistentdevicepaths.htm](https://docs.oracle.com/en-us/iaas/Content/Block/References/consistentdevicepaths.htm) 페이지에서 확인활 수 있습니다.

다음 명령어로 파일 시스템을 조회해 볼 수 있습니다.
```
$ lsblk -f
NAME               FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                         
|-sda1             vfat              2C33-7BA8                              /boot/efi
|-sda2             xfs               f5a988c4-7f58-4592-8edc-a60130c894b9   /boot
`-sda3             LVM2_member       ppZKAk-x3TH-chAK-4850-Qx9L-1VEW-PC5eBq 
  |-ocivolume-root xfs               cc7fcbb1-bc82-4e5a-9fdc-3767d5c32c48   /
  `-ocivolume-oled xfs               3730314b-4ca7-4454-8aeb-82e97c986fb3   /var/oled
sdb                ext3              d9388269-e087-4d50-a058-f6d08b9772c5  
```

#### 블록 볼륨 마운트
이제 마운트를 해보도록 하겠습니다. 여기서는 장치 경로를 통해 마운트를 합니다. 다음과 같이 마운트할 경로를 생성합니다.

```
$ sudo mkdir /mnt/vol1
```

/etc/fstab 파일을 오픈하여 다음과 같이 제일 아래에 다음 라인을 추가합니다.
> fstab에 추가하면, 인스턴스를 리부팅 하더라도 자동으로 마운트가 됩니다.

```
$ sudo vi /etc/fstab

# 아래 라인 추가
/dev/oracleoci/oraclevdb /mnt/vol1 ext3 defaults,_netdev,nofail 0 2
```

> 디바이스은 연결된 블록 볼륨 화면에서도 확인 가능하지만, 다음 명령어로도 확인이 가능합니다. ```ls -la /dev/oracleoci/```

이제 다음 명령어로 마운트합니다.
```
$ sudo mount -a
```

마운트 된 것을 확인할 수 있습니다.
```
$ df -h
Filesystem                  Size  Used Avail Use% Mounted on
devtmpfs                    7.7G     0  7.7G   0% /dev
tmpfs                       7.7G     0  7.7G   0% /dev/shm
tmpfs                       7.7G   41M  7.7G   1% /run
tmpfs                       7.7G     0  7.7G   0% /sys/fs/cgroup
/dev/mapper/ocivolume-root   36G  8.4G   28G  24% /
/dev/mapper/ocivolume-oled   10G  120M  9.9G   2% /var/oled
/dev/sda2                  1014M  316M  699M  32% /boot
/dev/sda1                   100M  5.0M   95M   5% /boot/efi
tmpfs                       1.6G     0  1.6G   0% /run/user/0
tmpfs                       1.6G     0  1.6G   0% /run/user/987
tmpfs                       1.6G     0  1.6G   0% /run/user/1000
/dev/sdb                     49G   53M   47G   1% /mnt/vol1
```


### 모든 리소스 정리
튜토리얼을 통해서 생성한 리소스에 대한 삭제는 다음 순서대로 진행합니다.

#### 블록 볼륨 분리 및 삭제
메뉴에서 **컴퓨트 (Compute) > 인스턴스 (Instances)**에서 실습에서 사용한 인스턴스를 선택합니다. 인스턴스 세부 정보 화면에서 좌측 **리소스 (Resources)** 세션의 **연결된 블록 볼륨**을 선택합니다. 목록에서 실습에서 사용한 볼륨 오른쪽 아이콘을 선택하고 **분리 (Detach)**를 선택하여 인스턴스를 분리합니다.

![](/assets/img/getting-started/2022/oci-bv-8.png " ")

이제 볼륨을 삭제할 수 있습니다. 메뉴에서 **스토리지 (Storage) > 블록 볼륨 (Block Volumes)**를 차례로 선택한 후에 실습에서 사용한 블록 볼륨의 오른쪽 아이콘을 클릭하고 **종료 (Terminate)**를 선택하여 볼륨을 삭제합니다.

![](/assets/img/getting-started/2022/oci-bv-9.png " ")

#### 인스턴스 종료
메뉴에서 **컴퓨트 (Compute) > 인스턴스 (Instances)**를 차례로 선택한 후 목록에서 실습에서 사용한 인스턴스의 오른쪽 아이콘을 클릭하고 **종료 (Terminate)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-bv-10.png " ")

삭제 대화창에서 **부팅 볼륨을 영구적으로 삭제 (Permanently delete the attached boot volume)**를 선택한 후 **인스턴스 종료** 버튼을 클릭하여 인스턴스와 부트볼륨을 모두 삭제합니다.

![](/assets/img/getting-started/2022/oci-bv-11.png " ")

#### 가상 클라우드 네트워크 (Virtual Cloud Network) 삭제
메뉴에서 **네트워킹 (Networking) > 가상 클라우드 네트워크 (Virtual Cloud Network)** 을 차례로 선택한 후 실습에서 사용한 VCN 오른쪽 메뉴를 클릭하고 **종료 (Terminate)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-bv-12.png)

VCN과 연관된 모든 리소스들이 나열됩니다. **모두 종료**를 클릭하여 VCN과 관련된 모든 리소스를 삭제합니다.

![](/assets/img/getting-started/2022/oci-bv-13.png)

> VCN의 리소스들을 다른 자원에서 사용중인 경우라면 VCN 자원을 삭제할 수 없습니다. 이 경우에는 연관된 자원을 삭제 한 후에 다시 VCN 리소스를 정리하여야 합니다.
