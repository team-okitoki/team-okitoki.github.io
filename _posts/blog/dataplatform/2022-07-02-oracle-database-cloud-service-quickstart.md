---
layout: page-fullwidth
#
# Content
#
subheadline: "DataPlatform"
title: "Oracle Database Cloud Service 프로비저닝 Quick Start"
teaser: "OCI 의 Oracle Database Cloud 서비스를 프로비저닝하고 사용할 수 있는 방법에 대해서 알아봅니다. Base Database Cloud 서비스로써 VM 및 BM 기반으로 프로비저닝하는 방법입니다."
author: lim
breadcrumb: true
categories:
  - dataplatform
tags:
  - [oci, oracle, database, dbcs, provisioning]
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

### 서비스 소개
Oracle Cloud Infrastructure (OCI) 의 가장 큰 장점 중의 하나는 Oracle Database 에 대해 클라우드 환경에서 사용이 편리하고 최적의 구성을 원클릭으로 구성할 수 있는 PaaS 서비스를 제공한다는 점입니다.
이번 블로그에서는 컴퓨트, 스토리지 구성, DB 설치, RAC 구성까지 원클릭 프로비저닝을 통해서 자동으로 구성을 해 주는 Virtual Machine, Bare Metal 기반의 데이터베이스 서비스인 Oracle Base Database Cloud Service 를 빠르게 Provisioning 하고 사용하는 방법에 대해서 알아보도록 하겠습니다.
(※ 이하 Oracle Base Database Cloud Service 를 편의상 DBCS 로 칭하겠습니다.)

#### 사전 준비 사항
Oracle Database Cloud Service (DBCS) 를 Provisioing 하려면 먼저, 사전에 아래와 같은 사항들이 준비되어야 합니다.
- DBCS 가 위치하게 될 구획 (Compartment)
- DBCS 가 위치하게 될 Virtual Cloud Network
- DBCS 가 위치하게 될 VCN 내 Public Subnet 이나 Private Subnet
- DBCS Host Access 를 위한 SSH Public Key 와 Private Key (※ Key가 없을 경우, Provisioning 화면에서 key 다운로드가 가능함)

<br>

### 1. Oracle Base Database Cloud Service (DBCS) 생성
DBCS 생성은 매우 간단한 절차에 의해 자동으로 Oracle Database 서비스를 구성하실 수 있습니다.

- OCI Console 메뉴에서 "Oracle Base Database (VM,BM)" 을 선택합니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/01.oci-dbcs-console-menu.png)

- DBCS 의 목록 화면이 나오면 Oracle Database 서비스 자원이 위치할 Compartment (구획)가 잘 선택되어 있는지 확인 후 "Create DB System" 버튼을 클릭합니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/02.oci-dbcs-create-db-system-button.png)

- Create DB System 화면에서는 DBCS 생성을 위한 다음과 같은 사항들을 입력하거나 선택 후 아래로 스크롤 다운 합니다.
    - Select a compartment : DBCS 가 위치할 Compartment 가 잘 선택되어 있는지 확인
    - Name your DB system : SRCGGDB (※ 목록에 Display 될 DBCS 이름)
    - Select an availability domain : AD-1 (※ AD domain 이 여러개 있는 Region 에서는 AD 를 지정, 선택할 수 있으나 한국의 Seoul, Chuncheon Region 은 Single AD 임)
    - Select a shape type : Virtual Machine (※ VM, Bare Metal, Exadata 중 선택 - Bare Metal 은 RAC 미지원)
    
    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/03.oci-dbcs-create-db-system-input-1.png)

- DBCS 가 사용할 Computing 의 Shape 을 선택 해 줍니다. "Change Shape" 버튼을 클릭하면 사용할 Compute Shape 및 Core 수를 변경할 수 있는 화면이 나타납니다. 

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/04.oci-dbcs-create-db-system-input-2.png)

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/05.oci-dbcs-create-db-system-input-2-shape.png)

- 기본 선택되어 있는 VM.Standard.E4.Flex 사용하도록 선택하고, 하단의 "Change Storage" 버튼을 클릭하면 Storage 의 성능을 높일 수 있는 화면이 나타납니다. Shape 선택과 Storage 를 선택 후 아래로 스크롤 다운합니다. (※ 기본 선택된 Shape 과 Storage 사용)  

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/06.oci-dbcs-create-db-system-input-2-storage.png)

    - Storage Management Software 선택
        - Oracle Grid Infrastructure : Oracle 에서 만든 Storage Software 로 RAC와 같은 Cluster 구성이 가능하도록 Grid를 지원하는 Storage Software 입니다. RAC 구성 시에는 반드시 선택해야 합니다. (※ 기본 선택 사용)
        - Local Volume Manager : Linux 기반의 Local Volume Manager Storage Software 를 사용하는 옵션으로 Single node 만 지원합니다.

    - Storage performance 선택
        - Balanced : 기본 성능 수준의 스토리지로 대부분의 워크로드에 대해 성능과 비용 절감을 감안하여 적절한 균형을 제공하는 스토리지 옵션입니다.
        - Higher performance : 대용량 데이터베이스를 포함하여 최상의 성능을 요구하는 워크로드에 적합한 스토리지 옵션으로 많은 IO 성능을 요구하는 High Workload 에 권장되는 스토리지 옵션입니다. (※ 기본 선택 사용)

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/07.oci-dbcs-create-db-system-input-2-storage-2.png)

    - 사용할 Storage 용량도 지정할 수 있습니다. Available Data Storage 에 사이즈를 지정하면 DBCS 가 사용하는 스토리지 용량은  지정하신 Data Storage 용량의 2배를 사용하게 됩니다. 화면과 같이 Recovery 영역을 자동으로 Data Storage 사이즈와 동일하게 지정되는 것을 확인하실 수 있습니다.
  
    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/08.oci-dbcs-create-db-system-input-2-storage-3.png)

- Configure the DB system 부분은 데이터베이스 서버 노드의 갯수를 지정할 수 있게 됩니다. Single 노드를 사용할 것인지, 2개의 노드로 RAC 환경으로 구성할 것인지 지정 후 스크롤 다운합니다. 지정된 노드의 갯수에 따라 Oracle Database software edition 이 자동으로 선택됩니다. (※ 2노드 RAC 일 경우 Enterprise Edition Extreme Performance 가 자동으로 지정됨)
- Oracle Database Software Edition 의 차이점 및 정보는 [DBCS 소개](/dataplatform/oracle-database-cloud-service-overview/){:target="_blank" rel="noopener"} 를 참조합니다. 

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/09.oci-dbcs-create-db-system-input-2-configure-db.png)

- Add SSH Keys 부분은 SSH 를 통해 DB System 서버에 접속을 지원하기 위한 Key 정보를 입력해 줍니다. 더불어 라이센스 타입은 "License included" 를 선택 후 아래로 스크롤 다운합니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/10.oci-dbcs-create-db-system-input-2-add-ssh.png)

- Specify the network information 부분은 DBCS 가 사용할 네트워크를 지정해 주는 부분입니다. DBCS 가 사용할 Virtual Cloud Network 과 Subnet 을 지정합니다. 일반적으로 DBCS 는 Private Subnet 에 위치시키는게 일반적이나 Public Subnet 에도 DBCS 를 생성할 수 있습니다. Network 정보와 host 명일 입력 후 Next 버튼을 클릭합니다.
    - Hostname prefix 는 DBCS 가 사용하는 Compute 인스턴스의 호스트명입니다. 편의상 앞서 입력한 DB system Name 과 동일한 이름을 입력합니다.

    - Private IP address 는 선택적으로 Private IP 를 지정하여 DBCS 를 구성하실 수 있습니다. 공란으로 둘 경우 자동으로 Private IP 가 지정됩니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/12.oci-dbcs-create-db-system-vcn-network.png)

- 다음 단계에서는 Database 정보를 입력하는 중요한 단계입니다. 아래 화면과 같이 생성할 DB 정보들을 입력 후 스크롤 다운합니다. 
    - Database Name : DB 의 이름 입력 (입력예 : SRCGGDB) 
    - Database unique name suffix : Unique Name 입력 (※ 입력예 : SRCGGDB)
    - Database unique name 은 상기 Database Name 과 unique name suffix 를 조합하여 자동으로 생성됩니다. (※ 입력예 : SRCGGDB_SRCGGDB)

    - Database image : 기본적으로 Oracle Database 19.0.0.0 버전이 선택됩니다. 19c 버전의 최신 patch 가 적용된 버전이나 기타 12c, 21c 버전을 사용하기를 원할 경우 아래 화면에서 "Change database image" 버튼을 누르면 database image 를 변경, 선택할 수 있는 화면이 나타납니다.

    - PDB Name : 12c 이상의 버전에서는 Container 기반의 Pluggable 데이터베이스가 기본 구조입니다. PDB Name 은 Pluggable DB의 이름을 입력해 줍니다. (※ 입력예 : PDB1)

        ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/13.oci-dbcs-create-input-3-db-information.png)

        - Oracle Database Image 는 아래 그림과 같이 Display all available versions 를 체크하면, Database version 마다의 중간 patch 버전과 latest 버전들이 함께 나옵니다. 19c 일 경우가 기본 선택되었다 하더라도 최신 패치셋이 적용된 latest 버전 사용을 권고합니다. 
        
        > 주의 : OCI GoldenGate 사용 시 19.0.0.0 버전에 Capture 가 안되는 버그가 있었음

        ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/14.oci-dbcs-create-input-3-db-image.png)

- 다음 단계는 Administrator (sys dba 계정) 계정에 대한 Credential 을 생성하는 단계입니다. sys 사용자의 Password 를 입력 후 Workload Type 을 선택해 줍니다. Workload Type 은 OLTP 성 Workload 를 위한 Transaction Processing 과 DW 형태 Workload 처리를 위한 Data warehouse 타입이 있으나 기본적으로 선택되어 있는 Transaction Processing 을 선택 후 아래쪽으로 스크롤 다운합니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/15.oci-dbcs-create-input-3-admin-credentials.png)

- 다음은 Backup 정책을 설정하는 단계입니다. "Enable automatic backups" 를 선택 후 Backup 의 보관주기, 백업 수행 시간 등을 지정 후 "Create DB system" 버튼을 클릭하면 DBCS 프로비저닝이 시작됩니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/16.oci-dbcs-create-input-3-backup.png)

- 프로비저닝이 시작되면 아래와 같이 노란색 상태로 Provisioning 이 진행되고 약 45분 ~ 1시간 정도 DBCS 구성 시간이 소요됩니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/17.oci-dbcs-povisioning.png)

- 프로비저닝이 완료되면 아래와 같이 녹색 상태로 AVAILABLE 상태가 됩니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/dbcs/quickstart/18.oci-dbcs-povisioning-completed.png)

<br>

### 2. Windows VM 의 SQL Developer 를 통한 SQL Client 접속

DBCS 가 Public Subnet 에 생성되어 있을 경우, DBCS 가 생성된 후 부여된 Public IP 를 통해 DBCS 에 접속이 가능하지만 Private Subnet 에 생성된 DBCS 는 OCI 의 Public Subnet 에 배포된 컴퓨트 인스턴스나 bation 서비스를 통해서만 접속이 가능합니다.
편의상 DBCS 가 생성된 VCN 내의 Public Subnet 에 Windows VM 을 통해 SQL Developer 를 통해 DB 에 SQL 접속 방법에 대해 설명합니다.

- Windows 서버 VM 인스턴스 준비

    ![Windows Preparation](/assets/img/dataplatform/2022/goldengate/02.oci-goldengate-windows-preparation.png)

- DB 서버 접속을 위해 상기 Provisioning 한 윈도우 서버에 원격 데스크탑 을 통해 접속합니다.

    ![Windows Preparation](/assets/img/dataplatform/2022/goldengate/03.oci-goldengate-windows-preparation-2.png)

- 접속된 윈도우 서버에서 Oracle SQL Developer (https://www.oracle.com/database/sqldeveloper/technologies/download/) 를 다운로드 받아 설치합니다. 다운받은 zip 파일을 압축만 해제하면 됩니다. 압축해제된 파일 폴더에서 sqldeveloper.exe 를 실행합니다.
    ![SQL Developer](/assets/img/dataplatform/2022/goldengate/04.oci-goldengate-windows-sql-developer.png)

- SQL Developer 를 실행하면 아래와 같은 화면이 나타나며 상단의 새로운 DB Connection 을 생성할 수 있는 버튼을 클릭합니다.

    ![SQL Developer](/assets/img/dataplatform/2022/goldengate/05.oci-goldengate-windows-sql-developer-2.png)

- 생성된 DB 의 Connection 정보는 DBCS 의 상세화면에서 DB Connection 정보를 획득할 수 있습니다. 아래 그림과 같이 DB Connection 정보를 복사합니다.

    ![SQL Developer](/assets/img/dataplatform/2022/dbcs/quickstart/19.oci-dbcs-db-connection-string.png)

    ![SQL Developer](/assets/img/dataplatform/2022/dbcs/quickstart/20.oci-dbcs-db-connection-string-copy.png)

    ```text
    * DB Connection 정보  : srcggdb.sub07160235111.pslimvcn2021071.oraclevcn.com:1521/SRCGGDB_SRCGGDB.sub07160235111.pslimvcn2021071.oraclevcn.com

    상기 Connection 정보에서 SQL Developer 의 Connection 에 입력할 항목들을 추출합니다.

    1. 호스트 이름 : srcggdb.sub07160235111.pslimvcn2021071.oraclevcn.com
    2. 포트 : 1521
    3. 서비스 이름 : SRCGGDB_SRCGGDB.sub07160235111.pslimvcn2021071.oraclevcn.com

    ```

- 아래의 화면에 사용자 이름에 DB 생성 시 입력한 sys 사용자의 password 와 상기 DB Connection 정보에서 추출한 호스트 이름, 서비스 이름을 입력하고 테스트 및 저장 버튼을 클릭합니다. 여기서 반드시 사용자의 롤(Role)을 SYSDBA 로 선택해 줍니다.
    ![SQL Developer](/assets/img/dataplatform/2022/goldengate/06.oci-goldengate-sql-developer-connection-sys.png)

- Connection 을 클릭하여 설정한 DB 로 접속이 가능한지 확인합니다.

![SQL Developer](/assets/img/dataplatform/2022/goldengate/08.oci-goldengate-sql-developer-connect-sql.png)

- 이제 Database 에 스키마 생성 및 테이블 생성 및 활용의 준비가 완료되었습니다. 

<br>

---

