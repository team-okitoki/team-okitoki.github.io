---
layout: page-fullwidth
#
# Content
#
subheadline: "Release Notes 2022"
title: "8월 OCI Infrastructure 업데이트 소식"
teaser: "2022년 8월 OCI Infrastructure 업데이트 소식입니다."
author: kskim
breadcrumb: true
categories:
  - release-notes-2022-infrastructure
tags:
  - oci-release-notes-2022
  - Aug-2022
  - Infrastructure

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

## Cloud Shell now offers Private Access
* **Services:** Cloud Shell
* **Release Date:** Aug 2, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/db9629a3-0cf9-4c0c-94b7-b29e24180195/](https://docs.oracle.com/iaas/releasenotes/changes/db9629a3-0cf9-4c0c-94b7-b29e24180195/){:target="_blank" rel="noopener"}

### 기능 소개
Cloud Shell은 OCI Console(OCI 관리 콘솔)에서 실행되는 브라우저 기반 터미널입니다. OCI Cloud Shell은 GCP의 Google Cloud Shell, Azure의 Cloud Shell 및 AWS의 Session Manager와 같은 서비스입니다. OCI Cloud Shell를 이용하면 PuTTY를 사용하지 않고 OCI VM 인스턴스에 접속하거나 별도의 소프트웨어와 계정 설정 작업 없이 즉시 OCI CLI와 같은 툴을 사용할 수 있습니다.
이번에 추가된 기능으로 Private Access의 경우, public ip가 없는 private subnet의 경우 bastion, compute 통해서 터넕링 통해서 연결이 되었으나, private access를 사용하면 간단히 private subnet의 자원의 접근이 가능합니다. 

> 테넌시의 홈리전을 기본으로 접속 가능하며, 홈리전 이외의 리전 접속의 경우, RPG 연결을 해줘야 합니다.

![](/assets/img/infrastructure/2022/08/SCR-20221001-3bt.png)

## Block Volume scheduled backup limited to one per volume per day
* **Services:** Block Volume
* **Release Date:** Aug 2, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/2c45b14e-3180-44f2-9b85-c05c5c85796e/](https://docs.oracle.com/iaas/releasenotes/changes/2c45b14e-3180-44f2-9b85-c05c5c85796e/){:target="_blank" rel="noopener"}

### 기능 소개

블록볼륨의 백업은 이제 하나의 볼륨에 대해서 하루에 한 번의 백업으로 제한됩니다. 따라서 아래 우선순위에 따라서 조절이 됩니다 .

- 매일 : 백업이 매일 생성됩니다. 백업 시간을 지정합니다.
- 매주 : 백업이 매주 생성됩니다. 백업할 요일과 해당 요일의 시간을 지정합니다.
- 매월 : 백업이 매월 생성됩니다. 백업할 날짜와 시간을 지정합니다.
- 매년 : 백업이 매년 생성됩니다. 백업할 월, 해당 월의 일 및 해당 일의 시간을 지정합니다.

> 블록 볼륨 은 하루에 볼륨당 하나의 예약된 백업만 실행합니다. 특정 날짜에 볼륨에 대해 둘 이상의 백업이 예약된 경우 서비스는 다음 우선 순위를 사용하여 그 중 하나만 실행합니다.(1.매년 2.월간 간행물 3.주간 4.일일)


## OCI now supports intra-VCN routing
* **Services:** Networking
* **Release Date:** Aug 3, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/a1ada1f2-ca21-4650-9ebe-9246f576bc74/](https://docs.oracle.com/iaas/releasenotes/changes/a1ada1f2-ca21-4650-9ebe-9246f576bc74/){:target="_blank" rel="noopener"}

### 기능 소개

VCN 내부 라우팅을 사용하면 VCN CIDR 블록에 포함된 IP 주소로 향하는 트래픽에 적용된 기본 라우팅 결정을 재정의할 수 있습니다. VCN 내부 라우팅에는 다음과 같은 기능이 있습니다.
- 기본 경로: 모든 VCN 경로 테이블에는 VCN CIDR에 대한 암시적 로컬 경로가 있습니다. VCN의 대상으로 로컬 직접 라우팅에 사용됩니다. 경로 테이블의 사용자 지정 경로와 함께 이 암시적 로컬 경로가 최상의 경로 선택에 사용됩니다.
- 사용자 지정 VCN 내 경로: VCN 내 트래픽에 대해 라우팅 테이블에서 생성하는 라우팅 규칙입니다. 모든 사용자 지정 경로에는 대상 (DRG, LPG, VCN의 사설 IP) 과 경로 유형이 static 입니다.
- 경로 선택: 가장 긴 접두사 일치(또는 가장 구체적인 경로)가 선택됩니다. 동일한 접두사에 대해 여러 경로가 있는 경우 다음 경로 유형 우선순위에 따라 최상의 경로가 선택됩니다.
  1. 정적(사용자 정의)
  2. 암시적 로컬 경로(OCI에서 자동 생성)

> 서브넷 내 라우팅은 지원되지 않습니다. 발신 VNIC와 동일한 서브넷에 있는 대상 IP 주소가 있는 트래픽은 적절한 대상으로 직접 전달(라우팅되지 않음)됩니다.

![](/assets/img/infrastructure/2022/08/vcn-intra.jpeg)

## Bare metal compute instances: reboot migration on demand and extend maintenance due date
* **Services:** Compute
* **Release Date:** Aug 8, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/f5ffceca-e3de-4eb1-a45b-0459a2c69140/](https://docs.oracle.com/iaas/releasenotes/changes/f5ffceca-e3de-4eb1-a45b-0459a2c69140/){:target="_blank" rel="noopener"}

### 기능 소개

계획된 인프라 유지 관리로 인해 베어메탈 인스턴스 재부팅 마이그레이션이 예약된 경우 이제 유지 관리 기한 전에 인스턴스 마이그레이션을 사전에 재부팅할 수 있습니다.

재부팅 마이그레이션이 예약된 베어메탈 인스턴스의 유지 관리 기한을 연장할 수도 있습니다.

* **인프라유지관리:** [https://docs.oracle.com/iaas/Content/Compute/References/infrastructure-maintenance.htm](https://docs.oracle.com/iaas/Content/Compute/References/infrastructure-maintenance.htm){:target="_blank" rel="noopener"}
* **재부팅 마이그레이션 기한 연장:** [https://docs.oracle.com/iaas/Content/Compute/Tasks/movinganinstance.htm#extend-maintenance-due-date](https://docs.oracle.com/iaas/Content/Compute/Tasks/movinganinstance.htm#extend-maintenance-due-date){:target="_blank" rel="noopener"}



## New region pairings available for cross region replication of volumes
* **Services:** Block Volume
* **Release Date:** Aug 16, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/717024d7-98a1-481b-97f2-dbd5ab189861/](https://docs.oracle.com/iaas/releasenotes/changes/717024d7-98a1-481b-97f2-dbd5ab189861/){:target="_blank" rel="noopener"}

### 기능 소개

볼륨 복제시 사용할 수 있는 리전의 영억이 추가 되었습니다. 볼륨의 복제의 경우, 볼륨을 서비스 지역 이외에 따른 리전에 복제함으로 가용성을 높일 수 있으며 가용성이 높아진 결과 장애에 대해서 더욱 적극적으로 대응 할 수 있습니다. 
아래 그림은 source 리전 기준으로 복제 될 수 있는 리전의 리스트입니다. 

![](/assets/img/infrastructure/2022/08/screencapture-docs-oracle-en-us-iaas-Content-Block-Concepts-volumereplication-htm-2022-10-03-13_53_31-edit.jpg)



## Dynamic performance scaling with autotuning for Block Volume service
* **Services:**  Block Volume
* **Release Date:** Aug 30, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/87a4a40e-2727-41c2-a504-a2ecc4c081e8/](https://docs.oracle.com/iaas/releasenotes/changes/87a4a40e-2727-41c2-a504-a2ecc4c081e8/){:target="_blank" rel="noopener"}

### 기능 소개

볼륨볼륨의 경우, 사용자의 IOPS를 지정하지 않은 상태에서 default 속도가 지정되며, 추후 고객의 어플리케이션의 높은 IOPS에 요구에 따라서 추가적인 성능을 온라인에서 수동으로 조절할 수 있습니다.
성능 기반 자동 조정 이 활성화되면 블록 볼륨 은 성능을 최대한 기본 수준으로 조정합니다. 볼륨의 로드가 증가하면 서비스는 최선을 다해 필요에 따라 성능 수준을 높입니다


- 기본 성능 : 성능 기반 자동 조정 이 활성화 된 경우 볼륨이 연결될 때 Block Volume 이 성능을 조정하는 가장 낮은 성능 수준입니다. 성능 기반 자동 조정 이 비활성화된 경우 이는 볼륨의 성능 수준입니다 . Detached Volume Auto-tune 을 활성화 하고 볼륨이 분리된 경우 볼륨이 인스턴스에 다시 연결될 때 볼륨이 조정되는 성능 수준입니다. 
- Auto-tuned Performance : 볼륨의 유효 성능입니다. 볼륨에 대해 성능 기반 자동 조정 이 비활성화된 경우 이는 볼륨의 기본 성능과 동일합니다. 
- 성능 기반 자동 튜닝 : 이 필드는 성능 기반 자동 튜닝 기능이 볼륨에 대해 활성화되어 있는지 여부를 나타냅니다. 꺼져 있을 때 볼륨의 자동 튜닝 성능 은 항상 기본 성능 에 지정된 것과 동일합니다 .

분리된 볼륨 (compute에 연결되지 않은 detached 된 compute) 경우,
- 기본 성능 : 성능 기반 자동 조정 이 비활성화된 경우 볼륨을 생성하거나 기존 볼륨에 대한 성능 설정을 변경할 때 지정하는 볼륨의 성능 수준입니다. 볼륨이 연결되면 Detached Volume Auto-tune 의 활성화 여부에 관계없이 볼륨의 성능입니다.
- Auto-tuned Performance : 볼륨의 유효 성능입니다. 볼륨에 대해 Detached Volume Auto-tune 이 활성화 된 경우 볼륨이 분리될 때 Auto-tuned Performance 가 Low Cost 로 조정됩니다 . 자동 조정된 성능 은 성능 조정이 완료될 때까지 성능 설정을 낮은 비용 으로 표시하지 않습니다. 
- Detached Volume Auto-tune : 이 필드는 Detached Volume Auto-tune 이 볼륨에 활성화되어 있는지 여부를 나타냅니다. 꺼져 있을 때 볼륨의 유효 성능은 항상 기본 성능 에 지정된 것과 동일합니다 . 켜져 있을 때 볼륨 분리 시 볼륨 성능이 Low Cost 로 조정됩니다 .

![](/assets/img/infrastructure/2022/08/SCR-20221003-k8l.png)


## Longer notification before preemptible compute instances are deleted
* **Services:**  Compute
* **Release Date:** Aug 31, 2022
* **Documentation:** [https://docs.oracle.com/iaas/releasenotes/changes/5120d35b-05be-4ef2-9e72-7ce2dcffb947/](https://docs.oracle.com/iaas/releasenotes/changes/5120d35b-05be-4ef2-9e72-7ce2dcffb947/){:target="_blank" rel="noopener"}

### 기능 소개
선점 가능한 인스턴스는 일반 컴퓨팅 인스턴스와 동일하게 동작하지만 다른 곳에서 필요할 때 용량이 회수되고 인스턴스가 종료됩니다. 이벤트 서비스를 통해서 선점형 인스턴스가 종료되기전에 노티 서비스를 받을 수 있습니다.

![](/assets/img/infrastructure/2022/08/SCR-20221001-3yq.png)


