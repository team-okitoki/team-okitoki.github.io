---
layout: page-fullwidth
#
# Content
#
subheadline: "Governance"
title: "OCI에서 회사 도메인을 관리해보자"
teaser: "OCI 테넌시에 회사 도메인을 등록함으로서, 누군가가 회사 도메인을 통해 새로운 테넌시를 생성하는 것을 방지할 수 있습니다. 이러한 도메인 관리 기능에 대해서 설명합니다."
author: dankim
date: 2022-06-18 00:00:01
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, tenancy]
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

### 도메인 관리
도메인 관리 기능은 현재 회사에서 사용하고 있는 OCI 테넌시에 회사의 도메인을 등록함으로서, 다른 누군가가 회사의 도메인을 가지는 이메일을 활용하여 새로운 테넌시를 생성하는 시도를 방지할 수 있게 해주는 기능입니다. 예를 들어, "Company A"에서 근무하고 "companyA"가 도메인 이름인 경우 또 다른 누군가가 OCI 테넌시 생성 시 입력하는 이메일의 도메인으로 "companyA"를 사용하는 경우 생성 시도가 실패하게 됩니다.

결과적으로 엔터프라이즈 기업은 OCI의 도메인 관리 기능을 통해서, 회사의 도메인으로 OCI 테넌시를 생성하려고 하는 사용자를 파악할 수 있으며, 이를 통해서 OCI 환경을 보다 쉽게 제어함으로써 테넌시에 대한 기업 정책을 쉽게 적용할 수 있습니다. 또한 OCI 환경에서 도메인 소유권을 안전하게 확인하고 리소스 지출이나 관리를 보다 쉽게 제어할 수 있습니다.

도메인 관리 기능을 사용하기 위해서는 다음 정책이 필요합니다.
```
Allow group domainUsers to manage organizations-domain in compartmentA
Allow group domainUsers to manage organizations-domain-governance in compartmentA
```

### 도메인 추가 및 확인
관리할 도메인을 추가하는 방법은 다음과 같습니다.

1. 먼저 OCI 콘솔 메뉴에서 **거버넌스 & 관리(Governance & Administration) > 도메인 관리(Domain Management)**를 순서대로 클릭합니다.

![](/assets/img/getting-started/2022/managing-your-domains-1.png " ")

2. 도메인 추가 및 확인창 에서 추가 할 도메인의 이메일 주소를 입력합니다. 이 이메일 주소는 회사의 도메인을 가진 이메일로 누군가가 Oracle Cloud 계정을 생성하려고 할 때 알림을 받는 이메일입니다.

3. **Oracle Notification Service 요금에 동의합니다.** 를 체크합니다. 이 서비스는 [Oracle Notification Service](https://www.oracle.com/devops/notifications/)를 사용하며, 해당 서비스의 요금이 적용됩니다.

4. 회사의 도메인을 입력한 후 추가 및 확인을 클릭합니다.

![](/assets/img/getting-started/2022/managing-your-domains-2.png " ")

5. 도메인이 추가되고 TXT 레코드 필드가 값이 생성됩니다. 복사 아이콘을 클릭하여 TXT 레코드 값을 도메인 레코드로 추가([TXT 레코드 추가](https://kr.godaddy.com/help/add-a-txt-record-19232))하면, 오라클은 해당 도메인이 사용자가 소유한 도메인인지 검증합니다. 검증이 완료되면, 이후 OCI 도메인 관리에 등록된 도메인의 상태가 **Pending**에서 **Verified**로 변경됩니다. 이 과정을 완료하는데 최대 72시간 소요될 수 있습니다.

### 도메인 관리
도메인 관리 페이지에 추가한 도메인이 표시됩니다. 도메인은 다음과 같은 정보를 포함합니다.
* **도메인:** 도메인의 이름입니다.
* **알림:** 연관된 **Notification Service**에 대한 **Topic**입니다. 도메인이 검증되어야만 Topic이 생성됩니다. 또한 Topic이 생성되면 이메일로 구독 확인요청 메일을 받게 되며, 확인을 해야 실제 알림을 받을수 있습니다.
* **상태:** 
  * **보류중(Pending):** 확인 중 상태
  * **실패(Failed):** 72시간까지 검증이 제대로 되지 않은 경우의 상태
  * **활성(Active):** 검증되고 거버넌스가 활성화(Enabled) 된 상태
  * **비활성화(Disabled):** 확인되었지만 거버넌스가 활성화 되지 않아 관리되지 않은 상태
  * **해제중(Releasing):** 고객이 삭제를 요청한 상태
  * **해제됨(Released):** 작업 요청 완료, 7일이 지나면 도메인 관리 페이지에서 사라집니다.
* **날짜:** 마지막으로 수정한 날짜입니다. verified, enabled, disabled 또는 이메일이 업데이트된 경우 업데이트됩니다.

도메인의 상태가 Active인 경우 다음 작업을 수행할 수 있습니다.
* 거버넌스 활성화(Enable) 또는 비활성화(disable)
* 이메일 업데이트
* 도메인 제거

#### 도메인 활성, 비활성, 이메일 업데이트 도메인 제거
* 도메인을 활성화 하기 위해서는 도메인 관리에서 **작업(Actions)** 메뉴를 클릭한 후 **거버넌스 사용(Enable Governance)**을 클릭합니다.
* 도메인을 비 활성화 하기 위해서는 도메인 관리에서 **작업(Actions)** 메뉴를 클릭한 후 **거버넌스 사용 안함(Disable Governance)**을 클릭합니다.
* 도메인의 이메일 주소를 업데이트하기 위해서는 도메인 관리에서 **작업(Actions)** 메뉴를 클릭한 후 **이메일 업데이트(Update Email)**를 클릭합니다.
* 도메인을 삭제하기 위해서는 도메인 관리에서 **작업(Actions)** 메뉴를 클릭한 후 **도메인 제거(Remove Domain)**를 클릭합니다.

### 도메인 해지
오라클은 등록된 도메인이 유효하고 올바른 사용자에게 할당이 되었는지 정기적으로 확인합니다. 만일 도메인이 이 확인 검사를 통과하지 못하면 관리자는 이메일 알림을 받게되고 72시간 이내에 TXT 레코드 정보를 업데이트 해야 합니다. 만일 아무런 조치를 취하지 않으면 해당 도메인 등록은 취소(Revocation)됩니다. 취소되어도 다시 해당 도메인에 대해서 추가 및 검증을 할 수 있습니다.