---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "9월 OCI AI/ML 업데이트 소식"
teaser: "2022년 9월 OCI AI/ML 업데이트 소식입니다."
author: yhcho
breadcrumb: true
categories:
  - release-notes-2022-aiml
tags:
  - oci-release-notes-2022
  - set-2022
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

## Accelerated Data Science 2.6.4 is released
* **Services:** Data Science
* **Release Date:** Sept. 14, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/46f1119d-f159-4ab7-8e0c-140a0cd8b7da/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/46f1119d-f159-4ab7-8e0c-140a0cd8b7da/){:target="_blank" rel="noopener"}

### 업데이트 내용
ADS 2.6.4 버전에서 Model Artifacts의 크기가 2-6GB 까지 지원하게 되었습니다.
2기가 이상의 Artifacts를 사용하기 위해서 먼저 Object Storage에 업로드하고, Model Catalog로 전송하도록 구성해야 합니다.
자세한 내용은 [Large-model-artifacts](https://docs.oracle.com/en-us/iaas/tools/ads-sdk/latest/user_guide/model_catalog/model_catalog.html#large-model-artifacts){:target="_blank" rel="noopener"} 에서 확인하실 수 있습니다.
