---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "6월 OCI MDS (MySQL Database Service) 업데이트 소식"
teaser: "2022년 6월 OCI MDS (MySQL Database Service) 업데이트 소식입니다."
author: kskim
breadcrumb: true
categories:
  - release-notes-2022-mds
tags:
  - oci-release-notes-2022
  - June-2022
  - MDS

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

## MySQL Database Service: Compare Configurations
* **Services:**  MySQL Database
* **Release Date:** June 1, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/5a92085b-19a2-4166-b558-bec8081b9f80/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/5a92085b-19a2-4166-b558-bec8081b9f80/){:target="_blank" rel="noopener"}

### 기능 소개
이제 MYSQL 데이터베이스 서비스 콘솔을 사용하여 두 구성의 모양, 초기화 변수 및 사용자 변수를 비교할 수 있습니다. MySQL 로 이동하여 구성 을 클릭 하고 비교하려는 두 구성 을 선택하고 작업 버튼을 클릭한 다음  비교 를 클릭 합니다 (변수값 및 shape의 비교 등)

![](/assets/img/infrastructure/2022/06/compareconfigurations01.png)


![](/assets/img/infrastructure/2022/06/compareconfigurations02.png)

---

## MySQL Database Service: Reduced downtime while changing configurations
* **Services:**  MySQL Database
* **Release Date:** June 1, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/5a92085b-19a2-4166-b558-bec8081b9f80/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/5a92085b-19a2-4166-b558-bec8081b9f80/){:target="_blank" rel="noopener"}

### 기능 소개
MySQL 구성 변경할 때 가동 중지 시간이 줄어 듭니다. MySQL 데이터베이스 서비스는 다시 시작해야하는 변수와 아닌 변수를 자동으로 구분하여 현재 변경이 가능한 부분은 업데이트 되고 재부팅으로 변경이 가능한 부분은 데이터베이스가 다시 시작되는 경우 적용되게 됩니다.


---

## Support for MySQL Database
* **Services:** tools
* **Release Date:** June 14, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/41b4139c-0558-49e7-9e6d-31ee3d4ca241/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/41b4139c-0558-49e7-9e6d-31ee3d4ca241/){:target="_blank" rel="noopener"}

### 기능 소개
OCI 내 데이터베이스 툴을 사용하여, MySQL 접속이 가능합니다. 

![](/assets/img/infrastructure/2022/06/supportformysqldatabse01.png)

---


## Introducing HeatWave Real-Time Resizing
* **Services:** MySQL Databse
* **Release Date:** June 15, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/afd1d4a5-a497-4b06-8969-c635f6a93f19/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/afd1d4a5-a497-4b06-8969-c635f6a93f19/){:target="_blank" rel="noopener"}

### 기능 소개
HeatWave의 리사징을 다운타임 없이 조정이 가능합니다. 

- 가동 중지 및 서비스 중단 없이 실시간으로 HeatWave 클러스터의 노드 크기를 조정(증가 또는 감소)할 수 있습니다.
- HeatWave 클러스터의 노드 크기를 조정하면 다음과 같은 이점이 있습니다.
  - 사용 가능: 크기 조정 중 다운타임 및 서비스 중단이 없으며 DB 시스템에서 계속 쿼리를 실행할 수 있습니다.
  - 유연성: 데이터 크기에 따라 HeatWave 클러스터 노드를 1에서 64 사이의 숫자로 늘리거나 줄일 수 있습니다. 또한 선택한 모양과 데이터 크기에 따라 필요한 노드 수를 예측할 수 있습니다
  - 균형 조정: 크기 조정이 완료된 후 데이터는 클러스터의 모든 노드에서 균형을 이루고 모든 새 쿼리는 새 클러스터 크기에서 실행됩니다

---

## MySQL HeatWave eliminates the minimum cluster size requirement
* **Services:** MySQL Databse
* **Release Date:** June 21, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/7e66c3d4-13f7-4e1e-8e47-20bc29faa14a/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/7e66c3d4-13f7-4e1e-8e47-20bc29faa14a/){:target="_blank" rel="noopener"}

### 기능 소개
MySQL HeatWave는 최소 클러스터 크기 요구 사항을 제거했습니다. 이것은 HeatWave 클러스터의 진입 비용을 줄입니다. 이제 최소 비용으로 소규모 워크로드에 HeatWave를 사용할 수 있습니다.