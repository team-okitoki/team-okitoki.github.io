---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI Container Engine for Kubernetes (OKE) Cluster 접속 가이드"
teaser: "OCI에서 서비스하는 관리형 쿠버네티스 서비스인 OCI Container Engine for Kubernetes (OKE)에 접속하는 방법을 소개합니다."
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

### 실습을 위한 클러스터 생성
먼저 OKE Cluster가 준비되어야 합니다. OKE Cluster 생성은 다음 포스트를 참고합니다.

[OCI Container Engine for Kubernetes (OKE) Cluster 빠른 생성 (Quick Create)](https://team-okitoki.github.io/cloudnative/quick-create-oke-cluster/)

### 준비사항
OKE Cluster에 접속하기 위해서는 기본적으로 다음 두 개의 도구를 설치해야 합니다.

1. OCICLI 설치가 필요합니다. 설치 방법은 아래 포스트를 참고합니다.  
    [OCICLI 도구 설정하기](https://team-okitoki.github.io/getting-started/ocicli-config/)

2. kubectl 설치  
    [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

### 클러스터에 접속(Access Cluster)
앞서 생성한 Cluster 상세 화면에서 **클러스터에 접속(Access Cluster)** 버튼을 클릭한 후 다음 스크린샷과 같이 **로컬 액세스**를 선택합니다. 그러면 로컬에서 수행해야 하는 두 개의 명령어를 확인할 수 있습니다.
![](/assets/img/cloudnative-security/2022/access-oke-cluster-1.png)

해당 명령어를 복사해서 로컬에서 실행합니다. 우선 첫 명령어로 kubeconfig 파일을 생성하기 위한 폴더를 생성합니다.

```
$ mkdir -p $HOME/.kube
```

두 번째 명령어를 사용해서 kubeconfig 파일을 생성합니다. 다음 명령어를 실행하면 **.kube** 하위에 **config** 파일이 생성됩니다.

```
$ oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.ap-seoul-1.aaaaaaaaulp............. --file $HOME/.kube/config --region ap-seoul-1 --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT
```

만약 OKE Cluster 생성 시 API Endpoint를 Private으로 지정한 경우에는 3번째 명령어를 실행합니다. 
```
$ oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.ap-seoul-1.aaaaaaaaulp............. --file $HOME/.kube/config --region ap-seoul-1 --token-version 2.0.0  --kube-endpoint PRIVATE_ENDPOINT
```

Kubectl 명령어로 접속을 확인합니다.

```
$ kubectl cluster-info
Kubernetes control plane is running at https://xxx.xxx.xxx.xxx:6443
CoreDNS is running at https://xxx.xxx.xxx.xxx:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### Cloud Shell을 통해 접속
로컬에 OCICLI와 kubectl 설치할 환경이 안된다면, OCI Console에서 제공하는 **Cloud Shell**을 활용하여 OKE Cluster에 접속할 수 있습니다.

앞서 생성한 Cluster 상세 화면에서 **클러스터에 접속(Access Cluster)** 버튼을 클릭한 후 다음 스크린샷과 같이 **Cloud Shell 접속(Cloud Shell Access)**를 선택합니다. 그러면 kubeconfig를 Cloud Shell에서 생성하는 명령어를 확인하고 복사합니다.
![](/assets/img/cloudnative-security/2022/access-oke-cluster-2.png)

이제 **Cloud Shell**을 오픈합니다. 우측 상단의 **Cloud Shell** 버튼을 클릭하여 오픈합니다.
![](/assets/img/cloudnative-security/2022/access-oke-cluster-3.png)

위에서 복사한 명령어를 **Cloud Shell**에서 실행한 후 동일하게 접속을 합니다.

![](/assets/img/cloudnative-security/2022/access-oke-cluster-4.png)





