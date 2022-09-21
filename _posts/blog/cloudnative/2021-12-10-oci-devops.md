---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI DevOps Service"
teaser: "OCI에서 DevOps라는 서비스를 제공하고 있는데, 관련 서비스에 대해서 간략히 살펴보고 정리해 봅니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, devops]
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

### DevOps
데브옵스(DevOps)는 소프트웨어의 개발(Development)과 운영(Operations)의 합성어로서, 소프트웨어 개발자와 정보기술 전문가 간의 소통, 협업 및 통합을 강조하는 개발 환경이나 문화를 의미합니다. (출처: 위키백과)

![](/assets/img/cloudnative-security/2022/devops.png)

DevOps를 예전에는 운영조직이 단순히 운영적인 측면만 부각해서 적용하거나, 혹은 개발자가 운영까지 모두 책임져야만 하는 그런 경우들이 많았었는데, 근래에는 DevOps만을 위한 별도의 전담팀을 두는 경우가 점점 많아지고 있는 거 같습니다. DevOps를 위한 전담팀은 보통 그들의 환경에 적합한 올바른 도구를 찾아서, 이를 쉽고 효율적으로 운영하기 위한 전략을 고민하게 됩니다. 이러한 고민을 조금이나마 덜어주기 위해서 각 클라우드 프로바이더들은 잘 구성된 DevOps 지원을 위한 서비스들을 제공하고 있는데, OCI DevOps 서비스도 이러한 End-to-End DevOps 자동화를 위한 서비스라고 볼 수 있습니다. 

### OCI DevOps Service
![](/assets/img/cloudnative-security/2022/oci-devops-1.png)
OCI DevOps 서비스는 소스관리부터, 빌드, 테스트 및 배포의 전반적인 엔드투엔드 DevOps를 지원합니다. 홈페이지상에서는 비용이 무료라고 나와 있는데, 서비스 자체에 적용된 비용은 없지만, 코드 저장을 위한 스토리지 비용이나, 빌드 및 배포과정에서 사용된 자원들(예, 로그, 알림, 빌드 환경등)에 대해서는 비용이 발생합니다. 하지만 사용시에만 발생하고, 활용 자원에 대한 비용도 저렴해서 가격에 대한 장점은 분명히 있다고 생각됩니다.

OCI DevOps의 경우에는 하나의 DevOps 프로젝트(OCI에서는 DevOps 프로젝트를 하나 생성하는것 부터 시작)내에 코드관리부터, 빌드, 파이프라인, 배포, 모니터링등의 기능들이 모두 같이 포함됩니다. 보통 타사의 경우 필요한 부분만(예를 들면, 빌드) 활성화 해서 사용이 가능한 반면에 OCI의 경우는 프로젝트 단위로 생성해서 사용하도록 되어 있는데, 각 단계별로 별도의 통제가 필요하거나, 혹은 따로 모니터링을 해야 하는 경우와 같이 세심하게 관리는 어렵겠지만, 전체 과정을 하나의 프로젝트에서 통합 관리함으로써 관리상의 편리함에 대한 이점은 있다고 볼 수 있습니다.

***DevOps 프로젝트 화면***  
DevOps 프로젝트 생성후에 프로젝트 상세화면에 들어가면 우측에 코드관리, 빌드, 배포, 모니터링과 관련된 모든 메뉴를 볼 수 있습니다.
![](/assets/img/cloudnative-security/2022/oci-devops-0.png)

### SCM
#### 1. Code Repositories
Code 저장소로 Private Git Repository를 제공합니다. 추가적으로 GitHub이나 GitLab과 같은 외부 서비스들을 연결해서 OCI DevOps에서 관리하게 해주는 Mirroring 기능도 제공하는데, GitHub이나 GitLab에 있는 소스를 OCI 환경에서 빌드하고 배포하는 경우 이 기능을 활용할 수 있습니다.

#### 2. Artifacts
OCI에서는 Maven이나 Python Repository와 같이 패키지화된 소프트웨어들을 관리하는 Artifact Repository를 제공합니다. DevOps의 Artifacts는 배포 파이프라인에서 이 Artifact Repository에 있는 소프트웨어 패키지를 참조할 수 있도록 구성할 수 있는 기능입니다. Artifact에서는 Artifact Repository에서 관리되는 파일중에서 인스턴스 롤링 업데이트를 위한 YAML 형태의 파일(인스턴스 그룹이라는 기능으로 제공), Kubernetes Manifest 파일, 일반 패키징된 애플리케이션 (Maven이나 Python Repository 역할)을 참조할 수 있으며, 추가적으로 컨테이너 이미지 레지스트리 (OCIR)의 컨테이너 이미지를 참조할 수 있습니다. Artifacts를 통해 참조된 패키지나 컨테이너 이미지는 배포 파이프라인의 스테이지로 추가될 수 있습니다.

### 빌드 파이프라인
빌드 파이프라인은 워크플로우를 쉽게 구성하기 위한 UI를 제공하는데, 기본적으로 하나의 파이프라인에 다음 4개의 스테이지를 사용할 수 있습니다. 파이프라인에서 스테이지를 추가하기 위해서는 **+** 버튼을 클릭한 후 추가하기 위한 스테이지 목록에서 스테이지를 선택합니다.

***빌드 파이프라인 화면***
![](/assets/img/cloudnative-security/2022/oci-devops-2.png)

***빌드 파이프라인에 스테이지 추가***
![](/assets/img/cloudnative-security/2022/oci-devops-4.png)


* **Managed Build:**  
OCI DevOps에서 제공되는 빌드 러너를 이용해서 빌드 및 테스트 수행합니다. (AMD 혹은 Intel Shape 1 OCPU, 8 GB 사용, 별도 비용 발생)
* **Deliver Artifacts:**  
패키징된 소프트웨어를 Artifact Repository로 퍼블리시합니다.
* **Trigger Deployment:**  
배포 파이프라인이 있는경우 빌드 파이프라인에서 배포 파이프라인을 호출합니다.
* **Wait:**  
빌드 파이프라인내에서 사용하는 대기 타이머를 위한 스테이지입니다.

이 기능외에 빌드 이력관리 기능을 제공합니다.

### 배포 파이프라인
빌드 파이프라인과 마찬가지로 워크플로우 구성을 위한 UI를 제공하고 있으며 다음과 같은 스테이지를 사용할 수 있습니다. 아래 내용을 보면 알겠지만, 현재 배포환경의 경우 OKE, Instance Group, Functions을 지원하고 있습니다. 크게 3개의 영역으로 나눠서 스테이지를 제공합니다.

***배포 파이프라인 화면***
![](/assets/img/cloudnative-security/2022/oci-devops-3.png)

***배포 파이프라인에 스테이지 추가***
![](/assets/img/cloudnative-security/2022/oci-devops-5.png)

#### 1. Deploy
* **Apply manifest to your Kubernetes cluster:**  
쿠버네티스 클러스터 배포를 위한 매니패스트를 활용하여 배포할 수 있도록 해줍니다.
* **Deploy incrementally through Compute instance groups:**  
Compute Instance Group 점진적으로 롤링 업데이트를 수행하며, 한번에 오프라인이 될 수 있는 인스턴스의 수를 지정 가능하고 자동 롤백을 지원합니다.  
참고로 인스턴스 그룹 환경 생성은 아래 링크 참고합니다.

  [https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/devops/using/create_instancegroup_environment.htm#create_instance_group_environment](https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/devops/using/create_instancegroup_environment.htm#create_instance_group_environment)

* **Uses the built-in Functions update strategy:**  
Functions 배포해주는 스테이지입니다.

#### 2. Control
* **Pause the deployment for approvals:**  
배포 중간단계에서 배포 파이프라인에 대한 승인 권한이 있는 관리자가 승인을 해야 진행할 수 있도록 해주는 스테이지로 승인자 수를 지정할 수 있습니다. 승인자의 경우는 OCI Policy를 통해서 지정할 수 있도록 되어있습니다.
* **Traffic Shift:**  
배포하는 과정에서 들어오는 트래픽을 분산하도록 해줍니다. Load Balancer가 지정되어 있는 백엔드에 대해서만 가능하며, Load Balancer와 Backend Listener, Traffic Target (실제 트래픽이 이동할 댓아 백엔드)를 지정합니다. Batch Count, Batch Delay의 경우 들어오는 트래픽의 얼마큼을 이동할지를 결정하는데, 예를 들어 Batch Count를 5로 지정하는 경우 20%(100/5)가 대상 환경으로 이동합니다. 보통 Canary나 Blue/Green 배포 전략을 세울때 사용하게 됩니다.
* **Wait:**  
배포 파이프라인에서 특정 시간만큼 일시중지가 필요할 때 사용됩니다.

#### 3. Integrations
* **Run a custom logic through a function:**  
배포 과정에서 특정 시스템에 로그를 남겨야 하거나, 알림을 특정 사용자에게 전달해야 하는 경와 같이 별도의 커스텀 로직을 실행해야 하는 경우가 있을 수 있습니다. 이 경우에 OCI Functions에 로직을 담은 함수를 배포하고, 배포 파이프라인에서 이를 활용할 수 있습니다.

빌드 파이프라인과 동일하게 배포 파이프라인에도 이력관리 기능을 제공합니다.

### 기타 제공 기능
* 빌드 및 배포에 대한 로깅
* 매트릭스 (빌드 및 배포 실행 시간, 실패 건수, 배포 스테이지 타임아웃 건수, 코드 저장소 용량 및 개수, 코드 저장소 Push 및 Pull 건수 등)

### Jenkins와 통합
마지막으로 살펴볼 기능은 Jenkins와의 통합 기능입니다. 이 기능은 OCI Console에서 제공되는 기능이 아니라, Jenkins Plugin으로 제공되는 기능입니다.

[https://plugins.jenkins.io/oracle-cloud-infrastructure-devops/](https://plugins.jenkins.io/oracle-cloud-infrastructure-devops/)

앞서 간단히 언급한 거처럼, 클라우드 프로바이더에서 제공하는 DevOps 서비스를 활용하기도 하지만, 보통은 Private 환경이나, 멀티 클라우드 환경으로 인해서 Jenkins와 같이 널리 사용되는 도구들을 표준으로 활용하는 경우가 많습니다. 만약 CI도구로 Jenkins를 활용하고 있다면, OCI Artifact 업로드나 배포 파이프라인 연동으로 OCI 빌드 파이프라인이 아닌 Jenkins와 통합하고자 하는 요구가 있을 수 있습니다. 이때 OCI DevOps Service에서 제공하는 Jenkins Plugin을 통해서 통합할 수 있습니다. 

### 참고
* https://docs.oracle.com/en-us/iaas/Content/devops/using/home.htm  
* https://plugins.jenkins.io/oracle-cloud-infrastructure-devops/  
* https://technology.amis.nl/software-development/oci-devops-build-pipelines-and-code-repositories-for-cicd/  
* https://docs.oracle.com/en/solutions/build-pipeline-using-devops/index.html#GUID-D0D5B9DA-5C61-468C-A238-BE5530965A3A
