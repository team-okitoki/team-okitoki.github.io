---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "Flannel CNI 플러그인으로 사용자 정의 OKE Cluster(Oracle Container Engine for Kubernetes) 클러스터 구성"
teaser: "OKE (Oracle Container Engine for Kubernetes)에서는 CNI(컨테이너 네트워크 인터페이스) 플러그인으로 Flannel과 VCN-Native Pod Networking 플러그인을 지원합니다. Flannel 플러그인을 사용하는 OKE Cluster를 사용자 정의 구성하는 방법에 대해서 알아봅니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, kubernetes, oke, cni, flannel]
#
# Styling
#
header: no
#  image:
#    title: /assets/img/cloudnative-security/2022/weblogic_oke_0.png
#     thumb: /assets/img/cloudnative-security/2022/weblogic_oke_0.png
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

### Flannel CNI 플러그인
OKE에서는 CNI(Container Network Interface: 컨테이너간 네트워킹 제어를 위한 플러그인 개발 표준) 플러그인으로 Flannel과 VCN-Native Pod Networking을 지원합니다. Flannel에 대한 설명과 VCN-Native Pod Networking 구성 방법은 다음 포스팅을 참고합니다.

[VCN-Native Pod Networking CNI 플러그인을 사용하여 OKE (Oracle Container Engine for Kubernetes) 클러스터 구성](http://localhost:4000//cloudnative/vcn-native-pod-networking-for-oke/){:target="_blank" rel="noopener"}

<mark>OKE Cluster를 생성할 때 VCN등을 모두 자동으로 생성해 주는 <b>빠른 생성(Quick Create)</b> 옵션과 사용자가 VCN 및 이미지, 노드등을 직접 선택하여 구성하는 <b>사용자 정의(Custom Create)</b> 옵션을 제공합니다. <b>빠른 생성</b>의 경우 기본 CNI로 Flannel이 자동으로 적용됩니다. 하지만 Flannel CNI를 사용하면서 별도의 VCN에 OKE Cluster를 구성해야 할 필요가 있는데, 이 경우에는 <b>사용자 정의</b> 옵션을 통해서 구성해야 합니다. 이번 포스팅을 통해서 <b>사용자 정의</b> 옵션을 활용하여 Flannel CNI를 사용하는 OKE Cluster를 구성하는 방법에 대해서 알아봅니다.</mark>

### Flannel CNI 플러그인으로 OKE 클러스터 생성하기

#### 1. OKE Cluster를 Custom으로 구성하는 가이드 확인
OKE Cluster를 Custom으로 구성할 때 아래 공식 문서를 참고하여 구성할 수 있습니다.

[공식문서](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-flannel-cni-publick8sapi_privateworkers_publiclb)

문서에는 총 4개의 예제가 제공되는데, 여기서는 1번 예제를 참고하여 구성합니다. 1번 예제는 Kubernetes API Endpoint를 Public으로 구성하고, Worker Node는 Private, Load Balancer는 Public으로 구성하는 예제입니다. 구성도는 다음과 같습니다.

![](https://docs.oracle.com/en-us/iaas/Content/Resources/Images/conteng-network-flannel-eg1.png)

#### 2. VCN 생성하기
VCN 생성은 아래 포스트를 참고하여 생성합니다. 여기서는 VCN 이름을 ```my-vcn```으로 지정하여 생성하도록 하겠습니다.

[OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/){:target="_blank" rel="noopener"}

#### 3. 보안 목록(Security List)에 규칙 추가
VCN을 자동으로 생성하면, 기본적으로 2개의 서브넷 (Private, Public)과 2개의 보안 목록(Private 용도와 Public 용도)이 자동으로 생성됩니다. 여기서는 기본으로 생성되는 서브넷과 보안 목록을 활용하여 구성합니다.

##### 3-1. 서브넷의 CIDR 블록 정보
아래는 기본으로 생성된 서브넷과 CIDR 블록이며, API Endpoint와 Worker Node를 다음과 같이 구성하도록 하겠습니다.

<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">Name</th>
      <th class="entry" id="About__entry__2">CIDR Block</th>
      <th class="entry" id="About__entry__2">Description</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">공용 서브넷-my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">10.0.0.0/24</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">API Endpoint를 위한 서브넷</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">10.0.1.0/24</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Worker Node를 위한 서브넷</span>
      </td>
      </tr>
      </tbody>
</table>

##### 3-2. Public Kubernetes API Endpoint 서브넷을 위한 보안 목록 규칙 추가
앞서 생성한 VCN (my-vcn)을 선택하고 왼쪽 리소스 메뉴에서 보안 목록(Security Lists) 선택 > **Default Security List for my-vcn** 선택 후, 대화창에서 다른 수신 규칙(Another Ingress Rule)을 클릭하여 수신 규칙(Ingress Rule)을, 다른 송신 규칙(Another Egress Rule)을 클릭하여 송신 규칙(Egress Rule)을 입력합니다.

<summary><b>Ingress</b></summary>
<div markdown="1">
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">Security List Name</th>
      <th class="entry" id="About__entry__1">Rule Type</th>
      <th class="entry" id="About__entry__2">State</th>
      <th class="entry" id="About__entry__3">Source</th>
      <th class="entry" id="About__entry__4">Protocol/Dest. Port</th>
      <th class="entry" id="About__entry__4">Type and Code</th>
      <th class="entry" id="About__entry__5">Description</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Default Security List for my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/6443</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Kubernetes worker to Kubernetes API endpoint communication.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Default Security List for my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/12250</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Kubernetes worker to control plane communication.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Default Security List for my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">ICMP</td>
      <td class="entry" headers="About__entry__6">Type: 3, Code: 4</td>
      <td class="entry" headers="About__entry__7"><span class="ph">Path Discovery.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Default Security List for my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">0.0.0.0/0</td>
      <td class="entry" headers="About__entry__5">TCP/6443</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">External access (Internet) to Kubernetes API endpoint.</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

<summary><b>Egress</b></summary>
<div markdown="1">
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">Security List Name</th>
      <th class="entry" id="About__entry__1">Rule Type</th>
      <th class="entry" id="About__entry__2">State</th>
      <th class="entry" id="About__entry__3">Destination</th>
      <th class="entry" id="About__entry__4">Protocol/Dest. Port</th>
      <th class="entry" id="About__entry__4">Type and Code</th>
      <th class="entry" id="About__entry__5">Description</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Default Security List for my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">All <font color=green><b>{region}</b></font> Services In Oracle Services Network <br>(기본 생성된 서비스 게이트웨이)</td>
      <td class="entry" headers="About__entry__5">TCP/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow Kubernetes API endpoint to communicate with OKE.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Default Security List for my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">All <font color=green><b>{region}</b></font> Services In Oracle Services Network <br>(기본 생성된 서비스 게이트웨이)</td>
      <td class="entry" headers="About__entry__5">ICMP</td>
      <td class="entry" headers="About__entry__6">Type: 3, Code: 4</td>
      <td class="entry" headers="About__entry__7"><span class="ph">Path Discovery.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Default Security List for my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow Kubernetes API endpoint to communicate with worker nodes.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Default Security List for my-vcn</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">ICMP</td>
      <td class="entry" headers="About__entry__6">Type: 3, Code: 4</td>
      <td class="entry" headers="About__entry__7"><span class="ph">Path Discovery.</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

##### 3-3. Private Worker Nodes 서브넷을 위한 보안 목록 규칙 생성
앞서 생성한 VCN (my-vcn)을 선택하고 왼쪽 리소스 메뉴에서 보안 목록(Security Lists) 선택 > **전용 서브넷-my-vcn의 보안 목록** 선택 후, 대화창에서 다른 수신 규칙(Another Ingress Rule)을 클릭하여 수신 규칙(Ingress Rule)을, 다른 송신 규칙(Another Egress Rule)을 클릭하여 송신 규칙(Egress Rule)을 입력합니다.

<summary><b>Ingress</b></summary>
<div markdown="1">
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">Security List Name</th>
      <th class="entry" id="About__entry__1">Rule Type</th>
      <th class="entry" id="About__entry__2">State</th>
      <th class="entry" id="About__entry__3">Source</th>
      <th class="entry" id="About__entry__4">Protocol/Dest. Port</th>
      <th class="entry" id="About__entry__4">Type and Code</th>
      <th class="entry" id="About__entry__5">Description</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn의 보안 목록</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow pods on one worker node to communicate with pods on other worker nodes.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn의 보안 목록</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.0.0/24 (Kubernetes API Endpoint CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow Kubernetes control plane to communicate with worker nodes.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn의 보안 목록</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">0.0.0.0/0</td>
      <td class="entry" headers="About__entry__5">ICMP</td>
      <td class="entry" headers="About__entry__6">Type: 3, Code: 4</td>
      <td class="entry" headers="About__entry__7"><span class="ph">Path Discovery.</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

<summary><b>Egress</b></summary>
<div markdown="1">
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">Security List Name</th>
      <th class="entry" id="About__entry__1">Rule Type</th>
      <th class="entry" id="About__entry__2">State</th>
      <th class="entry" id="About__entry__3">Destination</th>
      <th class="entry" id="About__entry__4">Protocol/Dest. Port</th>
      <th class="entry" id="About__entry__4">Type and Code</th>
      <th class="entry" id="About__entry__5">Description</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn의 보안 목록</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow pods on one worker node to communicate with pods on other worker nodes.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn의 보안 목록</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">0.0.0.0/0</td>
      <td class="entry" headers="About__entry__5">ICMP</td>
      <td class="entry" headers="About__entry__6">Type: 3, Code: 4</td>
      <td class="entry" headers="About__entry__7"><span class="ph">Path Discovery.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn의 보안 목록</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">All <font color=green><b>{region}</b></font> Services In Oracle Services Network <br>(기본 생성된 서비스 게이트웨이)</td>
      <td class="entry" headers="About__entry__5">TCP/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow worker nodes to communicate with OKE.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn의 보안 목록</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.0.0/24</td>
      <td class="entry" headers="About__entry__5">TCP/6443</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Kubernetes worker to Kubernetes API endpoint communication.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">전용 서브넷-my-vcn의 보안 목록</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.0.0/24</td>
      <td class="entry" headers="About__entry__5">TCP/12250</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Kubernetes worker to control plane communication.</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

#### 4. OKE Cluster 생성
이제 OKE Cluster를 생성합니다. OCI Console 왼쪽 상단 메뉴 버튼을 클릭한 후 **개발자 서비스(Developer Services) > Kubernetes 클러스터(OKE) (Kubernetes Clusters (OKE))**를 차례로 선택합니다.

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-5.png)

**클러스터 생성(Create Cluster)** 버튼을 클릭한 후 **사용자정의 생성(Custom Create)**를 선택하고 **제출(Submit)** 버튼을 클릭합니다.

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-6.png)

클러스터 정보를 다음과 같이 입력/선택 합니다.

* **이름(Name):** oke-cluster1
* **구획(Compartment):** 클러스터 생성을 위한 구획 선택
* **Kubernetes 버전:** v1.24.1 (현재 최신 버전)

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-7.png)

네트워크 설정에서는 다음과 같이 구성합니다.

* **네트워크 유형(Network type):** 플란넬 오버레이(Flannel overay)
* **VCN:** 앞서 생성한 VCN (e.g. my-vcn)
* **Kubernetes 서비스 LB 서브넷(Kubernetes service LB subnets):** 공용 서브넷-my-vcn
* **Kubernetes API 끝점 서브넷(Kubernetes API endpoint subnet):** 공용 서브넷-my-vcn
* **API 끝점에 공용 IP 주소 지정(Assign a public IP address to the API endpoint):** 선택
  * Cluster 구성 후 바로 확인할 수 있도록 공용 IP주소를 할당합니다.

![](/assets/img/cloudnative-security/2022/oke-cluster-with-flannel-cni-1.png)

노드 풀을 다음과 같이 설정합니다.
* **이름(Name):** pool1
* **구획(Compartment):** 노드 풀을 구성할 구획 선택
* **버전(Version):** v1.24.1 (클러스터 버전과 동일한 버전 선택)
* **구성 및 이미지(Shape and Image)**
  * **구성(Shape):** VM.Standard.E4.Flex
  * **OCPU 수 선택(Select the number of OCPUs):** 1
  * **메모리 양(Amount of Memory (GB)):** 16
  * **이미지(Image):** Oracle Linux 8 (이미지 빌드: 2022.06.30-0, 쿠버네티스 버전: 1.24.1)
    * 이미지는 OKE 워커 노드 이미지로 구성하며 최신 클러스터 버전을 지원하는 최신 이미지로 선택
* **노드 풀 옵션(Node Pool options):**
  * **노드 수(Number of nodes):** 3
* **부트 볼륨(Boot volume):** 기본
* **배치 구성(Placement configuration)**
  * **가용성 도메인(Availability domain):** 가용성 도메인 선택
  * **워커 노드 서브넷(Worker node subnet):** 전용 서브넷-my-vcn
  * **결함 도메인(Fault domains)):** 선택 안함

![](/assets/img/cloudnative-security/2022/oke-cluster-with-flannel-cni-2.png)

마지막으로 모든 설정을 검토하고 클러스터 생성(Craete Cluster) 버튼을 클릭하여 클러스터를 생성합니다.

![](/assets/img/cloudnative-security/2022/oke-cluster-with-flannel-cni-3.png)

#### 5. OKE Cluster 생성 확인 및 접속
OKE Cluster가 생성되고 노드풀에 3개의 노드가 모두 활성 상태인 것을 확인할 수 있습니다.
![](/assets/img/cloudnative-security/2022/oke-cluster-with-flannel-cni-4.png)

OKE Cluster에 접속하는 방법은 다음 포스팅을 참고합니다.

[OCI Container Engine for Kubernetes (OKE) Cluster 접속 방법](https://team-okitoki.github.io/cloudnative/access-oke-cluster/)