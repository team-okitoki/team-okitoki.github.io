---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "10월 OCI Oracle Data Platform 관련 업데이트 소식"
teaser: "2022년 10월 OCI Oracle Data Platform 관련 업데이트 소식입니다."
author: lim
breadcrumb: true
categories:
  - release-notes-2022-dataplatform
tags:
  - oci-release-notes-2022
  - October-2022
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


## OCI Egress is now chargeable for Media Streams
* **Services:**  Media Streams
* **Release Date:** Oct. 4, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/Content/dms-mediastream/home.htm](https://docs.oracle.com/en-us/iaas/Content/dms-mediastream/home.htm){:target="_blank" rel="noopener"}

### 서비스 소개
OCI Media Streams는 HTTP 라이브 스트리밍(HLS)과 같은 형식으로 패키징된 디지털 비디오를 시청자에게 전달할 수 있는 기능을 제공합니다. 사전 패키징된 HLS 패키지를 수집하거나 OCI Media Flow를 사용하여 소스 비디오를 스트리밍에 적합한 형식으로 트랜스코딩 및 패키징할 수 있습니다. Media Streams는 CDN(Content Delivery Network)을 통한 비디오 배포의 원본 서비스 역할을 하도록 구성할 수 있습니다.

다음 다이어그램은 OCI Media Flow 와 OCI Media Streams 가 어떻게 통합되는지를 나타내는 그림입니다. 

![](/assets/img/database/2022/07/01_architecturediagram_medserv_1.png)

### Key Capabilities
* Media Services에는 ABR (Adaptive Bit Rate) 스트림에 대한 대상 형식 변환, 암호화 및 비디오 분할을 위한 패키징 기능이 포함되어 있습니다. 또한 선도적인 CDN(Content Delivery Network) 파트너 생성 통합 또는 직접 서비스 에지 서비스를 사용하여 패키지된 ABR 콘텐츠의 안전하고 확장 가능한 배포를 제공합니다. Media Streams는 소스 콘텐츠에서 스트리밍 형식의 배포 및 패키징 프로세스를 단순화하고 복잡한 비디오 패키징 인프라의 원활한 관리를 가능하게 합니다.

### 신규 변경 사항

Media Streams에 대한 OCI Egress(Outbound Data Transfer) 면제 기간이 종료되었습니다.

<br>

## Solaris & Windows platform support and improved host top process identification
* **Services:**  Operations Insights
* **Release Date:** Oct. 4, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/operations-insights/doc/analyze-host-resources.html#OOPSI-GUID-513D7C7B-1D4B-44A9-A01F-772DBD995F4D](https://docs.oracle.com/en-us/iaas/operations-insights/doc/analyze-host-resources.html#OOPSI-GUID-513D7C7B-1D4B-44A9-A01F-772DBD995F4D){:target="_blank" rel="noopener"}

### 서비스 소개
Operations Insights를 사용하면 개별 호스트와 여러 호스트에 대한 현재 및 예상 CPU 사용량을 볼 수 있습니다.

### 신규 변경 사항
Operations Insights는 이제 Solaris 및 Windows 호스트 플랫폼 유형을 모두 지원합니다. 호스트 상위 프로세스는 이제 호스트 프로세스 문제의 표시 및 분석을 개선하기 위해 개별 프로세스 세부 정보에 액세스할 수 있는 표 (tabular) 형식으로 나타납니다.

- 지원 플랫폼 타입
    - Linux
    - Solaris
    - zLinux
    - Windows

![](/assets/img/database/2022/09/06_operation_insights_host.png)

<br>

## New Release for Data Integration (revised)
* **Services:**  Data Integration, Oracle Cloud Infrastructure
* **Release Date:** Oct. 5, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/releasenotes/changes/8daf8df9-032f-4587-aa8c-62b756840bbf/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/8daf8df9-032f-4587-aa8c-62b756840bbf/){:target="_blank" rel="noopener"}

### 서비스 소개
신규 버전의 Data Integration 이 출시가 되었습니다.

### 신규 변경 사항
신규 버전의 Data Integration 에 반영된 사항은 아래와 같습니다.
- Public 또는 Private REST API 에 대한 Endpoint 의 기본 URL을 사용하여 데이터 소스에 연결하고 데이터를 추출
- Data Flow (DI) 또는 Data Loader task에서 Object Storage, S3 또는 HDFS 소스를 구성할 때 Excel 파일 유형을 사용
- Data Flow (DI) 에서 JSON, Avro 및 Parquet 파일의 계층 배열 데이터를 관계형 형식으로 비정규화하기 위해 flatten operator (평면화 연산자)를 사용
- Pipeline 에서 Decision Operator 를 사용하여 Boolean 값으로 평가되는 조건식을 기반으로 분기 흐름을 지정
- Data Flow(DI) 또는 Data Loader task 에서 BICC Fusion 애플리케이션 소스를 구성할때 target attribute 으로 포함할 column 유형을 선택
- Data Loader task 에서 BICC Fusion 애플리케이션 소스로 작업할 때 여러 데이터 엔터티 로드 유형을 사용
- Logical entity qualifier 와 함께 Data Loader task 에서 파일 패턴을 사용하여 여러 Object Storage, S3 또는 HDFS 소스 데이터 엔티티를 선택하고 런타임 시 일치하는 파일을 논리적 엔티티로 통합
- REST task 에서 polling 을 구성할 때 json_path 함수와 함께 CAST 식에서 JSON_TEXT 유형을 사용
- Pipeline REST task 에서 JSON 데이터 유형 응답 출력 SYS.RESPONSE_PAYLOAD_JSON 및 SYS.RESPONSE_HEADERS_JSON을 사용

<br>

## New GoldenGate deployment types and connections now available
* **Services:**  Data Integration, Oracle Cloud Infrastructure
* **Release Date:** Oct. 7, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/releasenotes/changes/8daf8df9-032f-4587-aa8c-62b756840bbf/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/8daf8df9-032f-4587-aa8c-62b756840bbf/){:target="_blank" rel="noopener"}

### 서비스 소개
신규 버전의 GoldenGate 서비스가 Release 되었습니다. 새로운 GoldenGate Release 에는 Oracle 데이터베이스, MySQL 및 Bigdata Deployment 유형과 이러한 Deployment 를 지원하는 다양한 DB Connection 유형이 추가되었습니다.
추가된 Deployment Type 인 MySQL 과 BigData 도 GoldenGate 구성이 가능해졌습니다.

![](/assets/img/database/2022/10/01_New-GoldenGate.png)

### 신규 변경 사항

* Deployment Types
    - Oracle Database
    - MySQL
    - Big Data
* Supported Connectoins
    - Oracle Databases (Oracle Database 11.2.0.4, 12.1.0.2, and higher, ExaCS, Autonomous DB, AWS RDS)
    - MySQL (MySQL Database Server 5.7, 8.0
OCI MySQL Database Service 8.0
Amazon Aurora MySQL 5.7
Amazon RDS for MariaDB 10.4, 10.5
Amazon RDS for MySQL 5.7, 8.0
Azure Database for MySQL 5.7, 8.0
MariaDB 10.4, 10.5)
    - Big Data (Apache Kafka 2.4, 2.5, 2.6, 2.7, 2.8
OCI Streaming
OCI Object Storage (target only))
    - GoldenGate microservices deployments
 



---
