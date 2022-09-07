---
youtubeId: fyqT6GqbZRQ
youtubeId2: wbUBIApC8Mo

layout: page-fullwidth
#
# Content
#
subheadline: "Compute"
title: "OCI CLI를 이용한 HA시 IP 변경"
teaser: "OCI CLI를 이용한 HA시 IP 변경"
author: "kskim"
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, vnic, cli]
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



### CLI를 이용한 VNIC IP 변경 (HA구성)
클라우드 환경에서 대표 IP를 기준으로 어플리케이션의 등의 문제로 HA 구성을 위해서 IP를  A라는 compute에서 B라는 compute로 
변경하고자 하려면 기본적인 default IP로는 변경이 불가하다. 따라서 추가적인 VNIC을 생성해서 이 VNIC의 ip를 스위칭하여 
compute A,B에 ip를 cli를 통해서 할당 / 해제를 할 수 있다. 

![](/assets/img/infrastructure/2022/vnic-ip-change/ip-change.png)

설정순서 : 
1. OCI-CLI 설치 (https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
2. compute에 신규 vnic 생성 (아래 그림 참조)
3. CLI를 통한 VNIC IP 할당/해제 (아래 그림 참조)

> 제약사항 : 기본적으로 할당된 Primary IP의 경우 할당/재할당이 불가, 할당된 IP를 다른 compute에 할당하기 위해서는 기존 IP의 경우 해제해야함.

- 오라클 클라우드는 각 자원읜 고유한 ID 값을 가지고 있습니다. 이는 아래 그림에서 참조 부탁 드립니다. (각 리소스의 상세정보에 OCID 가 존재합니다.-중북되지 않은 고유값입니다.)
> OCIDs use this syntax: ocid1.<RESOURCE TYPE>.<REALM>.[REGION][.FUTURE USE].<UNIQUE ID>






1. VNIC 생성하기 (2개의 compute에 추가 vnic을 각각 생성한다.)
   ![](/assets/img/infrastructure/2022/vnic-ip-change/1.png)
   ![](/assets/img/infrastructure/2022/vnic-ip-change/2.png)


2. VNIC 할당/해제 (명령어)
 
```
oci network vnic [unassign-private-ip/assign-private-ip] --ip-address [private ip] --vnic-id [vnic ocid]

##assign 01 할당 프로세스
##assign 02 ip 해제
oci network vnic unassign-private-ip --ip-address 10.0.0.221 --vnic-id ocid1.vnic.oc1.ap-chuncheon-1.ab4w4ljrtp22glfy7mfpfpfhvixs7ujqcdicgmhvhj35hrqllm6l3wccitua

##assign 01 ip 설정
oci network vnic assign-private-ip --ip-address 10.0.0.221 --vnic-id ocid1.vnic.oc1.ap-chuncheon-1.ab4w4ljrtfcf4vuwbs352zcsl6ojfv625xpwzicz4swzfmldcxiqcwy3xq2a
```
![](/assets/img/infrastructure/2022/vnic-ip-change/3.png)
![](/assets/img/infrastructure/2022/vnic-ip-change/4.png)
![](/assets/img/infrastructure/2022/vnic-ip-change/5.png)


3. VNIC 할당/해제 (명령어)
```
##assign 02 할당 프로세스
##assign 01 ip 해제
oci network vnic unassign-private-ip --ip-address 10.0.0.221 --vnic-id ocid1.vnic.oc1.ap-chuncheon-1.ab4w4ljrtfcf4vuwbs352zcsl6ojfv625xpwzicz4swzfmldcxiqcwy3xq2a
##assign 02 ip 설정
oci network vnic assign-private-ip --ip-address 10.0.0.221 --vnic-id ocid1.vnic.oc1.ap-chuncheon-1.ab4w4ljrtp22glfy7mfpfpfhvixs7ujqcdicgmhvhj35hrqllm6l3wccitua
```
![](/assets/img/infrastructure/2022/vnic-ip-change/6.png)
![](/assets/img/infrastructure/2022/vnic-ip-change/7.png)
![](/assets/img/infrastructure/2022/vnic-ip-change/8.png)


