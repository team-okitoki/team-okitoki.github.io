---
layout: page-fullwidth
#
# Content
#
subheadline: "Concepts"
title: "OCI 주요 컨셉 및 용어 정리"
teaser: "Oracle Cloud Infrastructure 를 시작하는데 도움이 되는 주요 개념과 용어의 간단한 설명을 제공합니다."
author: yhcho
date: 2022-06-30 00:00:00
breadcrumb: true
comments: true
categories:
  - getting-started
tags:
  - oci
  - concepts
  - key concepts
  - terminology
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

### 주요 개념 및 용어
Oracle Cloud Infrastructure(OCI)를 시작하려는 사용자에게 도움이 되는 OCI의 주요 개념과 용어에 대한 설명입니다.
이 포스트에서는 주요 개념 및 용어에 대한 간단한 설명만 제공하고 있습니다.

#### Tenancy
Oracle Cloud Infrastructure(OCI) 에 등록하면 Oracle이 고객을 위한 Tenancy(테넌트)를 생성합니다.
이 테넌트는 클라우드 리소스를 생성, 구성 및 관리할 수 있는 Oracle Cloud Infrastructure(OCI) 내의 안전한 격리된 파티션입니다.

#### Instance
Instance(인스턴스)는 클라우드에서 실행되는 컴퓨팅 호스트입니다.
Oracle Cloud Infrastructure(OCI) 컴퓨팅 인스턴스를 사용하면 기존의 소프트웨어 기반 가상 시스템이 아닌 호스팅된 물리적 하드웨어를 활용하여 높은 수준의 보안 및 성능을 보장할 수 있습니다.

##### Types Of Compute Instances
- **Bare Metal Instance** : Oracle Cloud Infrastructure는 물리적 호스트("bare metal") 시스템을 제어할 수 있도록 지원합니다. Bare Metal Instance(BM)는 물리적인 서버를 하이퍼바이저 없이 **단일 사용자(테넌트)에게 전용으로 사용할 수 있는 컴퓨팅 환경을 제공합니다**. 물리적 CPU, 메모리 및 NIC(네트워크 인터페이스 카드)를 단독으로 제어할 수 있기 때문에 서버자원의 성능을 100% 사용할 수 있어서 높은 성능을 제공합니다.
- **Virtual Machine Instance** : Virtual Machine Instance(VM)는 물리적인 서버위에 하이퍼바이저에 의해 가상화된 환경을 통해 컴퓨팅 환경을 제공하며, **단일 사용자가 아닌 다중 사용자가 환경을 공유 합니다**. 하이퍼바이저에 의해 가상화된 계층에서 컴퓨팅 자원이 실행되기 때문에 Bare Metal 보다 상대적으로 낮은 성능을 제공합니다.
- **Dedicated VM Host** : Dedicated VM Host는 BM과 VM의 조합입니다. 일반적인 VM과는 달리 단일 사용자에게 할당된 Bare Metal 서버위에 VM 환경이 제공되기 때문에 공유 인프라를 사용하지 못하도록 하는 격리에 대한 규정 준수 및 관련 요구사항을 충족할 수 있습니다. 하지만 VM에 비교하여 지원하는 Shape이 제한적이고, 인스턴스와 관련된 기능 중 자동확장,인스턴스 구성,인스턴스 풀 등 일부 기능을 지원하지 않습니다.
![OCI Compute Types](/assets/img/getting-started/2022/oci-compute-types.png " ")

#### Shape
Compute 리소스 또는 Load Balancing 리소스에 대한 사양을 구성하는 조합입니다.
Compute 에 대한 Shape는 인스턴스에 할당된 CPU 수와 메모리 양을 지정하고, Load Balancing에 대한 Shape는 수신 트래픽과 송신 트래픽에 대해 로드 밸런서의 사전 프로비저닝된 총 최대 용량(bandwidth)을 결정합니다.

##### Types of Shape (Load Balancing)
- **Fixed Shape (Dynamic)** : Load Balancer의 네트워크 대역폭이 100Mbps, 400Mbps, 8,000Mbps 크기로 고정되어있는 Shape 입니다. <mark style="background-color:#fff5b1">현재는 일부 레거시 사용자의 Tenancy 에서만 제한적으로 생성이 가능하고, <b>2023년 5월 11일부터는 새로운 고정형태의 LB를 생성할 수 없습니다.</b></mark>
- **Flexible Shape** : Load Balancer의 네트워크 대역폭을 최소 대역폭과 최대 대역폭을 직접 지정하여 LB의 네트워크 대역폭을 지정하는 유연한 형태의 Shape 입니다. 고정형태와 동일하게 사용하고 싶은 경우 최소,최대 대역폭을 동일하게 지정하여 사용이 가능합니다.

##### Types of Shape (Compute)
Compute Shape는 인스턴스에 할당할 CPU, Memory, Storage의 조합입니다. Oracle Infrastructure에서는 여러가지 미리 정의된 Shape을 제공합니다. 자세한 내용은 [컴퓨트 Shapes](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm)를 참조하세요.
- **Standard Shape** : 일반적인 워크로드에 적합한 Shape으로써 CPU 코어, Memory, 네트워크 리소스의 균형적인 사양을 제공합니다. Intel 및 AMD 프로세서에서 사용할 수 있습니다. 
- **DenseIO Shape** : DenseIO Shape에는 NVMe기반 SSD로 구성된 Storage를 포함하고 있기 때문에, 고성능 Storage가 필요한 Big Data, 대용량 Database등 워크로드에 적합합니다. 
- **GPU Shape** : CPU와 GPU 조합으로 하드웨어 가속(hardware acceleration)이 필요한 워크로드에 적합한 사양을 제공합니다. GPU Shape에는 Intel CPU와 NVIDIA GPU가 포함됩니다.
- **High-perfomance Computing (HPC) Shapes** : 높은 사양의 CPU 와 대규모 병렬 HPC 워크로드를 위한 Cluster Networking이 필요한 고성능 워크로드에 적합한 사양을 제공합니다. HPC Shape는 Bare Metal Instance 에서만 제공합니다.

#### Regions and Availability Domains(AD)
Oracle Cloud Infrastructure(OCI) 는 Regions 및 Availability Domains(AD)에서 물리적으로 호스팅됩니다. 
Regions은 지리적 영역이며 Avalability Domains(AD)은 특정 Regions 내에 위치한 데이터 센터입니다. 각각의 Regions은 하나 이상의 가용성 도메인(AD)으로 구성되어 있습니다.

Avalability Domain은 동시에 장애가 발생하거나, 다른 Avalability Domain의 영향으로 장애가 발생할 가능성이 매우 낮도록 설계되어있습니다. 
따라서 클라우드 서비스를 구성할 때 고가용성(HA)을 보장하고 리소스 장애를 방지하기 위해서는 Regions의 여러 가용성 도메인(AD)을 사용해야 합니다. 
다만 컴퓨트 인스턴스 및 인스턴스에 연결된 스토리지 볼륨과 같은 일부 리소스는 동일한 가용성 도메인(AD) 내에서 생성되어야 하기 때문에 서비스 구성시 이 부분을 고려야해 합니다.
자세한 내용은 [지역 및 가용성 도메인](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm#top) 을 참조하십시오.

<details>
<summary><b style="color:blue;">Oracle Cloud Infrastructure Commercial Regions 목록 보기 (클릭)</b></summary>
<div markdown="1">
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">Region Name</th>
      <th class="entry" id="About__entry__2">Region Identifier</th>
      <th class="entry" id="About__entry__3">Region Location</th>
      <th class="entry" id="About__entry__4">Region Key</th>
      <th class="entry" id="About__entry__5">Realm  Key</th>
      <th class="entry" id="About__entry__6">Availability Domains</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Australia East (Sydney)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-sydney-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Sydney, Australia</td>
      <td class="entry" headers="About__entry__4"><span class="ph">SYD</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Australia Southeast (Melbourne)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-melbourne-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Melbourne, Australia</td>
      <td class="entry" headers="About__entry__4"><span class="ph">MEL</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Brazil East (Sao Paulo)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">sa-saopaulo-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Sao Paulo, Brazil</td>
      <td class="entry" headers="About__entry__4"><span class="ph">GRU</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Brazil Southeast (Vinhedo)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">sa-vinhedo-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Vinhedo, Brazil</td>
      <td class="entry" headers="About__entry__4"><span class="ph">VCP</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Canada Southeast (Montreal)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ca-montreal-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Montreal, Canada</td>
      <td class="entry" headers="About__entry__4"><span class="ph">YUL</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Canada Southeast (Toronto)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ca-toronto-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Toronto, Canada</td>
      <td class="entry" headers="About__entry__4"><span class="ph">YYZ</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Chile (Santiago)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">sa-santiago-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Santiago, Chile</td>
      <td class="entry" headers="About__entry__4"><span class="ph">SCL</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">France Central (Paris)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">eu-paris-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Paris, France</td>
      <td class="entry" headers="About__entry__4"><span class="ph">CDG</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">France South (Marseille)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">eu-marseille-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Marseille, France</td>
      <td class="entry" headers="About__entry__4"><span class="ph">MRS</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Germany Central (Frankfurt)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">eu-frankfurt-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Frankfurt, Germany</td>
      <td class="entry" headers="About__entry__4"><span class="ph">FRA</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">3</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">India South (Hyderabad)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-hyderabad-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Hyderabad, India</td>
      <td class="entry" headers="About__entry__4"><span class="ph">HYD</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1 </td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">India West (Mumbai)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-mumbai-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Mumbai, India</td>
      <td class="entry" headers="About__entry__4"><span class="ph">BOM</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1 </td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Israel Central (Jerusalem)</span></td>
      <td class="entry" headers="About__entry__2"><span class="ph">il-jerusalem-1</span></td>
      <td class="entry" headers="About__entry__3">Jerusalem, Israel</td>
      <td class="entry" headers="About__entry__4"><span class="ph">MTZ</span></td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Italy Northwest (Milan)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">eu-milan-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Milan, Italy</td>
      <td class="entry" headers="About__entry__4"><span class="ph">LIN</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Japan Central (Osaka)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-osaka-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Osaka, Japan</td>
      <td class="entry" headers="About__entry__4"><span class="ph">KIX</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Japan East (Tokyo)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-tokyo-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Tokyo, Japan</td>
      <td class="entry" headers="About__entry__4"><span class="ph">NRT</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Netherlands Northwest (Amsterdam)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">eu-amsterdam-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Amsterdam, Netherlands</td>
      <td class="entry" headers="About__entry__4"><span class="ph">AMS</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Saudi Arabia West (Jeddah)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">me-jeddah-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Jeddah, Saudi Arabia</td>
      <td class="entry" headers="About__entry__4"><span class="ph">JED</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Singapore (Singapore)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-singapore-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Singapore,Singapore</td>
      <td class="entry" headers="About__entry__4"><span class="ph">SIN</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">South Africa Central (Johannesburg)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">af-johannesburg-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Johannesburg, South Africa</td>
      <td class="entry" headers="About__entry__4"><span class="ph">JNB</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">South Korea Central (Seoul)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-seoul-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Seoul, South Korea</td>
      <td class="entry" headers="About__entry__4"><span class="ph">ICN</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">South Korea North (Chuncheon)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">ap-chuncheon-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Chuncheon, South Korea</td>
      <td class="entry" headers="About__entry__4"><span class="ph">YNY</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Sweden Central (Stockholm)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">eu-stockholm-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Stockholm, Sweden</td>
      <td class="entry" headers="About__entry__4"><span class="ph">ARN</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Switzerland North (Zurich)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">eu-zurich-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Zurich, Switzerland</td>
      <td class="entry" headers="About__entry__4"><span class="ph">ZRH</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">UAE Central (Abu Dhabi)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">me-abudhabi-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Abu Dhabi, UAE</td>
      <td class="entry" headers="About__entry__4"><span class="ph">AUH</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">UAE East (Dubai)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">me-dubai-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Dubai, UAE</td>
      <td class="entry" headers="About__entry__4"><span class="ph">DXB</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">UK South (London)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">uk-london-1</span>
      </td>
      <td class="entry" headers="About__entry__3">London, United Kingdom</td>
      <td class="entry" headers="About__entry__4"><span class="ph">LHR</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">3</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">UK West (Newport)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">uk-cardiff-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Newport, United Kingdom</td>
      <td class="entry" headers="About__entry__4"><span class="ph">CWL</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">US East (Ashburn)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">us-ashburn-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Ashburn, VA</td>
      <td class="entry" headers="About__entry__4"><span class="ph">IAD</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">3</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">US West (Phoenix)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">us-phoenix-1</span>
      </td>
      <td class="entry" headers="About__entry__3">Phoenix, AZ </td>
      <td class="entry" headers="About__entry__4"><span class="ph">PHX</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">3</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">US West (San Jose)</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">us-sanjose-1</span>
      </td>
      <td class="entry" headers="About__entry__3">San Jose, CA </td>
      <td class="entry" headers="About__entry__4"><span class="ph">SJC</span>
      </td>
      <td class="entry" headers="About__entry__5">OC1</td>
      <td class="entry" headers="About__entry__6">1</td>
      </tr>
      </tbody>
</table>
</div>
</details>

#### Fault Domains
Fault Domain은 Avalability Domain에 구성되어있는 하드웨어와 Infrastructure의 그룹입니다. 
하나의 Availability Domain에는 각 3개의 Fault Domain으로 구성되어 있으며, Availability Domain에서 발생할 수 있는 하드웨어 장애나 계획된 유지보수 작업을 수행할 때 서비스에 영향을 주지 않기 위해서 구성할 때 사용합니다.

#### Console
Oracle Cloud Infrastructure에 액세스하고 관리하는 데 사용할 수 있는 간단하고 직관적인 웹 기반 사용자 인터페이스입니다. 
  - OCI Console 화면 예시 : **Get Started**
      ![OCI Console 화면](/assets/img/getting-started/2022/oci-console-getting-started.png " ")

  - OCI Console 화면 예시 : **Dash Board**
      ![OCI Console Dashboard](/assets/img/getting-started/2022/oci-console-dashboard.png " ")
  
#### Oracle Cloud Identifier(OCID)
모든 오라클 클라우드 인프라 리소스에는 오라클 OCID(Oracle Cloud Identifier)라는 오라클이 할당한 고유 ID가 있습니다. 이 ID는 콘솔 및 API에서 리소스 정보의 일부로 포함됩니다.
OCID 구문에 대한 자세한 내용은 [리소스 식별자](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/identifiers.htm#Resource_Identifiers) 를 참조하십시오.

#### Compartments
Compartments(구획)는 OCI 리소스를 관리하기 위한 논리적인 그룹입니다. 일반적으로 서비스 별로 구획을 구분하거나, 조직별로 구획을 구분하여 클라우드 리소스에 대한 액세스를 쉽게 구성하고 제어할 수 있을 뿐만 아니라 OCI Console에서 리소스 작업을 시작하면 구획이 사용자가 보고 있는 리소스에 대한 필터 역할을 합니다. 
사용자의 테넌트가 구성되면 최초 Root Compartment가 자동으로 생성되고 클라우드 관리자가 Root Compartment 하위로 새로운 Compartment를 생성할 수 있습니다. (생성한 구획 하위에 추가로 중첩하여 생성도 가능합니다.)
생성한 Compartment에 정책을 생성하여 사용자들이 접근할 수 있는 리소스를 제한하도록 관리할 수 있습니다.

#### Security Zones
Security Zones(보안 영역)은 Compartments(구획)과 연결됩니다. Security Zones(보안 영역)에 클라우드 리소스를 생성하고 업데이트하면 Oracle Cloud Infrastructure(OCI)는 해당 리소스가 보안 영역 정책에 부합하는지에 대해 검증하는 작업을 실행합니다. 
만약, 생성하려는 리소스가 정책을 위반하면 작업은 거부됩니다. 보안 영역을 사용하면 리소스가 OCI 보안 원칙이나 사용자가 정의한 정책을 준수하고 있다는 것을 확신할 수 있습니다.

#### Virtual Cloud Network (VCN)
Virtual Cloud Network(가상 클라우드 네트워크)는 인스턴스가 실행되는 Subnet, Route Table 및 Gateway를 포함한 기존 네트워크의 가상 버전입니다. 
클라우드 네트워크는 단일 Region 내에 있지만 모든 Region 의 Availability Domains(가용성 도메인)을 포함합니다. 
클라우드 네트워크에서 정의하는 각 서브넷은 단일 가용성 도메인(AD)에 있거나 해당 영역의 모든 가용성 도메인(AD)에 걸쳐 있을 수 있습니다(모든 가용성 도메인에 설정하는것을 권장합니다). 
OCI 에서 Compute Instance를 시작하려면 클라우드 네트워크를 하나 이상 설정해야 합니다. 
Public Traffic을 처리할 선택적 인터넷 게이트웨이와 On-Premises 네트워크를 안전하게 확장하기 위한 IPSec Connection 또는 FastConnect를 사용하여 클라우드 네트워크를 구성할 수 있습니다.

#### Image
Image(이미지)는 운영 체제 및 오라클 리눅스 등의 다른 소프트웨어를 정의하는 가상 하드 드라이브의 템플릿입니다. 
인스턴스를 실행할 때 이미지를 선택하여 인스턴스 특성을 정의할 수 있습니다. Oracle은 사용할 수 있는 플랫폼 이미지 집합을 제공합니다. 
또한 템플릿으로 사용하도록 이미 구성한 인스턴스에서 이미지를 저장하여 동일한 소프트웨어 및 사용자 정의로 더 많은 인스턴스를 실행할 수도 있습니다.

#### Key Pair
Key Pair(키 쌍)는 Oracle Cloud Infrastructure(OCI)에서 사용하는 인증 메커니즘입니다. 키 쌍은 Private Key(개인 키) 파일과 Public Key(공용 키) 파일로 구성됩니다. 공개 키는 Oracle Cloud Infrastructure에 업로드합니다. Private Key(개인 키)는 컴퓨터에 안전하게 보관합니다. 개인 키는 비밀번호와 같이 개인만 알고, 보관해야 할 키입니다.

Key Pair(키 쌍)는 서로 다른 사양에 따라 생성될 수 있습니다. Oracle Cloud Infrastructure(OCI)는 특정 목적을 위해 두 가지 유형의 키 쌍을 사용합니다.
- 인스턴스 SSH 키 쌍: 이 키 쌍은 인스턴스에 대한 보안 셸(SSH) 연결을 설정하는 데 사용됩니다. 인스턴스를 프로비저닝할 때 공용 키를 제공하면 인스턴스의 인증된 키 파일에 저장됩니다. 인스턴스에 로그온하려면 공용 키로 확인된 개인 키를 제공해야 합니다.
- API 서명 키 쌍: 이 키 쌍은 PEM 형식으로 API 요청을 제출할 때 사용자를 인증하는 데 사용됩니다. API를 통해 Oracle Cloud Infrastructure에 액세스할 사용자만 이 키 쌍이 필요합니다.

이러한 키 쌍에 대한 요구 사항에 대한 자세한 내용은 [보안 자격 증명](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#Security_Credentials) 을 참조하십시오.

#### Block Volume
블록 볼륨은 Oracle Cloud Infrastructure 인스턴스에 영구 블록 스토리지 공간을 제공하는 가상 디스크입니다. 
예를 들어 데이터 및 응용 프로그램을 저장하기 위해 컴퓨터의 실제 하드 드라이브와 마찬가지로 블록 볼륨을 사용합니다. 
한 인스턴스에서 볼륨을 분리하여 데이터 손실 없이 다른 인스턴스에 연결할 수 있습니다.

#### Object Storage
Object Storage는 데이터를 객체로 저장하고 관리할 수 있는 스토리지 아키텍처입니다. 저장할 수 있는 최대 데이터 파일의 크기는 최대 10TB 이며 업로드된 데이터는 어디에서나 엑세스할 수 있습니다. 
자주 변경되지 않거나 접근하지 않는 데이터는 Archive 옵션을 선택하게 되면 매우 많은 양의 데이터를 합리적인 가격으로 저장할 수 있습니다.
오브젝트 스토리지의 일반적인 사용 사례로는 데이터 백업, 파일 공유, 로그 및 센서 생성 데이터와 같은 비정형 데이터 저장등의 용도로 사용됩니다.

#### Bucket
버킷은 개체 저장소에서 데이터와 파일을 저장하기 위해 사용하는 논리적 컨테이너입니다. 버킷에는 개체를 무제한으로 포함할 수 있습니다.
