---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "8월 OCI AI/ML 업데이트 소식"
teaser: "2022년 8월 OCI AI/ML 업데이트 소식입니다."
author: yhcho
breadcrumb: true
categories:
  - release-notes-2022-aiml
tags:
  - oci-release-notes-2022
  - aug-2022
  - AI/ML
  
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

## Introducing Flexible Compute Shapes for Notebook Sessions and Jobs
* **Services:** Data Science
* **Release Date:** Aug 17, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/0e9ab1ea-ea15-4c53-9b7c-22043ffc859a/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/0e9ab1ea-ea15-4c53-9b7c-22043ffc859a/){:target="_blank" rel="noopener"}

### 서비스 소개
노트북 세션은 OCI 데이터 과학(Data Science) 프로젝트에 포함된 서비스로 노트북 세션을 생성하여 JupyterLab 인터페이스의 머신 러닝 라이브러리를 사용하여 Python 코드를 작성하고 실행할 수 있습니다.

### 업데이트 내용
이번 업데이트를 통해 노트북 세션에서 사용하는 Compute Shape에서도 Flex Shape을 선택할 수 있도록 기능이 추가 되었습니다.
- 데이터 과학 프로젝트에서 **"노트북 세션"** -> **"노트북 세션 생성**" 버튼을 클릭합니다.
  ![](/assets/img/aiml/2022/oci-202208-release-md-1.png " ")
- 컴퓨트 섹션의 **"선택"** 버튼을 클릭합니다.
  ![](/assets/img/aiml/2022/oci-202208-release-md-2.png " ")
- AMD, Intel 계열의 Shape에서 Flex Shape이 추가된 것을 확인할 수 있습니다.
  ![](/assets/img/aiml/2022/oci-202208-release-md-3.png " ")
- ![](/assets/img/aiml/2022/oci-202208-release-md-4.png " ")


## New Languages Supported for Speech
* **Services:** Speech
* **Release Date:** Aug 12, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/ba8d3a1b-6d78-47ef-9643-6327427ae37f/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/ba8d3a1b-6d78-47ef-9643-6327427ae37f/){:target="_blank" rel="noopener"}

### 업데이트 소개
OCI 의 AI 서비스 중 하나인 Speech 서비스는 사람의 음성을 포함한 파일 기반의 오디오 데이터를 텍스트 문자로 쉽게 변환할 수 있는 기능을 제공하는 서비스 입니다.
이번 업데이트를 통해 기존에 <mark>영어(English-US), 스페인어(Spanish), 포르투갈어(Portuguese)</mark> 3가지 언어만 지원되던 Speech 서비스에 아래와 같이 새로운 언어(억양)가 추가로 지원됩니다.
- 영어(영국억양)(English-Great Britain)
- 영어(호주억양)(English-Australia)
- 영어(인도억양)(English-India)
- 프랑스어(French)
- 이탈리아어(Italian)
- 독일어(German)
- 힌디어(Hindi)
  ![](/assets/img/aiml/2022/oci-202208-release-md-5.png " ")