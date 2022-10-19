---
layout: page-fullwidth
#
# Content
#
subheadline: "DataPlatform"
title: "Oracle Bigdata Cloud Service 소개"
teaser: "OCI (Oracle Cloud Infrastructure) 에서 제공하고 있는 Bigdata Cloud Service 에 대해 알아봅니다. OCI Big Data Service는 가용성이 높은 전용 Hadoop 및 Spark Cluster를 온디맨드로 프로비저닝해 주는 서비스로써 안전하게 OCI 에서 관리되는 Managed Service 입니다."
author: lim
breadcrumb: true
categories:
  - dataplatform
tags:
  - [oci, bigdata, hadoop, apache, cloudera, hdfs, hive, ambari]
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
이번 글에서는 OCI 에서 제공하는 빅데이터 (Bigdata) 를 위한 Hadoop Cluster 서비스에 대해서 알아보도록 하겠습니다.
Big Data Service는 가용성이 높은 전용 Hadoop 및 Spark Cluster를 온디맨드로 프로비저닝해 주는 서비스로써 안전하게 OCI 에서 관리되는 Managed Service 입니다. 작은 규모의 테스트 및 개발 클러스터에서부터 대규모 Production Cluster를 지원하는 다양한 Oracle Cloud Infrastructure 컴퓨팅 Shape들을 사용하여 빅 데이터 및 분석 워크로드에 맞게 클러스터를 확장하는 서비스입니다.

![](/assets/img/database/2022/05/05_oci_database_releasenote_bigdata_main.png)

***Big Data Service 가 포함하고 있는 사항***

* Hadoop 기술 Stack의 선택
  * **ODH (Apache Hadoop):** Apache Hadoop(ODH)을 포함한 Oracle Distribution 설치가 포함된 Hadoop 스택. ODH에는 Apache Ambari, Apache Hadoop, Apache HBase, Apache Hive, Apache Spark 및 빅 데이터 작업 및 보안을 위한 기타 서비스가 포함됩니다.
  * **CDH (Cloudera Hadoop):** Apache Hadoop(CDH)을 포함한 Cloudera Distribution의 전체 설치를 포함하는 Hadoop 스택. CDH에는 Cloudera Manager, Apache Flume, Apache Hadoop, Apache HBase, Apache Hive, Apache Hue, Apache Kafka, Apache Pig, Apache Sentry, Apache Solr, Apache Spark 및 빅 데이터 작업 및 보안을 위한 기타 서비스가 포함됩니다. Big Data Service의 현재 버전에는 CDH 6.3.3이 포함되어 있습니다.
* ID 관리, 네트워킹, 컴퓨팅, 스토리지 및 모니터링을 포함한 Oracle Cloud Infrastructure 기능 및 리소스
* 클러스터 생성 및 관리를 위한 REST API
* bda-oss-admin 스토리지 제공자를 관리하기 위한 명령줄 인터페이스
* 기본 Oracle Cloud Infrastructure 형태를 기반으로 모든 크기의 클러스터를 생성할 수 있는 기능 (ex: 유연한 가상 환경에서 작고 수명이 짧은 클러스터, 전용 하드웨어에서 매우 큰 장기 실행 클러스터 또는 이들의 조합)
* Optional secure, high availablity (HA) 클러스터
* Oracle Cloud SQL 통합 - Oracle SQL 쿼리 언어를 사용하여 Apache Hadoop, Apache Kafka, NoSQL 및 객체 저장소 전반에서 데이터 분석
* Big Data Service 클러스터에 배포된 항목을 사용자 지정할 수 있는 전체 액세스 권한 제공

### Hadoop Ecosystem

Open Source Hadoop 은 Hadoop HDFS 및 관리를 위한 Open Source 진영의 다양한 Ecosystem 들이 있습니다. Ecosystem 을 이루고 있는 Tool 들을 역할에 맞는 솔루션을 사용함으로써 완전한 Big Data 시스템을 완성하게 됩니다.

![](/assets/img/database/2022/05/06_oci_database_releasenote_bigdata_hadoop_echosystem.png)

### OCI Big Data Cluster
OCI 에서 Managed 서비스로 제공되는 Big Data 서비스는 손쉽게 Cluster 를 One-Click 으로 생성하게 됩니다.
Big Data Cluster 생성을 수행하게 되면 노드들의 역할에 따라 Master Node, Utility Node, Master Node, Worker Node 들이 설치되고 각각의 노드에 Ambari, Hue, Jupyter Notebook, Ranger 등의 툴들이 자동 설치가 됩니다.
Worker Node 는 용량이 추가 증설이 필요할 경우, 노드를 추가하여 Scale-Out 을 원활하게 수행할 수 있게 지원합니다.

![](/assets/img/database/2022/05/06_oci_database_releasenote_bigdata_cluster_1.png)

![](/assets/img/database/2022/05/06_oci_database_releasenote_bigdata_cluster_2.png)

* OCI Bigdata Cluster Components - Cluster 를 Provisioing 하면 Hadoop Ecosystem 의 S/W 들이 BigData Cluster 생성 시에 아래의 각 역할별 노드들에 자동 구성됩니다.

![](/assets/img/dataplatform/2022/bigdata/01.oci-bigdata-cloud-service-cluster-components.PNG)

* Cluster Manager - Cluster 를 관리하기 위한 관리 툴로 Cloudera Hadoop (CDH) 일 경우 Cloudera admin 이 설치되고, Oracle Distribution Hadoop (ODH) 일 경우 Ambari 가 설치됩니다.

![](/assets/img/dataplatform/2022/bigdata/02.oci-bigdata-cloud-service-cluster-manage-admin.PNG)

* Cluster 권한 관리 - Cluster 의 권한 및 정책 관리를 위해 Ranger 가 설치됩니다.

![](/assets/img/dataplatform/2022/bigdata/03.oci-bigdata-cloud-service-cluster-policy-mgr.PNG)


* Hadoop 데이터 저장 - Hadoop File System (HDFS) 에 데이터 저장은 hadoop fs put 명령을 통해 저장합니다. 저장 시 hive 명령을 통해 Hive DB 에 데이터를 저장합니다.

![](/assets/img/dataplatform/2022/bigdata/04.oci-bigdata-cloud-service-hadoop-hive-data-load.PNG)

* Hive 데이터 조회 - Hive DB 에 저장된 Data 조회를 위해 Hue 인터페이스를 제공하며, SQL 쿼리로 데이터 조회할 수 있습니다. (Utility Node)

![](/assets/img/dataplatform/2022/bigdata/05.oci-bigdata-cloud-service-hive-hue-data-query.PNG)

* Data Lake (Object Storage) 로의 Data 저장 - Hadoop File System 의 데이터를 Data Lake 인 Object Storage 로의 Data 저장을 지원합니다.

![](/assets/img/dataplatform/2022/bigdata/06.oci-bigdata-cloud-service-data-lake-load.PNG)

* 빅데이터 소스 쿼리를 위한 Oracle SQL 지원 (Oracle Cloud SQL) - 별도의 Oracle Cloud SQL 컴퓨트 노드를 지원합니다.
  - 다양한 소스에 대한 손쉬운 쿼리 지원
      - 하나의 Oracle SQL 쿼리를 통해 여러 데이터 저장소의 정보를 상호 연관
      - HDFS, Hive, Object Stores, Kafka, NoSQL wldnjs
      - Oracle 기반의 Application 들에 대한 수정이 필요 없음
  - 단순한 관리
      - 기존 Hive 메타데이터 및 보안 사용

![](/assets/img/dataplatform/2022/bigdata/08.oci-bigdata-cloud-service-cloud-sql-0.PNG)

![](/assets/img/dataplatform/2022/bigdata/07.oci-bigdata-cloud-service-cloud-sql.PNG)

<br>

### OCI Bigdata 서비스 적용 방안

* OCI 에는 Data Lake 를 위한 다양한 서비스들을 제공합니다. 최근에는 Data Lake 를 Data Lake 와 Data Warehouse 를 합성한 Lake House 라고 칭하기도 합니다.

* 다음 그림은 OCI 기준의 Lake House 를 지원하는 서비스 구성들입니다.

![](/assets/img/dataplatform/2022/bigdata/09.oci-bigdata-cloud-lake-house.PNG)


    - Autonomouse Data Warehouse : 고성능 스토리지 및 자동화된 관리 기능을 가진 Oracle DB PaaS 서비스
    - MySQL HeatWave : MySQL 데이터베이스 서비스에 대한 분석 및 트랜잭션 쿼리를 위한 새로운 통합 고성능 인메모리 쿼리 가속기
    - Object Storage Data Lake :  다양한 데이터를 위한 저비용 스토리지
    - Managed 오픈소스 서비스 : 고객이 구현한 기존 관리형 오픈 소스 서비스 (예: Spark, Hadoop, Elasticsearch, Redis)
    - OCI Data Integration : 분석 및 데이터 Science를 위해 쉽게 ETL(추출, 변환 및 로드) 데이터를 로드, 데이터 레이크와 데이터 웨어하우스 간의 코드 없는 Data Flow 설계 
    - OCI Data Catalog : 데이터 검색을 위해 데이터 레이크와 데이터 웨어하우스 모두에서 사용하는 Data Asset Inventory를 유지 관리

* 기존의 Bigdata 및 DW 환경을 OCI의 Data Lake 서비스들을 매핑하여 아래 그림과 같이 구축하실 수 있습니다.

![](/assets/img/dataplatform/2022/bigdata/10.oci-bigdata-cloud-lake-house-example.PNG)

이러한 OCI Big Data Service는 데이터 통합, 데이터 과학 및 분석 서비스와 상호 운용되는 동시에 개발자가 Oracle SQL을 사용하여 데이터에 쉽게 액세스할 수 있도록 하기 때문에 사용하고 관리하기 쉽습니다. 


---

