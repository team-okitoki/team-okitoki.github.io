---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "9월 OCI Oracle Data Platform 관련 업데이트 소식"
teaser: "2022년 9월 OCI Oracle Data Platform 관련 업데이트 소식입니다."
author: lim
breadcrumb: true
categories:
  - release-notes-2022-dataplatform
tags:
  - oci-release-notes-2022
  - September-2022
  - DATABASE
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
 

## Preferred Credentials in Database Management
* **Services:**  Database Management
* **Release Date:** Sept. 6, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/database-management/doc/set-preferred-credentials.html](https://docs.oracle.com/en-us/iaas/database-management/doc/set-preferred-credentials.html){:target="_blank" rel="noopener"}

### 서비스 소개
이제 Database Management 에서 선호 자격 증명을 설정하여 사용자 Role 및 수행할 작업을 기반으로 데이터베이스에 대한 기본 연결을 제공함으로써 다양한 사용자 그룹의 의무를 분리하고 또 다른 Security Layer를 제공할 수 있습니다. 

선호 인증서 (Preferred Credential)는 Oracle Cloud Infrastructure Vault 서비스에 저장된 암호 인증서를 사용하여 Database Management 서비스에 액세스할 수 있도록 합니다. 선호 인증서 기능은 아래와 같이 사용자 및 역할을 나누어 권한을 세분화 할 수 있습니다.

* 기본 모니터링 (Monitoring) : Matric 을 수집하고 데이터베이스 플릿 요약 또는 관리되는 데이터베이스 세부 정보를 볼 수 있는 최소 권한입니다. 기본 모니터링 자격 증명은 Database Management 가 활성화된 경우 모니터링 사용자에 대해 자동으로 설정됩니다. (Built-in user : DBSNMP)
* 고급 진단 (Advanced diagnostics) : Performance Hub 및 AWR Explorer와 같은 진단 도구를 사용할 수 있는 고급 권한입니다. 고급 진단 자격 증명이 관리되는 데이터베이스에 대해 설정된 경우 진단 기능을 자동으로 사용하고 관리되는 데이터베이스의 읽기 작업에 사용할 수 있습니다.
* 관리 (Administrator) : 테이블스페이스 생성 및 데이터베이스 매개변수 편집과 같은 관리 작업을 수행할 수 있는 관리 권한입니다. 관리되는 데이터베이스에 대해 관리 자격 증명이 설정된 경우 관리되는 데이터베이스에서 쓰기 작업을 수행하기 위해 사용할 수 있습니다.

![](/assets/img/database/2022/09/09_database_management_overview.png)

## Data Flow now supports Spark 3.2.1, Conda Packs, and Delta Lakes
* **Services:**  Data Flow
* **Release Date:** Sept. 8, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/releasenotes/changes/2eb1dc89-8a8c-45a4-9951-bac853b44d50/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/2eb1dc89-8a8c-45a4-9951-bac853b44d50/){:target="_blank" rel="noopener"}

### 서비스 소개

Oracle Cloud Infrastructure Data Flow는 Apache Spark ™ 애플리케이션을 실행하기 위한 완전 관리형 서비스입니다. 개발자가 애플리케이션에 집중할 수 있도록 하고 이를 실행할 수 있는 쉬운 런타임 환경을 제공합니다. 애플리케이션 및 워크플로와의 통합을 위한 API 지원을 통해 쉽고 간단한 사용자 인터페이스를 제공합니다. 

![](/assets/img/database/2022/06/01_Data_Flow_Service_overview_1.png)


* 신규 개선 사항
  - OCI Data Flow 서비스에서 이제 Spark 3.2.1을 지원합니다. Spark 3.2.1에 대한 지원은 Data Flow가 이제 Delta Lakes 를 지원 하고 Conda Pack과 통합 될 수 있음 을 의미합니다.
  ![](/assets/img/database/2022/09/03_data_flow_spark_new.png)

* Delta Lakes 지원
  - Delta Lake는 데이터 레이크에 안정성을 제공하는 오픈 소스 스토리지 계층입니다. Delta Lake는 Parquet 을 기반으로 한 Open Format 이며, ACID 트랜잭션을 제공하고  Apache Spark API와 완벽하게 호환됩니다.  Delta Lake 를 사용하면 데이터 레이크 위에 Lakehouse 아키텍처를 구축할 수 있습니다. Delta Lake 1.2.1은 Data Flow Spark 3.2.1 처리 엔진과 통합되어 있으므로 추가 Spark 구성이 필요하지 않습니다.
  ![](/assets/img/database/2022/09/01_data_flow_delta.png)

* Conda Pack 과의 통합 지원
  - Conda 는 가장 널리 사용되는 Python 패키지 관리 시스템입니다. conda-pack 을 사용 하면 PySpark 사용자는 Conda 환경을 직접 사용하여 다양한 Python 패키지를 사용할 수 있습니다. Spark 3.2.1과 함께 Data Flow를 사용하는 경우 Conda Pack과 통합할 수 있습니다.
  ![](/assets/img/database/2022/09/04_data_flow_spark_new-2.png)

<br>

## New Release for Data Integration (Bug fixes)
* **Services:**  Data Integration
* **Release Date:** Sept. 19, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/releasenotes/changes/127df661-6007-4aa7-b6e7-4e2c3c481c5f/]https://docs.oracle.com/en-us/iaas/releasenotes/changes/127df661-6007-4aa7-b6e7-4e2c3c481c5f/){:target="_blank" rel="noopener"}


### 서비스 소개

Data Integration 의 Bug Fix 수정 사항들이 반영되었습니다. 지속적인 Bug 사항들이 개선되고 있습니다.

* 신규 개선 사항
  - 예약된 작업이 몇초 또는 밀리초 내에 두 번 실행되도록 트리거되는 간헐적인 문제가 수정됨
  - 중지된 작업 영역에서 실행 요청 후 내보낸 잘못된 코드로 인해 트리거되는 잘못된 alarm 이 발생되는 사항 수정
  - 데이터 엔터티 목록을 필터링하기 위해 데이터 로더 작업과 함께 이름 또는 패턴을 사용할 때의 시간 초과 문제가 수정됨
  - 호환되지 않는 TLS 버전을 사용하는 내부 서비스 에이전트 문제가 수정됨

<br>

## View Trail files in GoldenGate
* **Services:**  GoldenGate
* **Release Date:** Sept. 23, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/releasenotes/changes/127df661-6007-4aa7-b6e7-4e2c3c481c5f/]https://docs.oracle.com/en-us/iaas/releasenotes/changes/127df661-6007-4aa7-b6e7-4e2c3c481c5f/){:target="_blank" rel="noopener"}


### 서비스 소개

OCi GoldenGate 버전 21.6 이상으로 업그레이드된 Deployment 는 이제 리소스 아래의 배포 세부 정보 페이지에서 Trail File 의 정보를 볼 수 있습니다.

![](/assets/img/database/2022/09/07_GoldenGate_Trail.png)

Trail 파일은 시간 경과에 따라 축적될 수 있으므로 사용되지 않은 추적 파일을 주기적으로 비워야 합니다. Trail 파일을 Purge 하는 방법은 아래와 같습니다.

### Trail 파일 Purge 방법

1. OCI GoldenGate 의 Deployment 를 수동 백업
2. 현재 동작 중인 프로세스들 Review
3. Purge Task Setup 
    - OCI GoldenGate Admin 의 Configuration 메뉴에서 Purge Task 설정

    ![](/assets/img/database/2022/09/08_GoldenGate_Trail_Purge_Task.png)

 
---
