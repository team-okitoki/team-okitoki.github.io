---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI Container Engine for Kubernetes (OKE)에 WebLogic 배포해보기"
teaser: "OCI에서 서비스하는 관리형 쿠버네티스 서비스인 OCI Container Engine for Kubernetes (OKE)에 WebLogic을 배포하는 과정을 설명합니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, kubernetes, oke, weblogic]
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

### WebLogic for OCI, WebLogic for OKE
엔터프라이즈 웹 애플리케이션 서버 시장에서 가장 인기가 높은 WebLogic 서버가 현재 OCI에서 관리형 서비스로 제공되고 있습니다. 제공되는 배포 모델은 VM에 직접 설치 구성되는 WebLogic for OCI와 OCI Container Engine인 OKE에 배포하는 WebLogic for OKE 모델 두 가지입니다. 둘 다 OCI의 마켓플레이스를 통해서 제공되며, OCI의 IaC 도구인 Resource Manager를 통해서 자동으로 배포가 가능합니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_0.png)

이번 포스팅에서는 WebLogic을 OKE 환경에 배포하는 내용을 다루도록 합니다.

### WebLogic Kubernetes Operator
Kubernetes Cluster에 WebLogic Domain을 관리 배포할 수 있는 WebLogic Operator를 12c 버전부터 지원하고 있습니다. WebLogic Operator에 대한 자세한 내용은 아래 링크에서 확인할 수 있습니다.

[WebLogic Kubernetes Operator](https://oracle.github.io/weblogic-kubernetes-operator/)

![](/assets/img/cloudnative-security/2022/weblogic_oke_0_1.png)

WebLogic Operator의 주요 역할은 다음과 같습니다.
* Kubernetes의 기능으로 WebLogic 환경을 프로비저닝하고 운영하기 위한 메커니즘 제공
* WebLogic 도메인 구성을 커스텀 리소스로 등록
* WebLogic Operator는 커스텀 리소스를 해석하고 WebLogic의 클러스터, 관리 서버 등을 제어
* Kubernetes YAML을 기반으로 WebLogic 환경에서 IaaS(Infrastructure as a Code)를 쉽게 구현
* WebLogic 서버의 스케일 아웃, 분산 배포, 자동 재시작과 같은 동적인 제어도 YAML을 통해서 쉽게 구현

WebLogic Operator를 OKE를 포함하여 다른 CSP에서 제공하는 Kubernetes Cluster에 직접 설치하여 WebLogic Domain을 구성할 수 있습니다. 설치 및 구성 가이드는 [WebLogic Kubernetes Operator](https://oracle.github.io/weblogic-kubernetes-operator/) 링크를 참고합니다.

이번글에서는 OCI의 마켓플레이스에서 제공하는 Resource Manager Stack을 활용하여 자동으로 프로비저닝 하는 방법에 대해서 설명합니다.

### WebLogic for OKE provisioning in OCI Marketplace
현재 WebLogic for OKE를 OCI 마켓플레이스에서 제공하고 있습니다. OCI 마켓플레이스에서 제공되는 WebLogic for OKE 배포 아키텍처는 다음과 같습니다. 기본적으로 Jenkins나 Nginx, WebLogic Operator를 위한 Non-WebLogic Node Pool과 WebLogic 도메인을 포함되는 WebLogi Node Pool로 구성됩니다. 여기에 Jenkins나 Admin 서버등 내부에서만 접속 가능하도록 Private Load Balancer가 배포되어 연결되며, 도메인에 배포되는 애플리케이션은 Public Load Balancer가 서비스로 배포됩니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_0_3.png)

WebLogic for OKE를 OCI 마켓플레이스에서 확인하려면, OCI 콘솔에 로그인 후 메뉴에서 마켓플레이스(Marketplace) > 모든 애플리케이션(All Applications)를 차례로 클릭합니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_0_2.png)

검색 키워드를 ```weblogic oke```로 검색으로 하면 다음과 같이 4개의 애플리케이션이 검색됩니다. 이 중에서 필요한 애플리케이션을 선택합니다. 여기서는 **Oracle WebLogic Server Enterprise Edition for OKE BYOL**을 선택하여 진행하도록 합니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_1.png)

> 현재는 WebLogic Enterprise와 Suite만 제공되며, BYOL(Bring Your Own License)과 UCM중에서 선택할 수 있습니다. BYOL은 WebLogic License를 가지고 있는 경우 해당 License를 그대로 OCI에서 사용할 수 있으며, 인프라 사용 비용만 청구됩니다. UCM의 경우 WebLogic License가 없는 사용자인 경우에 구독 비용에 License를 같이 포함하여 사용할 수 있습니다. 인프라 사용비용 외에 추가 비용이 발생합니다.

> WebLogic Standard Edition을 OCI에서 BYOL로 구성해야 한다면, VM에 구성되는 WebLogic for OCI를 통해서 사용 가능합니다.

설치할 웹로직 버전과 구획을 선택하고 **스택 실행**을 클릭합니다.

> 현재 OKE에 구성 가능한 버전은 12.2.1.4 버전이며, VM에 구성되는 WebLogic for OCI의 경우는 14.1.1.0 까지 지원합니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_2.png)

기본 설정으로 두고 다음을 클릭합니다.
![](/assets/img/cloudnative-security/2022/weblogic_oke_3.png)

#### 스택 구성 - WebLogic Server on Container Cluster (OKE)
WebLogic Server on Container Cluster (OKE) 부분에 다음과 같이 입력합니다.
* **Resouce Name Prefix:** wlsoke
  * 생성되는 모든 리소스(Compute, Network, Storage 등) 이름에 설정한 Prefix가 붙게 됩니다.
* **SSH Public Key**
  * 인스턴스에 접속하기 위한 SSH Public키를 입력합니다. 가지고 있는 키가 있다면 해당 키를 사용하고, 없다면 ssh-keygen과 같은 도구를 활용하여 공개키를 생성합니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_4.png)

#### 스택 구성 - Network
Network 설정에서는 VCN을 구성하게 됩니다. VCN 구성 시 미리 생성한 VCN이 있다면 해당 VCN을 활용하면 되고, 없다면 새로 생성됩니다.

참고로 VCN 생성은 아래 포스트를 참고하여 생성할 수 있습니다.

[OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/)

* **Virtual Cloud Network Strategy:** Use Existing VCN
  * VCN이 없다면 Create New VCN을 선택합니다.
* **Network Compartment:** 구획 선택
* **Existing Network:** VCN을 선택
* **Bastion Host Subnet CIDR:** 10.0.7.0/28
  * 주의: 기본값은 10.0.1.0/28 이지만, 보통 VCN Wizard로 생성한 VCN의 경우 10.0.1.0/24 블록을 갖는 서브넷이 기본으로 생성되어, 스택 실행 시 충돌로 인한 오류가 발생할 수 있기 때문에 10.0.7.0/28 블록을 갖도록 수정해야 합니다.
* **Administration Host Subnet CIDR:** 10.0.2.0/28
* **File System and Mount Target Subnet CIDR:** 10.0.3.0/28
* **Kubernetes Cluster Subnet CIDR:** 10.0.4.0/28
* **Kubernetes API Endpoint Subnet CIDR:** 10.0.5.0/28
* **Load Balancer Subnet CIDR:** 10.0.6.0/28
* **Existing NAT Gateway:** 기본 NAT 게이트웨이 선택
* **Existing Service Gateway:** 기본 서비스 게이트웨이 선택
* **Minimum Bandwidth for Jenkins Load Balancer:** 10
* **Maximum Bandwidth for Jenkins Load Balancer:** 100

![](/assets/img/cloudnative-security/2022/weblogic_oke_5.png)
![](/assets/img/cloudnative-security/2022/weblogic_oke_6.png)

#### 스택 구성 - Container Cluster (OKE) Configuration
OKE 클러스터를 구성하기 위한 설정입니다. 다음과 같이 선택 및 입력합니다.

**Kubernetes version:** v1.22.5
  * Recommeded version인 1.22.5 버전을 선택
* **Non-WebLogic Node Pool Shape:** VM.Standard.E4.Flex (1 OCPU, 16GB Memory)
  * Jenkins와 같은 WebLogic과 직접적인 관련이 없는 Pod가 배포될 Node
* **Nodes in the Node Pool for non-WebLogic pods:** 1
* **WebLogic Node Pool Shape:** VM.Standard.E4.Flex (1 OCPU, 16GB Memory)
  * WebLogic Managed 서버 Pod가 배포될 Node
* **Nodes in the Node Pool for WebLogic pods:** 3
* **PODs CIDR:** 10.96.0.0/16

![](/assets/img/cloudnative-security/2022/weblogic_oke_7.png)

#### 스택 구성 - Administration Instances
WebLogic Admin 서버가 배포되는 노드를 설정합니다.

* **Availability Domain for compute instances:** 배포될 AD를 선택
* **Administration Instance Compute Shape:** VM.Standard.E4.Flex (1 OCPU, 16GB Memory)
* **Bastion Instance Shape:** VM.Standard.E4.Flex (1 OCPU, 16GB Memory)
  * WebLogic 서버에 접속하기 위한 Bastion 서버 인스턴스

![](/assets/img/cloudnative-security/2022/weblogic_oke_8.png)

#### 스택 구성 - File System, Registry (OCIR), OCI Policies
Network File Storage인 File System 설정, WebLogic Docker Image 저장소인 OCIR (Oracle Cloud Infrastructure Registry) 구성, OCI Policies 생성에 대한 설정을 합니다.

**File System**  
* **Availability Domain for File system:** 배포될 AD를 선택

**Registry (OCIR)**
* **Registry User Name:** OCI Console 우측 상단 프로파일에서 보이는 사용자 아이디
  * ex) oracleidentitycloudservice/dan.donghu.kim@gmail.com
* **OCIR Auth Token Compartment:** OCIR Auth Token에 대한 Vault Secret이 위치한 구획
* **Validated Secret for OCIR Auth Token:** OCIR Auth Token에 대한 Vault Secret 선택

  ```OCIR Auth Token 생성 및 Valut Secret 생성) ``` OCIR에 연결하기 위해서는 username과 password가 필요합니다. password의 경우는 인증 토큰(Auth Token)이라는 값을 활용하는데, 인증 토큰의 경우 우측 상단 프로파일에서 사용자를 클릭한 후 왼쪽에 있는 **인증 토큰** 메뉴를 통해서 토큰을 생성할 수 있습니다.

  ![](/assets/img/cloudnative-security/2022/weblogic_oke_8_1.png)

  이렇게 생성한 토큰을 OCI Vault에 저장하여야 합니다. Valut를 생성하기 위해서는 메뉴에서 **Identity & Security > Vault**로 이동하여 다음 화면과 같이 생성합니다.

  ![](/assets/img/cloudnative-security/2022/weblogic_oke_8_2.png)

  Valut 저장소를 생성한 후에는 아래 화면과 같이 마스터 암호화 키(Master Encryption Keys)를 생성합니다.

  ![](/assets/img/cloudnative-security/2022/weblogic_oke_8_3.png)

  이제 앞서 생성한 인증 토큰을 암호(Secret)에 생성합니다.
  ![](/assets/img/cloudnative-security/2022/weblogic_oke_8_4.png)

  **OCI Policies**
  * **OCI Policies:** 체크
    * Resource Manager Stack 실행시에 앞서 생성한 Valut Secret과 Oracle Database등의 접근을 허용하기 위한 Policy를 자동으로 생성해줍니다.

  ![](/assets/img/cloudnative-security/2022/weblogic_oke_9.png)

이제 모든 스택 구성이 완료되었습니다. **다음** 버튼을 눌러서 최종 검토를 한 후에 **생성** 버튼을 클릭하여 스택 생성 및 Job을 실행합니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_10.png)

**프로비저닝 진행**
![](/assets/img/cloudnative-security/2022/weblogic_oke_12.png)

**프로비저닝 완료**
![](/assets/img/cloudnative-security/2022/weblogic_oke_14.png)

**출력된 결과 확인**
![](/assets/img/cloudnative-security/2022/weblogic_oke_15.png)

### WebLogic 도메인 생성 
OKE Cluster에 WebLogic가 완료되었습니다. 이제 Jenkins를 활용하여 WebLogic Domain을 구성해 보도록 하겠습니다. Jenkins 서버는 Private Subnet에 구성되어 있기 때문에 Bastion 서버를 활용하여 터널링을 통해 접속해야 합니다. 먼저 SOCKS Proxy 구성을 다음과 같이 진행합니다. (아래는 MacOS에서 SOCKS Proxy 설정한 화면)

* **SOCKS Proxy Server:** localhost:1088

![](/assets/img/cloudnative-security/2022/weblogic_oke_16.png)

> SOCKS Proxy 설정은 Windows 10/11의 경우 인터넷 옵션에서 구성이 가능하며, Putty를 활용하여 구성도 가능합니다. 방법은 구글링을 해보면 많이 나와 있기 때문에 여기서는 다루지 않도록 합니다.

접속은 생성된 Private Load Balancer의 IP로 접속합니다. 생성된 Private Load Balancer의 Private IP는 **Networking > Load Balancer**에서 확인이 가능합니다. 다음과 같이 접속합니다.

* **Url:** http://[Private Load Balancer IP]/jenkins

Jenkins 초기 화면에서 Admin 사용자를 생성합니다.
![](/assets/img/cloudnative-security/2022/weblogic_oke_17.png)

여러개의 빌트인된 파이프라인을 볼 수 있습니다. 여기서 **create domain** 파이프라인으로 도메인을 생성할 것입니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_18.png)

파이프라인을 실행하기 전에 대부분의 파이프라인에서 Groovy Script를 활용하고 있기 때문에 Jenkins에서 Groovy Script를 사용하도록 허용해야 합니다. 먼저 Jenkins 관리 화면으로 이동합니다.
![](/assets/img/cloudnative-security/2022/weblogic_oke_27.png)

**In-process Script Approval**을 클릭합니다.
![](/assets/img/cloudnative-security/2022/weblogic_oke_28.png)

모든 스크립트를 **Approve** 합니다.
![](/assets/img/cloudnative-security/2022/weblogic_oke_29.png)

이제 다시 Jenkins 파이프라인 화면에서 **create doamin** 을 선택한 후 다음과 같이 입력 및 선택합니다.
* **Domain_Name:** okedomain(특수문자 허용하지 않습니다. 특수 문자가 들어간 경우 파이프라인 실행 시 오류 발생합니다.)
* **Base_Image:** Default
* **Administration_Username:** weblogic
* **Administration_Password:** welcome1
* **Managed_Server_Count:** 2 (최대 9개)
* **Patch Automatically:** 체크
그 외 모두 기본으로 둔 상태에서 **빌드하기** 버튼을 클릭합니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_19.png)
![](/assets/img/cloudnative-security/2022/weblogic_oke_20.png)

**실행 로그**
![](/assets/img/cloudnative-security/2022/weblogic_oke_21.png)

**Stage View**
![](/assets/img/cloudnative-security/2022/weblogic_oke_22.png)

다음 정보로 웹로직 관리 콘솔에 로그인을 합니다.
# Weblogic Server 로그인 정보
* **Url:** http://[Private Load Balancer IP]/[WebLogic Domain Name]/console (ex. http://10.0.6.9/okedomain/console)
* **ID:** weblogic
* **PW:** welcome1

![](/assets/img/cloudnative-security/2022/weblogic_oke_23.png)

정상적으로 로그인이 되었습니다.
![](/assets/img/cloudnative-security/2022/weblogic_oke_24.png)

Admin 서버와 2개의 Managed Server가 동작하고 있는 것을 확인할 수 있습니다.
![](/assets/img/cloudnative-security/2022/weblogic_oke_25.png)

### Sample Application 배포
이번에는 샘플 애플리케이션을 웹로직 서버에 배포해보도록 합니다. Jenkins 파이프라인에서 **sample App**을 선택합니다. 아래 화면과 같이 배포할 도메인을 선택하고 실패 시 롤백이 되도록 **Rollback_On_Failure**를 체크한 후 **빌드하기**버튼을 클릭합니다.

![](/assets/img/cloudnative-security/2022/weblogic_oke_26.png)

배포가 되면 External Load Balancer가 서비스로 배포됩니다. 다음과 같이 접속할 수 있습니다.

* https://[External Load Balancer IP]/sample-app/
![](/assets/img/cloudnative-security/2022/weblogic_oke_31.png)

지금까지 OCI 마켓플레이스를 통해서 WebLogic for OKE를 프로비저닝해보고, 웹로직 도메인 생성, 샘플 애플리케이션 배포까지 해보았습니다. 도메인 자체를 컨테이너 이미지화 하여 관리하고, 배포/확장/패치등을 CI/CD 파이프라인으로 자동화도 할 수 있도록 지원합니다. 사실 근래에 많은 애플리케이션이 Kubernetes 환경에서 운영이 되고 있고, DevOps 자동화 환경도 이에 맞춰서 운영이 되는 추세이기 때문에, 이러한 경험을 그대로 WebLogic 기반의 Java EE 애플리케이션 운영에도 적용할 수도 있으며, Kubernetes 환경에서 Java EE 애플리케이션 뿐 아니라 다양한 언어로 개발된 애플리케이션과의 연계가 용이한 환경도 훨씬 효율적으로 구성 가능할 것으로 기대됩니다.

