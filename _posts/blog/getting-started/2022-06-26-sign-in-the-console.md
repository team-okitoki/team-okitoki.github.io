---
layout: page-fullwidth
#
# Content
#
subheadline: "Cloud Sign-In"
title: "OCI 콘솔 사용을 위한 기본 조건과 로그인 해보기"
teaser: "Oracle Cloud Infrastructure (OCI) Console을 사용하기 위한 기본조건을 확인하고 로그인 절차에 대해 알아봅니다."
author: yhcho
date: 2022-06-26 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, sign-in, console]
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

### OCI 콘솔 사용 조건
아래 표에는 Oracle Infrastructure Classic 콘솔 및 Application 콘솔 에서 지원하는 브라우저의 목록이 나열되어 있습니다.
<table cellpadding="4" cellspacing="0" class="Formal" title="" summary="This table lists the browser requirements for Applications Console and Infrastructure Classic Console." width="100%" frame="hsides" border="1" rules="rows">
 <thead>
    <tr align="left" valign="top">
       <th align="left" valign="bottom" width="0%" id="d1522e47">Web / Mobile 브라우저</th>
       <th align="left" valign="bottom" width="0%" id="d1522e49"><span>Infrastructure Classic Console</span> 과 <span>Applications Console</span></th>
    </tr>
 </thead>
 <tbody>
    <tr align="left" valign="top">
       <td align="left" valign="top" width="0%" id="d1522e57" headers="d1522e47 ">Microsoft Internet Explorer</td>
       <td align="left" valign="top" width="0%" headers="d1522e57 d1522e49 ">
          <p>11 버전 이상</p>
       </td>
    </tr>
    <tr align="left" valign="top">
       <td align="left" valign="top" width="0%" id="d1522e63" headers="d1522e47 ">
          <p>Mozilla Firefox</p>
       </td>
       <td align="left" valign="top" width="0%" headers="d1522e63 d1522e49 ">
          <p> 52 버전 이상</p>
       </td>
    </tr>
    <tr align="left" valign="top">
       <td align="left" valign="top" width="0%" id="d1522e70" headers="d1522e47 ">
          <p>Google Chrome</p>
       </td>
       <td align="left" valign="top" width="0%" headers="d1522e70 d1522e49 ">
          <p>63 버전 이상</p>
       </td>
    </tr>
    <tr align="left" valign="top">
       <td align="left" valign="top" width="0%" id="d1522e77" headers="d1522e47 ">
          <p>Apple Safari</p>
       </td>
       <td align="left" valign="top" width="0%" headers="d1522e77 d1522e49 ">
          <p>10 버전 이상</p>
       </td>
    </tr>
    <tr align="left" valign="top">
       <td align="left" valign="top" width="0%" id="d1522e84" headers="d1522e47 ">
          <p>Microsoft Edge</p>
       </td>
       <td align="left" valign="top" width="0%" headers="d1522e84 d1522e49 ">
          <p>35 버전 이상</p>
       </td>
    </tr>
    <tr align="left" valign="top">
       <td align="left" valign="top" width="0%" id="d1522e91" headers="d1522e47 ">
          <p>Safari, Chrome, Firefox on iOS (iPad and iPhone)</p>
       </td>
       <td align="left" valign="top" width="0%" headers="d1522e91 d1522e49 ">
          <p>최신버전</p>
       </td>
    </tr>
    <tr align="left" valign="top">
       <td align="left" valign="top" width="0%" id="d1522e98" headers="d1522e47 ">
          <p>Chrome, Firefox on Android (Phone and Tablet) </p>
       </td>
       <td align="left" valign="top" width="0%" headers="d1522e98 d1522e49 ">
          <p>최신버전</p>
       </td>
    </tr>
 </tbody>
</table>

### OCI 콘솔에 로그인하기
OCI 콘솔에 로그인 하는 절차를 확인합니다.

#### 기존 고객 (Identity Domain 미 적용 고객)
1. [https://cloud.oracle.com](https://cloud.oracle.com) 링크로 접속합니다.
2. **[Cloud Account Name]** 에 생성한 **클라우드 계정 이름**을 입력 후 **Next** 버튼을 클릭 합니다.
   ![Cloud Sign-in #1](/assets/img/getting-started/2022/oci-cloud-sign-in.png " ")
3. 이동된 화면에서 IDCS 또는 OCI IAM 중 로그인할 방법을 선택 후 정보를 입력하여 로그인합니다.
   ![Cloud Sign-in #2](/assets/img/getting-started/2022/oci-cloud-sign-in-options.png " ")
4. OCI IAM 서비스를 통해 로그인하는 경우, Oracle Cloud Infrastructure Direct Sign-In 하단에 정보를 입력 후 **Sign-In** 버튼을 통해 로그인 합니다.
   ![Cloud Sign-in #4](/assets/img/getting-started/2022/oci-cloud-sign-in-iam.png " ")
5. IDCS 서비스를 통해 로그인하는 경우, 아래 화면에서 사용자 이름 및 비밀번호를 입력하고 **사인인** 버튼을 통해 로그인 합니다.
   ![Cloud Sign-in #3](/assets/img/getting-started/2022/oci-cloud-sign-in-idcs.png " ")

#### 신규 고객 (Identity Domain 적용 고객)
1. [https://cloud.oracle.com](https://cloud.oracle.com) 링크로 접속합니다.
2. **[Cloud Account Name]** 에 생성한 **클라우드 계정 이름**을 입력 후 **Next** 버튼을 클릭 합니다.
   ![Cloud Sign-in #1](/assets/img/getting-started/2022/oci-cloud-sign-in.png " ")
3. 이동된 화면에서 로그인할 도메인을 선택한 후 **Next** 버튼을 클릭합니다.
   ![Cloud Sign-in #2](/assets/img/getting-started/2022/oci-cloud-id-sign-in.png " ")
5. 이동된 화면에서 사용자 이름 및 비밀번호를 입력하고 **사인인** 버튼을 통해 로그인합니다.
   ![Cloud Sign-in #3](/assets/img/getting-started/2022/oci-cloud-id-sign-in2.png)
