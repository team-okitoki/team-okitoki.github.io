---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "10월 OCI Infrastructure 업데이트 소식"
teaser: "2022년 10월 OCI Infrastructure 업데이트 소식입니다."
author: ks.kim
breadcrumb: true
categories:
  - release-notes-2022-infrastructure
tags:
  - oci-release-notes-2022
  - Oct-2022
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

## Full Stack Disaster Recovery is now available
* **Services:** Full Stack Disaster Recovery, Oracle Cloud Infrastructure
* **Release Date:** Oct. 25, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/ec2eaf1e-e2f8-4e62-95fb-348e0cf7fa86/](https://docs.oracle.com/iaas/releasenotes/changes/ec2eaf1e-e2f8-4e62-95fb-348e0cf7fa86/){:target="_blank" rel="noopener"}

### 기능 소개
한 번의 클릭으로 전체 애플리케이션 스택에 대한 포괄적인 재해 복구 관리를 제공하는 OCI를 위한 최초의 진정한 DRaaS(Disaster Recovery-as-a-Service) 솔루션입니다.
- 사용 가능한 리전은 아래와 같습니다. 
1. Amsterdam
2. Ashburn
3. Frankfurt
4. London
5. Phoenix

-
- 다음 OCI 리소스 유형에 대한 재해 복구를 지원합니다.
1. 컴퓨팅 인스턴스
2. 부트 및 블록 볼륨(볼륨 그룹)
3. Oracle Exadata 데이터베이스 서비스 
4. 오라클 엔터프라이즈 데이터베이스 서비스 
5. Shared Exadata 인프라의 Oracle Autonomous Database



![](/assets/img/infrastructure/2022/10/SCR-20221124-evi.png)

## X9-based (Intel) and E4-based (AMD) GPU shapes for Compute instances
* **Services:** Compute
* **Release Date:** Oct. 27, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/e6a5078c-bc69-45be-8553-eef9d1ddc5a2/](https://docs.oracle.com/iaas/releasenotes/changes/e6a5078c-bc69-45be-8553-eef9d1ddc5a2/){:target="_blank" rel="noopener"}

### 기능 소개
베어 메탈 인스턴스에 두 가지 새로운 GPU 형태를 사용할 수 있습니다.
1. BM.GPU.GU1: X9-based GPU compute.
2. BM.GPU.GM4: E4-based GPU compute.
- 두 형태 모두 로컬로 연결된 NVMe 기반 SSD 스토리지를 포함합니다.  BM.GPU.GM4.8 모양은 클러스터 네트워크를 지원합니다.

