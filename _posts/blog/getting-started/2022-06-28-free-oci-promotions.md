---
layout: page-fullwidth
#
# Content
#
subheadline: "Cloud Account"
title: "OCI 무료 계정 생성 및 관리하기"
teaser: "Oracle Cloud Infrastructure (이하 OCI)는 한달동안 300달러 상당의 무료 크레딧을 제공하는 무료 계정을 제공합니다. 이번 포스팅을 통해서 OCI 무료 계정을 생성하는 방법과 계정 관리 방법에 대해서 알아봅니다."
author: dankim
date: 2022-06-28 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - oci
  - free trial
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

### 하나의 Free Trial 계정에서 두 개의 무료 옵션 제공
Oracle Cloud Free Tier에서는 300달러(한달)의 무료 크레딧을 기본적으로 제공하며, 추가적으로 기간 제한없이 사용할 수 있는 여러개의 Always Free 서비스들을 포함해서 제공하고 있습니다.

![](/assets/img/getting-started/2022/freetrial.png " ")

### Free Trial 계정 생성하기

1. Oracle Cloud 어카운트 생성을 위해서 [SignUp](https://signup.cloud.oracle.com) 폼을 오픈합니다.

   다음과 같은 등록 페이지를 볼 수 있습니다.
       ![](/assets/img/getting-started/2022/cloud-infrastructure-ko.png " ")

2.  다음 정보를 입력합니다.
    * **국가/지역** 입력
    * **성/이름** 과 **이메일**

3. 유효한 이메일 주소를 입력한 후, **내 전자메일 확인** 버튼을 선택합니다.
       ![](/assets/img/getting-started/2022/verify-email-ko.png " ")

4. 다음과 같은 이메일을 수신하게 되면, 본문의 **Verify email** 버튼을 클릭합니다.
       ![](/assets/img/getting-started/2022/verification-mail-ko.png " ")

5. Oracle Cloud Free Tier 계정 생성을 위해서 다음과 같은 정보를 추가로 입력합니다.
    - **패스워드**
    - **회사 이름**
    - **클라우드 계정 이름**은 생성하는 클라우드를 대표하는 이름으로 처음엔 자동으로 생성되어 있지만, 변경이 가능합니다. 클라우드에 로그인을 위해 꼭 필요한 정보이며, 추후 변경이 가능합니다.

    - **Home Region**은 클라우드 로그인 시 기본적으로 선택되는 리전입니다. 처음 등록후에는 변경할 수 없습니다.
    - **계속** 클릭
    ![](/assets/img/getting-started/2022/account-info-ko.png " ")

6.  주소 정보를 입력합니다.
    ![](/assets/img/getting-started/2022/free-tier-address-ko.png " ")

7.  휴대폰 번로를 입력한 후  **계속** 버튼을 클릭합니다.
    ![](/assets/img/getting-started/2022/free-tier-address-2-ko.png " ")

8. **지급 검증 방법 추가** 버튼을 클릭한 후 유효한 지불정보를 입력합니다.
    ![](/assets/img/getting-started/2022/free-tier-payment-1-ko.png " ")

9. 지불 정보 검증이 완료되면 아래와 같은 화면을 볼 수 있습니다.
    ![](/assets/img/getting-started/2022/free-tier-payment-2-ko.png " ")

10. **계약**을 검토하고 동의 체크 후 **내 무료 체험판 시작하기** 버튼을 클릭합니다.
    ![](/assets/img/getting-started/2022/free-tier-agreement-ko.png " ")

11. 프로비저닝이 완료되면 아래와 같은 메일을 수신하게 됩니다. 
    ![](/assets/img/getting-started/2022/account-provisioned-ko.png " ")

### 오라클 클라우드에 사인인 하기

1. 브라우저를 통해서 [cloud.oracle.com](https://cloud.oracle.com)로 접속합니다. 클라우드 계정 이름을 입력하고 **Next** 버튼을 클릭합니다.

    ![](/assets/img/getting-started/2022/cloud-oracle-ko.png " ")

2. 사용자 이름과 비밀번호를 입력한 후 **사인인** 버튼을 클릭합니다.

   ![](/assets/img/getting-started/2022/cloud-login-tenant-single-sigon-ko.png " ")

3. 이제 Oracle Cloud를 사용하실 수 있습니다. 만일 로그인 후 상단에 **Your account is currently being set up, and some features will be unavailable. You will receive an email after setup completes.** 라는 메시지가 보인다면, 아직 환경을 준비하는 상태, 프로비저닝이 진행중이라는 것을 의미합니다. 조금만 더 기다리면, 모든 과정이 완료되고 최종 완료 메일을 받게됩니다.

    ![](/assets/img/getting-started/2022/oci-console-home-page-ko.png " ")

### 구독 정보 및 사용 비용 확인하기
우선 사용 비용을 모니터링 하는 방법을 알아보도록 하겠습니다. OCI Console을 통해서 기본적으로 얼마의 크레딧이 있고, 얼마의 크레딧을 사용하고 있는지 모니터링 할 수 있습니다. 

우선 구독한 정보를 확인하고 간단히 사용 비용에 대한 요약된 페이지를 확인해보도록 하겠습니다. OCI Console 메뉴에서 **Billing & Cost Management > Subscriptions**를 선택합니다.

![](/assets/img/getting-started/2022/oci-subscription-1.png " ")

다음과 같이 구독 목록을 볼 수 있습니다. 

![](/assets/img/getting-started/2022/oci-subscription-2.png " ")

해당 구독을 클릭하면 구독에 대한 상세 정보와 함께  얼마의 비용을 사용하고 있으며, 사용하고 있는 서비스는 몇개이고, 몇개의 리전에서 사용중인지를 간단히 확인할 수 있습니다.
![](/assets/img/getting-started/2022/oci-subscription-3.png " ")

또한 다음과 같이 날짜별로 사용된 금액을 확인할 수 있습니다.
![](/assets/img/getting-started/2022/oci-subscription-4.png " ")

각 일자별로 우측의 아이콘을 클릭하면 상세하게 어떤 서비스에 대한 비용이 발생했는지 확인 가능합니다.
![](/assets/img/getting-started/2022/oci-subscription-5.png " ")

### 비용 분석하기
상세한 비용 분석(Cost Analysis) 기능도 제공되고 있습니다. **Billing & Cost Management > Cost Analysis**를 클릭합니다.

![](/assets/img/getting-started/2022/oci-cost-analytics-1.png " ")

비용 분석 (Cost Analysis)에서는 여러 조건과 필터를 통해 검색하고, 날짜 및 사용 서비스, 지역등 다양한 항목으로 그룹핑하여 비용을 분석할 수 있습니다.
![](/assets/img/getting-started/2022/oci-cost-analytics-2.png " ")

![](/assets/img/getting-started/2022/oci-cost-analytics-3.png " ")

### 예산 설정하기
OCI Console에서는 예산을 미리 책정하여 사용량에 대한 한도를 설정하고, 예산을 초과하는 시기를 미리 알림 받을 수 있도록 설정할 수 있는 기능도 제공하고 있습니다. 예산 설정을 위해서 **Billing & Cost Management > Budget**을 클릭합니다.

![](/assets/img/getting-started/2022/oci-budget-1.png " ")

**Create Budget**을 클릭합니다.
![](/assets/img/getting-started/2022/oci-budget-2.png " ")

예산에 대한 설정을 합니다. 아래과 같이 입력하고 **Create** 버튼을 클릭하여 예산을 생성합니다.
* 예산 범위 (Budget Scope): 
    * Compartments: 특정 구획에 대해서 예산을 설정할 수 있습니다.
    * Cost-Tracking Tag: OCI에서 Compute나 스토리지와 같은 리소스를 생성할 때 사용자가 임의의 Tag를 추가할 수 있습니다. 여기서는 사용자가 설정한 특정 Tag 값을 갖는 리소스에 대해서만 예산을 적용할 수 있습니다. 
    > Tag 예시) myproduct.dev.database=TRUE
* 예산 스케쥴 및 예산 처리를 시작할 일자 및 예산 금액 선택
* 예산 경보 규칙
    * 임계치 매트릭(Threshold Metric): 
        * Actual Spend (실제 지출 비용): 실제 사용 금액을 모니터링
        * Forecast Spend (지출 예측): 리소스 사용량을 관찰하고 예산을 초과할지를 예측 (예측 알고리즘은 최소 3일 이상의 사용된 데이터가 필요)
    * 임계치 유형 (Threshold Type): 
        * 예산 비율(Percentage of Budget): 월 예산 비율
        * 절대 금액(Absolute Amount): 고정된 금액 (예, 100만원)
    * 이메일 수신자 및 메시지
        * 이메일은 쉼표, 세미콜론, 공백, 탭 또는 새 줄을 사용하여 구분할 수 있습니다.
        * 메시지는 1000자를 초과할 수 없습니다.

![](/assets/img/getting-started/2022/oci-budget-3.png " ")
