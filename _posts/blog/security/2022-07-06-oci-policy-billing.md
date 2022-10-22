---
layout: page-fullwidth
#
# Content
#
subheadline: "Policy"
title: "OCI 빌링 메뉴 사용을 위한 정책 생성"
teaser: "일반 사용자에게 빌링 관련 메뉴 접근 및 관리를 위한 정책 생성 방법 가이드 입니다."
author: yhcho
date: 2022-07-06 00:00:00
breadcrumb: true
categories:
  - security
tags:
  - [oci, security, policy]
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

### OCI 빌링 메뉴 접근 허용을 위한 정책 생성 방법
OCI 클라우드 관리자가 아닌 일반 사용자에게 빌링 메뉴 접근 허용을 위한 정책을 생성하기 위해 정책 메뉴로 이동합니다.

1. 햄버거 메뉴 클릭 후 "**ID & 보안**" → "**ID**" → "**정책**" 메뉴를 클릭 합니다.
   ![](/assets/img/cloudnative-security/2022/oci-policy-menu.png)
2. 이동한 화면에서 "정책생성" 버튼을 클릭하여 정책 생성 화면으로 이동합니다.
   ![](/assets/img/cloudnative-security/2022/oci-policy-create.png)
3. 다음과 같이 입력 후 "**수동 편집기 표시**" 옵션을 활성화 합니다.
   - 이름 : **billing-policy**
   - 설명 : **빌링 메뉴 접근을 위한 정책 입니다.**
   - 구획 : **전체 테넌시에 적용하기 위해서 root compartment에 정책을 생성합니다.**
   ![](/assets/img/cloudnative-security/2022/oci-policy-billing-create.png)
4. 수동 편집기에 아래와 같이 입력합니다.
   - 특정 그룹에 대한 정책 생성 
    ```text
    Allow group <group> to manage accountmanagement-family in tenancy
    ```
5. "**생성**" 버튼을 클릭하여 정책을 생성을 마무리 합니다.
6. 정책을 생성한 그룹의 사용자로 로그인 후 적용 여부를 확인합니다.