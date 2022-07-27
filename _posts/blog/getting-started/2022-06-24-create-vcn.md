---
layout: page-fullwidth
#
# Content
#
subheadline: "Networking"
title: "OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기"
teaser: "Oracle Cloud Infrastructure (이하 OCI)에서는 가상 클라우드 네트워크 (VCN)을 쉽게 생성할 수 있도록 도와주는 Quick Wizard를 제공합니다. 이번 포스팅에서는 Quick Wizard를 활용하여 빠르게 VCN을 생성하는 방법에 대해서 알아봅니다."
author: dankim
breadcrumb: true
date: 2022-06-24 00:00:00
categories:
  - getting-started
tags:
  - oci
  - vcn
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

### VCN 생성
VCN 생성 Wizard를 활용하여 간단하게 VCN을 하나 구성합니다. 아래와 같이 Networking > Virtual Cloud Networks를 선택한 후 **Start VCN Wizard**를 클릭합니다.

![](/assets/img/getting-started/2022/create-vcn-1.png)

**Create VCN with Internet Connectivity**를 선택한 후 **Start VCN Wizard**를 클릭합니다.

![](/assets/img/getting-started/2022/create-vcn-2.png)

VCN 이름을 입력한 후 **Next**를 선택합니다.
- VCN Name: my-vcn

![](/assets/img/getting-started/2022/create-vcn-3.png)

생성되는 VCN 정보를 검토하고 **Create** 버튼을 클릭합니다.

![](/assets/img/getting-started/2022/create-vcn-4.png)

VCN 관련 리소스들이 정상적으로 생성이 완료된 것을 확인할 수 있습니다.

![](/assets/img/getting-started/2022/create-vcn-5.png)

### VCN 정보 및 리소스 확인
위의 생성된 VCN 리소스 화면에서 **View Virtual Cloud Network**을 선택하거나 **Networking > Virtual Cloud Networks > 생성한 VCN**을 선택하여 VCN Detail 화면으로 이동합니다.

다음과 같이 VCN내에 생성된 리소스 (Subnet, Route Tables, Internet Gateway, NAT Gateway, Security List 등)가 생성된 것을 확인할 수 있으며, VCN에 대한 상세 정보도 같이 확인할 수 있습니다.

![](/assets/img/getting-started/2022/create-vcn-6.png)