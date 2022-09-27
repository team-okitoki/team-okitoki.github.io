---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "8월 OCI Oracle Data Platform 관련 업데이트 소식"
teaser: "2022년 8월 OCI Oracle Data Platform 관련 업데이트 소식입니다."
author: lim
breadcrumb: true
categories:
  - release-notes-2022-dataplatform
tags:
  - oci-release-notes-2022
  - August-2022
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


## New Release for Data Integration (Bug fixes)
* **Services:**  Data Integration, Oracle Cloud Infrastructure
* **Release Date:** Aug. 2, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/data-integration/home.htm](https://docs.oracle.com/en-us/iaas/data-integration/home.htm){:target="_blank" rel="noopener"}

### 서비스 소개
Data Integration 은 데이터 엔지니어와 ETL 개발자가 다양한 데이터 자산에서 데이터 수집과 같은 공통 ETL(추출, 변환 및 로드) 작업을 수행하는 데 도움이 되는 Fully Managed Multi tenant 서비스입니다. Integration 할 Source 의 데이터를 정리, 변환 및 재구성하고 Target 데이터 Asset에 효율적으로 로드해 주는 서비스입니다. 이번에 Data Integration 의 신규 버전이 반영되었고 아래의 Bug 들이 Fix 되었습니다.

* 많은 수의 엔터티 필드가 있는 Data Flow 를 저장할때 발생하던 문제가 해결됨.
* 데이터 로더 작업 실행에서 runtime child task operation 중 잘못된 parameter 설정이 수정됨.
* ATP 암호 문제로 인해 발생하는 HTTP 404 코드 오류가 수정됨.
* 사용하지 않는 포트는 비활성화되고 agent library 는 보안 조치로 제거됨.

## Support for OCI Compute
* **Services:**  Operation Insights
* **Release Date:** Aug. 9, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/operations-insights/doc/analyze-host-resources.html](https://docs.oracle.com/en-us/iaas/operations-insights/doc/analyze-host-resources.html){:target="_blank" rel="noopener"}

### 서비스 소개

Operations Insights는 오라클 데이터베이스 및 일반 Host 의 리소스 활용도와 용량에 대한 360도 통찰력을 제공하는 서비스입니다. CPU 및 스토리지 리소스를 쉽게 분석하고, 용량 문제를 예측하고, 데이터베이스 플릿 전체에서 SQL 성능 문제를 사전에 식별할 수 있습니다. Operations Insights 의 Host capacity planning 기능은 이제 OCI Compute 인스턴스에 대해서도 지원합니다.

* Host Capacity Planning

![Operation Insights](/assets/img/database/2022/08/01_Operation-insights-host.png)

## Optimizer Statistics Monitoring in Database Management
* **Services:**  Database Management
* **Release Date:** Aug. 9, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/database-management/doc/monitor-and-analyze-optimizer-statistics.html](https://docs.oracle.com/en-us/iaas/database-management/doc/monitor-and-analyze-optimizer-statistics.html){:target="_blank" rel="noopener"}

### 서비스 소개

Managed Database에 대한 Optimizer 통계를 모니터링하고, 통계 수집 작업 및 Optimizer Statistics Advisor 작업을 분석하고, Database Management에서 Optimizer Statistics Advisor 권장 사항을 구현할 수 있습니다. Optimizer 통계 섹션으로 이동하려면 관리되는 데이터베이스 세부 정보 페이지로 이동하고 리소스 아래의 왼쪽 창에서 Optimizer 통계를 클릭합니다.

* Optimizer Statistics
  - Optimizer Statistics는 데이터베이스 및 데이터베이스의 개체에 대한 세부 정보를 설명하는 데이터 모음입니다. 통계는 액세스 경로를 평가할 때 Optimizer 가 사용하는 데이터 저장 및 배포에 대한 통계적으로 정확한 그림을 제공합니다. Optimizer는 통계를 사용하여 테이블, 파티션 또는 인덱스에서 검색된 행 수(및 바이트 수)를 추정합니다. Optimizer는 액세스 비용을 추정하고 가능한 계획에 대한 비용을 결정한 다음 비용이 가장 낮은 실행 계획을 선택합니다.

    ![Optimizer Statistics](/assets/img/database/2022/08/02_Optimzer_statistics.png)

* Optimizer Statistics Monitoring

  - Database Management 기능에 Optimizer Statistics Monitoring 기능이 추가 되었으며 아래의 메뉴로 접근하실 수 있습니다.
  -  Managed database details page -> 좌측 pane 메뉴 중에서 Optimizer statistics 메뉴 하위 -> Resource 메뉴


## New metrics added for GoldenGate service
* **Services:**  GoldenGate, Monitoring, Oracle Cloud Infrastructure
* **Release Date:** Aug. 12, 2022
* **Documentation:**
[https://docs.oracle.com/en/cloud/paas/goldengate-service/using/goldengate-metrics1.html](https://docs.oracle.com/en/cloud/paas/goldengate-service/using/goldengate-metrics1.html){:target="_blank" rel="noopener"}

### 서비스 소개

Oracle Cloud Console 내에서 GoldenGate 모니터링을 위해 새로운 Metric 이 추가되었습니다. 프로세스별 메트릭을 사용하여 추출, 복제, 배포 및 수신기 경로를 포함한 특정 GoldenGate 프로세스에 대한 Alarm 을 생성할 수 있습니다.

* Monitoring 메뉴 : OCI Console -> Observability & Management -> Monitoring -> Service Metrics 에 oci_goldengate 가 추가됨

![OGG Monitoring](/assets/img/database/2022/08/03_oci_goldengate_monitoring.png)


## New Release for Database Management
* **Services:**  Database Management
* **Release Date:** Aug. 16, 2022
* **Documentation:**
[https://docs.oracle.com/en/cloud/paas/goldengate-service/using/goldengate-metrics1.html](https://docs.oracle.com/en/cloud/paas/goldengate-service/using/goldengate-metrics1.html){:target="_blank" rel="noopener"}

### 서비스 소개

오라클 데이터베이스 클라우드 서비스들을 관리할 수 있는 Database Management 서비스의 신규 버전이 업데이트 되었습니다.

* 신규 기능
  - Compartment 또는 Database Group 에서 관리되는 데이터베이스 집합 또는 단일 관리되는 데이터베이스에 대해 심각도에 따라 Open 경보의 총 수와 경보의 수를 모니터링
  - 데이터베이스 유형별로 집합 Summary 페이지에 표시된 데이터베이스를 필터링
  - Database Management Page에서 Autonomous Database 에 대한 Database Management 를 활성화

* Database Filtering 및 Alarm 경보 수 보기

![OGG Monitoring](/assets/img/database/2022/08/04_database_management_new.png)

* Database Management ADB 추가 기능

![OGG Monitoring](/assets/img/database/2022/08/05_database_management_new_adb_add.png)


## Data Flow now supports Oracle Cloud Infrastructure Logging
* **Services:**  Data Flow
* **Release Date:** Aug. 17, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/data-flow/using/home.htm](https://docs.oracle.com/en-us/iaas/data-flow/using/home.htm){:target="_blank" rel="noopener"}

### 서비스 소개
Oracle Cloud Infrastructure Data Flow는 Apache Spark 애플리케이션을 실행하기 위한 완전 관리형 서비스입니다. 개발자가 애플리케이션에 집중할 수 있도록 하고 이를 실행할 수 있는 쉬운 runtime 환경을 제공합니다. 애플리케이션 및 워크플로와의 통합을 위한 API 지원을 통해 쉽고 간단한 사용자 인터페이스를 제공합니다. 기본 인프라, 클러스터 프로비저닝 또는 소프트웨어 설치에 시간을 소비할 필요가 없습니다. 

* 신규 기능 
  - 이번에 추가된 Data Flow 의 신규 기능은 Oracle Cloud Infrastructure Logging을 사용하여 콘솔 또는 CLI에서 Spark 진단 로그 및 (사용자 지정) 애플리케이션 로그를 제공할 수 있습니다.

![Data Flow](/assets/img/database/2022/08/06_data_flow_logging.png)

## Database CPU Capacity Planning Allocation Range
* **Services:**  Operation Insights
* **Release Date:** Aug. 23, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/operations-insights/doc/analyze-database-resources.html#OOPSI-GUID-E6F4BA94-0D38-4E0B-8191-E42F54D37933](https://docs.oracle.com/en-us/iaas/operations-insights/doc/analyze-database-resources.html#OOPSI-GUID-E6F4BA94-0D38-4E0B-8191-E42F54D37933){:target="_blank" rel="noopener"}

### 서비스 소개

Operations Insights Capacity Planning 기능은 데이터베이스의 리소스 및 사용량에 대한 Insights 를 제공하므로써 조직의 최대 데이터베이스 용량과 장기적으로 사용할 데이터베이스 용량 예측을 가능하게 합니다.

* 신규 기능
  - 이제 Trend 및 예측 분석 차트에 초과 할당 Range 가 표시됩니다. 이 Range 는 호스트의 단일 데이터베이스 또는 데이터베이스 그룹에 대해 해당 데이터베이스에 할당된 CPU 수 대비 호스트가 실제로 보유한 CPU 수를 보여주므로써 잠재적인 리소스 및 성능 문제를 쉽게 식별할 수 있습니다.

* Over Allocation Range Chart

![Operation Insights](/assets/img/database/2022/08/07_operation_insights_forecast-over.png)


## New Release for Data Integration (Security fixes)
* **Services:**  Data Integration, Oracle Cloud Infrastructure
* **Release Date:** Aug. 30, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/data-integration/home.htm](https://docs.oracle.com/en-us/iaas/data-integration/home.htm){:target="_blank" rel="noopener"}

### 서비스 소개
Data Integration 의 이번 릴리스에는 보안 취약점을 수정하는 수정 사항이 포함되어 있습니다.

* Bug Fixes
  - Upgraded Hadoop version to 3.3.3
  - Upgraded Hadoop's hadoop-aws to 3.3.3
  - Upgraded Java Secure Channel to version 0.2.2
  - Upgraded Gson Java library to 2.9.0
  - Removed com.h2database:h2 JAR dependency
  - Upgraded org.json:json package to 20220320
  - Excluded log4j and netty-all JAR files from agent plug-in
  - Upgraded org.apache.spark:spark-network-common JAR to 3.3.0
  - Upgraded org.apache.commons:commons-compress JAR to 1.21


## Enhanced Integration with Database Management
* **Services:**  Database Management, Operations Insights
* **Release Date:** Aug. 30, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/database-management/doc/monitor-and-manage-specific-managed-database.html](https://docs.oracle.com/en-us/iaas/database-management/doc/monitor-and-manage-specific-managed-database.html){:target="_blank" rel="noopener"}

### 서비스 소개
이제 OCI Database Management 서비스 콘솔에서 현재 데이터베이스 Context 내에서 직접 Operations Insights SQL Warehouse 및 Capacity Planning 기능에 액세스할 수 있습니다.

* Database Management Console 에서 Capacity Planning 및 SQL 웨어하우스 액세스

![DB Mgmt](/assets/img/database/2022/08/08_database_management_capacity_sql_warehouse.png)

---
