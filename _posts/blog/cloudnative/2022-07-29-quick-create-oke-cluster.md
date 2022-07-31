---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI Container Engine for Kubernetes (OKE) Cluster를 Quick Create(빠르게 생성) 기능을 활용하여 빠르게 구성하기"
teaser: "OCI에서 서비스하는 관리형 쿠버네티스 서비스인 OCI Container Engine for Kubernetes (OKE)의 Cluster를 Quick Create(빠르게 생성) 기능을 사용하여 빠르게 구성하는 방법을 설명합니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, kubernetes, oke]
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

### Oracle Kubernetes Engine (OKE)
Oracle Cloud Infrastructure Container Engine for Kubernetes (줄여서 OKE)는 OCI에서 서비스하는 관리형 쿠버네티스 엔진입니다. 

쿠버네티스가 무엇인지에 대해서는 아래 쿠버네티스 홈페이지 문서를 참고합니다.

[쿠버네티스란 무엇인가?](https://kubernetes.io/ko/docs/concepts/overview/what-is-kubernetes/)

대부분의 클라우드 제공자들이 쿠버네티스 서비스를 제공하고 있는데, OCI에서는 **Control Plane**에 대한 비용은 무료이고, 사용한 리소스 (Compute, Storage, Network등)에 대한 비용만 지불합니다. 리소스 비용도 타사 대비 많이 저렴해서 아주 낮은 비용으로 서비스를 이용할 수 있습니다. 또한 Database로 유명한 Oracle DB나 MySQL DB를 OCI에서 서비스형으로 제공하고 있는데, OKE와 잘 통합되어 있어서 이러한 DB를 OKE에서 쉽게 활용할 수 있습니다.

### OKE Cluster 빠른 생성
그럼 우선 OKE Cluster를 빠른 생성 기능을 활용하여 생성해보도록 하겠습니다. **빠른 생성**은 OKE 클러스터를 구성할 때 가장 최소의 정보만 제공하면 나머지는 자동으로 생성해 주는 기능입니다. 기본적으로 처음 지정한 OKE Cluster 이름을 Prefix로 해서 VCN, Instance, Compute등이 자동으로 생성됩니다.

먼저 **cloud.oracle.com**으로 로그인합니다. 계정이 없다면 아래 포스트를 참고하여 계정을 생성하고 로그인합니다.

[OCI 무료 계정 생성 및 관리하기](https://team-okitoki.github.io/getting-started/free-oci-promotions/)

OCI Console에 로그인하면, 좌측 상단의 햄버거 메뉴를 클릭하고, **개발자 서비스(Developer Services) > Kubernetes 클러스터(Kubernetes Cluster) (OKE)**를 순서대로 클릭합니다.

![](/assets/img/cloudnative-security/2022/quick-create-oke-cluster-1.png)

좌측 구획(Compartment)를 선택한 후 **클러스터 생성(Create Cluster)** 버튼을 클릭합니다. **클러스터 생성 대화창**에서 **빠른 생성(Quick Create)**를 선택한 후 **제출(submit)**을 클릭합니다.

![](/assets/img/cloudnative-security/2022/quick-create-oke-cluster-2.png)

**빠른 클러스터 생성 대화창**에서 다음과 같이 입력합니다.

* **이름(Name):** my-oke-cluster-1
* **Kubernetes 버전(Kubernetes version):** v1.23.4
  * 포스팅하는 시점에서 가장 최신 버전은 1.23.4 버전입니다.
* **Kubernetes API 끝점(Kubernetes API Endpoint):** 공용 끝점(Public Endpoint)
  * Kubernetes API Endpoint를 Public으로 제공할 지, Private 으로 제공할 지를 선택할 수 있습니다.
* **Kubernetes 워커 노드(Kubernetes worker nodes):** 전용 워커(Private Workers)
  * Kubernetes 워커 노드의 위치를 Private 혹은 Public으로 지정할 수 있습니다.
* **Shape:** VM.Standard.E4.Flex
  * AMD Flex Shape으로 CPU와 메모리를 지정할 수 있습니다.
    * OCPU 수 선택: 1 OCPU
    * 메모리 양(GB): 16GB
* **노드 수(Number of nodes):** 3

입력이 완료되면 **다음**을 클릭합니다.

![](/assets/img/cloudnative-security/2022/quick-create-oke-cluster-3.png)

마지막으로 입력된 내용을 검토한 후 **클러스터 생성(Create Cluster)** 버튼을 클릭하여 OKE 클러스터를 생성합니다.

![](/assets/img/cloudnative-security/2022/quick-create-oke-cluster-4.png)

다음과 같이 클러스터에 필요한 리소스 생성요청이 진행됩니다. 
![](/assets/img/cloudnative-security/2022/quick-create-oke-cluster-5.png)

클러스터 생성 요청을 하면, 쿠버네티스 클러스터, 노드풀, 워커 노드가 생성됩니다. 먼저 생성된 쿠버네티스 클러스터 상세 페이지로 이동하여 상태를 확인합니다.

다음과 같이 클러스터의 상태가 활성(Active)상태인 것을 볼 수 있습니다.
![](/assets/img/cloudnative-security/2022/quick-create-oke-cluster-6.png)

클러스터 상세 페이지 왼쪽 **리소스(Resources)**의 **노드 풀(Node Pools)**을 클릭하면 생성된 **노드 풀** 목록에서 노드 풀과 상태를 확인할 수 있습니다.
![](/assets/img/cloudnative-security/2022/quick-create-oke-cluster-7.png)

생성된 **노드 풀**을 클릭한 후 왼쪽 **리소스(Resources)**의 **노드(Nodes)**을 클릭하면 생성된 워커 노드(Worker Node)와 상태, 버전등을 확인할 수 있습니다.
![](/assets/img/cloudnative-security/2022/quick-create-oke-cluster-8.png)

생성된 OKE Cluster 접속 방법은 다음 포스트를 참고해 주세요.

[OCI Container Engine for Kubernetes (OKE) Cluster 접속 방법](https://team-okitoki.github.io/cloudnative/quick-create-oke-cluster/)