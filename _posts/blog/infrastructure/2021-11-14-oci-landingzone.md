---
layout: page-fullwidth
#
# Content
#
subheadline: "Infrastructure"
title: "OCI Landing Zone"
teaser: "퍼블릭 클라우드 환경에서 여러 조직이 함께 사용해야 하는 엔터프라이즈 환경을 구성해야 한다면, 좀 더 안전하고 잘 설계된 기초 환경을 필요로 할 것입니다. 엔터프라이즈 환경에서 클라우드를 보다 쉽게 구성하고, 운영 및 관리하기 위한 기초 공사를 Cloud Landing Zone이라고 합니다. 이번 포스팅을 통해서 오라클에서 제시하고 있는 OCI환경을 위한 Landing Zone 구성 방법에 대해서 살펴보겠습니다."
author: dankim
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, landingzone]
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

### Landing Zone이란
우선 Landing Zone이란 용어부터 살펴보겠습니다. Landing이라는 단어가 일반적으로 항공기나 우주선이 착륙하는 것을 의미하고, Landing Zone이 그 착륙하는 공간을 의미하는데, 항공분야뿐 아니라 여러 분야에서 이 용어가 사용되고 있습니다. 예를 들면, 군사용어로 Landing Zone은 헬기나 수송기가 구출작전을 수행하거나 군대나 보급품 투입을 위해 상륙하는 지역을 의미합니다. 골프에서도 티샷을 하고 공이 낙하하는 지역을 Landing Zone이라고 부릅니다.  
이와 같이 Landing Zone은 운송수단을 비롯해서 어떤 목적을 수행하기 위한 특정 수단이 안전하게 착륙할 수 있는 이상적인 공간을 의미하며, 이러한 공간을 위해서는 가장 기본적이고 필수적인 요소들을 확보해야 합니다. 헬기의 경우 프로펠라 크기를 감안한 안전면적이나 헬기와 사람 혹은 교통수단과의 안전거리 확보등이 기본요소가 될 수 있습니다.

![](/assets/img/infrastructure/2022/oci-landingzone-1.jpeg)


### Cloud Landing Zone
위에서 언급한 분야 외에도 주식이나 코인, 광고, 낚시등 다양한 분야에서 Landing Zone이라는 용어가 사용이 되고 있습니다.  
마찬가지로 IT 분야에서도 Landing Zone이라는 용어가 종종 사용이 되는데, IT 프로젝트 수행에 있어서 성공 요소들을 테이블로 정의한 것을 Landing Zone이라고 부르기도 합니다.

퍼블릭 클라우드 환경의 경우도 한두사람이 사용하는 환경이라면 크게 신경쓰지 않아도 되겠지만, 여러 조직이 함께 사용해야 하는 엔터프라이즈 환경을 구성해야 한다면, 이를 위해 좀 더 안전하고 잘 설계된 기초 환경을 필요로 할 것입니다. 이러한 환경을 쉽게 구성, 관리 및 운영을 위한 기초 공사가 필요할텐데, 이것을 Cloud Landing Zone이라고 부릅니다.

![](/assets/img/infrastructure/2022/oci-landingzone-2.png)

### OCI Landing Zone
모든 CSP(AWS, Azure, GCP, Alibaba등)들은 기본적으로 Langing Zone 참조 아키텍처와 솔루션을 제공하고 있습니다. 마찬가지로 OCI에서도 Landing Zone 참조 아키텍처를 제공합니다. OCI가 타 CSP와 다른 부분은 멀티 어카운트 통합부분입니다. 보통 CSP가 제공하는 Landing Zone 아키텍처를 살펴보면 각각의 어떤 역할을 담당하는 여러개의 어카운트를 통합하는 형태의 아키텍처가 기본 전제가 되는 경우가 많습니다. OCI의 경우는 Tenancy (어카운트) 하위에 있는 Compartment(구획)을 활용하여, 하나의 어카운트(Tenancy)에 특정 역할을 담당하는 여러개의 Compartment로 구성하는 형태의 아키텍처로 제공하고 있습니다.

OCI Landing Zone은 CIS (Center for Internet Security) 벤치마크를 충족하는 문서를 참고합니다. 관련된 문서는 아래 링크를 참고하면 되고, OCI용 CIS 벤치마크 자료도 다운로드 받아볼 수 있습니다.

[https://www.cisecurity.org/benchmark/oracle_cloud/](https://www.cisecurity.org/benchmark/oracle_cloud/)

해당 문서에는 OCI에서 Landing Zone을 구성할 때 참고할 모범사례들이 각 영역별로 구분되어 잘 설명이 되어 있습니다. 또한 CIS 벤치마크를 기반으로 OCI에 Landing Zone을 자동으로 구성해주는 Terraform 모듈을 제공하고 있습니다. 관련 Terraform 모듈은 아래 GitHub 저장소를 참고합니다.

[https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart](https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart)

### OCI Landing Zone Architecture
OCI에서 제공하는 참조 아키텍처는 네트워크 환경 구성에 따라서 크게 두가지 형태로 구성이 가능한데, 첫번째는 단일 리전에 단일 혹은 여러 VCN환경(Exadata 포함되는 경우) 형태로 구성하는 아키텍처입니다.

![](/assets/img/infrastructure/2022/oci-landingzone-3.png)

기본적으로 생성되는 내용은 용도에 따라 3개의 컴파트먼트가 생성이 되고, 필요에 따라서 Exadata Compartment를 생성할 수 있습니다.  
Security Compartment에는 Notification이나 키관리, 취약점 스캐닝과 같은 보안과 연관된 리소스들이 생성이 되고, AppDev에는 기본적으로 Object Storage가 하나 생성이 됩니다. 이 안에 사용자가 개발에 필요한 리소스들을 생성해서 관리하도록 되어 있습니다. DB compartmen에는 Database 자원을, 그리고 옵션으로 Exadata 관련 자원을 관리하는 Exadata Compartment가 포함될 수 있습니다.

이러한 컴파트먼트를 세부적으로 관리하기 위한 사용자 그릅과 다이나믹 그룹, 정책이 생성되고, 여러 리소스 자원들의 이벤트를 생성하기 위한 이벤트 규칙이 생성됩니다.  
네트워크는 기본적으로 하나의 VCN이 생성되고, 웹 서브넷, 애플리케이션 서브넷, DB 서브넷이 생성이 되며, 관련해서 라우팅 테이블과 Security List, 네트워크 시큐리티 그룹이 생성됩니다.
그외 퍼블릭 서브넷을 위한 Internet Gateway, 프라이빗 서브넷을 위한 NAT Gateway, 내부 OCI서비스 연결을 위한 Service Gateway가 기본 생성됩니다.

그림을 보면 알겠지만, 3 Tier 애플리케이션을 위한 아키텍처인 것을 알수 있습니다. 현재 OCI에서는 3 Tier 애플리케이션을 위한 아키텍처만 제공하고 있는데, 향후 로드맵을 보면 쿠버네티스 환경을 위한 아키텍처도 제공될 예정이라고 합니다.

두번째 그림은 네트워크 구성을 Hub & Spoke 형태로 구성하는 아키텍처입니다.

![](/assets/img/infrastructure/2022/oci-landingzone-4.png)
앞의 구성과 다른 부분은 네트워크 부분입니다. 네트워크 부분이 앞쪽에 허브 역할을 하는 하나의 VCN을 두고 여기에 Inbound과 Outbound를 위한 서브넷으로 구성하는 형태입니다. DMZ역할을 하는 VCN이라고 이해하면 됩니다.  
그리고 안쪽에 용도에 따라서 Spoke형태로 VCN을 추가하고, 각 VCN을 허브 역할을 하는 VCN과 DRG 게이트웨이를 활용해서 연결하는 구조라고 보면 됩니다.  
네트워크 자체를 분리해서 관리할 필요가 있고, 좀 더 네트워크 보안에 초점을 둔 아키텍처라고 볼 수 있습니다.  

### CIS OCI Landing Zone Quick Start Template
이러한 Langing Zone을 구성하기 위해서 앞에서 언급한거처럼 OCI에서는 아래는 OCI Langing Zone Terraform 모듈을 제공하고 있으며, 모듈은 Github에서 다운로드 받을 수 있습니다. 기본적으로 이 모듈은 Terraform으로 수행할 수도 있지만, OCI에서는 Terraform을 돌릴수 있는 IaC 서비스로 Resource Manager라는 서비스를 사용하여 실행할 수 있습니다. Azure의 경우도 Blueprint나 Terraform으로 수행할 수 있도록 제공하는데, OCI도 이와 비슷하다고 보면 됩니다.

아래는 OCI Langing Zone Terraform 모듈을 통해서 다뤄지는 리소스들입니다.

* IAM (Identity & Access Management)
* Networking
* Keys
* Cloud Guard
* Logging
* Vulnerability Scanning
* Bastion
* Events
* Notifications
* Object Storage

### CIS OCI Landing Zone Quick Start Template 실행 방법
앞서 언급한거처럼 Terraform CLI로 실행이 가능하지만, 여기서는 OCI Resource Manger를 활용하여 Landing Zone환경을 구성해보도록 하겠습니다.

우선 아래 Github 저장소 에서 템플릿을 Zip 파일로 다운로드 받습니다.

[https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart](https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart)

![](/assets/img/infrastructure/2022/oci-landingzone-5.png)

그리고 OCI에는 Resource Manager라는 Infra as Code를 위한 서비스가 있는데, 여기서 스택 생성을 클릭하면 아래와 같은 화면을 볼 수 있습니다. 여기서 Github 에서 다운로드 받은 템플릿 zip파일을 드래그 드랍합니다.

![](/assets/img/infrastructure/2022/oci-landingzone-6.png)

다음에 몇가지 변수들을 입력해야 하는데, 우선 네트워크부분에 아이피등(CIDR)을 입력합니다. 

여기서 Hub & Spoke Architecture라고 선택하는 부분이 있는데, 앞서 설명한 두 개의 아키텍처중에서 Hub & Spoke 형태로 구성하고자 한다면 이 부분을 체크하면 됩니다. 

Connectivity는 온프레미스 환경과 연결 구성하는 부분이 필요한 경우 추가할 수 있습니다. 

Notifications에서는 특정 이벤트 발생 시 알림을 받을 관리자 이메일 주소를 입력하면, Notifications 서비스가 활성화 되고, 사용자가 보안 취약한 구성이나 행위를 감지하고 적절하게 대처하기 위한 서비스로 Cloud Guard를 활성화 하고자 하면 마찬가지로 ENABLE하면 됩니다. 

그외 로깅 서비스를 활성화 하면 오딧 로그나 VCN 네트워크 로그를 수집할 수 있도록 활성화 되고, Vulnerability Scanning을 체크하면, 각 Langing Zone Compartment에 대한 보안 취약한 문제들이 있는지 스캔해서 리포팅해줍니다.

![](/assets/img/infrastructure/2022/oci-landingzone-7.png)

이렇게 스택을 생성한 후에 Apply를 클릭해서 스택을 실행하면 OCI에 랜딩존 환경을 구성해줍니다.
대략 10-15분 정도 소요됩니다.

![](/assets/img/infrastructure/2022/oci-landingzone-8.png)

### 구성된 Resource 확인
스택을 실행하고 나면 다음과 같은 리소스들이 생성됩니다.

#### IAM
앞서 아키텍처에서 설명한거처럼 다음과 같이 4개의 컴파트먼트가 생성되고 관련된 그룹과 Policy가 생성된 것을 확인할 수 있습니다.
![](/assets/img/infrastructure/2022/oci-landingzone-9.png)

#### Network
단일 VCN 모드로 생성한 경우인데, 네트워크 부분은 app, db, security로 구분된 3개의 서브넷이 생성되고, 그외 라우팅 테이블, 인터넷 및 NAT 게이트웨이아 내부 OCI 서비스 연동을 위한 서비스 게이트웨이, Security List와 Network Security Group이 용도에 맞게 생성된 것을 확인할 수 있습니다.
![](/assets/img/infrastructure/2022/oci-landingzone-10.png)

#### Event, Log, Audit, Notification
여러 이벤트들을 알림으로 전달하기 위한 이벤트 규칙과 Notification이 활성화 되고, 로그를 중앙에서 모니터링하기 위한 로깅 서비스가 활성화 된 것을 확인할 수 있습니다.

![](/assets/img/infrastructure/2022/oci-landingzone-11.png)

#### Cloud Guard
마지막으로 Cloud Guard가 활성화 되는데, 사용자의 보안 취약한 구성이나 행위를 모니터링하고 감지하며, 이를 해결하기 위한 서비스입니다.

![](/assets/img/infrastructure/2022/oci-landingzone-12.png)

### Security Partners
기본 제공하는 아키텍처위에 특정 벤더의 보안 솔루션을 사용해야 하는 경우가 있을 수 있습니다.
이를 위해 제공되는 템플릿도 같이 제공되고 있는데, 현재는 아래 4개의 제품을 OCI Langing Zone 아키텍처에 추가로 구성하실 수 있습니다.

#### Palo Alto Networks
[https://github.com/oracle-quickstart/oci-palo-alto-networks/tree/master/cis-landing-zone](https://github.com/oracle-quickstart/oci-palo-alto-networks/tree/master/cis-landing-zone)

#### Fortinet 
[https://github.com/oracle-quickstart/oci-fortinet/tree/master/cis-landing-zone](https://github.com/oracle-quickstart/oci-fortinet/tree/master/cis-landing-zone)

#### CheckPoint
[https://github.com/oracle-quickstart/oci-check-point/tree/master/cis-landing-zone](https://github.com/oracle-quickstart/oci-check-point/tree/master/cis-landing-zone)

#### CISCO
[https://github.com/oracle-quickstart/oci-cisco/tree/master/cis-landing-zone](https://github.com/oracle-quickstart/oci-cisco/tree/master/cis-landing-zone)

### Roadmap (CIS OCI Benchmark Foundation 1.2)
CIS OCI Langing Zone의 현재 버전인 1.1입니다. 향후 1.2로 업데이트가 될 텐데, 공식적으로 추가 및 변경될 내용중에서 몇 가지 주요하게 볼 부분은 다음과 같습니다.

* Support OKE networking  
현재는 3 Tier Application Architecture에 대한 지원만 되지만, OKE Networking을 이후 버전부터 지원하면서, MSA와 같은 아키텍처도 같이 대응할 수 있게 될 예정입니다.

* Cost tracking and budgets  
비용이나 예산에 대한 관리 구성도 포함(Cost tracking and budgets)될 것으로 보입니다.

* Integrate with OCI Console Quick Start  
템플릿을 GitHub에서 다운로드 받아서 Resource Manager로 실행하는 것이 아니라 OCI Console에서 바로 실행함으로써 실행에 있어서 좀 더 간편함을 제공할 예정입니다.

* Pipeline automation  
OCI에서 제공하는 DevOps 서비스도 Landing Zone에 같이 추가될 예정입니다.

* Support OCI Organizations  
OCI에서는 Compartment를 활용하여 Langing Zone 환경을 구성한다고 설명했는데, 사실 이 부분이 하나의 Tenancy만 사용한다면 장점이 될 수도 있겠지만, 여러 Tenancy를 사용하는 고객 입장에서는 좀 아쉬운 부분이 될 수 있습니다. 여러 Tenancy를 통합해서 Landing Zone을 구성해야 하는 요건이 있을 수 있기 때문입니다. 다행히 이번에 OCI도 Organizations라는 기능으로 여러개의 Tenancy를 관리하고 통합하는 기능이 추가되었는데, 이 부분도 다음 버전의 Landing Zone 아키텍처에 추가될 예정이라고 합니다. 

* Integrate with upcoming new OCI IAM  
또한 기존에 IAM(OCI Native 계정관리)과 Identity Cloud Service (PaaS형 계정관리 서비스)가 분리되어 있었는데, 이번에 ICI IAM이라는 이름으로 통합이 되면서 앞으로 Tenancy나 사용자, 그룹, Compartment등의 관리는 각각의 OCI IAM의 Identity Domain내에서 관리되기 때문에 Landing Zone 템플릿에도 이 이부분이 반영이 될 예정이라고 합니다.

### 참조
[https://docs.oracle.com/en/solutions/cis-oci-benchmark/index.html](https://docs.oracle.com/en/solutions/cis-oci-benchmark/index.html)  
[https://www.ateam-oracle.com/post/cis-oci-landing-zone-quick-start-template](https://www.ateam-oracle.com/post/cis-oci-landing-zone-quick-start-template)  
[https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart](https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart)