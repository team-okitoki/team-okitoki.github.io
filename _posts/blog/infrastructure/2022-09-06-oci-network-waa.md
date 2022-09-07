---
youtubeId: fyqT6GqbZRQ
youtubeId2: wbUBIApC8Mo

layout: page-fullwidth
#
# Content
#
subheadline: "Networking"
title: "Web Application Acceleration (WAA) 사용하여 응답속도 향상"
author: "ks.kim"
breadcrumb: true
categories:
  - network 
tags:
  - [oci, netwwork, waa]
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


### 1.Web Application Acceleration (WAA) 란?
웹사이트 속도 향상을 위해서 다양한 기능이이 존재한다. CDN , 이미지 최적화, gzip 압축 , 빠른 DNS 서버가 있으며, 이중 OCI에서 WAA라고 하는 LB에 연결하여 사용 할 수 있는 Web Application Acceleration 을 사용하고 한다. 
2022년 06월에 릴리스된 Web Application Acceleration (WAA)은 정적 사이트 용 기능으로 로드 밸런스에 연결하기만 하면 됩니다. 또한 기능으로는 HTTP 응답 캐시/압축되고 응답의 고속화를 실현 할 수 있는 서비스 입니다. 

> WAA는 무료!!!!

### 2.Web Application Acceleration (WAA) 구성방법
> WAA 구성을 위해서는 LB가 기본적으로 구성되어 있어야 합니다.

- WAA 생성하기 위해 Networking -> Web Application Accelerations 클릭
![접근하기](/assets/img/infrastructure/WAA/SCR-20220906-kzu.png)
- 아래 접근해서 새로운 WAA 생성하기
![접근하기](/assets/img/infrastructure/WAA/SCR-20220906-l21.png)
- WAA 생성시, Caching 및 Compression 옵션을 선택 후 미리 생성된 LB에 연결 할 수 있도록 합니다.
![접근하기](/assets/img/infrastructure/WAA/SCR-20220906-l5g.png)
- 생성된 WAA를 클릭하면 세부정보를 확인이 가능하다.
![접근하기](/assets/img/infrastructure/WAA/SCR-20220906-l8z.png)


### 3.테스트하기 (추후 업데이트 예정)








