---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "VCN-Native Pod Networking CNI 플러그인을 사용하여 OKE (Oracle Container Engine for Kubernetes) 클러스터 구성"
teaser: "OKE (Oracle Container Engine for Kubernetes)에서는 기본 CNI(컨테이너 네트워크 인터페이스) 플러그인으로 Flannel을 사용하였지만, 이제는 VCN-Native Pod Networking이라는 새로운 CNI 플러그인을 사용할 수 있습니다. VCN-Native Pod Networking CNI에 대해서 알아보고, 이를 이용하여 OKE Cluster를 구성하는 방법에 대해서 알아봅니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, kubernetes, oke, cni, VCN-Native Pod Networking]
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

### Flannel overlay networking
OKE에서는 기존에 기본 CNI(Container Network Interface: 컨테이너간 네트워킹 제어를 위한 플러그인 개발 표준)로 Flannel만 제공되었습니다. Flannel은 대표적인 CNI중 하나이며, 오버레이 네트워크(Overlay Network: 각 노드들의 네트워크위에 별도의 가상 네트워크를 구성하여 마치 하나의 네트워크인 것처럼 인식하는 것)를 두고 서로 다른 노드간의 Pod 통신도 문제 없이 이뤄질 수 있도록 해주는 역할을 합니다.

**Flannel overlay networking**  
<cite>Image source: https://blogs.oracle.com/cloud-infrastructure/post/announcing-vcn-native-pod-networking-for-kubernetes-in-oci</cite>
![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONT94FDF8973EA4486AB65E88CA4DF72114/Medium?cb=_cache_7675&format=jpg&channelToken=f7814d202b7d468686f50574164024ec)



Flannel Overlay Networking로 클러스터를 구성하면, 위 그림처럼 Layer 3에서 네트워킹을 제공하는 추가적인 Overaly Networking이 구성됩니다. 그리고 Kubernetes Worker Node에서 실행되는 Pod는 Overlay Network을 통해서 IP를 할당받게 됩니다. Flannel은 VCN Worker Node 서브넷 대역의 IP를 사용히지 않아야 하는 경우나 Node 서브넷에서 제공되는 IP수가 운영해야 하는 Pod수보다 적을 수 있는 환경에서 사용하면 좋습니다.

자세한 내용은 아래 Flannel 공식 Github 문서를 참고 하시기 바랍니다.

[Flannel](https://github.com/flannel-io/flannel)

### OKE를 위한 OCI VCN Native CNI

**Native pod networking**  
<cite>Image source: https://blogs.oracle.com/cloud-infrastructure/post/announcing-vcn-native-pod-networking-for-kubernetes-in-oci</cite>

![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONT78BF0A5D337F41A887531F7969A18FDE/Medium?cb=_cache_7675&format=jpg&channelToken=f7814d202b7d468686f50574164024ec)

위 그림은 Worker Node를 위한 서브넷(CIDR: 10.20.40.0/24)과 Pod를 위한 서브넷  (CIDR: 10.20.50.0/24)을 VCN에 생성하여 **Native pod networking**를 사용한 OKE Cluster를 구성한 그림입니다. Pod의 경우 각 Worker Node의 vNICs(가상 네트워크 인터페이스 카드)에 Pod 서브넷 대역에서 제공되는 Private IP를 할당하고 이를 Pod에 사용하게 되며, Pod는 해당 인터페이스를 통해서 인바운드/아웃바운드 통신을 하게 됩니다. 이런 식으로 각 Pod는 vNIC에 연결되고 VCN에 직접 연결되어 Overlay Networking과 같은 캡슐화 없이 통신이 가능해집니다. Native pod networking을 사용한 Cluster내의 Pod는 OKE Cluster 노드가 아닌 같은 VCN내의 다른 VM 인스턴스과의 통신이 가능하며, 다른 VCN과의 통신(Local or Remote Peering 사용), 온프레미스 환경과의 통신(OCI FastConnect 혹은 IPSec VPN 사용)도 사용 가능합니다. 또한 OCI VCN Flow Log 기능을 통해서 Pod간 트래픽도 추적할 수 있습니다. 이 외에도 캡슐화를 위한 별도의 레이어가 없어 오버헤드가 줄어들면서 처리량이나 대기시간에 있어서 일관성 있는 성능을 제공합니다. (다른 노드간 Pod 통신 대기시간이 Flannel 사용시보다 약 25% 향상됨)

> OKE Cluster를 생성할 때 Quick Create라는 기능을 활용하여 빠르게 Cluster를 생성하는 기능을 제공하는데, 현재는 기본으로 Flannel CNI로만 구성됩니다. 

### VCN-Native Pod Networking으로 클러스터 생성하기
현재는 OKE Cluster Quick Create 기능으로는 Flannel만 지원하기 때문에 Custom Create 기능으로 생성하여야 합니다. Custom Create 기능으로 생성하기 위해서는 먼저 VCN이 준비되어 있어야 합니다. (Quick Create의 경우 VCN을 자동생성할 수 있음)

#### 1. 아키텍처
OKE Cluster를 Custom으로 구성할 때 아래 공식 문서를 참고하여 구성할 수 있습니다.

[공식 문서](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm)

문서에는 총 4개의 예제가 제공되는데, 여기서는 3번 예제를 참고하여 구성합니다. 3번 예제는 Kubernetes API Endpoint를 Public으로 구성하고, Worker Node는 Private, Load Balancer는 Public으로 구성하는 예제입니다. 구성도는 다음과 같습니다.

**구성도**  
![](https://docs.oracle.com/en-us/iaas/Content/Resources/Images/conteng-network-oci-cni-eg1.png)

#### 2. VCN 생성하기
VCN 생성은 아래 포스트를 참고하여 생성합니다. 여기서는 VCN 이름을 ```OKEVCN```으로 지정하여 생성하도록 하겠습니다.

[OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/){:target="_blank" rel="noopener"}

#### 3. 보안 목록(Security List) 생성
VCN을 자동으로 생성하면, 기본적으로 2개의 서브넷 (Private, Public)과 2개의 보안 목록(Private 용도와 Public 용도)이 자동으로 생성됩니다. 여기서는 기본으로 생성되는 서브넷과 보안 목록은 두고, **VCN-Native Pod Networking** 구성을 위한 별도의 서브넷과 보안 목록을 생성할 것입니다.

##### 3-1. 생성하게 될 서브넷의 CIDR 블록 정보
여기서 사용하게 될 서브넷과 CIDR 블록이며, 서브넷은 뒤에서 생성할 예정이므로 참고만 합니다.
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">Name</th>
      <th class="entry" id="About__entry__2">CIDR Block</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Public Subnet for Kubernetes API Endpoint</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">10.0.0.0/24</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Private Subnet for Worker Nodes</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">10.0.1.0/24</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Public Subnet for Service Load Balancers</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">10.0.2.0/24</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph"><font color=red>(Optional) Private Subnet for Bastion</font></span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><font color=red>10.0.3.0/24</font></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Private Subnet for Pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">10.0.4.0/24</span>
      </td>
      </tr>
      </tbody>
</table>

```여기서 구성하는 환경에서는 Bastion은 제외합니다. 또한 문서에는 Route Table과 Internet Gateway, NAT Gateway, Service Gateway를 별도로 생성하는 것처럼 되어 있지만, 여기서는 VCN Quick Create로 생성된 것을 그대로 활용합니다.```

##### 3-2. Public Kubernetes API Endpoint 서브넷을 위한 보안 목록 규칙 생성
보안 목록 생성은 앞서 생성한 VCN (OKEVCN)을 선택하고 왼쪽 리소스 메뉴에서 **보안 목록(Security Lists) 선택 > 보안 목록 생성 (Create Security List)**를 차례로 선택한 후 대화창에서 **다른 수신 규칙(Another Ingress Rule)**을 클릭하여 수신 규칙(Ingress Rule)을, **다른 송신 규칙(Another Egress Rule)**을 클릭하여 송신 규칙(Egress Rule)을 입력합니다. 

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-1.png)

생성하기 위한 보안 목록은 다음 테이블을 참고하여 생성합니다.

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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/12250</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Kubernetes worker to Kubernetes API endpoint communication.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.4.0/24 (Pods CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/6443</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Pod to Kubernetes API endpoint communication (when using VCN-native pod networking).</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.4.0/24 (Pods CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/12250</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Pod to Kubernetes API endpoint communication (when using VCN-native pod networking).</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/12250</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow Kubernetes API endpoint to communicate with worker nodes.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
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
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-KubernetesAPIendpoint</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.4.0/24 (Pods CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow Kubernetes API endpoint to communicate with pods (when using VCN-native pod networking).</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

##### 3-3. Private Worker Nodes 서브넷을 위한 보안 목록 규칙 생성
앞서 생성한 보안 목록과 마찬가지로 동일하게 다음 테이블을 참조하여 생성합니다.

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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-workernodes</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.0.0/24 (Kubernetes API Endpoint CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/12250</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow Kubernetes API endpoint to communicate with worker nodes.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-workernodes</span>
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
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-workernodes</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.2.0/24 (Load balancer subnet CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/30000-32767</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Load Balancer to Worker nodes node ports.</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-workernodes</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.4.0/24 (Pods CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow worker nodes to access pods.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-workernodes</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-workernodes</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-workernodes</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-workernodes</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.0.0/24</td>
      <td class="entry" headers="About__entry__5">TCP/12250</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Kubernetes worker to Kubernetes API endpoint communication.</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

##### 3-4. Private Pods 서브넷을 위한 보안 목록 규칙 생성
마찬가지로 동일하게 다음 테이블을 참조하여 생성합니다.

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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow worker nodes to access pods.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.0.0/24 (Kubernetes API Endpoint CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow Kubernetes API endpoint to communicate with pods.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.4.0/24 (Pods CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow pods to communicate with other pods.</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.4.0/24 (Pods CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow pods to communicate with other pods.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">All <font color=green><b>{region}</b></font> Services In Oracle Services Network <br>(기본 생성된 서비스 게이트웨이)</td>
      <td class="entry" headers="About__entry__5">TCP/ALL</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow pods to communicate with OCI services.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">0.0.0.0/0</td>
      <td class="entry" headers="About__entry__5">TCP/443</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Allow pods to communicate with internet.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.0.0/24 (Kubernetes API Endpoint CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/6443</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Pod to Kubernetes API endpoint communication (when using VCN-native pod networking).</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.0.0/24 (Kubernetes API Endpoint CIDR)</td>
      <td class="entry" headers="About__entry__5">TCP/12250</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Pod to Kubernetes API endpoint communication (when using VCN-native pod networking).</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

##### 3-5. Public Load Balancer 서브넷을 위한 보안 목록 규칙 생성
마지막으로 다음 테이블을 참조하여 Public Load Balancer 서브넷을 위한 보안 목록 규칙을 생성합니다.

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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-loadbalancers</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Ingress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">0.0.0.0/0 (Internet)</td>
      <td class="entry" headers="About__entry__5">TCP/80</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Load Balancer listener protocol and port.</span>
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
      <td class="entry" headers="About__entry__1"><span class="ph">seclist-loadbalancers</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Egress</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">Stateful</span>
      </td>
      <td class="entry" headers="About__entry__4">10.0.1.0/24 (Worker Nodes CIDR)</td>
      <td class="entry" headers="About__entry__5">ALL/30000-32767</td>
      <td class="entry" headers="About__entry__6"></td>
      <td class="entry" headers="About__entry__7"><span class="ph">Load Balancer to Worker nodes node ports.</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

```Bastion환경을 구성하기 위한 보안 규칙은 [공식 문서](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm)를 참고합니다.```

##### 3-6. 생성된 보안 목록 규칙 확인
아래와 같이 기본 2개의 보안목록 외에 4개의 보안 목록이 생성된 것을 확인할 수 있습니다.

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-2.png)

#### 4. 서브넷 생성
총 4개의 서브넷을 생성할 것입니다. 서브넷은 앞서 생성한 VCN(OKEVCN)을 클릭한 후 왼쪽 리소스 메뉴에서 서브넷(Subnet)을 선택 후 서브넷 생성(Create Subnet)을 클릭하여 생성합니다. 

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-3.png)

생성을 위한 정보는 다음 테이블을 참고합니다.

<summary><b>서브넷</b></summary>
<div markdown="1">
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">Subnet Name</th>
      <th class="entry" id="About__entry__2">Type</th>
      <th class="entry" id="About__entry__3">CIDR Block</th>
      <th class="entry" id="About__entry__4">Route Table</th>
      <th class="entry" id="About__entry__5">Subnet access</th>
      <th class="entry" id="About__entry__6">DNS Resolution</th>
      <th class="entry" id="About__entry__7">DHCP Options</th>
      <th class="entry" id="About__entry__8">Security List</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Private Subnet for Kubernetes API Endpoint</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Regional</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">10.0.0.0/24</span>
      </td>
      <td class="entry" headers="About__entry__4">Default Route Table for {VCN Name}</td>
      <td class="entry" headers="About__entry__5">Private</td>
      <td class="entry" headers="About__entry__6">Selected</td>
      <td class="entry" headers="About__entry__7">Default</td>
      <td class="entry" headers="About__entry__8"><span class="ph">seclist-KubernetesAPIendpoint</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Private Subnet for Worker Nodes</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Regional</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">10.0.1.0/24</span>
      </td>
      <td class="entry" headers="About__entry__4">Route Table for Private Subnet-{VCN Name}</td>
      <td class="entry" headers="About__entry__5">Private</td>
      <td class="entry" headers="About__entry__6">Selected</td>
      <td class="entry" headers="About__entry__7">Default</td>
      <td class="entry" headers="About__entry__8"><span class="ph">seclist-workernodes</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Public Subnet for Service Load Balancers</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Regional</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">10.0.2.0/24</span>
      </td>
      <td class="entry" headers="About__entry__4">Default Route Table for {VCN Name}</td>
      <td class="entry" headers="About__entry__5">Private</td>
      <td class="entry" headers="About__entry__6">Selected</td>
      <td class="entry" headers="About__entry__7">Default</td>
      <td class="entry" headers="About__entry__8"><span class="ph">seclist-loadbalancers</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph"><font color=red>(Optional) Private Subnet for Bastion</font></span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><font color=red>Regional</font></span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph"><font color=red>10.0.3.0/24</font></span>
      </td>
      <td class="entry" headers="About__entry__4"><font color=red>Route Table for Private Subnet-{VCN Name}</font></td>
      <td class="entry" headers="About__entry__5"><font color=red>Private</font></td>
      <td class="entry" headers="About__entry__6"><font color=red>Selected</font></td>
      <td class="entry" headers="About__entry__7"><font color=red>Default</font></td>
      <td class="entry" headers="About__entry__8"><span class="ph"><font color=red>seclist-pods</font></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Private Subnet for Pods</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">Regional</span>
      </td>
      <td class="entry" headers="About__entry__3"><span class="ph">10.0.4.0/24</span>
      </td>
      <td class="entry" headers="About__entry__4">Route Table for Private Subnet-{VCN Name}</td>
      <td class="entry" headers="About__entry__5">Private</td>
      <td class="entry" headers="About__entry__6">Selected</td>
      <td class="entry" headers="About__entry__7">Default</td>
      <td class="entry" headers="About__entry__8"><span class="ph">seclist-Bastion</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

생성을 하면 서브넷 목록에서 다음과 같이 4개의 서브넷을 확인할 수 있습니다.

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-4.png)

#### 5. OKE Cluster 생성
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

* **네트워크 유형(Network type):** VCN-고유 Pod 네트워킹(VCN-native pod networking)
* **VCN:** 앞서 생성한 VCN (e.g. OKEVCN)
* **Kubernetes 서비스 LB 서브넷(Kubernetes service LB subnets):** Public Subnet for Service Load Balancers
* **Kubernetes API 끝점 서브넷(Kubernetes API endpoint subnet):** Public Subnet for Kubernetes API Endpoint
* **API 끝점에 공용 IP 주소 지정(Assign a public IP address to the API endpoint):** 선택
  * Cluster 구성 후 바로 확인할 수 있도록 공용 IP주소를 할당합니다.

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-8.png)

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
  * **워커 노드 서브넷(Worker node subnet):** Private Subnet for Worker Nodes
  * **결함 도메인(Fault domains)):** 선택 안함
* **Pod 통신(Pod communication)**
  * **서브넷(Subnet):** Private Subnet for Pods

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-9.png)

마지막으로 모든 설정을 검토하고 **클러스터 생성(Craete Cluster)** 버튼을 클릭하여 클러스터를 생성합니다.

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-10.png)

#### 6. OKE Cluster 접속 및 Native Pod Network 확인
OKE Cluster에 접속하는 방법은 다음 포스트를 참고합니다.

[OCI Container Engine for Kubernetes (OKE) Cluster 접속 방법](https://team-okitoki.github.io/cloudnative/access-oke-cluster/)

다음 명령어로 Native Pod Network을 확인할 수 있습니다.
```
$ kubectl get NativePodNetwork
NAME                                                           STATE     REASON
anuwgljrvsea7yica6kpvzhjeyan2w7s6riem2se4c43t5xvmefnntsrm2ra   SUCCESS   COMPLETED
anuwgljrvsea7yick7i7vpeirnsdw7n4hbjb4d5tb4mahtmujhu7goz47yra   SUCCESS   COMPLETED
anuwgljrvsea7yictl7tvbmk5luyjxncijtnmxpiwdrrlyeer36jpxvbbbpq   SUCCESS   COMPLETED
```

이 중에서 한개의 Pod Network에 대한 상세 정보를 조회해 보면, 조회한 Native Pod Networking과 관련된 노드와 Pod CIDR, 확보된 31개의 Pod IP 주소등을 확인할 수 있습니다.
```
$ kubectl describe NativePodNetwork (or npn) anuwgljrvsea7yica6kpvzhjeyan2w7s6riem2se4c43t5xvmefnntsrm2ra
Name:         anuwgljrvsea7yica6kpvzhjeyan2w7s6riem2se4c43t5xvmefnntsrm2ra
Namespace:    
Labels:       <none>
Annotations:  <none>
API Version:  oci.oraclecloud.com/v1beta1
Kind:         NativePodNetwork
Metadata:
  Creation Timestamp:  2022-09-24T10:56:48Z
  Generation:          1
  Managed Fields:
    API Version:  oci.oraclecloud.com/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:spec:
        .:
        f:id:
        f:maxPodCount:
        f:podSubnetIds:
    Manager:      Kubernetes Java Client
    Operation:    Update
    Time:         2022-09-24T10:56:48Z
    API Version:  oci.oraclecloud.com/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:metadata:
        f:ownerReferences:
          .:
          k:{"uid":"89df57c9-9f2c-4514-913c-576fc92f994f"}:
    Manager:      cloud-provider-oci
    Operation:    Update
    Time:         2022-09-24T10:58:47Z
    API Version:  oci.oraclecloud.com/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:status:
        .:
        f:reason:
        f:state:
        f:vnics:
    Manager:      cloud-provider-oci
    Operation:    Update
    Subresource:  status
    Time:         2022-09-24T10:58:47Z
  Owner References:
    API Version:     v1
    Kind:            Node
    Name:            10.0.1.210
    UID:             89df57c9-9f2c-4514-913c-576fc92f994f
  Resource Version:  1431
  UID:               ef118350-555f-4565-946f-7547d71aca66
Spec:
  Id:             ocid1.instance.oc1.ap-seoul-1.anuwgljrvsea7yica6kpvzhjeyan2w7s6riem2se4c43t5xvmefnntsrm2ra
  Max Pod Count:  31
  Pod Subnet Ids:
    ocid1.subnet.oc1.ap-seoul-1.aaaaaaaavd74v4ixwoik3dzup236hmg3tdy73ybxe56inafvyfnnjvg7srtq
Status:
  Reason:  COMPLETED
  State:   SUCCESS
  Vnics:
    Addresses:
      10.0.4.119
      10.0.4.31
      10.0.4.64
      10.0.4.181
      10.0.4.221
      10.0.4.91
      10.0.4.158
      10.0.4.240
      10.0.4.186
      10.0.4.144
      10.0.4.251
      10.0.4.120
      10.0.4.118
      10.0.4.99
      10.0.4.139
      10.0.4.71
      10.0.4.195
      10.0.4.21
      10.0.4.246
      10.0.4.42
      10.0.4.83
      10.0.4.2
      10.0.4.244
      10.0.4.11
      10.0.4.44
      10.0.4.157
      10.0.4.159
      10.0.4.43
      10.0.4.62
      10.0.4.50
      10.0.4.123
    Mac Address:  02:00:17:02:51:4E
    Router Ip:    10.0.4.1
    Subnet Cidr:  10.0.4.0/24
    Vnic Id:      ocid1.vnic.oc1.ap-seoul-1.abuwgljrj2d7wzlyqhlruivls2mr2vr5udpuq56qtp7s2nzu3x55g7byzyca
Events:           <none>
```

생성된 각 Worker Node의 vNIC에도 Pod를 위한 Secondary vNIC이 존재하는 것을 확인할 수 있으며, 해당 vNIC에 31개의 Pod를 위한 IP가 지정되어 있는 것을 확인할 수 있습니다.

![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-11.png)
![](/assets/img/cloudnative-security/2022/vcn-native-pod-networking-for-oke-12.png)