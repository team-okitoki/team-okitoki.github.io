---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "8월 OCI MDS (MySQL Database Service) 업데이트 소식"
teaser: "2022년 8월 OCI MDS (MySQL Database Service) 업데이트 소식입니다."
author: kskim
breadcrumb: true
categories:
  - release-notes-2022-mds
tags:
  - oci-release-notes-2022
  - Aug-2022
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

## MySQL HeatWave: Auto reload of data in HeatWave cluster after MySQL upgrade
* **Services:** MySQL Database
* **Release Date:** Aug 2, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/db33019e-d94b-42ea-a8ef-f868fc7ab93a/](https://docs.oracle.com/iaas/releasenotes/changes/db33019e-d94b-42ea-a8ef-f868fc7ab93a/){:target="_blank" rel="noopener"}

### 기능 소개
HeatWave는 이제 유지 관리 업그레이드 또는 계획된 다시 시작으로 인해 MySQL 노드가 다시 시작된 후 MySQL InnoDB에서 데이터를 자동으로 다시 로드합니다. 자동 재장전 기능을 사용하면 유지 관리 또는 작업을 다시 시작한 후 더 이상 수동 단계를 수행할 필요가 없습니다. 이는 운영 오버헤드를 줄이고 서비스 가용성을 향상시킵니다.



## MySQL AutoPilot: Auto Error Recovery from MySQL failure
* **Services:** MySQL Database
* **Release Date:** Aug 2, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/2f1effb8-da40-4886-8d47-9b37b8026680/](https://docs.oracle.com/iaas/releasenotes/changes/2f1effb8-da40-4886-8d47-9b37b8026680/){:target="_blank" rel="noopener"}

### 기능 소개
자동 오류 복구를 사용하면 이제 MySQL이 실패하고 다시 시작될 때 HeatWave 클러스터가 자동으로 다시 시작되고 오류가 발생하기 전에 로드된 테이블을 식별하고 MySQL에서 해당 테이블을 자동으로 다시 로드합니다. 이것은 사용자의 개입을 줄이고 서비스 가동 시간을 향상시킵니다.

## MySQL Database Service: Easier to scale up or down
* **Services:**  MySQL Database
* **Release Date:** Aug 25, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/187cc858-5a61-4974-b7e0-ed8befa6dc5c/](https://docs.oracle.com/iaas/releasenotes/changes/187cc858-5a61-4974-b7e0-ed8befa6dc5c/){:target="_blank" rel="noopener"}

### 기능 소개

이제 MySQL 데이터베이스 서비스를 통해 독립 실행형 DB 시스템 형태를 변경할 수 있으므로 워크로드 요구 사항에 따라 용량을 더 쉽게 확장하거나 축소할 수 있습니다.