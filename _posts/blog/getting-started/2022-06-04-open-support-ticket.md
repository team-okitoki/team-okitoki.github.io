---
layout: page-fullwidth
#
# Content
#
subheadline: "Support"
title: "OCI 지원 요청(SR)을 위해 지원 티켓을 오픈하여 지원받는 방법"
teaser: "OCI를 유료로 구독하는 경우 OCI를 사용하면서 생길 수 있는 여러가지 이슈에 대한 지원을 받을 수 있습니다. 이번 포스팅을 통해서 OCI에서 지원 티켓을 생성하여 지원받는 방법에 대해서 설명합니다."
author: dankim
date: 2022-06-04 00:00:02
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, support]
#published: false

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

### OCI 지원 센터 (Support Center)
OCI 지원 센터에서는 OCI를 사용하면서 생길 수 있는 여러 이슈(기술, 빌링, 리소스 요청등)에 대한 요청을 할 수 있는 공간입니다.

> 지원 센터에서 SR 티켓을 생성하기 위해서는 Free Tier 계정을 유료 (Paid) 계정으로 업그레이드를 하여야 합니다.

지원 센터는 메뉴에서 **거버넌스 & 관리 > 지원 센터**를 클릭하거나
![](/assets/img/getting-started/2022/open-support-ticket-1.png " ")

오른쪽 상단의 **Help** 아이콘을 클릭한 후 **지원 센터 방문**을 클릭하면 이동합니다. 지원 센터에 들어가서 **지원 요청 신청**이나 **제한 증가 요청**을 할 수 있지만, **Help** 아이콘을 클릭하면 바로 요청 폼으로 이동도 가능합니다.
![](/assets/img/getting-started/2022/open-support-ticket-2.png " ")

티켓 생성의 경우 OCI Tenancy를 생성할 때 만든 Tenancy 관리자 계정(Cloud Account Admin 권한을 갖는 사용자)은 기본적으로 생성 가능할 수 있지만, 다른 일반 사용자가 티켓을 생성하기 위해서는 오라클 서포트 계정을 프로비저닝하고 Tenancy 관리자로부터 승인을 받아야 합니다. OCI 일반 사용자 계정을 Oracle 지원 요청이 가능한 계정으로 사용하기 위해서는 관리자로 부터 승인을 받는 절차를 수행해야 합니다. 해당 절차는 다음 포스팅을 참고합니다.

[OCI와 MOS(My Oracle Support) 계정 연동, OCI의 일반 사용자에게 지원 요청(SR) 권한 할당 방법](https://team-okitoki.github.io/getting-started/configuring-support-account/)

### OCI 지원 센터를 통해서 요청할 수 있는 일반적인 사항들
보통 OCI를 사용하면서 발생하는 다양한 기술 이슈에 대한 요청을 할 수 있지만, 이러한 지원 외에도 다음과 같은 지원 요청도 가능합니다.
* Tenancy 관리 계정 패스워드가 Lock이 된 경우
* Tenancy 관리자를 추가하거나 변경이 필요한 경우
* 빌링과 관련된 질문 요청
* 서비스 제한 증가 요청
* 근본 원인 분석 (Request a root cause analysis (RCA)) 요청

### SR 티켓 생성
우측 상단 **Help** 아이콘을 클릭한 후 **지원 요청 생성**을 클릭하거나, 지원 센터에서 **지원 요청 생성**을 통해 티켓을 생성할 수 있습니다. 다음과 같이 지원 옵션으로 기술 지원(Technical Support), 청구 지원(Billing Support), 제한 증가(Limit Increase)에 대한 요청을 할 수 있습니다.

#### 기술 지원 (Technical Support)
기술 지원을 위한 SR 티켓을 생성하기 위해서는 다음 항목에 대한 내용을 입력하여야 합니다.
* **문제 요약(Issue Summary):** 문제를 짧게 요약하여 작성합니다.
* **문제 설명(Describe Your Issue):** 발생한 문제에 대해서 상세하게 기술합니다. 
* **심각도 수준:** 다음 항목중에서 선택합니다. 일반적인 질문이나 이슈의 경우 **사소한 서비스 손실**로 선택하지만, 비즈니스에 영향을 줄만한 장애와 같은 이슈라면 **심각한 서비스 손실** 혹은 **전체적 서비스 손실**을 선택합니다.
  * 전체적 서비스 손실 (Complete loss of service)
  * 심각한 서비스 손실 (Severe loss of service)
  * 사소한 서비스 손실 (Minor loss of service)
  * 서비스 손실 없음 (No loss of service)

선택적으로 다음 내용을 포함할 수 있습니다.
* **서비스:** 어떤 서비스에 대한 요청인지 선택
* **서비스 카테고리:** 서비스에 대한 카테고리 선택
* **문제 유형:** 발생한 문제 유형 선택
* **리소스 OCID:** 해당 리소스의 OCID를 확인

![](/assets/img/getting-started/2022/open-support-ticket-3.png " ")

기술 지원 요청시에 근본 원인 분석(Request a root cause analysis (RCA)) 요청을 할 수 있습니다. RCA는 중대한 이슈가 발생(DB 셧다운, 인스턴스 셧다운)과 같은 이슈가 발생했을때 근본적인 원인에 대한 분석을 요청하는 경우라고 볼 수 있습니다. 이러한 요청이 필요한 경우에는 문제 요약 항목에 **Root Cause Analysis (RCA) Request** 라는 내용을 포함하여 생성합니다.

#### 청구 지원 (Billing Support)
청구 지원에서는 청구된 비용에 대한 문의나 이슈에 대해서 요청할 수 있습니다.
![](/assets/img/getting-started/2022/open-support-ticket-4.png " ")

#### 서비스 한도 증가 요청 (Limit Increase)
OCI에서 제공되는 자원은 기본적으로 어느정도의 Limit이 설정되어 있습니다. Limit을 확인하기 위해서는 **거버넌스 & 관리 > 제한, 할당량 및 사용량**에서 확인이 가능합니다. 만일 자원이 더 필요하다면, 서비스 한도 증가 요청폼에서 필요한 자원과 수량, 필요한 이유를 작성하여 증가 요청할 수 있습니다.

![](/assets/img/getting-started/2022/open-support-ticket-5.png " ")

### 생성한 SR 티켓 목록 확인하기
생성한 SR 요청건은 지원 센터의 지원 목록에서 확인할 수 있습니다. **기술**, **청구**, **제한**을 클릭하여 필터링도 가능합니다.

![](/assets/img/getting-started/2022/open-support-ticket-6.png " ")

## SR 티켓에 댓글이나 파일 업로드
생성한 SR 요청을 목록에서 클릭하면 상세화면으로 이동합니다. 상세화면에서는 해당 지원 요청건에 별도로 댓글이나 파일을 첨부할 수 있습니다. 

댓글을 달기 위해서는 왼쪽의 **설명(Comments)** 버튼을 클릭하고, **설명 추가(Add Comment)** 버튼을 클릭하여 입력합니다. 

![](/assets/img/getting-started/2022/open-support-ticket-7.png " ")

첨부는 왼쪽의 연결(Attachments)을 클릭하고 **업로드 파일(Upload File)**을 클릭하고 파일이나 이미지를 업로드 합니다.

### SR 티켓 닫기
요청한 지원건이 모두 해결되면 지원 티켓을 닫아야 합니다. 지원 티켓을 닫기 위해서는 지원 티켓 목록에서 해당 지원을 클릭하고 **티켓 닫기** 버튼을 클릭하면 대화창이 표시됩니다. 간단히 이유를 입력하고 **닫기**를 클릭합니다.