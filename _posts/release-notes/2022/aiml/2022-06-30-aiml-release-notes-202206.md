---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "6월 OCI AI/ML 업데이트 소식"
teaser: "2022년 6월 OCI AI/ML 업데이트 소식입니다."
author: yhcho
breadcrumb: true
categories:
  - release-notes-2022-aiml
tags:
  - oci-release-notes-2022
  - june-2022
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

## ADS JupyterLab UI Enhancements
* **Services:** Data Science
* **Release Date:** June 9, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/3f43adf7-d2ec-4aed-a676-781262e15c62/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/3f43adf7-d2ec-4aed-a676-781262e15c62/){:target="_blank" rel="noopener"}

### 서비스 소개
OCI Data Science 에서는 Data Science 모델 작업을 위한 JupyterLab Notebook 세션을 제공합니다. 노트북 세션에서는 다양한 워크로드에서 활용할 수 있는 Conda 환경을 제공하고 있으며, Conda 환경을 탐색할 수 있는 **Environment Explorer** 를 제공합니다.

### 업데이트 내용

#### The Environment Explorer 탭의 기능이 추가 되었습니다.
- 콘다 환경을 쉽게 설치, 복제, 게시, 제거할 수 있는 Action Menu가 추가되었습니다.
  ![Environment Explorer #1](/assets/img/aiml/2022/oci-202205-release-notebook-1.png)
  ![Environment Explorer #2](/assets/img/aiml/2022/oci-202205-release-notebook-2.png)
- Conda 환경의 **"Description"** 섹션에서 해당 환경의 최신버전에서 업데이트된 내용을 제공합니다.
  ![Environment Explorer #3](/assets/img/aiml/2022/oci-202205-release-notebook-3.png)

#### The Launcher tab 개선사항
- 설정 섹션에서 간편하게 오브젝트 스토리지 버킷에 대한 설정을 할 수 있습니다. 버킷을 설정하면 특정 Conda 환경 및 결과물을 게시할때 사용됩니다.
  ![Launcher #1](/assets/img/aiml/2022/oci-202205-release-notebook-4.png)
- 런처 화면에서 설치되어 있는 Conda 환경을 Publish 할 수 있는 메뉴가 추가되었습니다.
  ![Launcher #1](/assets/img/aiml/2022/oci-202205-release-notebook-5.png)

---

## The Data Labeling V3 Release is now Available
* **Services:** Data Labeling
* **Release Date:** June 22, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/e2fbe612-239c-4704-8008-3932576dfacd/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/e2fbe612-239c-4704-8008-3932576dfacd/){:target="_blank" rel="noopener"}

### 서비스 소개
OCI에서는 텍스트 또는 이미지로 구성된 데이터셋을 AI 또는 ML 에서 활용할 수 있도록 라벨링 할 수 있는 서비스인 Data Labeling 서비스를 제공합니다.
- Data Labeling 예시 **(데이터셋 준비 -> 데이터 라벨링 -> 모델 학습 -> 모델 배포)**
  ![Data Labeling 예시 #1](/assets/img/aiml/2022/oci-202206-release-datalabeling-1.png)
- OCI Data Labeling 서비스 구성 예시
  ![Data Labeling 예시 #2](/assets/img/aiml/2022/oci-202206-release-datalabeling-2.png)

### 업데이트 내용
기존 V2 까지 공개되었던 데이터 라벨링 서비스에서 이번 업데이트를 통해 V3를 공개하였습니다. V3에서 추가된 기능은 아래와 같습니다.

- 이제 CSV 파일에서 텍스트 기반 [데이터셋을 생성](https://docs.oracle.com/iaas/data-labeling/data-labeling/using/datasets.htm#dataset-create){:target="_blank" rel="noopener"}할 수 있습니다.
  - 처음 5개의 열과 행이 미리 보기로 표시됩니다.
  - 열 구분 기호, 줄 구분 기호 및 이스케이프 문자를 지정합니다. 모든 구분 기호를 사용자가 지정할 수 있습니다.
- Data-set을 JSONL Compact Plus Content format 으로 내보낼 수 있도록 기능이 추가 되었습니다.
- 데이터셋의 레코드를 [소스 코드](https://github.com/oracle-samples/oci-data-science-ai-samples/tree/master/data_labeling_examples){:target="_blank" rel="noopener"}를 통해 대량으로 라벨링 할 수 있습니다.
  - 크게 BOUNDING_BOX(위치 지정 라벨링), CLASSIFICATION(분류)) 방식으로 라벨링을 할 수 있도록 제공함
  - CLASSIFICATION(분류)) 의 경우 FIRST_LETTER_MATCH(첫글자 매칭), FIRST_REGEX_MATCH(정규식 매칭), CUSTOM_LABELS_MATCH(사용자 정의 매칭) 유형을 제공함.


        - FIRST_LETTER_MATCH: The first letter of the DLS Dataset record's name must be equal to the first letter of the label that the record will be annotated with. The matching is not case-sensitive.
        Consider a dataset having following records: cat1.jpeg, cat2.jpeg, dog1.png, dog2.png
        Label Set: cat , dog 
        Result of FIRST_LETTER_MATCH labeling algorithm: 
            cat1.jpeg will be labeled with cat label
            cat2.jpeg will be labeled with cat label
            dog1.png will be labeled with dog label
            dog2.png will be labeled with dog label

        - FIRST_REGEX_MATCH: The regular expression (regex) pattern assigned to _FIRST_MATCH_REGEX_PATTERN_ will be applied to the DLS Dataset record's name, and the first capture group extracted must be equal to the label that the record will be annotated with.
        Consider a dataset having following records: PetCat1.jpeg, PetCat2.jpeg, PetDog1.png, PetDog2.png
        Label Set: cat , dog 
        FIRST_MATCH_REGEX_PATTERN : ^([^\/]*)\/.*$
        Result of FIRST_REGEX_MATCH labeling algorithm: 
            PetCat1.jpeg will be labeled with cat label
            PetCat2.jpeg will be labeled with cat label
            PetDog1.png will be labeled with dog label
            PetDog2.png will be labeled with dog label


        - CUSTOM_LABELS_MATCH: This algorithm takes object storage path as input along with the label that needs to be applied to records under that path. Only root level path is supported. Multiple labels can also be assigned to a given path. The labeling algorithm for this case is .
        Consider a dataset having following records:
        cat/cat1.jpeg, cat/cat2.jpeg, dog/dog1.jpeg, dog/dog2.jpeg
        Labels in dataset: dog, pup, cat, kitten
        CUSTOM_LABELS={ "dog/": ["dog","pup"], "cat/": ["cat", "kitten"] }
        Result of CUSTOM_LABELS_MATCH algorithm: 
            cat/cat1.jpeg will be labeled with cat and kitten labels
            cat/cat2.jpeg will be labeled with cat and kitten labels
            dog/dog1.png will be labeled with dog and pup labels
            dog/dog2.png will be labeled with dog and pup labels
 
  - BOUNDING_BOX는 레코드별로 OCI, BOX의 4개 좌표값, 라벨링 정보를 CSV 형태로 사전 정의가 필요합니다.
    ![데이터 예시](/assets/img/aiml/2022/oci-202206-release-datalabeling-3.png)
- [샘플 코드를 활용하여 Python 코드를 활용하여 OCI DLS(Data Labeling Service)의 레코드에 라벨링 하기](/aiml/bulk-labeling-with-python-code/){:target="_blank" rel="noopener"} 에서 자세한 내용을 확인할 수 있습니다.
<br><br>

---

## Launch of the Notebook Explorer
* **Services:** Data Science
* **Release Date:** June 30, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/988eb1cd-2844-4bf2-94f6-a0f3da94d3e3/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/988eb1cd-2844-4bf2-94f6-a0f3da94d3e3/){:target="_blank" rel="noopener"}

### 서비스 소개
OCI 데이터 과학의 Jupyter Notebook 세션에 Notebook Explorer 기능이 추가되었습니다. 이 기능을 통해서 다양한 콘다환경의 Notebook Example을 콘다환경 설치 없이 탐색하고 확인할 수 있게 되었습니다.
![Notebook Explorer #1](/assets/img/aiml/2022/oci-202205-release-notebook-6.png)
![Notebook Explorer #2](/assets/img/aiml/2022/oci-202205-release-notebook-7.png)

---