---
layout: page-fullwidth
#
# Content
#
subheadline: "Cloud Sign-In"
title: "OCI의 로그인 옵션 살펴보기"
teaser: "Oracle Cloud Infrastructure (OCI)에서 제공하는 2가지 로그인 옵션에 대해 알아봅니다."
author: yhcho
date: 2022-06-27 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, sign-in, iam, idcs]
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

### 로그인 옵션 종류
Oracle Cloud 계정을 생성하게 되면 Oracle 에서는 사용자에게 두 가지 다른 ID 시스템을 제공하여 사용자를 생성하고 Oracle Cloud Infrastructure 에 로그인 할 수 있는 옵션을 제공합니다. 

![](/assets/img/getting-started/2022/oci-identity-systems.png " ")
<br>
![](/assets/img/getting-started/2022/oci-signin-options.png " ")


### Oracle Cloud Infrastructure IAM Service (Identity and Access Management)
Oracle Cloud Infrastructure 에는 인증과 엑세스 제어 관리를 위해 IAM (Identity and Access Management Service)이라고 하는 자체 ID 서비스(Native 형태)가 포함되어 있습니다.
 - Oracle Cloud 계정을 생성하게 되면, OCI IAM 서비스가 포함되어 테넌시가 프로비전 됩니다.
 - Cloud Account를 생성할 때 입력한 사용자 이름을 사용 하여 IAM 서비스에 첫번째 사용자가 자동으로 생성되고, 이 계정에는 관리자 권한이 부여되어 모든 Oracle Cloud Infrastructure 서비스를 바로 사용 및 관리할 수 있습니다.


### Oracle Identity Cloud Service (Oracle IDCS)
Oracle Identity Cloud Service는 OCI 이전에 Oracle에서 서비스하던 여러 PaaS 형태의 서비스(현재 OCI로 점차 이관되고 있음)에 대한 인증 및 권한 관리를 위해 사용하던 시스템입니다.
 - 사용자가 Oracle Cloud 계정을 생성하게 되면 Oracle IDCS 시스템이 자동으로 구성되고 먼저 생성된 OCI IAM 시스템과 통합되어 사용되도록 자동으로 구성됩니다.
 - Cloud Account를 생성할 때 입력한 사용자 이름을 사용 하여 IDCS 서비스에 두번째 사용자가 자동으로 생성되고, 이 계정에는 관리자 권한이 부여되어 모든 Oracle Cloud Infrastructure 서비스를 바로 사용 및 관리할 수 있습니다.
 - 또한 IDCS에 등록된 사용자는 이 Single Sign On(SSO) 옵션을 사용하여 Oracle Cloud Infrastructure 에 로그인 한 다음 재 인증 없이 다른 Oracle Cloud 서비스로 이동할 수 있습니다(My Oracle Support 등등).

### Oracle IAM 과 Oracle IDCS의 차이점?
앞서 다룬 내용과 같이 Oracle IAM과 Oracle IDCS는 서로 다른 인증 & 엑세스 제어 관리 시스템 입니다.
두 시스템의 차이점은 관리 대상 서비스 및 시스템의 범위 입니다.
 - **OCI IAM 서비스** : 기본적으로 Oracle Cloud Infrastructure의 서비스에 대한 인증 & 엑세스 제어를 관리 합니다. 통합(페더레이션) 기능을 통해 3rd Party 인증서비스와 통합 가능합니다.
 - **Oracle IDCS 서비스** : Oracle Identity Cloud Service는 Oracle Cloud Infrastructure 뿐만 아니라 Oracle의 다른 Cloud 서비스(PaaS)에 대한 인증 & 엑세스 제어를 관리 합니다.

![](/assets/img/getting-started/2022/oci-iam-idcs-comparison.png " ")


### 주의할 사항
OCI IAM 과 Oracle IDCS는 각기 다른 시스템이기 때문에 OCI IAM 에서 특정 사용자의 비밀번호를 변경하는 경우 Oracle IDCS에는 변경사항이 반영되지 않습니다.
![](/assets/img/getting-started/2022/oci-iam-idcs-change-pw.png " ")

### 요약
현재는 IDCS와 IAM이 통합된 OCI IAM Identity Domain이라는 OCI 자체 서비스가 출시되었고, 점차 모든 리전과 무료 계정에도 적용되고 있으니, 앞으로는 OCI에서의 IAM 관리가 보다 심플해질 것이라 생각됩니다.

<br>**사용자 추가 및 Identity Domain 관련 자세한 내용은 아래 포스팅을 참고해주세요.**

  - [OCI에서 사용자,그룹,정책 관리하기](/getting-started/adding-users/)
  - [OCI IAM Identity Domain에 대해 알아보기](/getting-started/oci-iam-identity-domain/)
