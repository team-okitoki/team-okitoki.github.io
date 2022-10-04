---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "7월 OCI Infrastructure 업데이트 소식"
teaser: "2022년 7월 OCI Infrastructure 업데이트 소식입니다."
author: kskim
breadcrumb: true
categories:
  - release-notes-2022-infrastructure
tags:
  - oci-release-notes-2022
  - July-2022
  - Infrastructure

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




## CloudShell now offers GraalVM Enterprise JDK 17 and Native Image
* **Services:** Cloud Shell
* **Release Date:** July 26, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/58ab4d12-028b-41c4-b875-4989833cf4cc/](https://docs.oracle.com/iaas/releasenotes/changes/58ab4d12-028b-41c4-b875-4989833cf4cc/){:target="_blank" rel="noopener"}

### 기능 소개
Cloud Shell은 OCI Console(OCI 관리 콘솔)에서 실행되는 브라우저 기반 터미널입니다. OCI Cloud Shell은 GCP의 Google Cloud Shell, Azure의 Cloud Shell 및 AWS의 Session Manager와 같은 서비스입니다. OCI Cloud Shell를 이용하면 PuTTY를 사용하지 않고 OCI VM 인스턴스에 접속하거나 별도의 소프트웨어와 계정 설정 작업 없이 즉시 OCI CLI와 같은 툴을 사용할 수 있습니다.
- GraalVM의 java 17 버전 및 네이티브 이미지를 지원합니다.

![](/assets/img/infrastructure/2022/08/SCR-20221003-id3.png)

## OCI Network Firewall Service is now availabile
* **Services:**  Network Firewall, Oracle Cloud Infrastructure
* **Release Date:** July 21, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/47aff695-ff50-4f77-bafd-b25a3ab4c90f/](https://docs.oracle.com/iaas/releasenotes/changes/47aff695-ff50-4f77-bafd-b25a3ab4c90f/){:target="_blank" rel="noopener"}

### 기능 소개
OCI 네트워크 방화벽은 팔로알토 네트웍스의 차세대 방화벽 기술(NGFW)을 사용하여 구축된 클라우드 네이티브 관리형 방화벽 서비스입니다. 기계 학습 기반 방화벽 기능을 제공하여 OCI 워크로드를 보호하고 OCI에서 쉽게 사용할 수 있습니다. OCI 기본 서비스로서의 방화벽 제품인 OCI 네트워크 방화벽을 사용하면 추가 보안 인프라를 구성 및 관리할 필요 없이 방화벽 기능을 활용할 수 있습니다.

![](/assets/img/infrastructure/2022/08/Medium.jpg)

## New features added to Network Visualizer
* **Services:**  Networking
* **Release Date:** July 19, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/47dcb6c4-9b30-4112-b162-f67013396a68/](https://docs.oracle.com/iaas/releasenotes/changes/47dcb6c4-9b30-4112-b162-f67013396a68/){:target="_blank" rel="noopener"}

### 기능 소개
Network Visualizer를 사용하여 토폴로지 맵과 관련 리소스 정보가 포함된 PDF를 내보낼 수 있습니다. 이제 탑재 대상 및 Kubernetes 클러스터를 포함하여 더 많은 유형의 리소스를 볼 수도 있습니다.

![](/assets/img/infrastructure/2022/08/SCR-20221003-ikb.png)



## Extend the reboot migration deadline for Compute VM instances scheduled for infrastructure maintenance
* **Services:**  Compute
* **Release Date:** July 19, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/ca548f96-2419-4934-a1fa-4b58d17d9a64/](https://docs.oracle.com/iaas/releasenotes/changes/ca548f96-2419-4934-a1fa-4b58d17d9a64/){:target="_blank" rel="noopener"}

### 기능 소개

인프라 유지 보수를 위해 예약된 컴퓨팅 VM 인스턴스에 대한 재부팅 마이그레이션 마감 시간 연장이 가능합니다. 

## Advanced BIOS settings for bare metal compute instances
* **Services:**  Compute
* **Release Date:** July 18, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/f038c65b-764c-4859-8ada-c4c9270662ac/](https://docs.oracle.com/iaas/releasenotes/changes/f038c65b-764c-4859-8ada-c4c9270662ac/){:target="_blank" rel="noopener"}

### 기능 소개

베어메탈 컴퓨팅 인스턴스를 생성할 때 이제 성능을 최적화하고 라이선스 비용을 절감할 수 있는 고급 BIOS 설정을 구성할 수 있습니다. 다음 옵션을 사용할 수 있습니다.

- 코어 비활성화
- NUMA 설정 사용자 지정
- 동시 멀티스레딩 비활성화
- 액세스 제어 서비스 활성화 또는 비활성화
- 가상화 지침 활성화 또는 비활성화
- IOMMU(입출력 메모리 관리 장치) 활성화 또는 비활성화

![](/assets/img/infrastructure/2022/08/SCR-20221003-ixi.png)


## Cloud Guard adds Log Insight Detector
* **Services:**   Cloud Guard, Oracle Cloud Infrastructure
* **Release Date:** July 15, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/83af2734-ee0a-4408-9801-58303c21b713/](https://docs.oracle.com/iaas/releasenotes/changes/83af2734-ee0a-4408-9801-58303c21b713/){:target="_blank" rel="noopener"}

### 기능 소개

Cloud Guard는 사용자가 Cloud Guard 기능을 로그 개체로 확장할 수 있는 두 가지 새로운 구성 요소를 추가했습니다.

데이터 소스  를 통해 Cloud Guard는 탐지를 유도하는 데 사용할 수 있는 새로운 정보 소스를 정의할 수 있습니다. 데이터 소스 설정 을 참고하십시오 .
Log Insight Detector 는 이러한 특수 데이터 소스에 대한 데이터 소스 쿼리를 사용하여 모니터링되는 로그 개체에 대한 문제를 식별한 다음 Cloud Guard 문제 페이지에서 문제를 표시합니다.



## Process Automation is now available
* **Services:**    Oracle Cloud Infrastructure, Process Automation
* **Release Date:** July 13, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/dd3ff004-262a-4548-8eb7-9be0ffaab84a/](https://docs.oracle.com/iaas/releasenotes/changes/dd3ff004-262a-4548-8eb7-9be0ffaab84a/){:target="_blank" rel="noopener"}

### 기능 소개

Oracle Cloud Infrastructure Process Automation REST API를 사용하여 비즈니스 프로세스를 자동화하고 관리가 가능합니다.
- 구조적 및 동적 프로세스 모델링
- 의사결정 모델링
- 외부 앱 및 통합에 대한 연결
- 웹 양식
- 사용자 작업 관리 및 추적

* **링크:** [https://docs.oracle.com/en/cloud/paas/process-automation/user-process-automation/index.html](https://docs.oracle.com/en/cloud/paas/process-automation/user-process-automation/index.html){:target="_blank" rel="noopener"}
