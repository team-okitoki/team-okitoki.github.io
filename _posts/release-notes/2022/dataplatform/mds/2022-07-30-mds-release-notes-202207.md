---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "7월 OCI MDS (MySQL Database Service) 업데이트 소식"
teaser: "2022년 7월 OCI MDS (MySQL Database Service) 업데이트 소식입니다."
author: kskim
breadcrumb: true
categories:
  - release-notes-2022-mds
tags:
  - oci-release-notes-2022
  - Jul-2022
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

## MySQL Database Service Support for MySQL Version 8.0.30
* **Services:** MySQL Database
* **Release Date:** July 27, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/4798f5c1-942f-43c3-a17b-e7bc83c2f2e9/](https://docs.oracle.com/iaas/releasenotes/changes/4798f5c1-942f-43c3-a17b-e7bc83c2f2e9/){:target="_blank" rel="noopener"}

### 기능 소개

OCI의 MDS의 경우, MySQL사이트에서 제공되는 업데이트와 동일한 버전으로 업그레이드가 가능합니다. 
이는 OCI MySQL팀과 MySQL팀과 동일한 팀이며, OCI는 엔터프라이즈를 제공합니다.

## MySQL Database Service: Point in Time Restore (PITR)
* **Services:**    MySQL Database
* **Release Date:** July 14, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/02970ec0-abe1-4fcd-a7c7-49808bd2e09d/](https://docs.oracle.com/iaas/releasenotes/changes/02970ec0-abe1-4fcd-a7c7-49808bd2e09d/){:target="_blank" rel="noopener"}

### 기능 소개
이제 시점 복원(PITR) 기능을 사용하여 독립 실행형 MySQL DB 시스템을 특정 시점으로 복원할 수 있습니다.
PITR을 활성화하면 MySQL 바이너리 로그가 DB 시스템 호스트 외부에 안전하게 보관되어 약 5분의 RPO(복구 시점 목표)를 달성할 수 있습니다.
데이터베이스 작업에 영향을 주지 않고 온라인으로 신규 또는 기존 DB 시스템에서 PITR을 활성화할 수 있습니다.