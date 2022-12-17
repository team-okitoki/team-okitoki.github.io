---
layout: page-fullwidth
#
# Content
#
subheadline: "Networking"
title: "Dynamic Routing Gateway(DRG) and Transit Routing inside a hub VCN"
teaser: "OCI Networking의 Dynamic Routing Gateway(DRG)와 Transit Routing 구성을 위한 Route Table들에 대해서 설명합니다."
author: dankim
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, networking, dynamic routing gateway, drg]
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

### 이 글을 읽기전에
이 글을 읽기 전에 OCI Networking과 관련된 용어나 기본 구성에 대한 이해를 위해서 아래 포스팅을 미리 읽어보는 것을 추천드립니다.

* [OCI 주요 컨셉 및 용어 정리](https://team-okitoki.github.io/getting-started/key-concepts/)
* [OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/)
* [OCI Local Peering - 동일 리전에서 서로 다른 VCN간 연결하기](https://team-okitoki.github.io/infrastructure/oci-local-peering/)
* [OCI Remote Peering - 서로 다른 리전간의 VCN 연결하기](https://team-okitoki.github.io/infrastructure/oci-remote-peering/)

### Dynamic Routing Gateway (DRG)
Dynamic Routing Gateway (이하 DRG)는 OCI의 특정 VCN에서 동일 리전의 VCN이나 다른 리전의 VCN, 혹은 온프레미스 네트워크와의 연결을 지원하기 위한 가상 라우터입니다. 

DRG에 연결할 수 있는 유형에는 VCN(Virtual Cloud Network), IPSec Tunnel, FastConnect(전용선 서비스), RPC(Remote Peering Connection)가 있는데, 각 유형별로 Attachment라는 오브젝트를 생성하여 DRG에 붙일 수 있습니다. 예를 들면 특정 VCN을 DRG를 통해 연결하고자 한다면 VCN Attachment를 생성하여 연결하고, IPSec Tunnel을 DRG를 통해 연결하고자 한다면 IPSec Tunnel Attachment를 생성하여 연결할 수 있습니다. DRG에  연결된 각 Attachment는 기본적으로 서로 통신이 가능한 상태가 됩니다. 여기에 각 Attachment에는 DRG를 위한 Route Table을 구성할 수 있습니다. 이 DRG Route Table은 DRG내에 연결된 다른 Attachment로 이동할 수 있는 경로 규칙을 정의할 수 있습니다. 예를 들면 아래 그림에서 트래픽이 VCN A를 나와 IPSec Tunnel(온프렘)으로 이동한다고 가정했을 때, VCN A는 VCN A Attachment를 통해서 DRG로 들어오고, DRG Route Table의 규칙을 통해서 IPSec Attachment로 이동할 수 있게 구성할 수 있습니다.

![](/assets/img/infrastructure/2022/oci-networking-drg-1.png)

### Transit Routing
Transit Routing은 중개자 역할을 하는 VCN(보통 Hub VCN이라 부름)을 통해서 다른 VCN(보통 Spoke VCN이라 부름)이나 온프레미스 네트워크로 트래픽을 라우팅하는 개념입니다. 일반적으로 부서별로 각각 자체 VCN을 가지는 큰 조직이 있을 수 있고, 온프레미스 네트워크에서 각 부서의 VCN, 즉 Spoke VCN에 액세스를 할 수 있어야 합니다. 이때 각 Spoke VCN에서 보안과 관련된 부분도 직접 관리할 수 있겠지만, 보안을 담당하는 부서가 따로 있는 경우라면 중앙에서 직접 관리 및 통제하기를 원할 수 있는데 이럴 때 구성하는 방식이 Transit Routing입니다. 여기서 중앙에서 보안을 관리하는 부분을 Hub VCN에서 담당하게 됩니다. 이러한 Transit Routing 구성을 위해 가장 중요하게 사용되는 요소가 바로 DRG입니다.

![](/assets/img/infrastructure/2022/oci-networking-drg-2.png)

위 그림은 OCI에서 Transit Routing을 구성한 예시입니다. 이 그림에서 **VCN H(172.16.0.0/16)**가 Hub 역할을 담당하고 보안부서에서 관리한다고 설정해 보겠습니다. 그리고 **VCN S(172.17.0.0/16)**은 Spoke VCN으로 특정 서비스 개발 부서가 관리한다고 설정하고, 온프레미스 네트워크는 **10.0.0.0/16** CIDR 블록을 가지고 IPSec VPN Tunnel을 통해 연결하는 것으로 설정합니다. **VCN H**에서는 보안을 위해 **Network Firewall**을 구성하고, 온프레미스와 모든 VCN(Hub와 Spoke)간 통신은 이 **Network Firewall**을 거치도록 구성하여 트래픽을 모니터링하고, 위험을 감지/차단할 수 있도록 설정합니다.

이러한 구성을 위해 여러 개의 VCN과 온프레미스 네트워크와 연결을 해야 하므로 DRG가 필요하고, 여기에 VCN H Attachment와 VCN S Attachment, IPSec Tunnel Attachment가 포함되어야 합니다. VCN Attachment는 VCN 상세 화면에서 생성이 가능하며, IPSec Tunnel Attachment는 IPSec VPN Connection을 OCI에서 구성하면 자동으로 해당 DRG에 Attachment를 생성합니다. 마찬가지로 다른 리전의 VCN을 연결하기 위해 RPC(Remote Peering Connection)를 생성하면 자동으로 DRG에 RPC Attachment가 생성됩니다. 아래는 VCN Attachment를 생성하는 화면입니다.

**VCN Attachment 생성 화면**
![](/assets/img/infrastructure/2022/oci-networking-drg-4.png)

> IPSec Tunnel Attachment를 구성하기 위해서는 사전에 온프레미스 CPE와 IPSec Connection을 구성해야 하는데, 이 부분은 미리 구성되어 있다고 가정하겠습니다.

이 구성에서 나올 수 있는 경로는 다음과 같습니다.
* ON-PREMISE -> VCN H Network Firewall -> VCN H Subnet
* ON-PREMISE -> VCN H Network Firewall -> VCN S Subnet
* VCN S Subnet -> VCN H Network Firewall -> ON-PREMISE
* VCN S Subnet -> VCN H Network Firewall -> VCN H Subnet
* VCN H Subnet -> VCN H Network Firewall -> ON-PREMISE
* VCN H Subnet -> VCN H Network Firewall -> VCN S Subnet

위 경로를 만들기 위해서는 앞서 얘기한 DRG로 들어오는 트래픽의 경로를 정의하는 **DRG Route Table**과 VCN으로 들어오는 경로를 정의하는 **VCN Route Table**, 서브넷에서 나가는 경로를 정의하는 **Subnet Route Table**에 대해서 이해해야 합니다.

#### Subnet Route Table, DRG Route Table and VCN Route Table
Subnet Route Table에서는 Subnet에서 나가는 트래픽의 경로 규칙을 정의합니다. DRG Route Table은 일반적으로 VCN 내의 Subnet에서 다른 네트워크로 이동하기 위해 DRG로 들어가는 경우 관여합니다. 보통 다른 네트워크로 이동하기 위해 Subnet의 Route Table Target으로 DRG를 지정하게 되는데 이때 관여하게 됩니다. 만약에 DRG를 거친 이후 다시 특정 VCN으로 들어가 해당 VCN 내의 특정 Target을 거쳐야 하는 경우가 있을 수 있습니다. 위 시나리오처럼 특정 VCN 내에 Network Firewall이 있고, 모든 트래픽은 이 Firewall을 거치도록 네트워크를 구성해야 하는 경우라고 할 수 있습니다. 이렇게 VCN으로 들어오는(Ingress) 트래픽의 경로 규칙을 정의하는 곳이 VCN Route Table 입니다. Subent Route Table은 VCN 에서 생성하여 Subent에 적용합니다. DRG Route Table은 DRG에서 생성 및 관리하며, VCN Route Table은 VCN에서 생성하여 관리하지만, 둘 모두 관련된 Attachment(일반적으로 VCN Route Table은 VCN Attachment에 설정)에 설정을 하게 됩니다.

**VCN Route Table 생성 화면**  
VCN Route Table은 VCN으로 들어오는 트래픽의 경로를 정의하는데, VCN에서 관리하는 Route Table로 생성합니다. 
![](/assets/img/infrastructure/2022/oci-networking-drg-5.png)

**DRG Route Table 생성 화면**   
DRG Route Table은 DRG에서 관리하는 Route Table로 DRG 상세화면에서 생성할 수 있습니다. 다음과 같이 생성할 수 있습니다.
![](/assets/img/infrastructure/2022/oci-networking-drg-6.png)

생성한 VCN Route Table과 DRG Route Table은 VCN Attachment에 다음과 같이 설정할 수 있습니다.  
**DRG Route Table을 VCN Attachment에 설정**
![](/assets/img/infrastructure/2022/oci-networking-drg-7.png)

**VCN Route Table을 VCN Attachment에 설정**
![](/assets/img/infrastructure/2022/oci-networking-drg-8.png)

이제 이 구성에서 나올 수 있는 경로에 DRG, Subent Route Table, DRG Route Table, VCN Route Table을 붙여보겠습니다.
* ON-PREMISE<mark>(Subnet Route Table)</mark> -> DRG<mark>(DRG Route Table)</mark> -> VCN H Attachment <mark>(VCN Route Table)</mark> -> VCN H Network Firewall<mark>(Subnet Route Table)</mark> -> VCN H Subnet
* ON-PREMISE<mark>(Subnet Route Table)</mark> -> DRG<mark>(DRG Route Table)</mark> -> VCN H Attachment<mark>(VCN Route Table)</mark> -> VCN H Network Firewall<mark>(Subnet Route Table)</mark> -> VCN S Subnet
* VCN S Subnet<mark>(Subnet Route Table)</mark> -> VCN H Attachment<mark>(VCN Route Table)</mark> -> VCN H Network Firewall<mark>(Subnet Route Table)</mark> -> ON-PREMISE
* VCN S Subnet<mark>(Subnet Route Table)</mark> -> VCN H Attachment<mark>(VCN Route Table)</mark> -> VCN H Network Firewall<mark>(Subnet Route Table)</mark> -> VCN H Subnet
* VCN H Subnet<mark>(Subnet Route Table)</mark> -> VCN H Attachment<mark>(VCN Route Table)</mark> -> VCN H Network Firewall<mark>(Subnet Route Table)</mark> -> ON-PREMISE
* VCN H Subnet<mark>(Subnet Route Table)</mark> -> VCN H Attachment<mark>(VCN Route Table)</mark> -> VCN H Network Firewall<mark>(Subnet Route Table)</mark> -> VCN S Subnet

다음은 위 경로를 포함한 그림입니다.
![](/assets/img/infrastructure/2022/oci-networking-drg-9.png)

그림을 보면 VCN H내의 Network Firewall을 Target으로 구성해야 하므로, VCN으로 들어오는 경로 규칙을 갖는 VCN Route Table은 VCN H에만 있는 것을 알 수 있습니다.

### Remote Peering Connection(RPC) Attachment로 다른 리전의 VCN과 연결
다른 리전(e.g. Tokyo)의 VCN과 연결하기 위해서는 DRG가 두 리전에 모두 존재하여야 하며, RPC로 연결되어야 합니다. RPC로 연결되면 기본적으로 RPC Attachment가 양 리전에 자동으로 생성됩니다. 이제 DRG Route Table에서 RPC Attachment로의 경로 규칙을 추가해 주고, 다른 리전의 DRG Route Table에도 동일하게 RPC Attachment로의 경로 규칙을 추가해 줍니다. 그리고 각 서브넷에 목적지로 다른 리전을 추가해 줍니다. 마지막으로 VCH H의 VCN Route Table에는 다른 리전으로 가능 경우도 동일하게 Network Firewall을 거치도록 구성해 줍니다.

이 구성에서는 다음과 같은 경로가 추가될 수 있습니다.
* Seoul VCN H<mark>(Subnet Route Table)</mark> -> Seoul Network Firewall<mark>(Subnet Route Table)</mark> -> Seoul DRG<mark>(DRG Route Table)</mark> -> Seoul RPC Attachment -> Tokyo DRG<mark>(DRG Route Table)</mark> -> Tokyo VCN S -> Tokyo VCN S Attachment -> Tokyo VCN S Subnet
* Tokyo VCN S<mark>(Subnet Route Table)</mark> -> Tokyo DRG<mark>(DRG Route Table)</mark> -> Tokyo RPC Attachment -> Seoul DRG<mark>(DRG Route Table)</mark> -> Seoul VCN H Attachment<mark>(VCN Route Table)</mark> -> Seoul Network Firewall<mark>(Subnet Route Table)</mark> -> Seoul VCN H Subnet
* Tokyo VCN S<mark>(Subnet Route Table)</mark> -> Tokyo DRG<mark>(DRG Route Table)</mark> -> Tokyo RPC Attachment -> Seoul DRG<mark>(DRG Route Table)</mark> -> Seoul VCN H Attachment<mark>(VCN Route Table)</mark> -> Seoul Network Firewall<mark>(Subnet Route Table)</mark> -> Seoul DRG<mark>(DRG Route Table)</mark> -> IPSec Tunnel Attachment -> ON-PREMISE
* ON-PREMISE -> Seoul DRG<mark>(DRG Route Table)</mark> -> Seoul VCN H Attachment<mark>(VCN Route Table)</mark> -> Seoul Network Firewall<mark>(Subnet Route Table)</mark> -> Seoul DRG<mark>(DRG Route Table)</mark> -> Seoul RPC Attachment -> Tokyo DRG<mark>(DRG Route Table)</mark> -> Tokyo VCN S Attachment ->  Tokyo VCN Subnet

다른 리전과 연결되는 구성도에 경로를 포함한 그림입니다.
![](/assets/img/infrastructure/2022/oci-networking-drg-10.png)

### Import Route Distribution
지금까지 DRG와 관련된 Route Table에 대해서 알아보았습니다. 이 중에서 DRG Route Table은 DRG 내의 여러 Attachment로 이동하는 경로를 정의합니다. DRG Route Table은 네트워크 구성이 VCN 한두 개 연결하는 구성이라면 간단히 직접 경로 규칙을 추가하여 구성할 수도 있습니다. 하지만 연결되는 Spoke VCN이 점점 많아지거나, 다른 리전에서의 서비스가 늘어나 점점 여러 다른 리전이 계속 추가되는 상황이라면, 당연히 관리해야 하는 DRG Route Table도 늘어날 것이고, 경로 규칙 또한 많아져 관리하기 매우 어려워질 수 있습니다. 자칫 이 부분을 잘 못 구성하여 엉뚱하게 경로를 탈 수 있고, 잘 못된 부분을 찾기도 매우 어려울 수 있습니다.

이러한 문제를 해결하기 위해서 앞서 직접 추가해주는 규칙 외에도 동적으로 DRG Attachment에 엮여 있는 네트워크의 환경을 참고하여 자동으로 DRG Route Table에 경로 규칙을 가져와(Import) 구성해 줄 수 있는데, 이것이 Import Route Distribution입니다.

![](/assets/img/infrastructure/2022/oci-networking-drg-11.png)

Import Route Distribution을 구성할 때에는 기본적으로 어느 Attachment까지의 정보를 참조할지 범위를 지정해 주게 됩니다. Attachment를 지정할 때는 Priority, Match Type, Attachment를 선택할 수 있습니다. Match Type 유형에는 다음과 같은 항목이 있습니다.
* Attachment Type: Attachment 유형만 지정합니다. (e.g. VCN, IPSec, Virtual Circuit, RPC)
* Attachment: Attachment를 직접 지정합니다. (e.g. Hub A Attachment, Hub B Attachment, RPC-1 Attachment)
* Match All: DRG에 있는 모든 Attachment를 포함합니다.

**Import Route Distribution 생성 화면**
![](/assets/img/infrastructure/2022/oci-networking-drg-12.png)

Import Route Distribution은 DRG에 생성한 후 다음과 같이 DRG Route Table에 적용합니다.

![](/assets/img/infrastructure/2022/oci-networking-drg-13.png)

Import Route Distribution을 통해서 가져온 경로 규칙은 자동으로 DRG Route Table에 추가됩니다. 추가된 경로 규칙은 DRG Route Table 상세화면의 **모든 경로 규칙 가져오기(Get All Route Rules)** 버튼을 클릭하여 확인할 수 있으며 Import Route Distribution으로 추가된 규칙은 유형이 **Dynamic(사용자가 직접 추가한 경우에는 Static이라고 표기됨)**으로 표기됩니다. 

![](/assets/img/infrastructure/2022/oci-networking-drg-14.png)
![](/assets/img/infrastructure/2022/oci-networking-drg-15.png)

### Import Route Distribution 사용 시 주의할 점
Import Route Distribution은 자동으로 DRG에 연결된 Attachment로부터 각 네트워크에 대한 경로를 자동으로 구성해 준다는 점에서 매우 좋은 기능이지만, 잘못 사용하면 원하지 않는 경로가 추가될 수도 있기 때문에 주의해서 사용해야 합니다. 예를 들면 Seoul VCN S에서 ON-PREMISE로 가야 하는 경우가 있습니다. 이때 Seoul VCN S Attachment에 있는 DRG Route Table에 Import Route Distribution을 사용하고 있고, Import Route Distribution Statement에 IPSec이 포함되어 있을 수 있습니다. 이렇게 되면 VCN S는 원래 의도했던 Seoul VCN H의 Network Firewall로 이동하지 않고 바로 IPSec Tunnel Attachment를 통해서 ON-PREMISE로 이동해 버립니다. 물론 이 경우에는 Import Route Distribution Statement에 IPSec을 제외하면 해결되겠지만,  Import Route Distribution을 어쩔 수 없이 사용해야 하고, 또 특정 Attachment를 꼭 포함해야 하는 상황도 있을 수 있습니다. Dynamic 경로 규칙은 Import Route Distribution Statement에서 제외하지 않는 한 제거가 불가능하므로, 이런 경우에는 직접 Static 경로를 추가하여 해결할 수 있습니다. Static 경로는 Dynamic 경로보다 우선하여 동작하며, 목적지가 충돌 나서 우선순위에 밀린 경로는 그림처럼 **Conflict**로 표기됩니다.

![](/assets/img/infrastructure/2022/oci-networking-drg-16.png)

### 요약
지금까지 DRG와 Transit Routing 구성을 위한 Route Table 들에 대해서 알아보았습니다. OCI에서는 이러한 복잡한 네트워크 구성을 위해서 DRG와 관련 Route Table에 대해서 잘 이해하고 있어야 합니다. 요약하면 DRG Route Table은 DRG 내의 Attachment 이동을 위한 경로 규칙이 포함될 수 있습니다. VCN Route Table은 VCN Attachment를 통해서 VCN으로 들어가는 경로 규칙이 포함됩니다. 보통 Hub VCN에 Network Firewall과 같은 특정 타겟을 지정하는 경우에 사용됩니다. Import Route Distribution은 DRG Route Table 구성을 동적으로 구성하도록 도와줍니다. 이 기능은 자동화라는 장점이 있지만, 세세한 제어가 어렵기 때문에 예상하지 못한 경로가 포함될 수 있으며, 이런 부분을 Static 규칙을 포함하거나, 적절하게 Import Route Distribution Statement를 구성하여 해결할 수 있습니다. 