---
layout: page-fullwidth
#
# Content
#
subheadline: "Cloud Account"
title: "OCI 무료 계정 생성하기"
teaser: "Oracle Cloud Infrastructure (이하 OCI)는 한달동안 300달러 상당의 무료 크레딧을 제공하는 무료 계정을 제공합니다. 이번 포스팅을 통해서 OCI 무료 계정을 생성하는 방법에 대해서 알아봅니다."
author: dankim
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

### 하나의 Free Trial 계정에서 두 개의 무료 옵션 제공
Oracle Cloud Free Tier에서는 300달러(한달)의 무료 크레딧을 기본적으로 제공하며, 추가적으로 기간 제한없이 사용할 수 있는 여러개의 Always Free 서비스들을 포함해서 제공하고 있습니다.

![](/assets/img/getting-started/2020-06/freetrial.png " ")

### Free Trial 계정 생성하기

1. Oracle Cloud 어카운트 생성을 위해서 [SignUp](https://signup.cloud.oracle.com) 폼을 오픈합니다.

   다음과 같은 등록 페이지를 볼 수 있습니다.
       ![](/assets/img/getting-started/2020-06/cloud-infrastructure-ko.png " ")

2.  다음 정보를 입력합니다.
    * **국가/지역** 입력
    * **성/이름** 과 **이메일**

3. 유효한 이메일 주소를 입력한 후, **내 전자메일 확인** 버튼을 선택합니다.
       ![](/assets/img/getting-started/2020-06/verify-email-ko.png " ")

4. 다음과 같은 이메일을 수신하게 되면, 본문의 **Verify email** 버튼을 클릭합니다.
       ![](/assets/img/getting-started/2020-06/verification-mail-ko.png " ")

5. Oracle Cloud Free Tier 계정 생성을 위해서 다음과 같은 정보를 추가로 입력합니다.
    - **패스워드**
    - **회사 이름**
    - **클라우드 계정 이름**은 생성하는 클라우드를 대표하는 이름으로 처음엔 자동으로 생성되어 있지만, 변경이 가능합니다. 클라우드에 로그인을 위해 꼭 필요한 정보이며, 추후 변경이 가능합니다.

    - **Home Region**은 클라우드 로그인 시 기본적으로 선택되는 리전입니다. 처음 등록후에는 변경할 수 없습니다.
    - **계속** 클릭
    ![](/assets/img/getting-started/2020-06/account-info-ko.png " ")

6.  주소 정보를 입력합니다.
    ![](/assets/img/getting-started/2020-06/free-tier-address-ko.png " ")

7.  휴대폰 번로를 입력한 후  **계속** 버튼을 클릭합니다.
    ![](/assets/img/getting-started/2020-06/free-tier-address-2-ko.png " ")

8. **지급 검증 방법 추가** 버튼을 클릭한 후 유효한 지불정보를 입력합니다.
    ![](/assets/img/getting-started/2020-06/free-tier-payment-1-ko.png " ")

9. 지불 정보 검증이 완료되면 아래와 같은 화면을 볼 수 있습니다.
    ![](/assets/img/getting-started/2020-06/free-tier-payment-2-ko.png " ")

10. **계약**을 검토하고 동의 체크 후 **내 무료 체험판 시작하기** 버튼을 클릭합니다.
    ![](/assets/img/getting-started/2020-06/free-tier-agreement-ko.png " ")

11. 프로비저닝이 완료되면 아래와 같은 메일을 수신하게 됩니다. 
    ![](/assets/img/getting-started/2020-06/account-provisioned-ko.png " ")

### Task 2: 오라클 클라우드에 사인인 하기

1. 브라우저를 통해서 [cloud.oracle.com](https://cloud.oracle.com)로 접속합니다. 클라우드 계정 이름을 입력하고 **Next** 버튼을 클릭합니다.

    ![](/assets/img/getting-started/2020-06/cloud-oracle-ko.png " ")

2. 사용자 이름과 비밀번호를 입력한 후 **사인인** 버튼을 클릭합니다.

   ![](/assets/img/getting-started/2020-06/cloud-login-tenant-single-sigon-ko.png " ")

3. 이제 Oracle Cloud를 사용하실 수 있습니다. 만일 로그인 후 상단에 **Your account is currently being set up, and some features will be unavailable. You will receive an email after setup completes.** 라는 메시지가 보인다면, 아직 환경을 준비하는 상태, 프로비저닝이 진행중이라는 것을 의미합니다. 조금만 더 기다리면, 모든 과정이 완료되고 최종 완료 메일을 받게됩니다.

    ![](/assets/img/getting-started/2020-06/oci-console-home-page-ko.png " ")