---
layout: page-fullwidth
#
# Content
#
subheadline: "Identity & Security"
title: "OCI 계정의 비밀번호 변경하기"
teaser: "OCI 로그인하기 위한 계정 유형별 비밀번호 변경 방법에 대해 알아봅니다."
author: yhcho
date: 2022-06-20 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, sign-in, iam, oracle IDCS, identity domain, changing password, password]
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

### OCI 계정의 비밀번호 변경하기
OCI 콘솔에 로그인 유형별 비밀번호 변경 방법에 대해 알아봅니다.

#### OCI IAM (Legacy) 사용자 비밀번호 변경하기
1. OCI 콘솔에서 사용자 프로파일 아이콘 클릭 -> **비밀번호 변경** 메뉴를 클릭합니다.
   ![OLD IAM 비밀번호 변경 #1](/assets/img/getting-started/2022/oci-old-iam-change-password-1.png)
2. 기존 비밀번호와 새로운 비밀번호를 입력하여 비밀번호를 변경합니다.
   ![OLD IAM 비밀번호 변경 #2](/assets/img/getting-started/2022/oci-old-iam-change-password-2.png)

#### Oracle IDCS 사용자 비밀번호 변경하기
1. OCI 콘솔에서 사용자 프로파일 아이콘 클릭 -> **서비스 사용자 콘솔** 메뉴를 클릭합니다.
   ![IDCS 비밀번호 변경 #1](/assets/img/getting-started/2022/oci-idcs-change-password-1.png)
2. 이동한 화면에서 사용자 프로파일 아이콘 클릭 -> **비밀번호 변경** 메뉴를 클릭합니다.
   ![IDCS 비밀번호 변경 #2](/assets/img/getting-started/2022/oci-idcs-change-password-2.png)
3. 기존 비밀번호와 새로운 비밀번호를 입력하여 비밀번호를 변경합니다.
   ![IDCS 비밀번호 변경 #3](/assets/img/getting-started/2022/oci-idcs-change-password-3.png)

#### OCI IAM Identity Domain 사용자 비밀번호 변경하기
1. OCI 콘솔에서 사용자 프로파일 아이콘 클릭 -> **내 프로파일** 메뉴를 클릭합니다.
   ![NEW IAM 비밀번호 변경 #1](/assets/img/getting-started/2022/oci-new-iam-change-password-1.png)
2. 이동된 프로파일 화면에서 **"비밀번호 변경"** 버튼을 클릭합니다.
   ![NEW IAM 비밀번호 변경 #2](/assets/img/getting-started/2022/oci-new-iam-change-password-2.png)
3. 레이어팝업에서 현재 기존 비밀번호와 새로운 비밀번호를 입력하여 비밀번호를 변경합니다.
   ![NEW IAM 비밀번호 변경 #3](/assets/img/getting-started/2022/oci-new-iam-change-password-3.png)

