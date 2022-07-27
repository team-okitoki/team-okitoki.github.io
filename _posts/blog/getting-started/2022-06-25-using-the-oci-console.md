---
layout: page-fullwidth
#
# Content
#
subheadline: "Cloud Console"
title: "OCI 콘솔에 대해 알아보기"
teaser: "Oracle Cloud Infrastructure (OCI) Console UI 구성 및 기능을 알아봅니다."
author: yhcho
date: 2022-06-25 00:00:00
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

### OCI 콘솔 알아보기
OCI Console을 원활하게 사용하기 위해서 지원되는 브라우저를 확인 후 지원되는 브라우저에서 로그인이 필요합니다. 아래 포스팅을 통해 지원되는 브라우저 조건 및 로그인 방법을 먼저 확인 합니다.
> [OCI 콘솔 사용을 위한 기본 조건과 로그인 해보기](/getting-started/sign-in-the-console/)

### OCI 콘솔 화면 구성 살펴보기
콘솔에서 제공하는 시작하기, 대시보드 탭별로 화면 구성을 살펴 봅니다.

#### 시작하기 탭
시작하기 탭에서는 서비스 링크, 빠른시작, 리소스 실행, 탐색 시작 섹션을 제공합니다. 자세한 내용은 아래 사진의 내용을 참고해주세요.
![시작하기 설명 #1](/assets/img/getting-started/2022/oci-console-getting-start-1.png)
![시작하기 설명 #2](/assets/img/getting-started/2022/oci-console-getting-start-2.png)

#### 대시보드 탭
대시보드 탭에서는 리소스 탐색기, 청구, 모니터링, 로깅등을 시각화하여 모니터링 할 수 있는 도구를 제공합니다. 사용자의 요구사항에 따라 직접 위젯을 추가하거나 레이아웃을 편집할 수 있습니다.
![대시보드 설명 #1](/assets/img/getting-started/2022/oci-console-dashboard-1.png)

### 콘솔 설정
OCI 콘솔 오른쪽 상단에 사용자 아이콘을 클릭하여 콘솔 설정을 변경할 수 있습니다.
![콘솔 설정 변경 #1](/assets/img/getting-started/2022/oci-console-setting-1.png)

#### 세션 타임아웃 시간 변경
콘솔 설정 상단에 "**세션 시간 초과**" 섹션에서 세션 타임아웃 시간을 조정할 수 있습니다.
타임아웃 시간은 15분, 30분, 60분, 사용자 정의 시간으로 선택할 수 있고 사용자 정의 시간은 5분~60분 사이로 입력 가능합니다.

- 세션 타임아웃 변경 섹션
 ![콘솔 설정 변경 #2](/assets/img/getting-started/2022/oci-console-setting-2.png)
- 타임아웃 시간 초과 값 **드롭다운** 클릭 시 변경 옵션값을 확인할 수 있습니다.
 ![콘솔 설정 변경 #3](/assets/img/getting-started/2022/oci-console-setting-3.png)
- **사용자정의 시간(분)** 선택 시 직접 입력할 수 있습니다. (5분~60분)
 ![콘솔 설정 변경 #4](/assets/img/getting-started/2022/oci-console-setting-4.png)

#### 사용자 프로필 설정
메인 화면에서 추천 메뉴를 자동으로 추천하기 위한 사용자의 직무별 프로파일을 선택할 수 있습니다.
![콘솔 설정 변경 #5](/assets/img/getting-started/2022/oci-console-setting-5.png)

### 영역 전환
OCI 콘솔 우측 상단에 드롭다운 박스를 클릭하여 OCI Region(영역)을 변경할 수 있습니다.

#### 구독되어 있는 영역간 영역 전환
1. 우측 상단에 Region(영역) 드롭다운 박스를 클릭합니다.
   ![영역 변경 #1](/assets/img/getting-started/2022/oci-console-regions-change-1.png)
2. 클릭하여 현재 구독되어 있는 Region(영역) 중 변경할 Region(영역)을 클릭합니다.
   ![영역 변경 #2](/assets/img/getting-started/2022/oci-console-regions-change-2.png)
3. Region(영역) 전환이 완료 되었습니다.
   ![영역 변경 #3](/assets/img/getting-started/2022/oci-console-regions-change-3.png)

#### 영역 구독 추가
1. 우측 상단에 Region(영역) 드롭다운 박스를 클릭합니다.
   ![영역 변경 #1](/assets/img/getting-started/2022/oci-console-regions-change-1.png)
2. 레이어 팝업 하단 **"영역 관리"** 메뉴를 클릭합니다.
   ![영역 구독 추가 #1](/assets/img/getting-started/2022/oci-console-regions-subscription-1.png)
3. 영역 관리 메뉴에서 추가할 Region(영역) 우측 **"구독"** 버튼을 클릭하여 구독을 추가 합니다.
   ![영역 구독 추가 #2](/assets/img/getting-started/2022/oci-console-regions-subscription-2.png)
4. 팝업 내용을 확인하고 **"구독"** 버튼을 클릭하여 추가 합니다.
   ![영역 구독 추가 #3](/assets/img/getting-started/2022/oci-console-regions-subscription-3.png)

#### 제한 증가 요청 (영역 구독 수)
만약 구독을 추가하려고 할때 아래 사진과 같이 최대 영역 수를 초과했다는 메시지가 나타난다면, 제한 증가 요청을 통해 구독 제한을 추가할 수 있습니다.

1. 화면 우측에 있는 지원 센터 아이콘을 클릭합니다.
   ![영역 구독 추가 #4](/assets/img/getting-started/2022/oci-console-regions-subscription-4.png)
2. 클릭 후 팝업되는 레이어에서 **"제한 증가 요청"** 버튼을 클릭합니다.
   ![영역 구독 추가 #5](/assets/img/getting-started/2022/oci-console-regions-subscription-5.png)
3. 클릭 후 이동된 화면에서 아래와 같이 선택 및 입력 합니다.
 - 서비스 범주 : **Regions**
 - 리소스 : **Subscribed region count**
 - 테넌시 제한 : **3** / 각자 현재 제한에서 필요한 만큼 추가한 숫자를 입력합니다.
 - 요청 사유 : **각자 사유를 자유롭게 입력**
 - **"지원 요청 생성"** 버튼 클릭하여 완료 합니다.

   ![영역 구독 추가 #6](/assets/img/getting-started/2022/oci-console-regions-subscription-6.png)
4. 지원 요청이 생성 완료된 이후 일반적으로 1 영업일 이내에 처리가 완료됩니다.

### 콘솔 언어 변경
OCI 콘솔에서는 사용자에 맞게 콘솔 UI에서 표기되는 언어를 변경할 수 있습니다.
1. 우측 상단 "언어" 아이콘을 클릭합니다.
   ![콘솔 언어 변경 #1](/assets/img/getting-started/2022/oci-console-language-change-1.png)
2. 원하는 언어를 선택 후 클릭합니다. (English 선택)
   ![콘솔 언어 변경 #2](/assets/img/getting-started/2022/oci-console-language-change-2.png)
3. 언어 변경이 완료되었습니다. (한국어 -> 영어)
   ![콘솔 언어 변경 #3](/assets/img/getting-started/2022/oci-console-language-change-3.png)
