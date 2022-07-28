---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "7월 OCI Database 업데이트 소식"
teaser: "2022년 7월 OCI Database 업데이트 소식입니다."
author: lim
breadcrumb: true
categories:
  - release-notes-2022-database
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

### Media Flow Concepts
* Media Flow : 미디어 콘텐츠를 처리하기 위한 사용자 정의 워크플로입니다. 미디어 워크플로에는 수행할 처리 작업을 정의하는 여러 미디어 워크플로 작업이 포함됩니다.
* System Workflow : 사용할 수 있는 미리 정의된 미디어 워크플로.
미디어 워크플로 작업: 유형에 따라 워크플로의 특정 지점에서 수행할 처리를 정의합니다.
* Media Flow Job : 작업은 워크플로를 통해 콘텐츠를 실행하는 데 사용됩니다. 여러 미디어 워크플로를 정의하고 워크플로를 사용하여 여러 작업을 만들 수 있습니다.

![](/assets/img/database/2022/07/02_medserv_screenshot_0.png)

![](/assets/img/database/2022/07/02_medserv_screenshot.png)

---

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

---
