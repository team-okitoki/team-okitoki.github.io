---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "5월 OCI AI/ML 업데이트 소식"
teaser: "2022년 5월 OCI AI/ML 업데이트 소식입니다."
author: yhcho
breadcrumb: true
categories:
  - release-notes-2022-aiml
tags:
  - oci-release-notes-2022
  - may-2022
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


## Accelerated Data Science v2.5.10 is released
* **Services:** Data Science
* **Release Date:** May 6, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/0e643b8f-cca1-4f03-90d5-86a7e83fd9ae/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/0e643b8f-cca1-4f03-90d5-86a7e83fd9ae/){:target="_blank" rel="noopener"}

### 서비스 소개
Oracle ADS(Accelerated Data Science) SDK는 OCI Data Science 서비스의 일부로 포함된 Python 라이브러리입니다. ADS는 데이터 수집에서 모델 평가 및 해석에 이르기까지 기계 학습 모델의 수명 주기와 관련된 모든 단계를 다루는 개체 및 방법을 통해 친숙한 사용자 인터페이스를 제공합니다.

### OCI ADS 설치 방법
```terminal
$ python3 -m pip install oracle-ads
```

### 업데이트 내용
- 빅데이터 서비스에 연결하기 위한 <mark>BDSSecretKeeper</mark> 클래스에서 OCI Vault 서비스에 저장된 자격증명을 이용할 수 있도록 개선되었습니다.<br>[자세한 내용 확인](https://docs.oracle.com/en-us/iaas/tools/ads-sdk/latest/user_guide/big_data_service/connect.html#using-the-vault){:target="_blank" rel="noopener"}
- 빅데이터 서비스에 연결하기 위해 OCI Vault 없이 수동으로 연결을 구성하기 위한 <mark>krbcontext</mark> 와 <mark>refresh_ticket</mark> 기능이 추가 되었습니다.<br>[자세한 내용 확인](https://docs.oracle.com/en-us/iaas/tools/ads-sdk/latest/user_guide/big_data_service/connect.html#without-using-the-vault){:target="_blank" rel="noopener"}
- ADS Configuration 구성파일 경로를 지정할 수 있도록 <mark>set_auth</mark> 메서드가 추가 되었습니다. 이 기능을 통해 OCI ADS 구성파일의 경로를 변경할 수 있습니다.<br>[사용 예시 확인](https://docs.oracle.com/en-us/iaas/tools/ads-sdk/latest/user_guide/big_data_service/quick_start.html?highlight=set+auth){:target="_blank" rel="noopener"}
- OCI CLI 요구사항을 <mark>2.59.0</mark> 버전이상으로 변경하였습니다.

---


## Introducing Bring Your Own Container
* **Services:** Data Science
* **Release Date:** May 26, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/a569bbf6-4fb3-4f59-964b-cae816a3ccbd/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/a569bbf6-4fb3-4f59-964b-cae816a3ccbd/){:target="_blank" rel="noopener"}

### 서비스 소개
사용자가 직접 구성한 컨테이너 이미지를 사용하여 Data Science의 <mark>Job</mark> 또는 <mark>Job Runs</mark>를 실행할 수 있도록 기능이 추가 되었습니다.

### 사전 요구 사항
- 사용자가 별도로 도커로 빌드한 이미지가 **OCI 컨테이너 레지스트리**에 업로드 되어 있어야 합니다.
- 업로드된 이미지의 OCID를 확인 후 복사합니다.
![OCIR 예시](/assets/img/aiml/2022/oci-202205-release-ocir.png " ")

### Bring Your Own Container 적용 예시
1. **"데이터 과학"** 메뉴로 이동하여 프로젝트로 이동합니다. (프로젝트가 없는 경우 생성 필요)
   ![BYOC 예시](/assets/img/aiml/2022/oci-202205-release-byoc-1.png " ")
2. **"작업생성"** 버튼을 클릭합니다.
   ![BYOC 예시](/assets/img/aiml/2022/oci-202205-release-byoc-2.png " ")
3. 작업생성 화면에서 **"자체 컨테이너 적용"**을 체크하고 복사한 *컨테이너 저장소에 저장한 이미지의 OCID*를 붙여넣습니다.
   ![BYOC 예시](/assets/img/aiml/2022/oci-202205-release-byoc-3.png " ")
4. 다른 선택사항을 기존과 동일하게 선택하고 **"생성"** 버튼을 클릭 합니다.