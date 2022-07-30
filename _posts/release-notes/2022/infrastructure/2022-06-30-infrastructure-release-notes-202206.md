---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "6월 OCI Infrastructure 업데이트 소식"
teaser: "2022년 6월 OCI Infrastructure 업데이트 소식입니다."
author: kskim
breadcrumb: true
categories:
  - release-notes-2022-infrastructure
tags:
  - oci-release-notes-2022
  - June-2022
  - Infrastructure

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

## Ultra High Performance level now supported for boot volumes
* **Services:** Block Volume
* **Release Date:** June 28, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/4d1cdf63-3d2f-4a46-a435-b21aff1eff65/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/4d1cdf63-3d2f-4a46-a435-b21aff1eff65/){:target="_blank" rel="noopener"}

### 기능 소개
반가상화 연결이 있는 VM 인스턴스의 부팅 볼륨은 초고성능 수준을 지원합니다.
- 고성능으로 변경할때, 부팅 볼륨을 분리했다가 다시 연결해야합니다.
- 볼륨 크기에 따른 성능이 다릅니다. 따라서 볼륨 크기에 따른 성능은 아래와 같습니다. 

![](/assets/img/infrastructure/2022/06/uhp01.png)


