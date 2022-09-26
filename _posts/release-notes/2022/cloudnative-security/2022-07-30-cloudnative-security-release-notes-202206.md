---
layout: page-fullwidth
#
# Content
#
subheadline: "OCI Release Notes 2022"
title: "7월 OCI Cloud Native & Security 업데이트 소식"
teaser: "2022년 7월 OCI Cloud Native & Security 업데이트 소식입니다."
author: dankim
breadcrumb: true
categories:
  - release-notes-2022-cloudnative-security
tags:
  - oci-release-notes-2022
  - july-2022
  - cloudnative
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

## Use GraalVM Enterprise in DevOps Build Pipelines
* **Services:** DevOps
* **Release Date:** July 7, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/devops/using/graalvm.htm](https://docs.oracle.com/en-us/iaas/Content/devops/using/graalvm.htm){:target="_blank" rel="noopener"} 

### 기능 소개
새로은 JIT Compiler인 Graal을 기반으로 하는 JVM인 GraalVM은 성능, Polygrot 환경 (여러 언어를 통합), 빠른 시작이 가능한 Native Image 기능을 제공하는 최신 VM입니다.

OCI에서는 GraalVM Enterprise를 추가 비용없이 사용할 수 있는데, 이제 OCI DevOps Build Pipeline에서 이 GraalVM Enterprise 빌드 자동화를 지원합니다.

### 빌드 파이프라인 구성
GraalVM Enterprise에서 필요한 컴포넌트를 설치하는 명령어를 스탭에 추가할 수 있는데, 아래 예시는 GraalVM Native Image를 위한 컴포넌트를 설치하는 스탭입니다.

```
steps:
  - type: Command
    name: "Install the latest GraalVM Enterprise 22.x for Java 17 - JDK and Native Image"
    command: |
      yum -y install graalvm22-ee-17-native-image
```

환경 변수 JAVA_HOME에 GraalVM Home Path를 다음과 같이 정의할 수 있습니다.
```
env:
  variables:
    "JAVA_HOME" : "/usr/lib64/graalvm/graalvm22-ee-java17"
```

아래와 같이 Step에서 Path에 Java Home을 지정할 수 있습니다.
```
env:
  variables:
    # PATH is a reserved variable and cannot be defined as a variable.
    # PATH can be changed in a build step and the change is visible in subsequent steps.
 
steps:
  - type: Command
    name: "Set the PATH here"
    command: |
      export PATH=$JAVA_HOME/bin:$PATH
```

아래 빌드 파이프라인은 Java 애플리케이션을 GraalVM과 Maven을 활용하여 Native Image로 빌드하는 예시입니다.

```
version: 0.1
component: build
timeoutInSeconds: 600
runAs: root
shell: bash
env:
  variables:
    "JAVA_HOME" : "/usr/lib64/graalvm/graalvm22-ee-java17"
    # PATH is a reserved variable and cannot be defined as a variable.
    # However, PATH can be changed in a build step and the change is visible in subsequent steps.
steps:
  - type: Command
    name: "Install the latest GraalVM Enterprise 22.x for Java 17 - JDK and Native Image"
    command: |
      yum -y install graalvm22-ee-17-native-image
  - type: Command
    name: "Set the PATH here. JAVA_HOME already set in env > variables above."
    command: |
      export PATH=$JAVA_HOME/bin:$PATH
  - type: Command
    name: "Build a native executable with the installed GraalVM Enterprise 22.x for Java 17 - Native Image"
    command: |
      mvn --no-transfer-progress -Pnative -DskipTests package
outputArtifacts:
  - name: app_native_executable
    type: BINARY
    location: target/my-app
```
---

## Support for VCN-native pod networking
* **Services:** Container Engine for Kubernetes
* **Release Date:** July 12, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengpodnetworking_topic-OCI_CNI_plugin.htm](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengpodnetworking_topic-OCI_CNI_plugin.htm){:target="_blank" rel="noopener"} 

### 기능 소개
OKE에서는 기존에 기본 CNI(Container Network Interface: 컨테이너간 네트워킹 제어를 위한 플러그인 개발 표준)로 Flannel만 제공되었습니다. Flannel은 대표적인 CNI중 하나이며, 오버레이 네트워크(Overlay Network: 각 노드들의 네트워크위에 별도의 가상 네트워크를 구성하여 마치 하나의 네트워크인 것처럼 인식하는 것)를 두고 서로 다른 노드간의 Pod 통신도 문제 없이 이뤄질 수 있도록 해주는 역할을 합니다.

**Flannel overlay networking**  
<cite>Image source: https://blogs.oracle.com/cloud-infrastructure/post/announcing-vcn-native-pod-networking-for-kubernetes-in-oci</cite>
![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONT94FDF8973EA4486AB65E88CA4DF72114/Medium?cb=_cache_7675&format=jpg&channelToken=f7814d202b7d468686f50574164024ec)

Flannel Overlay Networking로 클러스터를 구성하면, 위 그림처럼 Layer 3에서 네트워킹을 제공하는 추가적인 Overaly Networking이 구성됩니다. 그리고 Kubernetes Worker Node에서 실행되는 Pod는 Overlay Network을 통해서 IP를 할당받게 됩니다. Flannel은 VCN Worker Node 서브넷 대역의 IP를 사용히지 않아야 하는 경우나 Node 서브넷에서 제공되는 IP수가 운영해야 하는 Pod수보다 적을 수 있는 환경에서 사용하면 좋습니다.

자세한 내용은 아래 Flannel 공식 Github 문서를 참고 하시기 바랍니다.

[Flannel](https://github.com/flannel-io/flannel)

**Native pod networking**  
<cite>Image source: https://blogs.oracle.com/cloud-infrastructure/post/announcing-vcn-native-pod-networking-for-kubernetes-in-oci</cite>

![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONT78BF0A5D337F41A887531F7969A18FDE/Medium?cb=_cache_7675&format=jpg&channelToken=f7814d202b7d468686f50574164024ec)

위 그림은 Worker Node를 위한 서브넷(CIDR: 10.20.40.0/24)과 Pod를 위한 서브넷  (CIDR: 10.20.50.0/24)을 VCN에 생성하여 **Native pod networking**를 사용한 OKE Cluster를 구성한 그림입니다. Pod의 경우 각 Worker Node의 vNICs(가상 네트워크 인터페이스 카드)에 Pod 서브넷 대역에서 제공되는 Private IP를 할당하고 이를 Pod에 사용하게 되며, Pod는 해당 인터페이스를 통해서 인바운드/아웃바운드 통신을 하게 됩니다. 이런 식으로 각 Pod는 vNIC에 연결되고 VCN에 직접 연결되어 Overlay Networking과 같은 캡슐화 없이 통신이 가능해집니다. Native pod networking을 사용한 Cluster내의 Pod는 OKE Cluster 노드가 아닌 같은 VCN내의 다른 VM 인스턴스과의 통신이 가능하며, 다른 VCN과의 통신(Local or Remote Peering 사용), 온프레미스 환경과의 통신(OCI FastConnect 혹은 IPSec VPN 사용)도 사용 가능합니다. 또한 OCI VCN Flow Log 기능을 통해서 Pod간 트래픽도 추적할 수 있습니다. 이 외에도 캡슐화를 위한 별도의 레이어가 없어 오버헤드가 줄어들면서 처리량이나 대기시간에 있어서 일관성 있는 성능을 제공합니다. (다른 노드간 Pod 통신 대기시간이 Flannel 사용시보다 약 25% 향상됨)

### Native pod networking을 사용하는 OKE Cluster 구성하기
아래 포스트 참조

[VCN-Native Pod Networking CNI 플러그인을 사용하여 OKE (Oracle Container Engine for Kubernetes) 클러스터 구성하기](https://team-okitoki.github.io/cloudnative/vcn-native-pod-networking-for-oke/)

