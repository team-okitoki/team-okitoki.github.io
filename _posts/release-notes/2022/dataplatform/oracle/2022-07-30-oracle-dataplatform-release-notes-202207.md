---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "7월 OCI Oracle Data Platform 관련 업데이트 소식"
teaser: "2022년 7월 OCI Oracle Data Platform 관련 업데이트 소식입니다."
author: lim
breadcrumb: true
categories:
  - release-notes-2022-dataplatform
tags:
  - oci-release-notes-2022
  - July-2022
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
* **Services:** Data Integration
* **Release Date:** July 11, 2022
* **Documentation:** 
[https://docs.oracle.com/en-us/iaas/data-integration/home.htm](https://docs.oracle.com/en-us/iaas/data-integration/home.htm){:target="_blank" rel="noopener"}

### 서비스 소개
Data Integration 은 데이터 엔지니어와 ETL 개발자가 다양한 데이터 자산에서 데이터 수집과 같은 공통 ETL(추출, 변환 및 로드) 작업을 수행하는 데 도움이 되는 Fully Managed Multi tenant 서비스입니다. Integration 할 Source 의 데이터를 정리, 변환 및 재구성하고 Target 데이터 Asset에 효율적으로 로드해 주는 서비스입니다. 이번에 Data Integration 의 신규 버전이 반영되었고 아래의 Bug 들이 Fix 되었습니다.

* DOS-5168 - 높은 메모리 소비 동안 orchestration 을 담당하는 내부 서비스의 자동 다시 시작을 활성화했습니다.
* DIS-16957 - 다른 하위 집합인 컬럼을 수동으로 매핑할 때 소스와 대상 간의 잘못된 컬럼 매핑을 수정했습니다.
* DCMS-6038- Connection 을 위해 파라미터화된 source operator 들로 Data flow 을 열 때 표시되는 잘못된 오류 알림을 수정했습니다.
* DIS-16957 - 잘못된 endpoint 로 인해 Phoenix Region 의 시스템 ATP 암호 refresh issue 가 해결되었습니다.

## Oracle Database Service for Azure
* **Services:** Database
* **Release Date:** July 20, 2022
* **Documentation:** 
[https://docs.oracle.com/en-us/iaas/Content/multicloud/intro.htm](https://docs.oracle.com/en-us/iaas/Content/multicloud/intro.htm){:target="_blank" rel="noopener"}

### 서비스 소개
Oracle Database Service for Azure(ODSA) 를 사용하면 Oracle Cloud Infrastructure의 데이터베이스 서비스를 Azure 클라우드 환경에 쉽게 통합할 수 있습니다. ODSA는 서비스 기반 접근 방식을 사용하며 애플리케이션 스택에 대한 복잡한 클라우드 간 배포를 수동으로 생성해야 하는 불편함을 해결할 수 있는 하난의 방법입니다. ODSA를 사용하여 지원되는 OCI와 Azure 지역 간의 프라이빗 터널 연결인 Microsoft Azure용 Oracle Interconnect를 사용하여 Azure 계정에 연결하는 Exadata, Oracle Base Database 및 Oracle Autonomous Database 리소스를 배포할 수 있습니다.

* 자세한 Oracle Database Service for Azure 서비스 소개는 아래 링크 참조
* [Oracle Database Service for Azure](/dataplatform/oracle-database-service-for-azure/){:target="_blank" rel="noopener"}


## Media Flow service is now available
* **Services:** Media Flow
* **Release Date:** July 20, 2022
* **Documentation:** 
[https://docs.oracle.com/iaas/Content/dms-mediaflow/home.htm](https://docs.oracle.com/iaas/Content/dms-mediaflow/home.htm){:target="_blank" rel="noopener"}


### 서비스 소개
OCI Media Service 는 미디어(비디오) 소스 콘텐츠를 처리하기 위한 완전 관리형 서비스입니다. 적시에 패키징된 ABR(Adaptive Bitrate) 비디오 콘텐츠에 대해 확장 가능한 배포 및 생성을 제공합니다. 

* ABR 은 아래 그림처럼 다양한 Device 에서 최적의 Resolution 으로 Play 될 수 있는 Streaming Package 를 만드는 방식의 스트리밍 방식입니다.  

![](/assets/img/database/2022/07/06_ABR_Streaming.png)

* OCI Media Services 에는 OCI Media Flow 와 OCI Media Stream 이 포함됩니다. 서비스는 독립적으로 또는 함께 사용할 수 있으며 OCI Object Storage 에 저장된 콘텐츠에 대해 작동합니다. (Serverless-Functions 서비스)

* OCI Media Flow 를 사용하면 비디오 소스 콘텐츠를 처리하는 데 사용할 수 있는 콘텐츠 처리 워크플로를 구성할 수 있습니다. 처리에는 트랜스코딩, 전사, 썸네일 생성, ABR Packaging 및 음성(자동 전사용), 언어(전사물의 자연어 처리(NLP) 기반 분석용) 및 비전(객체 감지용)과 같은 OCI AI 서비스와의 통합이 포함됩니다.

* Media Flow는 OCI Object Storage 서비스의 Object Storage 버킷을 input source 로 사용하고 지정된 트랜스코딩 작업을 수행하여 객체 스토리지 버킷에 ABR 패키지를 생성합니다. OCI Media Streams 를 사용하여 스트리밍된 VOD(주문형 비디오)로 OCI Media Flow 의 output 을 전달할 수 있습니다.


* 다음은 OCI에 구축된 일반적인 end-to-end VOD 스트리밍 솔루션에 대한 개요입니다. 다음 다이어그램은 OCI Media Flow 와 OCI Media Streams 가 어떻게 통합되는지를 나타내는 그림입니다. 

![](/assets/img/database/2022/07/01_architecturediagram_medserv_1.png)

### Key Capabilities

* OCI Media Flow 를 사용하여 다양한 장치 유형 및 해상도에 대한 온디맨드 비디오 스트리밍에 적합한 다양한 출력 형식으로 비디오를 트랜스코딩합니다. Media Flow 는 소스 콘텐츠에서 스트리밍 형식을 만드는 프로세스를 단순화하고 복잡한 비디오 처리 인프라를 관리할 수 있도록 합니다. 트랜스코딩된 비디오에 대한 썸네일을 생성할 수도 있습니다.

* Media Flow 를 사용하면 Speech, Language, Vision 과 같은 다른 OCI AI 서비스와 통합할 수 있습니다. 미디어 워크플로에 이러한 작업 중 하나가 포함되면 OCI Media Flow 는 자동으로 필요한 데이터를 AI 서비스에 전송하고 결과를 수집합니다.

* OCI Media Flow 에는 ABR 스트림에 대한 대상 형식 변환 및 비디오 분할을 위한 패키징 기능이 포함되어 있습니다. 트랜스코딩된 콘텐츠를 Media Streams 로 직접 수집하거나 별도로 스트리밍할 수 있습니다. 

### Media Flow Concept
* Media Flow : 미디어 콘텐츠를 처리하기 위한 사용자 정의 워크플로입니다. 미디어 워크플로에는 수행할 처리 작업을 정의하는 여러 미디어 워크플로 작업이 포함됩니다.
* System Workflow : 사용할 수 있는 미리 정의된 미디어 워크플로.
미디어 워크플로 작업: 유형에 따라 워크플로의 특정 지점에서 수행할 처리를 정의합니다.
* Media Flow Job : 작업은 워크플로를 통해 콘텐츠를 실행하는 데 사용됩니다. 여러 미디어 워크플로를 정의하고 워크플로를 사용하여 여러 작업을 만들 수 있습니다.

![](/assets/img/database/2022/07/02_medserv_screenshot_0.png)

![](/assets/img/database/2022/07/02_medserv_screenshot.png)


## Media Streams is now available
* **Services:** Media Streams
* **Release Date:** July 20, 2022
* **Documentation:** 
[https://docs.oracle.com/iaas/Content/dms-mediastream/home.htm](https://docs.oracle.com/iaas/Content/dms-mediastream/home.htm){:target="_blank" rel="noopener"}


### 서비스 소개
OCI Media Streams는 HTTP 라이브 스트리밍(HLS)과 같은 형식으로 패키징된 디지털 비디오를 시청자에게 전달할 수 있는 기능을 제공합니다. 사전 패키징된 HLS 패키지를 수집하거나 OCI Media Flow를 사용하여 소스 비디오를 스트리밍에 적합한 형식으로 트랜스코딩 및 패키징할 수 있습니다. Media Streams는 CDN(Content Delivery Network)을 통한 비디오 배포의 원본 서비스 역할을 하도록 구성할 수 있습니다.

다음은 OCI에 구축된 일반적인 end-to-end VOD 스트리밍 솔루션에 대한 개요입니다. 다음 다이어그램은 OCI Media Flow 와 OCI Media Streams 가 어떻게 통합되는지를 나타내는 그림입니다. 

![](/assets/img/database/2022/07/01_architecturediagram_medserv_1.png)

### Key Capabilities
* Media Services에는 ABR (Adaptive Bit Rate) 스트림에 대한 대상 형식 변환, 암호화 및 비디오 분할을 위한 패키징 기능이 포함되어 있습니다. 또한 선도적인 CDN(Content Delivery Network) 파트너 생성 통합 또는 직접 서비스 에지 서비스를 사용하여 패키지된 ABR 콘텐츠의 안전하고 확장 가능한 배포를 제공합니다. Media Streams는 소스 콘텐츠에서 스트리밍 형식의 배포 및 패키징 프로세스를 단순화하고 복잡한 비디오 패키징 인프라의 원활한 관리를 가능하게 합니다.



* Media Streams는 Object Storage 버킷에 있는 트랜스코딩된 콘텐츠를 나타내는 HLS(m3u8 파일)를 수집하여 작동합니다. OCI Media Flow를 이용하거나 외부 트랜스코딩 서비스를 이용하여 콘텐츠를 제작할 수 있습니다. 그러나 콘텐츠는 Media Streams가 지원하는 수집 형식을 준수해야 하며 Object Storage 버킷에 있어야 합니다. Media Streams는 배포 채널의 일부로 정의된 대로 지정된 패키징 및 생성을 수행합니다.



### Media Streaming Concept

* Stream Distribution Channel : 발신 및 패키징 구성의 사용자 정의 조합입니다.
  * OCI Edge Stream CDN 구성 : 특정 CDN(콘텐츠 전송 네트워크) 통합 없이 OCI 미디어 스트림 배포 채널에서 직접 패키지 비디오 콘텐츠를 스트리밍할 수 있는 non-configuration 콘텐츠 전송 네트워크입니다.
  * Akamai Stream CDN 구성: OCI Media Streams 배포 채널이 Akamai의 오리진 서버 역할을 할 수 있도록 하는 Akamai CDN과의 통합을 지원하는 구성입니다.
* HLS Packaging 구성: 비디오 콘텐츠의 HTTP Live Streaming (HLS) 패키징을 위한 사용자 정의 구성입니다.

아래 그림은 Streaming Distribution Channel 을 생성하는 화면입니다.

![](/assets/img/database/2022/07/03_medserv_streaming_dist_channel.png)

Streaming Distribution Channel 에 배포하기 위해서는 정해진 Packaging 구성과 Play List 들을 기반으로 Edge 나 CDN 으로 배포할 비디오들을 선별하여 배포합니다.

아래 화면은 HTTP Live Streaming 을 위한 Packaging 을 구성하는 화면입니다. 

![](/assets/img/database/2022/07/04_medserv_streaming_create_package.png)


아래 화면은 CDN 으로 배포할 Play List 를 설정하는 화면입니다. Object Storage 에 저장된 비디오 항목을 선택하여 Play List 에 추가하여 설정합니다.

![](/assets/img/database/2022/07/05_medserv_streaming_create_playlists.png)


## AWR Explorer for Operations Insights
* **Services:** Operations Insights
* **Release Date:** July 26, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/operations-insights/doc/analyze-automatic-workload-repository-awr-performance-data.html#GUID-303405AA-30B6-45C3-8A17-5ADD11DFB16C](https://docs.oracle.com/en-us/iaas/operations-insights/doc/analyze-automatic-workload-repository-awr-performance-data.html#GUID-303405AA-30B6-45C3-8A17-5ADD11DFB16C){:target="_blank" rel="noopener"}


### 서비스 소개
이제 Operations Insights에서 AWR Explorer를 사용하여 AWR Hub 에 저장된 데이터베이스 성능 데이터를 비교할 수 있게 되었습니다.
Operations Insights에서 AWR Explorer를 사용하면 다음을 수행할 수 있습니다.

* 다양한 데이터베이스 시스템에서 AWR 데이터 보기 및 분석
* 시간별 AWR 보고서를 만들 필요 없이 성능 추세를 쉽게 식별
* 성능 문제를 감지하는 데 도움이 될 수 있는 Oracle Database 성능 데이터의 다양한 측면을 시각화

![AWR Explorer](/assets/img/database/2022/07/07_AWR_Explorer.png)
<br>
![AWR Explorer-2](/assets/img/database/2022/07/08_AWR_Explorer-2.png)
<br>
![AWR Explorer-3](/assets/img/database/2022/07/09_AWR_Explorer-3.png)

## TCPS Support for Oracle Cloud Databases
* **Services:** Database Management
* **Release Date:** July 26, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/database-management/doc/enable-database-management-oracle-cloud-databases.html#GUID-DA905E25-CE6F-48E2-B003-F86A330D8448](https://docs.oracle.com/en-us/iaas/database-management/doc/enable-database-management-oracle-cloud-databases.html#GUID-DA905E25-CE6F-48E2-B003-F86A330D8448){:target="_blank" rel="noopener"}

### 서비스 소개

이제 Oracle Cloud Database에 대한 데이터베이스 관리를 활성화할 때 TCP/IP with Transport Layer Security(TCPS) 프로토콜을 사용할 수 있습니다.
TCP 기반의 통신과 달리 TCPS 기반의 통신을 위해서는 Key Vault 에서 관리하는 전자 지갑의 PKCS 나 Java Key Store (keystore.jks) 저장소 컨텐츠가 필요합니다. 

![DB Mgmt](/assets/img/database/2022/07/10_Database_Mgmnt_TCPS.png)
<br>

![DB Mgmt](/assets/img/database/2022/07/11_Database_Mgmnt_TCPS_keystore.png)
<br>

## Updates to autoscaling and customer-managed encryption key features
* **Services:**  Big Data, Oracle Cloud Infrastructure
* **Release Date:** July 28, 2022
* **Documentation:**
[https://docs.oracle.com/en-us/iaas/Content/bigdata/home.htm](https://docs.oracle.com/en-us/iaas/Content/bigdata/home.htm){:target="_blank" rel="noopener"}

### 서비스 소개

Big Data Service는 Hadoop 및 Spark 클러스터를 온디맨드로 프로비저닝할 수 있게 기능을 제공합니다. 소규모 테스트 및 개발 클러스터부터 대규모 프로덕션 클러스터까지 지원하는 다양한 Oracle Cloud Infrastructure 컴퓨팅 Shape 들을 사용하여 빅 데이터 및 분석 워크로드에 맞게 클러스터를 확장할 수 있습니다. 이번에 업데이트된 Big Data Service 에서는 아래와 같은 기능들이 업데이트 되었습니다.

BDS Auto Scaling 및 Customer Managed 암호화 Key 기능 업데이트:

* ODH 클러스터에서 수평 및 수직 자동 크기 조정을 위한 일정 기반 옵션을 추가
* BDS 클러스터에 대해 고객 관리 암호화 키 사용
* 고객 관리 암호화 키를 사용하도록 기존 클러스터 업데이트



---
