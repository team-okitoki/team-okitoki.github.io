---
layout: page-fullwidth
#
# Content
#
subheadline: "DataPlatform"
title: "Oracle Database Cloud Service 소개"
teaser: "OCI (Oracle Cloud Infrastructure) 에서 제공하고 있는 Oracle Database Cloud Service 에 대해 알아봅니다."
author: lim
breadcrumb: true
categories:
  - dataplatform
tags:
  - [oci, database, dbcs, exacs, autonomous]
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
Oracle 은 전통적으로 데이터 관리 솔루션인 Database 솔루션의 강자였던 만큼 Oracle Cloud Infrastructure (OCI) 내에서도 Oracle Database 에 대해 최상의 성능을 보장하는 클라우드 기반의 데이터베이스 서비스들을 제공합니다. 
이러한 Database Cloud Service 는 다양한 Workload 의 유형 및 부하에 따라 Deployment 옵션들을 선택할 수 있어서 고객에게 최적의 비용으로 Oracle Database Cloud Service 를 사용할 수 있도록 합니다.

#### * 오라클 데이터베이스 Deployment Options

오라클 클라우드에서 제공하는 Oracle Database Cloud Service 의 형태를 살펴보면 워크로드의 수준에 따라서 다양한 Deploy Option 을 제공합니다.

![Deployment Option](/assets/img/dataplatform/2022/dbcs/01.blog-oracle-dbcs-deployment-option.PNG)

**1. Compute 기반 Database 서비스**

- 제일 작게는 고객들이 보유하고 있는 데이터베이스 라이선스를 가지고 컴퓨트 인스턴스에 Block 스토리지를 연결해서, DB를 직접 설치해서 서비스의 운영까지 고객이 직접 수행하게 되는 컴퓨트 기반의 DB 서비스입니다.

**2. Base Database Cloud 서비스**
- 컴퓨트, 스토리지 구성, DB 설치, RAC 구성까지 원클릭 프로비저닝을 통해서 자동으로 구성을 해 주는 Virtual Machine, Bare Metal 기반의 데이터베이스 서비스가 있습니다. 
- OCI 에서 가장 범용적으로 사용하는 Oracle Database Cloud 서비스는 Base Database Cloud 서비스로써 이번 글에서 자세히 다루도록 하겠습니다.

**3. Exadata Cloud 서비스**
- 최상의 성능이 요구되는 Workload 나 ERP 같은 대규모 시스템을 위해서 Exadata Infrastructure 기반으로 Oracle Database 를 Deploy 하는 옵션입니다. Exadata 인프라를 활용하기 때문에 고성능의 데이터베이스 서비스를 보장받을 수 있는 데이터베이스 클라우드 서비스입니다.

**4. Autonomous Database 서비스**
- Autonomous database 는 Exadata Infrastructure 기반의 자동으로 운영되고 다이나믹하게 스케일링 업/다운 기능까지 보유한 완전 자동화된 데이터베이스 클라우드 서비스입니다. DBA의 관리없이도 완전 자동으로 운영되는 서비스로 Workload 형태에 따라 OLTP 성 데이터 처리를 위한 **ATP (Autonomous Transaction Processing)** 과 DW 형태의 워크로드를 위한 **ADW (Autonomous Data Warehouse)** 와 NoSQL 유형의 데이터를 처리할 수 있는 **AJDB (Autonomous JSON Database)** 나뉘어 집니다.


#### * OCI 범용 Database Cloud Service - Base Database Cloud 서비스

OCI 에서는 베어메탈 또는 가상 머신기반의 단일 노드 Base Database Cloud 서비스인 DB System 을 제공합니다. 
2노드 RAC DB 시스템을 사용하려고 할 경우는 가상 머신 기반의 DB System 을 선택하셔야 합니다.
이런 DB System 자원 생성을 위해 Cloud Console, API, Oracle Cloud Infrastructure CLI, 데이터베이스 CLI(DBCLI), Enterprise Manager 또는 SQL Developer를 사용하여 이러한 시스템을 관리하실 수 있습니다.

#### * Base Database Service Support Edition

![DB Editions](/assets/img/dataplatform/2022/dbcs/02.blog-oracle-dbcs-editions.PNG)

OCI 의 Oracle Base Database Cloud Service 는 모든 On-Prem Oracle Database 솔루션과 동일한 Full 기능 세트를 지원합니다.
(<mark>2 Node RAC 구성 시 EE Extreme Performance Edition 을 선택해야 구성이 가능</mark>)

#### * Database Cloud Service Deployment Option 별 지원 Version 및 차이점
다음 표는 OCI Oracle Database Cloud 서비스의 Deployment 옵션별 지원 버전 및 차이점들을 요약한 표입니다.

![DB Editions](/assets/img/dataplatform/2022/dbcs/03.blog-oracle-dbcs-option-versions.PNG)

빨간색 박스로 표시된 부분이 Base Database Cloud Service 가 지원하는 버전 및 Edition, DBA Access 기능 지원하는지의 여부, DB 용량, RAC, Backup 의 자동/수동 여부등이 요약되어 있습니다.
Base Database Cloud 서비스를 이용하게 되면 OCI Console 및 CLI, Restful API 등을 통해 DB 시스템에 대한 운영이 가능하고 고객이 보유한 인프라와 손쉽게 연동이 가능합니다. 더불어 모든 운영 정책은 고객사의 보안 정책에 따라 조정하여 운영하실 수 있는 편리한 데이터베이스 클라우드 서비스입니다.

OCI 의 Database Cloud 서비스를 이용했을때 아래와 같이 다양한 장점들이 있습니다.
- 주기적인 업그레이드 및 패치 적용 용이 
- 데이터 백업 수행 용이
- 데이터 보호를 위한 Data Guard 적용 용이

#### * Base Database Service 버전 업그레이드 및 패치 적용

아래 화면과 같이 Database Cloud 서비스의 적용해야 할 업그레이드 항목 및 Patch 항목을 선택하여 손쉽게 적용이 가능하도록 지원합니다.
(RAC 일 경우, Rolling Patch 적용)
![DB Patch](/assets/img/dataplatform/2022/dbcs/04.blog-oracle-dbcs-patch.PNG)

#### * 자동 백업 기능 제공 (Automatic Backup & Recovery)
많은 DB 관리자들이 고민하는 사항 중 하나는 데이터의 백업 및 복구를 어떻게 할 것인지 고민을 많이 합니다. 오라클 Database Cloud 서비스에서는 자동으로 Backup 이 가능한 Automatic Backup Enable 기능을 제공하고 있으며, 언제든지 상시에 Full backup 을 생성할 수 있는 기능을 제공합니다.
자동 Backup 기능은 7일 ~ 60일 사이의 보존기간을 설정할 수 있으며, Backup 된 데이터로부터 DB 를 다시 생성하거나 복원할 수 있는 기능을 제공합니다.

![DB backup](/assets/img/dataplatform/2022/dbcs/05.blog-oracle-dbcs-automatic-backup.PNG)

![DB recovery](/assets/img/dataplatform/2022/dbcs/06.blog-oracle-dbcs-backup-db-create.PNG)

#### * 데이터 보호를 위한 Data Guard 적용
Oracle Cloud 의 Database Cloud 서비스는 OCI Console 화면을 통해 원격지 Standby 데이터베이스에 데이터 복제를 통해 데이터를 보호할 수 있는 Data Guard 를 손쉽게 적용할 수 있는 기능을 제공합니다.
- AD간 Region 간 Data Guard 구성
- Primary 로부터 자동으로 Standby 구성
- OCI Console UI 를 통해 Failover, Reinstate, Switchover 등의 기능 수행

![DB DataGuard](/assets/img/dataplatform/2022/dbcs/07.blog-oracle-dbcs-dg-button.PNG)


![DB DataGuard](/assets/img/dataplatform/2022/dbcs/08.blog-oracle-dbcs-dg-create.PNG)

#### * Database Cloud Service Security
Oracle Cloud 의 Database Cloud 서비스는 보안을 최우선으로 고려하였으며 다음과 같은 기능들이 적용됩니다.
- 모든 데이터베이스에 TDE 기능이 적용됨
- 모든 백업 데이터는 암호화됨
- SQL*Net Connection 들도 암호화됨
- OCI 네트워킹을 통한 데이터베이스 서비스 격리 – Private Subnet
- Virtual Cloud Network의 Security List를 통한 방화벽 기능
- VCN Routing Rule
- OS 접근을 위해 Password 기반의 인증을 사용하지 않음
- IAM Policy based access

---

