---
layout: page-fullwidth
#
# Content
#
subheadline: "Billing & Cost"
title: "OCI 비용과 사용량 분석하기"
teaser: "Oracle Cloud Infrastructure (OCI)에서 사용한 비용과 사용량을 모니터링 및 분석하는 방법에 대해서 알아봅니다."
author: dankim
date: 2022-06-04 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - oci
  - expense
  - usage
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

# -------------- 내용 필독 -------------------
# 작성할 내용은 아래부터 작성
# 작성 방법
# 각 챕터별 제목은 "###"로 시작한다.
# 하위 제목은 "####"로 시작한다.
# 이미지는 images 폴더안에 Category(getting-started, infrastructure, platform, database, aiml)에 넣고 사용 시 "../../images/카테고리명/이미지" 형태로 참조한다.
# Bold는 **글자**
# Bold + Italic은 ***글자***
# ------------------------------------------
---

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

### OCI에서 제공하는 비용 관련 도구들
OCI Console에서는 다음과 같은 비용 및 사용량에 대한 모니터링 도구들을 제공하고 있습니다. 

* 예산 (Budgets)
* 비용 분석 (Cost Analysis)
* 비용 및 사용 보고서 (Cost and Usage Reports)

그 외 간략히 요약된 비용 정보를 확인하고자 할때는 구독(Subscriptions) 페이지에서 확인이 가능합니다. 구독 (Subscriptions)에서 비용을 확인하는 방법은 아래 포스트를 참고합니다.

> [OCI 무료 계정 생성 및 관리하기 - 구독 정보 및 사용 비용 확인하기](http://localhost:4000//getting-started/free-oci-promotions/#%EA%B5%AC%EB%8F%85-%EC%A0%95%EB%B3%B4-%EB%B0%8F-%EC%82%AC%EC%9A%A9-%EB%B9%84%EC%9A%A9-%ED%99%95%EC%9D%B8%ED%95%98%EA%B8%B0)

### 비용 분석 (Cost Analysis)
비용 분석 (Cost Analysis)은 OCI에서 사용한 비용을 다양한 필터와 그룹항목으로 집계한 후 이를 차트 및 표 형태로 제공합니다. 또한 이렇게 집계된 비용 데이터를 CSV 파일로 다운로드 받아볼 수 있습니다. 비용 분석 화면은 다음 경로를 통해 확인할 수 있습니다.
> 청구 및 비용 관리 (Billing & Cost Management) > 비용 분석 (Cost Analysis)

![](/assets/img/getting-started/2022/oci-expense-cost-1.png " ")

일반적으로 비용 분석 페이지를 처음 오픈하게 되면, 서비스별로 사용한 비용에 대한 보고서를 보여줍니다. 여기서 아래와 같은 **조건**, **필터**, **그룹화** 기능을 활용하여 비용 보고서를 생성할 수 있습니다. 가령 기간, 일 및 월 단위 집계, 비용 혹은 사용량 검색과 함께 서비스에 적용한 특정 태그, 구획, 지역, 서비스등으로 필터링을 할 수 있으며, 마찬가지로 그룹화를 선택하여 비용을 확인할 수 있습니다.

![](/assets/img/getting-started/2022/oci-expense-cost-2.png " ")

이제 몇 가지 간단한 비용 필터링 하는 방법을 보겠습니다.
#### 날짜별로 비용을 필터링 하려면
메뉴에서 **청구 및 비용 관리 (Billing & Cost Management) > 비용 분석 (Cost Analysis)**을 클릭합니다. 아래와 같이 기본적으로 제공되는 보고서를 선택할 수 있습니다. 여기서는 **서비스별 비용**을 선택한 후 시작 날짜와 종료 날짜를 선택하고 적용 버튼을 선택합니다.
> 보고서는 사용자가 별도로 정의하여 저장할 수 있습니다. 사용자가 원하는 조건이나 필터, 그룹을 선택하면 **새 보고서 저장** 버튼이 활성화 되면서 새로운 보고서로 저장할 수 있습니다.
> 시작 날짜와 종료 날짜는 UTC(협정 세계시)입니다. (서울 표준시: UTC+09:00)

![](/assets/img/getting-started/2022/oci-expense-cost-3.png " ")

다음과 같이 조건 및 필터가 적용된 결과를 차트와 표로 확인할 수 있습니다.

![](/assets/img/getting-started/2022/oci-expense-cost-4.png " ")

#### 태그별로 비용을 필터링하려면
마찬가지로 메뉴에서 **청구 및 비용 관리 (Billing & Cost Management) > 비용 분석 (Cost Analysis)**을 클릭합니다. 보고서는 마찬가지로 **서비스별 비용**을 선택한 후 **필터**에서 **태그**를 선택합니다. **태그 네임스페이스** 및 **태그 키** 에서 **태그 지정 필터 옵션**을 선택 및 **태그 값 (다음 중에서 임의 항목 일치 선택시)**을 입력한 후 **적용**을 클릭합니다.
> 태그는 모든 리소스들이 기본적으로 OCI에서 제공되는 기본 **태그 네임스페이스** 및 **태그 키**를 갖고 있지만, 사용자가 임의로 **태그 네임스페이스** 및 **태그 키**를 생성하여 리소스에 할당이 가능합니다. ex) 태그 네임스페이스: mycompany, 태그 키: devteam, 태그 값: mydevteam

![](/assets/img/getting-started/2022/oci-expense-cost-5.png " ")
![](/assets/img/getting-started/2022/oci-expense-cost-6.png " ")

#### 구획별로 비용을 필터링하려면
메뉴에서 **청구 및 비용 관리 (Billing & Cost Management) > 비용 분석 (Cost Analysis)**을 클릭합니다. 보고서는 동일하게 **서비스별 비용**을 선택한 후 **필터**에서 **구획**을 선택합니다. 구획 필터링의 경우 **구획 이름**, **구획 OCID**, **구획 경로**를 이용해서 필터링할 수 있습니다. **구획 필터링 옵션**을 선택 및 **필터링** 값을 입력한 후 **적용** 버튼을 클릭하면 해당 구획에 생성된 리소스에 대한 비용에 대한 보고서가 생성됩니다.

![](/assets/img/getting-started/2022/oci-expense-cost-7.png " ")

#### 위에서 적용한 필터를 제거하려면
비용을 필터링하면 추가된 필터의 앞에 **X**아이콘과 함께 적용된 필터가 표시됩니다. 여기서 각 필터를 제거하려면 필터에 표기된 **X** 아이콘을 클릭하고, 모든 필터를 제거하려면 우측의 **모든 필터 지우기**를 클릭합니다.

![](/assets/img/getting-started/2022/oci-expense-cost-8.png " ")