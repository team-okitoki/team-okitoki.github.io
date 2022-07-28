---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "7월 OCI AI/ML 업데이트 소식"
teaser: "2022년 7월 OCI AI/ML 업데이트 소식입니다."
author: yhcho
breadcrumb: true
categories:
  - release-notes-2022-aiml
tags:
  - oci-release-notes-2022
  - july-2022
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

## Introducing Flexible Compute Shapes for Model Deployments
* **Services:** Data Science
* **Release Date:** July 19, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/27d18354-2b4c-4b7d-958b-8c90a909bca3/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/27d18354-2b4c-4b7d-958b-8c90a909bca3/){:target="_blank" rel="noopener"}

### 서비스 소개
모델 배치(Model Deployments)는 OCI에서 ML 학습 모델을 HTTP End-Point 통해 배치할 수 있는 OCI 데이터 과학 서비스의 관리 리소스입니다. 
실시간으로 예측을 제공하는 Web Application(HTTP API 끝점)으로 ML 라이브러리 모델을 배포하는 것은 모델이 소비되는 가장 일반적인 방법 중 하나이며, 모델 배치를 통해 생성된 HTTP 엔드포인트는 유연하게 Model Prediction 요청을 처리할 수 있습니다.   
![](/assets/img/aiml/2022/oci-202207-release-flow-to-deploy.png " ")

### 업데이트 내용
이번 업데이트를 통해 모델 배포에서 사용하는 Compute Shape에서도 Flex Shape을 선택할 수 있도록 기능이 추가 되었습니다.
- 데이터 과학 프로젝트에서 **"모델 배치"** -> **"모델 배치 생성**" 버튼을 클릭합니다.
  ![](/assets/img/aiml/2022/oci-202207-release-md-1.png " ")
- 컴퓨트 섹션의 **"선택"** 버튼을 클릭합니다.
  ![](/assets/img/aiml/2022/oci-202207-release-md-2.png " ")
- AMD, Intel 계열의 Shape에서 Flex Shape이 추가된 것을 확인할 수 있습니다.
  ![](/assets/img/aiml/2022/oci-202207-release-md-3.png " ")
- ![](/assets/img/aiml/2022/oci-202207-release-md-4.png " ")