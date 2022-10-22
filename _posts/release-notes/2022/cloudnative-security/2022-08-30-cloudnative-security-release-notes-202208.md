---
layout: page-fullwidth
#
# Content
#
subheadline: "OCI Release Notes 2022"
title: "8월 OCI Cloud Native & Security 업데이트 소식"
teaser: "2022년 8월 OCI Cloud Native & Security 업데이트 소식입니다."
author: dankim
breadcrumb: true
categories:
  - release-notes-2022-cloudnative-security
tags:
  - oci-release-notes-2022
  - aug-2022
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

## CSI volume plugin is initial default for clusters running Kubernetes version 1.24 (or later)
* **Services:** Kubernetes용 Container Engine
* **Release Date:** Aug. 2, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm#Provisioning_Persistent_Volume_Claims_on_the_Block_Volume_Service](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm#Provisioning_Persistent_Volume_Claims_on_the_Block_Volume_Service){:target="_blank" rel="noopener"} 

### 기능 소개
OKE Cluster에서는 Block Volume Storage를 연결하기 위한 플러그인으로 CSI(Container Storage Interface) Volume Plugin과 FlexVolume Volume Plugin을 지원합니다. FlexVolume Volume Plugin은 CSI가 나오기 전의 out-of-tree(플러그인 소스 코드를 쿠버네티스 레파지토리에 추가하지 않고도 Custom Plugin을 만들 수 있는 방식) Volume Plugin입니다. CSI는 메소스, 도커스웜등의 여러 컨테이너 오케스트레이션 커뮤니티들이 협력하여 스토리지 관리를 위한 공통 인터페이스인데, 쿠버네티스의 경우 1.3 이후부터 CSI를 지원하기 시작했습니다.

기존에는 OKE의 기본 Volume Plugin(지정하지 않을 경우)으로 FlexVoume Volume Plugin (Storage Class=oci)을 사용하였지만, 이번에 OKE 1.24버전 지원과 함께 CSI Volume Plugin (Storage Calss=oci-bv)이 기본 플러그인으로 변경되었습니다.

---

## Code Editor is now available
* **Services:** Cloud Shell, Developer Tools
* **Release Date:** Aug. 2, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/API/Concepts/code_editor_intro.htm](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/code_editor_intro.htm){:target="_blank" rel="noopener"} 

### 기능 소개
Code Editor는 웹 상에서 코드를 직접 편집할 수 있는 서비스입니다. Functions의 함수를 생성, 업데이트하거나, Resource Manager Stack에서 사용되는 Terraform 구성파일을 편집할 수도 있습니다.

자세한 기능은 다음과 같습니다.
* 12개 이상의 프로그래밍 언어 지원에 대한 구문 강조, 지능형 자동 완성, 린트, 코드 탐색 및 리팩토링 기능 제공.
* 지원되는 OCI서비스들에 대한 특정 기능이나 코딩 워크플로우 제공을 위해 플러그인을 제공. (e.g. Functions Plugin은 Code Editor내에서 Function을 배포하고 호출하는 기능을 제공)
* Git 기반 레파지토리와 연결하여 클론, 푸시, 커밋, 풀등의 작업 수행.
* Cloud Shell과 통합하여 Cloud Shell 홈 디렉토리에 저장된 코드르 읽고 편집할 수 있으며, Cloud Shell과 함께 설치된 30개 이상의 클라우드 기반 도구에 직접 액세스 할 수 있음.
* 글꼴, 색 구성, 화면 레이아웃, 키보드 단축키 및 언어등을 모두 개인화 할 수 있는 기능 제공.
* 세션 간 상태 지속으로 작업 상황을 자동으로 저장하므로, 다시 시작 시 마지막으로 편집된 페이지를 자동으로 오픈.

--- 

## Process Automation is now available
* **Services:** Oracle Cloud Infrastructure, Process Automation
* **Release Date:** Aug. 8, 2022
* **Documentation:** [https://docs.oracle.com/en/cloud/paas/process-automation/](https://docs.oracle.com/en/cloud/paas/process-automation/){:target="_blank" rel="noopener"} 

### 서비스 소개
Process Automation은 OCI에서 비즈니스 프로세스를 신속하게 설계, 자동화 및 관리할 수 있는 서비스입니다. 프로스세 디자이너 기능으로 프로세스 설계를 하고, 제공되는 워크스페이스에서 프로세스를 실행하고 모니터링 할 수 있습니다.

**Process Automation 프로비저닝**
![](https://oracle-livelabs.github.io/oic/opa-for-fusionApps/common/provision-opa/images/ocipa-instance-page.png)

**프로세스 디자인**
![](https://oracle-livelabs.github.io/oic/opa-for-fusionApps/get-started-opa/create-structured-process-app/images/submit-travel-request-impl.png)

**워크스페이스**
![](https://oracle-livelabs.github.io/oic/opa-for-fusionApps/get-started-opa/create-structured-process-app/images/workspace-approve-task.png)

---

## Support for setting the externalTrafficPolicy parameter and client IP address preservation independently of each other
* **Services:** Container Engine for Kubernetes
* **Release Date:** Aug. 17, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingloadbalancer.htm#contengcreatingnetworkloadbalancer_topic-Preserve_source_destination](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingloadbalancer.htm#contengcreatingnetworkloadbalancer_topic-Preserve_source_destination){:target="_blank" rel="noopener"} [https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingloadbalancer.htm#contengcreatingnetworkloadbalancer_topic_Preserving_client_IP](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingloadbalancer.htm#contengcreatingnetworkloadbalancer_topic_Preserving_client_IP){:target="_blank" rel="noopener"} 

### 기능 소개
OKE에서 Network Load Balancer를 사용하는 경우 이제 k8s 매니페스트 파일내에 externalTrafficPolicy 옵션을 사용할 수 있습니다. 이 옵션을 통해서 서비스가 노드 안에서만 응답할 것인지, 클러스터 전체로 나아가서 응답할 지를 결정할 수 있습니다. externalTrafficPolicy옵션의 기본 값은 <mark>cluster</mark>이며, 모든 노드 전반에 걸쳐서 패킷을 전송하여 부하를 고르게 분산하게 할 수 있습니다. 다만 트래픽을 받는 Pod가 없는 노드로 전송되는 경우에는 추가적인 홉을 거쳐서 다른 노드로 이동하므로, 수천개의 노드를 운영하는 클러스터의 경우 성능이 저하될 수 있습니다.

externalTrafficPolicy옵션을 <mark>local</mark>로 설정하는 경우 kube-proxy가 전달받을 pod가 있는 노드로만 전송됩니다. (다른 노드로 전송 시 패킷 드랍) <mark>local</mark> 설정의 경우 노드 간의 트래픽을 제거하여 수천개의 노드를 운영하는 클러스터의 경우 성능을 향상 시킬 수 있습니다. 또한 로드발란서 Health Check를 통해서 Pod가 존재하는 노드로만 트래픽을 전송하므로 패킷 드랍도 발생하지 않습니다. 다만, 트래픽을 고르게 분산하지 못한다는 단점도 존재합니다.

<mark>externalTrafficPolicy=local</mark>로 설정하는 경우에는 추가적으로 IP 패킷 헤더에서 클라이언트 IP를 보존하거나 보존하지 않도록 지정할 수 있습니다. 이 경우 다른 노드로 네트워크 홉을 건너지 않기 때문에 클라이언트 IP가 보존될 수 있습니다. 여기서 추가적으로 매니페스트파일에 다음 annotation을 추가함으로써 클라이언트 IP를 보존하거나 보존하지 않도록 지정합니다.


**클라이언트 IP 보존**
```text
oci-network-load-balancer.oraclecloud.com/is-preserve-source: "true"
```

**클라이언트 IP 보존 방지**
```text
oci-network-load-balancer.oraclecloud.com/is-preserve-source: "false"
```

---

## Support for explicitly specifying the file system type (ext3, ext4, XFS) for block volumes when provisioning PVCs
* **Services:** Container Engine for Kubernetes
* **Release Date:** Aug. 17, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm#contengcreatingpersistentvolumeclaim_topic_Provisioning_PVCs_on_BV_PV_File_storage_types](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm#contengcreatingpersistentvolumeclaim_topic_Provisioning_PVCs_on_BV_PV_File_storage_types){:target="_blank" rel="noopener"}

### 기능 소개
이제 CSI Plugin을 사용하여 Persistent Volume Claim(PVC)을 프로비저닝할 때 이제 다음 파일 시스템 유형 중 하나를 갖도록 블록 볼륨을 구성할 수 있습니다.


* ext3
* ext4 (the default)
* XFS

다음은 ext3 파일 시스템을 갖는 블록 볼륨을 지원하는 PVC를 생성하기 위해 Storage Class를 생성하는 메니페스트 예시입니다.
```yml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: oci-bv-ext3
provisioner: blockvolume.csi.oraclecloud.com
parameters:
  csi.storage.k8s.io/fstype: ext3
reclaimPolicy: Retain
allowVolumeExpansion: true
volumeBindingMode: WaitForConsumer
```

PVC 생성 시 위에서 작성한 Storage Class를 지정한 예시입니다.
```yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: oci-bv-claim-ext3
spec:
  storageClassName: oci-bv-ext3
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi
```

---

## File Based Trigger Feature for DevOps Build Run
* **Services:** DevOps
* **Release Date:** Aug. 23, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/devops/using/trigger_build.htm](https://docs.oracle.com/en-us/iaas/Content/devops/using/trigger_build.htm){:target="_blank" rel="noopener"}

### 기능 소개
이제 DevOps 빌드 파이프라인에서 파일 변경에 대한 트리거 옵션을 다음과 같이 지정할 수 있습니다.

* Files to include: 기본적으로 레파지토리에 있는 모든 파일에 대한 변경 사항을 트리거하여 빌드를 실행합니다. 여기에 특정 파일이나 경로를 지정하여 해당되는 파일의 변경이 발생할 경우에만 빌드 파이프라인을 실행할 수 있도록 지정할 수 있습니다. 파일을 지정할 때에는 [glob patterns](https://docs.oracle.com/en-us/iaas/Content/devops/using/glob-patterns.htm)의 문법을 따릅니다.
* Files to exclude: 빌드 실행에 있어서 파일 변경이 되어도 빌드가 실행되지 않도록 특정 파일이나 경로를 지정하여 배제할 파일을 지정할 수 있습니다. 마찬가지로 [glob patterns](https://docs.oracle.com/en-us/iaas/Content/devops/using/glob-patterns.htm)의 문법을 따릅니다.
