---
layout: page-fullwidth
#
# Content
#
subheadline: "OCI Release Notes 2022"
title: "5월 OCI Cloud Native & Security 업데이트 소식"
teaser: "2022년 5월 OCI Cloud Native & Security 업데이트 소식입니다."
author: dankim
breadcrumb: true
categories:
  - release-notes-2022-cloudnative-security
tags:
  - oci-release-notes-2022
  - may-2022
  - cloudnative
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

## Application Dependency Management service is now available
* **Services:** Application Dependency Management
* **Release Date:** May 3, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/application-dependency-management/home.htm](https://docs.oracle.com/en-us/iaas/Content/application-dependency-management/home.htm){:target="_blank" rel="noopener"}

### 서비스 소개
2021년 11월에 Apache Log4j 2에서 발생한 취약점(CVE-2021-44228, NVD)으로 인해 관련 소프트웨어를 패치하기 위해 분주했던 것을 기억합니다. 이러한 애플리케이션의 보안 취약점을 스캔하고 자동으로 패치할 수 있는 서비스가 OCI에 추가되었습니다.  

Application Dependency Management (애플리케이션 종속성 관리, 이하 ADM)는 애플리케이션 종속성(Dependency)에서 보안 취약성을 감지하는 서비스입니다. 이 서비스는 OCI DevOps의 빌드 파이프라인에 취약성 감사 단계를 추가하여 만일 취성점이 감지되면 빌드가 실패되고, 개발자에게 취약성에 대한 경고를 전달할 수 있는 기능을 제공합니다.

주된 내용은 다음과 같습니다.
1. ADM은 소프트웨어 취약점의 특성 및 심각도를 전달하기 위한 개방형 프레임워크인 Common Vulnerability Scoring System(CVSS)에서 제공하는 점수에 의존
2. CVSS는 National Vulnerability Database (NVD)에서 소프트웨어 취약점의 심각도를 0에서 10까지의 범위로 제공하는 것으로, 현재 NVD는 CVSS v2.0과 v3.X 표준을 지원
3. ADM은 OCI DevOps 파이프라인의 "빌드" 단계에서 구성
4. 현재 pom.xml 파일을 기반으로 한 Maven 종속성을 지원
 
### DevOps 빌드 파이프라인에서 지원

OCI DevOps의 빌드 파이프라인에서 Maven 프로젝트에 대한 취약성 감사 단계를 추가할 수 있습니다. 개발자는 최소 CVSS 점수를 설정할 수 있으며, 만약 패키지에서 해당 점수를 초과하는 CVE(공개적으로 알려진 보안 결함 목록)가 파이프라인에서 감지되면 빌드 실패와 함께 개발자에게 취약성에 대해 경고하고 패치하도록 합니다.

![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-1.png)

아래는 같이 OCI DevOps 빌드 파이프라인에 Vulnerability Audit(취약점 감사) 단계를 추가할 수 있습니다.

```yml
...
- type: VulnerabilityAudit
  name: "Vulnerability Audit Step"
  configuration:
    buildType: maven
    pomFilePath: ${OCI_PRIMARY_SOURCE_DIR}/pom.xml
  packagesToIgnore:
      - org.apache.struts
    maxPermissibleCvssV2Score: 6.0
    maxPermissibleCvssV3Score: 8.1
  knowledgeBaseId: ocid1...
  vulnerabilityAuditCompartmentId: ocid1...
  vulnerabilityAuditName: sample_va
...
```

다음과 같이 개발자는 OCI DevOps의 빌드 실행 세부 정보에서 취약점 감사 결과를 확인할 수 있습니다.

![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-2.png)

### 취약점 감사
발견된 취약점으로 인해 DevOps 빌드 파이프라인이 실패하는 경우 개발자는 취약점 감사 결과를 보고 관련 CVE와 함께 전체 종속성 트리를 볼 수 있습니다. 개발자는 CVE 점수를 검사하여 문제를 이해한 다음 취약성을 포함하지 않는 버전에 대한 일부 종속성을 패치하는 등 필요한 변경을 수행할 수 있습니다.

![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-3.png)

### 참고
* https://blogs.oracle.com/cloud-infrastructure/post/security-scanning-for-maven-now-available-in-oci-devops

--- 

## Accelerate function start-ups using provisioned concurrency
* **Services:** Functions
* **Release Date:** May 4, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/Functions/Tasks/functionsusingprovisionedconcurrency.htm](https://docs.oracle.com/en-us/iaas/Content/Functions/Tasks/functionsusingprovisionedconcurrency.htm){:target="_blank" rel="noopener"}

### 서비스 소개
Function이 처음 호출될 때(**Cold Start** 라고 부름) Function 실행에 필요한 인프라를 프로비저닝합니다. 보통 Function을 성공적으로 호출하기 위한 기본 Compute와 Network 관련 리소스가 준비되는데, 이러한 이유로 처음 호출될 때 최소 몇 초 이상의 시간이 소요됩니다. 한번 호출된 후에는 이 후 호출부터 (**Hot or Warm Start** 라고 부름)는 이미 준비된 인프라 환경에서 호출이 되기 때문에 Cold Start 보다 월등히 빠르게 응답합니다. **Hot Start** 환경이 되더라도, 일정시간 Function이 사용되지 않으면 다시 관련 인프라 리소스가 정리되고, 이 후 다시 호출될 때 이전과 마찬가지로 **Cold Start**가 됩니다.

이번에 추가된 기능은 이러한 초기 프로비저닝과 관련된 지연 시간을 최소화하고 처음부터 **Hot Start**를 보장하기 위한 기능으로 **프로비저닝된 동시성(provisioned concurrency)** 기능을 활성화 하여 적용할 수 있습니다.


### 적용 방법
프로비저닝된 동시성(provisioned concurrency)을 사용하기 위해서는 Function에 PCU (provisioned concurrency units)을 지정해야 합니다. PCU는 함수 OCICLI를 활용하여 Function을 생성하거나 업데이트 하는 시점에 다음과 같이 정하여 정의할 수 있습니다. 

```terminal
$ oci fn function create --application-id ocid1.fnapp.oc1.phx.aaaaaaaaaf______r3ca --display-name helloworld-func --image phx.ocir.io/ansh81vru1zp/helloworld/helloworld-func:0.0.1 --memory-in-mbs 128 --provisioned-concurrency "{\"strategy\": \"CONSTANT\", \"count\": 40}"
```

* **strategy:** 프로비저닝된 동시성(provisioned concurrency) 사용여부 나타내는 것으로 **CONSTANT(지정), NONE(미지정)** 중 하나를 입력합니다.
* **count:** 함수가 동시에 얼마나 호출되는지에 대한 수를 입력합니다.

### 가격
프로비저닝된 동시성(provisioned concurrency)기능을 활성화 하는 경우 대기중에도 일정 자원을 보유 및 유지를 위한 비용이 추가되는데, 추가되는 비용은 사용되지 않을때도 기본 Function 실행 시간의 25%가 추가됩니다. 예를 들면, 하나의 Function을 100분동안 호출했고, 100분동안 Idle 상태였다면, 총 비용은 125분 동안 사용 비용이 청구됩니다.

--- 

## OCI Search Service with OpenSearch is now available
* **Services:** Oracle Cloud Infrastructure, Search Service with OpenSearch
* **Release Date:** May 10, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/search-opensearch/home.htm](https://docs.oracle.com/en-us/iaas/Content/search-opensearch/home.htm){:target="_blank" rel="noopener"}

### 서비스 소개
인애플리케이션 검색 솔루션을 구축하는 데 사용할 수 있는 [OpenSearch](https://opensearch.org)를 기반으로 한 관리형 서비스로 대규모 데이터 세트를 검색하고 밀리초 내에 결과를 반환할 수 있도록 지원하는 서비스입니다. 

### 주요 내용
* OpenSearch 및 OpenDashboard는 2021년 Elasticsearch 및 Kibana(7.10.2)에서 분기
* OCI Serach Service는 OpenSearch 관리형 서비스로 패치, 업데이트, 업그레이드, 백업 및 스케일링을 포함한 일반적인 유지 관리 유지관리 활동을 다운타임 없이 지원
* Flex Shape을 기반으로 운영되기 때문에 처음에는 요구사항에 맞는 CPU, 메모리 및 스토리지 수를 지정하며, 확장이 필요한 경우 가동 중지 시간 없이 수평 또는 수직으로 즉시 크기를 조정
* 현재 포스팅하는 시점에서 아직 OCI SDK 및 CLI는 미지원

### 기본 개념
* **Cluster:** OpenSearch 기능을 제공하는 Compute Instance를 담고 있으며, 각 Compute Instance는 클러스터의 노드가 됩니다. 각 클러스터는 하나 이상의 데이터 노드, 마스터 노드 및 OpenSearch 대시보드 노드로 구성됩니다.
* **Data Node:** OpenSearch를 위한 데이터를 저장하고 데이터 검색, 관리 및 집계와 관련된 작업을 처리합니다. 클러스터의 데이터 노드를 구성할 때 노드당 필요한 최소 메모리는 8GB입니다.
* **Master Node:** 클러스터 작업을 관리하고 노드 상태를 모니터링하며 클러스터에 대한 네트워크 트래픽을 라우팅하며, 인덱스 생성 또는 삭제, 노드 추적, 어떤 노드에 어떤 샤드를 할당할지 결정하는 것과 같은 클러스터 전반의 작업을 담당합니다. 최소 마스터 노드의 매모리는 16GB입니다.
* **OpenSearch Dashboard Node:** 클러스터의 OpenSearch 대시보드를 관리하고 액세스를 제공합니다. 클러스터의 OpenSearch 대시보드를 구성할 때 노드당 필요한 최소 메모리는 8GB입니다.
* **OpenSearch Dashboards:** OpenSearch 데이터를 위한 시각화 도구이며 일부 OpenSearch 플러그인의 사용자 인터페이스로도 사용할 수 있습니다. 실시간 데이터로 대화형 데이터 대시보드를 만들 수 있습니다.

### 참고
* [OCI Search Service를 간단히 따라서 해볼 수 있는 자료](https://docs.oracle.com/en/learn/oci-opensearch/index.html#introduction)
* [TheKoguryo님 블로그: OCI Search 서비스를 사용한 로그 모니터링 (특히 OKE에서 OpenSearch로 로그를 보내는 방법에 대해서 아주 잘 정리되어 있습니다.)](https://thekoguryo.github.io/oracle-cloudnative/oci-services/logging/2.oci-opensearch/)

--- 

## New features for DevOps
* **Services:** DevOps
* **Release Date:** May 17, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/devops/using/create_connection.htm](https://docs.oracle.com/en-us/iaas/Content/devops/using/create_connection.htm){:target="_blank" rel="noopener"}, [https://docs.oracle.com/en-us/iaas/Content/devops/using/add-helmchart.htm](https://docs.oracle.com/en-us/iaas/Content/devops/using/add-helmchart.htm){:target="_blank" rel="noopener"}, [https://docs.oracle.com/en-us/iaas/Content/devops/using/scan-code.htm](https://docs.oracle.com/en-us/iaas/Content/devops/using/scan-code.htm){:target="_blank" rel="noopener"}

### 기능 소개
OCI DevOps 서비스에 다음 3개의 기능이 신규 추가되었습니다.

#### Bitbucket Cloud support
**Bitbucket Cloud**는 Atlassian에서 서비스하는 소유한 Git 기반 소스 코드 저장소 호스팅 서비스 입니다. DevOps의 외부 저장소로 기존 **GitHub, GitLab**에 이어 **Bitbucket Cloud**도 외부 저장소로 연결할 수 있도록 지원합니다.

![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-4.png)


#### Helm Chart support
Helm은 Chart라고 불리는 패키징 포멧을 사용하여 쿠버네티스 리소스를 정의한 파일들(쿠버네티스 YAML manifest와 values.yaml 파일 포함)을 묶을 수 있습니다. 일종의 쿠버네티스를 위한 소프트웨어 패키지라고 볼 수 있습니다. 

이번에 DevOps 서비스에서 OKE에 Helm Chart를 배포할 수 있는 기능이 추가되었습니다. 아래는 Helm Chart를 추가하기 위한 기본 필요 사항입니다.

* 모든 차트는 기본적으로 [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html)형식을 따르는 버전이 있어야 합니다.
  * Example: nginx 1.2.1
* Helm Chart를 배포 파이프라인에서 사용하기 전에 미리 OCI Container 레지스트리에 위치해 있어야 합니다.
* Helm 차트가 포함된 저장소 위치를 가리키도록 Artifact 참조를 생성해야 합니다.
  ![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-5.png)

DevOps 배포 파이프라인에서 **Kubernetes 클러스터에 Helm 차트 설치(Install Helm chart to Kubernetes cluster)** 스테이지를 선택하여 OKE 클러스터에 Helm Chart 배치를 자동화 할 수 있습니다. 
![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-6.png)

#### DevOps provides vulnerability audit
DevOps 빌드 파이프라인에서 Maven 프로젝트에서 사용하는 패키지의 취약점을 감지하는 기능이 포함되었습니다. 이 기능은 **Oracle Application Dependency Management (ADM)**의 취약점 지식 기반을 활용합니다. 자세한 내용은 **Application Dependency Management service is now available** 부분을 참고합니다.

## Support for Kubernetes version 1.23.4
* **Services:** Container Engine for Kubernetes
* **Release Date:** May 18, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/82948243-0363-414d-ad28-72a7653a4f24/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/82948243-0363-414d-ad28-72a7653a4f24/){:target="_blank" rel="noopener"}

### 업데이트 내용
이제 버전 1.22.5 및 1.21.5 외에도 Kubernetes 버전 1.23.4를 지원합니다. 관련하여 유의할 사항은 다음과 같습니다.

* Kubernetes 버전 1.23.4에 대한 지원이 가능해짐에 따라 Kubernetes용 Container Engine은 2022년 7월 19일에 Kubernetes 버전 1.20.11에 대한 지원을 중단합니다. 결과적으로 더 이상 다음을 수행할 수 없습니다.
  * Kubernetes 버전 1.20.11을 위한 새로운 클러스터를 생성할 수 없습니다.
  * Kubernetes 버전 1.20.11을 실행하는 기존 클러스터에 새 노드 풀을 추가할 수 없습니다.

---

## Usage plans to manage subscriber access to APIs
* **Services:** API Gateway
* **Release Date:** May 25, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/APIGateway/Tasks/apigatewaydefiningusageplans.htm](https://docs.oracle.com/en-us/iaas/Content/APIGateway/Tasks/apigatewaydefiningusageplans.htm){:target="_blank" rel="noopener"}

### 기능 소개
API Gateway를 생성하고 하나 이상의 Public API를 배포하여 운영하는 경우 관리자는 이와 관련하여 다음과 같은 기능이 필요할 수 있습니다.

* API에 액세스하는 API 소비자 및 API 클라이언트에 대한 모니터링 및 관리
* API를 소비하는 고객 별로 다른 액세스 계층을 설정하여 적용 
  * 예시) GOLD 계층은 시간당 최대 1000개 요청을 수용, SILVER 계층은 최대 500개 요청 허용, BRONZE 계층은 최대 100개 허용, 모든 계층은 모두 초당 10개 요청으로 제한.

API Management에서 사용 계획 (Usage Plans) 생성
![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-7.png)

**사용 계획**을 생성할 때 API 게이트웨이를 지정할 수 있으며, API Management에서 생성한 **구독자**별로 사용 계획을 적용할 수 있습니다.

**사용 계획**을 생성할 때 API 게이트웨이를 지정
![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-8.png)

API Management에서 생성한 **구독자**별로 계획 지정
![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-05-9.png)

---

## Support for CSI metrics
* **Services:** Container Engine for Kubernetes
* **Release Date:** May 26, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm#Provisioning_Persistent_Volume_Claims_on_the_Block_Volume_Service](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm#Provisioning_Persistent_Volume_Claims_on_the_Block_Volume_Service){:target="_blank" rel="noopener"}

### 기능 소개
OKE에서는 CSI(Container Storage Interface) 볼륨 플러그인을 사용하여 OKE에서 생성한 클러스터에 Block Volume을 연결하여 Persistent Volume Claim (PVC)를 프로비저닝 할 수 있는 기능을 제공하고 있습니다. 이제 CSI 볼륨 플러그인을 사용하여 PVC를 생성하면 Prometheus (메트릭 모니터링 도구)를 사용하여 다음과 같은 CSI 용량 통계를 볼 수 있습니다.

* kubelet_volume_stats_capacity_bytes
  * PVC 별 전체 용량 (바이트)
* kubelet_volume_stats_available_bytes
  * PVC 별 사용 가능한 용량 (바이트)
* kubelet_volume_stats_used_bytes
  * PVC 별 사용된 용량 (바이트)
* kubelet_volume_stats_inodes
  * 볼륨의 최대 inode 수
* kubelet_volume_stats_inodes_free
  * 볼륨에서 사용 가능한 inode 수
* kubelet_volume_stats_inodes_used
  * 볼륨에서 사용되는 inode 수

> Unix/Linux 파일시스템 상에서, 각 화일에 대한 정보(소유,허가,위치,크기,시기,종류 등)를 갖고 있는, 약 120 바이트의 고정 크기의 구조체(Structure)로써, 외부적으로는 번호로 표현됨. <cite>Source: http://www.ktword.co.kr/test/view/view.php?nav=2&no=1701&sh=inode (정보통신기술용어해설)</cite>