---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "6월 OCI Database 업데이트 소식"
teaser: "2022년 6월 OCI Database 업데이트 소식입니다."
author: lim
breadcrumb: true
categories:
  - release-notes-2022-database
tags:
  - oci-release-notes-2022
  - June-2022
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

## Flexible Compute Shapes are now Available with Data Flow
* **Services:** Data Flow
* **Release Date:** June 1, 2022
* **Documentation:** 
[https://docs.oracle.com/en-us/iaas/data-flow/using/home.htm](https://docs.oracle.com/en-us/iaas/data-flow/using/home.htm){:target="_blank" rel="noopener"}


### 서비스 소개
Oracle Cloud Infrastructure Data Flow는 Apache Spark ™ 애플리케이션을 실행하기 위한 완전 관리형 서비스입니다. 개발자가 애플리케이션에 집중할 수 있도록 하고 이를 실행할 수 있는 쉬운 런타임 환경을 제공합니다. 애플리케이션 및 워크플로와의 통합을 위한 API 지원을 통해 쉽고 간단한 사용자 인터페이스를 제공합니다. 

![](/assets/img/database/2022/06/01_Data_Flow_Service_overview_1.png)

Data Flow 는 Serverless 기반으로 작성된 Application 을 Spark Job 으로 생성하여 Job을 수행할 수가 있습니다. 아래 그림은 Spark Job 을 Serverless 로 수행하기 위한 절차입니다.

![](/assets/img/database/2022/06/02_Data_Flow_Service_overview_2.png)

Job 이 수행되고 난 후에는 Job 실행 결과를 확인하고 Log 를 분석하여 처리 결과를 확인하게 됩니다.

![](/assets/img/database/2022/06/03_Data_Flow_Service_overview_3.png)

### 신규 기능
다음의 Flexible Compute Shape 들을 지원하게 되었습니다.
* VM.Standard3.Flex (Intel)
* VM.StandardE3.Flex (AMD)
* VM.StandardE4.Flex (AMD)

---
