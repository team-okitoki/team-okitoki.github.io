---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "10월 OCI AI/ML 업데이트 소식"
teaser: "2022년 10월 OCI AI/ML 업데이트 소식입니다."
author: yhcho
breadcrumb: true
categories:
  - release-notes-2022-aiml
tags:
  - oci-release-notes-2022
  - oct-2022
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

## Addition of new regions
* **Services:** Anomaly Detection
* **Release Date:** Oct 6, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/d0a78dd9-05bc-41aa-a255-89423d552d79/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/d0a78dd9-05bc-41aa-a255-89423d552d79/){:target="_blank" rel="noopener"}

### 업데이트 내용
Anomaly Detection 서비스가 이제 아래 Region에서도 사용하실 수 있게 되었습니다.
- Mexico Central (Queretaro)
- France Central (Paris)

For more information about Anomaly Detection and features in Cloud regions, see:
- [Anomaly Detection](https://docs.oracle.com/iaas/Content/anomaly/using/home.htm)
- [Regions and Availability Domains](https://docs.oracle.com/iaas/Content/anomaly/using/overview.htm#regions)
- [OCI Data Regions](https://www.oracle.com/cloud/data-regions/#lad)


## Language version 2 is now available
* **Services:** Language
* **Release Date:** Oct 27, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/3e8b55ce-4c02-46e0-b017-89ff31414fcc/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/3e8b55ce-4c02-46e0-b017-89ff31414fcc/){:target="_blank" rel="noopener"}

### 업데이트 소개
OCI 의 AI 서비스 중 하나인 Language 서비스에 언어 번역 기능과 Custom Model Train 기능이 추가 되었습니다.
![](/assets/img/aiml/2022/oci-202210-release-aiml-1.png " ")

#### Language Translate 기능 추가 (번역 서비스)
AI Language 서비스에 번역기능이 추가되었습니다. 번역기능은 사전에 학습된 모델을 기반으로 번역이 되며 아래와 같이 다양한 언어의 번역을 지원합니다.
![](/assets/img/aiml/2022/oci-202210-release-aiml-2.png " ")

- 지원언어 (언어 코드는 ISO 639-1 코드로 설정함 [코드정보확인](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes){:target="_blank" rel="noopener"}<br>
  - 아랍어, 브라질-포르투갈, 체코어, 덴마크어, 네덜란드어, 영어, 핀란드어, 프랑스어, 프랑스어-캐나다어, 독일어, 이탈리아어, 일본어, 한국어, 노르웨이어, 폴란드어, 루마니아어, 중국어(간체), 중국어(번체), 스페인어, 스웨덴어, 터키어

- 가격정책
  - 최초 1,000 Transaction 무료, 이후 1,000 Transaction 마다 $10 과금. (AWS는 $15, GCP는 $20)
  - 1개의 Transaction은 최대 1,000개의 글자지원 (공백포함)
  - OCI는 Transaction을 기반으로 요금이 책정되어 있습니다. (1,000글자 보다 적게 요청해도 1개의 Transaction으로 간주함)
  - 예1) 1,010개의 문자 번역 요청 -> 2개 Transaction 발생
  - 예2) 500개의 문자 번역 요청 -> 1개 Transaction 발생

#### Language Custom Model 기능 추가 (사용자 정의 모델 기능 추가)
OCI AI Language 서비스에 Custom Model 훈련 기능이 추가되었습니다.
Custom Model의 경우 Text Classification 과 Named Entity Recognition (NER) 두 가지 타입의 사용자 정의 모델을 생성할 수 있습니다.
사용자 정의 모델은 OCI Data Labeling 기능을 통해서도 Labeling한 데이터로도 생성할 수 있습니다.

- **사용자 정의 모델 사용 사례 (Text Classification)**
  - **Use Case: Assigning Support Tickets**
    - 고객 지원 팀은 구조화되지 않은 자유 형식의 텍스트로 설명된 문제 또는 쿼리가 포함된 수백 개의 이메일 또는 티켓을 받습니다. 이러한 티켓을 신속하게 분류하고 올바른 소유자에게 티켓을 할당하는 것은 빠른 응답 시간을 보장하는 데 매우 중요합니다. 수동 분류는 많은 시간과 자원을 소모하고, 수동 분류를 사용하려면 사람들이 티켓을 읽고 적절한 팀원에게 할당해야 합니다. 대신 사용자 지정 모델을 생성하고 샘플 이메일 또는 지원 티켓에 대해 모델을 교육할 수 있습니다. 그런 다음 모델을 배포하여 새 티켓이나 이메일을 분석하고 분류한 후 적절한 소유자에게 자동으로 할당할지 결정할 수 있습니다.
  - **Use Case: Classifying Documents**
    - 채용 담당자는 작업 기록이나 추천서와 같은 지원자의 문서에 레이블을 수동으로 지정합니다. 수동으로 분류하려면 많은 문서를 읽고 라벨을 적용해야 하지만, 샘플 문서에 대해 훈련된 사용자 정의 텍스트 분류는 파이프라인을 구축하여 각 첨부 파일에 올바른 태그를 자동으로 할당하는 데 도움이 됩니다.

- **사용자 정의 모델 사용 사례 (Named Entity Recognition (NER))**
  - **Use Case: Extracting Custom Entities**
    - 인사 부서는 제안서, 채용 공고, 후보 프로필, 면접 노트 등과 같은 상당한 양의 비정형 데이터를 생성, 저장 및 처리합니다. 사전 교육을 받은 모델은 사전 훈련된 모델은 DATE와 같은 엔터티만 인식할 수 있지만 도메인 또는 제공된 후보 이름, 제공된 날짜, 채용 관리자 및 가입 날짜와 같은 비즈니스별 엔터티를 추출할 수 없습니다. 오퍼 레터와 같은 샘플 데이터 파일에서 사용자 정의 모델을 교육할 수 있습니다. 훈련된 모델은 제공된 사람, 제공된 엔터티, 감독자 및 HR 대표 이름과 같은 비즈니스 엔터티를 추출할 수 있다.
  - **Use Case: Retrieving Information**
    - 한 금융 서비스 회사가 자사의 정보 검색 시스템에서 보다 쉽게 결과를 얻을 수 있도록 계약에서 특정 주체를 추출하려고 합니다. 그들은 나중에 고객이 계약을 필터링할 수 있도록 그러한 엔티티를 추출하려고 한다. 예를 들어, 2022년 1월 1일 이후의 "유효일"과 3년 이상의 "기간"이 있는 계약만 표시하도록 필터링할 수 있습니다. 사용자 정의 모델을 사용하여 계약 기간, 유효 날짜, 서명 날짜, 공개자 및 수신자와 같은 서로 다른 엔티티를 식별할 수 있습니다. 이러한 엔터티를 추출한 후에는 검색 하위 시스템에서 엔터티를 필터 및 facets 으로 사용할 수 있습니다.
    
- **가격정책**
  - 최초 15시간 사용자정의 모델 훈련 무료
  - 이후 시간당 $1.50 비용 발생함
  - Custom Model의 경우 1,000개의 Transaction당 $3.5 비용이 발생함