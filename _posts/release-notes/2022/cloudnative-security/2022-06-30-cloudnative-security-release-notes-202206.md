---
layout: page-fullwidth
#
# Content
#
subheadline: "OCI Release Notes 2022"
title: "6월 OCI Cloud Native & Security 업데이트 소식"
teaser: "2022년 6월 OCI Cloud Native & Security 업데이트 소식입니다."
author: dankim
breadcrumb: true
categories:
  - release-notes-2022-cloudnative-security
tags:
  - oci-release-notes-2022
  - june-2022
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

## Support for fault domains in node pool placement configuration
* **Services:** Container Engine for Kubernetes
* **Release Date:** June 1, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm#Provisioning_Persistent_Volume_Claims_on_the_Block_Volume_Service](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm#Provisioning_Persistent_Volume_Claims_on_the_Block_Volume_Service){:target="_blank" rel="noopener"} 

### 기능 소개
이제 Worker Node Pool을 생성할 때 가용성 도메인(Availability Domain: AD)을 지정하면서, 하나 이상의 결함 도메인(Fault Domain)을 지정할 수 있습니다. 만약 장애 도메인을 지정하지 않으면, 작업자 노드가 해당 가용성 도메인의 모든 장애 도메인에 최대한 균등하게 분산됩니다.

> 현재 해당 기능은 당분간 지원이 보류됩니다.

---

## Support for OKE images as worker node base images
* **Services:** Container Engine for Kubernetes
* **Release Date:** June 1, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Reference/contengimagesshapes.htm#images](https://docs.oracle.com/en-us/iaas/Content/ContEng/Reference/contengimagesshapes.htm#images){:target="_blank" rel="noopener"} 

### 기능 소개
이제 클러스터 혹은 노드 풀을 생성/업데이트 할 때 Worker Node의 기본 이미지로 OKE 이미지를 지원합니다. 

* OKE 이미지를 사용하면 기존 플랫폼 이미지나 커스텀 이미지를 사용하여 프로비저닝하는 시간보다 절반 이상으로 빠르게 프로비저닝됩니다.
* OKE 이미지에는 Worker Node로서 필요한 모든 구성 요소와 필수 소프트웨어가 최적화되어 포함되어 있습니다.
* OKE 이미지는 Oracle에서 제공하며 기본 플랫폼 이미지 위에 구성됩니다.

![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-06-1.png)

---

## Private endpoints for Resource Manager
* **Services:** Resource Manager
* **Release Date:** June 8, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/private-endpoints.htm](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/private-endpoints.htm){:target="_blank" rel="noopener"} 

### 기능 소개
이제 리소스 매니저 (Resource Manager)에서 Private Resource (e.g. Private Compute Instance, Private Github)에 접속할 수 있습니다.

리소스 매니저는 테라폼 (Terraform)을 지원하는 IaC 도구입니다. Private Resource 접속을 위한 테라폼 구성 예제 코드와 작성 방법은 다음과 같습니다. (Remote Exec를 활용해 Private Instance에 접속하는 방법)

> https://github.com/oracle/terraform-provider-oci/blob/master/examples/resourcemanager/create_private_endpoint.tf


1. Private Instace를 생성하는 테라폼 구성 작성
  ```terraform
  // Compute instance that our SSH connection will be established with.
  resource "oci_core_instance" "private_endpoint_instance" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "test script as one remote-exec instance"

    availability_domain = lookup(data.oci_identity_availability_domains.get_availability_domains.availability_domains[0], "name")
    shape = local.default_shape_name

    // specify the subnet and that there is no public IP assigned to the instance
    create_vnic_details {
      subnet_id = oci_core_subnet.private_endpoint_integ_test_temp_subnet.id
      assign_public_ip = false
    }

    extended_metadata = {
      ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    }

    // use latest oracle linux image via data source
    source_details {
      source_id = data.oci_core_images.available_instance_images.images[0].id
      source_type = "image"
    }

    shape_config {
      memory_in_gbs = 4
      ocpus = 1
    }
  }
  ```

2. 테라폼 구성에 리소스 매니저의 Private Endpoint 생성을 위한 구성 작성
  ```terraform
  // The RMS private endpoint resource. Requires a VCN with a private subnet
  resource "oci_resourcemanager_private_endpoint" "rms_private_endpoint" {
    compartment_id = var.compartment_ocid
    display_name   = "rms_private_endpoint"
    description    = "rms_private_endpoint_description"
    vcn_id         = oci_core_vcn.private_endpoint_integ_test_temp_vcn.id
    subnet_id      = oci_core_subnet.private_endpoint_integ_test_temp_subnet.id
  }
  ```

3. 테라폼 구성으로 Private Endpoint에서 도달 가능한 IP(reachable IP) 데이터 작성
  ```terraform
  // Resolves the private IP of the customer's private endpoint to a NAT IP. Used as the host address in the "remote-exec" resource
  data "oci_resourcemanager_private_endpoint_reachable_ip" "test_private_endpoint_reachable_ips" {
    private_endpoint_id = oci_resourcemanager_private_endpoint.rms_private_endpoint.id
    private_ip          = oci_core_instance.private_endpoint_instance.private_ip
  }
  ```

4. Private Instance에 SSH 접속하여 명령어 실행
  ```terraform
  // Resource to establish the SSH connection. Must have the compute instance created first.
  resource "null_resource" "remote-exec" {
    depends_on = [oci_core_instance.private_endpoint_instance]

    provisioner "remote-exec" {
      connection {
        agent = false
        timeout = "30m"
        host = data.oci_resourcemanager_private_endpoint_reachable_ip.test_private_endpoint_reachable_ips.ip_address
        user = "opc"
        private_key = tls_private_key.public_private_key_pair.private_key_pem
      }
      // write to a file on the compute instance via the private access SSH connection
      inline = [
        "echo 'remote exec showcase' > ~/remoteExecTest.txt"
      ]
    }
  }
  ```

### OCI Console에서 Private Endpoint 생성
리소스 매니저의 Private Endpoint는 테라폼 구성외에도 OCI UI Console에서도 생성할 수 있습니다.

![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-06-2.png)

### Private Git Server 접속
Private Endpoint를 활용하면 Private Git Server에 있는 테라폼 구성에 접근할 수 있습니다. 관련 가이드는 아래 링크 참고합니다.

> https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/private-endpoints.htm#private-git

---

## Web Application Acceleration
* **Services:** Web Application Acceleration
* **Release Date:** June 15, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/d71db04b-0015-47c8-9e9c-ff7e4b334a78/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/d71db04b-0015-47c8-9e9c-ff7e4b334a78/){:target="_blank" rel="noopener"} 

### 서비스 소개
Web Application Acceleration(WAA)은 압축과 캐싱기능을 활용하여 Layer 7 Load Balancer의 트래픽 속도를 높여주는 서비스입니다.

***WAA UI***  
![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-06-3.png)

현재 WAA에서 압축을 지원하는 응답 유형은 다음과 같습니다.
* application/atom+xml
* application/geo+json
* application/javascript
* application/x-javascript
* application/json
* application/ld+json
* application/manifest+json
* application/rdf+xml
* application/rss+xml
* application/xhtml+xml
* application/xml
* font/eot
* font/otf
* font/ttf
* image/svg+xml
* text/css
* text/javascript
* text/plain
* text/xml

WAA를 구성 시의 유의 사항은 다음과 같습니다.
* 압축된 결과를 얻기 위해서는 반드시 요청 헤더에 **Accept-Encoding**이 포함되어야 합니다.
* 응답 헤더에 **Cache-Control** 값으로 **Private** 또는 **no-store**가 포함된 경우에는 캐시를 지원하지 않습니다.

---

## Support for backend set worker node selection for load balancers created by Container Engine for Kubernetes
* **Services:** Container Engine for Kubernetes
* **Release Date:** June 21, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingloadbalancer.htm#contengcreatingloadbalancer_topic-Selecting_worker_nodes_to_include_in_backend_sets](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingloadbalancer.htm#contengcreatingloadbalancer_topic-Selecting_worker_nodes_to_include_in_backend_sets){:target="_blank" rel="noopener"} 

### 기능 소개
OCI Load Balancer 또는 Network Load Balancer로 들어오는 트래픽은 백엔드 세트(Backend Set)의 백엔드 서버로 분산됩니다. 기본적으로 Load Balancer 또는 Network Load Balancer 서비스를 배포하면, Cluster Node에 있는 모든 Worker Node가 백엔드 세트에 포함됩니다.

하지만, 이번에 새로 지원하는 기능을 활용하면, 백엔드 세트에 포함할 노드를 특정하여 추가할 수 있습니다. 이 기능을 활용하여, Cluster내의 Worker Node들을 분류하여 서비스에 적용하는 형태로 논리적인 클러스터로 구성할 수 있습니다.

다음은 Load Balancer에 특정 Label(lbset=set1)을 갖는 Worker Node를 Backend Set으로 추가하는 예제입니다.

```yml
apiVersion: v1
kind: Service
metadata:
  name: my-nginx-svc
  labels:
    app: nginx
  annotations:
    oci.oraclecloud.com/load-balancer-type: "lb"
    oci.oraclecloud.com/node-label-selector: lbset=set1
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: nginx
```

다음은 Network Load Balancer에 특정 Label(lbset=set1)을 갖는 Worker Node를 Backend Set으로 추가하는 예제입니다.

```yml
apiVersion: v1
kind: Service
metadata:
  name: my-nginx-svc
  labels:
    app: nginx
  annotations:
    oci.oraclecloud.com/load-balancer-type: "nlb"
    oci-network-load-balancer.oraclecloud.com/node-label-selector: lbset=set1
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: nginx
```

다음은 Label 값으로 set1 또는 set3 값을 갖는 Worker Node들을 Backend Set에 추가하는 Annotation 예시입니다.
```text
# Load Balancer
oci.oraclecloud.com/node-label-selector: lbset in (set1, set3)

# Network Load Balancer
oci-network-load-balancer.oraclecloud.com/node-label-selector: lbset in (set1, set3)
```

Lable 값에 상관없이 특정 Label 키 (lbset)를 가진 Worker Node만 Backend Set에 추가할 수 있습니다.
```text
# Load Balancer
oci.oraclecloud.com/node-label-selector: lbset

# Network Load Balancer
oci-network-load-balancer.oraclecloud.com/node-label-selector: lbset
```

env=prod 라는 Label을 갖고, set1 또는 set3 값을 갖는 Worker Node들을 할당한 예시입니다.
```text
# Load Balancer
oci.oraclecloud.com/node-label-selector: env=prod,lbset in (set1, set3)

# Network Load Balancer
oci-network-load-balancer.oraclecloud.com/node-label-selector: env=prod,lbset in (set1, set3)
```

Label env가 test라는 값을 갖지 않는 모든 노드를 포함합니다.
```text
# Load Balancer
oci.oraclecloud.com/node-label-selector: env!=test

# Network Load Balancer
oci-network-load-balancer.oraclecloud.com/node-label-selector: env!=test
```

## Support for worker node deletion, along with new cordon and drain options
* **Services:** Container Engine for Kubernetes
* **Release Date:** June 28, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengdeletingworkernodes.htm](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengdeletingworkernodes.htm){:target="_blank" rel="noopener"} 

### 기능 소개
OKE Node Pool의 특정 Worker Node를 삭제하는 기능이 포함되었습니다. 

OKE에서 Node 삭제와 관련된 일반적인 유의 사항은 다음과 같습니다.
* Worker Node를 삭제 대상으로 한번 지정하면, 다시 되돌릴 수 없습니다. 만약 처음 삭제 작업이 실패하면, 다음 Node Pool 업데이트 (예. 노드 확장)시에 다시 해당 노드를 삭제 시도합니다.
* 특정 Node를 삭제 시도하는 것 외에도 Node Pool의 스케일을 조정하여 삭제도 가능합니다.
* OKE에서 생성된 Worker Node의 이름은 임의로 할당이 됩니다. 임의 할당된 이름을 변경하게 되면, 클러스터를 삭제 시 같이 삭제되지 않습니다.

### Cordoning 및 Draining
특정 Worker Node 삭제 시 **Corden** 및 **Drain** 옵션을 제공합니다.
#### Cordoning
Cordoning은 Kubernetes Cluster의 Worker Node를 Unscheduling 하는 옵션으로, kube-scheduler가 해당 노드에 새로은 Pod 배치를 방지합니다. 단, 기존에 배치된 Pod에는 영향을 주지 않습니다.

#### Draining
Draining은 Kubernetes Cluster의 삭제하고자 하는 Worker Node에 있는 Pod를 안전하게 다른 Worker Node로 이동시키기 위한 옵션입니다. 이동이 완료되면 기존 Node에 있는 Pod의 컨테이너도 정상적으로 종료되고, 정리됩니다.

### Node 삭제 방법
OKE 노드풀의 노드를 클릭한 후 작업(Action)을 선택하여 삭제(Delete Note)를 수행할 수 있으며, 삭제 대화창에서 고급 옵션 표시(Show Advanced Options)를 선택하면 다음과 같이 **Cordon** 및 **drain** 지정 옵션을 확인할 수 있습니다.

![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-06-4.png)

#### 축출 유예 기간 (Eviction grade period)
축출 유예 기간은 삭제 대상 Node에 대한 **Cordoning** (스케쥴러에서 배제) 및 **Draining** (Pod를 다른 노드로 이동)하기 위한 유예 시간을 지정하는 부분으로 기본 **60**분입니다. 만약 유예 시간없이 즉시 삭제하고 싶다면, **0을** 지정합니다.

#### 유예 기간 후 강제 종료 (Force terminate after grace period)
축출 유예 기간이 경과했는데도 불구하고 **Cordoning** 및 **Draining**이 완료되지 않았어도 해당 Node를 강제로 종료 (Terminate)되도록 설정하는 옵션입니다. 만일 이 옵션을 사용하지 않은 상태에서 축출 유예 기간이 경과한 Node는 **주의 필요 (Needs attention)** 상태로 표기됩니다. **주의 필요** 상태의 Node를 해결하기 위해서는 기존과 같으 **노드 삭제** 작업을 재 수행하면서 **유예 기간 후 강제 종료** 옵션을 선택하여 강제 종료합니다.

