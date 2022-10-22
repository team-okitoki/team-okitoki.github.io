---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI Opensearch 서비스 살펴보기"
teaser: "OpenSearch 와 OpenDashboard를 간편하게 사용할 수 있는 OCI의 관리형 서비스인 OCI Opensearch 서비스에 대해 알아봅니다."
author: yhcho
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, opensearch, opendashboard, elasticsearch, kibana]
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

### OCI Opensearch 소개
OCI Opensearch 서비스는 OCI에서 제공하는 Opensearch + OpenDashboard을 기반으로 구성된 관리형 서비스 입니다. 
OCI Opensearch 서비스를 사용하면 OCI에서 배포, 프로비저닝, 패치등 관리작업을 담당하며, 사용자는 유지 관리가 아닌 데이터에 집중할 수 있습니다.

**OCI Opensearch 가격**<br>
기본적으로 데이터 노드, 마스터 노드, 대시보드 노드 3가지 노드로 구성이 되며 기본적으로 각 노드에 사용되는 컴퓨트 자원의 비용만 발생하지만(데이터노드 2개까지는 별도 관리비용 발생하지 않음), 데이터 노드를 HA 구성 (3개 이상)으로 구성시 노드별 시간당 $0.25 비용이 추가로 발생합니다.

자세한 내용은 [OCI Opensearch 소개 페이지](https://www.oracle.com/kr/cloud/search/#rc30p1){:target="_blank" rel="noopener"}에서 확인할 수 있습니다.

### OCI Opensearch 사용해보기
> **Note**: 화면 언어는 한국어(Korean)로 설정하고 진행합니다. 언어 변경은 우측 상단의 **Language** 아이콘을 선택하고 변경할 수 있습니다.

#### 1. VCN(Virtual Cloud Networking) 생성 하기

1. 전체 메뉴를 클릭하여 **"네트워킹"** -> **"가상 클라우드 네트워크"** 를 클릭하여 가상 클라우드 네트워크 메뉴로 이동합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-3.png " ")
2. **"VCN 마법사 시작"** 버튼을 클릭하여 **"인터넷 접속을 통한 VCN 생성"** 을 선택 후 **"VCN 마법사 시작"** 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-4.png " ")
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-5.png " ")
3. 다음과 같이 입력하여 VCN을 생성합니다.
   - VCN 이름 : **my-vcn**
   - 구획 : 개인별 환경에 맞는 구획을 선택해주세요. (가급적 root 구획을 제외한 다른 구획에 생성하는 것을 권장 합니다.)
   - "다음" 버튼 클릭하여 내용 확인 후 "생성" 버튼 클릭하여 VCN 생성
   
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-6.png " ")
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-7.png " ")

#### 3. 보안 목록 작성하기

1. 생성된 VCN에서 전용 서브넷의 보안목록을 수정하기 위해 (2) 단계에서 생성한 VCN의 세부정보 화면으로 이동합니다.
   - VCN 세부정보 화면에서 "전용 서브넷-my-vcn" 를 클릭하여 서브넷 세부정보 화면으로 이동합니다.

   ![](/assets/img/cloudnative/2022/opensearch/opensearch-8.png " ")
2. 서브넷 세부정보 화면에서 전용 서브넷의 보안목록을 클릭하여 보안목록 화면으로 이동합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-9.png " ")
3. "수신 규칙 추가"를 클릭하여 아래와 같이 입력하여 수신 규칙을 추가 합니다.
   - 소스 유형 : **CIDR**
   - 소스 CIDR : **10.0.0.0/16**
   - 대상 포트 범위 : **5601, 9200**
   - 설명 : **for opensearch services**
   
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-10.png " ")

#### 4. 정책(Policy) 생성 하기
opensearch 서비스에서 vcn의 리소스 접근을 위해 아래와 같이 정책을 작성하여 줍니다. 
<br>정책 작성 시 VCN이 생성되어 있는 구획(Compartments)에 작성하거나 VCN 구획의 상위 구획에 작성해야 합니다.
> 예) VCN이 "Root구획/**VCN구획**"와 같에 생성되어 있는 경우 Root구획 또는 VCN구획에 정책을 작성합니다.

1. 전체 메뉴에서 **"ID & 보안"** -> **"ID"** -> **"정책"** 메뉴를 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/policy-1.png " ")
2. 정책 화면에서 **"정책 생성"** 버튼을 클릭합니다.
3. 정책 생성화면에서 아래와 같이 입력 하여 정책을 생성합니다.
   - 이름 : **opensearchPolicy**
   - 설명 : **opensearch 서비스 사용 관련 정책 입니다.**
   - 구획 : 개인별 환경에 맞는 구획을 선택해주세요. (정책의 경우 root 구획에 생성하셔도 됩니다.)
   - "수동 편집기 표시" 옵션 활성화
   - 아래 내용을 복사하여 "정책 작성기"에 붙여넣기 합니다. 
   ```
   Allow service opensearch to manage vcns in compartment [구획이름]
   Allow service opensearch to manage vnics in compartment [구획이름]
   Allow service opensearch to use subnets in compartment [구획이름]
   Allow service opensearch to use network-security-groups in compartment [구획이름]
   ```

   ![](/assets/img/cloudnative/2022/opensearch/policy-2.png " ")


#### 5. OCI Opensearch 클러스터 생성하기
<mark>현재 포스팅 작성 시점 기준으로(2022년 10월 중순) OCI Opensearch 에서는 공용 서브넷에 프로비전을 지원하지 않습니다. 클러스터 생성 시 공용 서브넷을 선택하더라도 공용 IP가 아닌 전용 IP만 할당됩니다.</mark>
1. 전체 메뉴에서 **"데이터베이스"** -> **"OpenSearch"** 메뉴를 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-11.png " ")
2. **"클러스터 생성"** 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-12.png " ")
3. 클러스터 구성 화면에서 아래와 같이 입력 후 **"다음"**을 클릭합니다.
   - 이름 : **cluster-for-demo**
   - 구획에 생성 : <mark>VCN이 생성되어 있는 구획을 선택합니다. (개인별 환경에 맞는 구획을 선택해주세요.)</mark>

   ![](/assets/img/cloudnative/2022/opensearch/opensearch-13.png " ")
4. 노드 구성 화면에서 상단 노드 최적화 옵션에서 **"개발"**을 선택합니다. 다른 옵션은 기본값으로 구성 후 "다음"을 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-14.png " ")
5. 네트워킹 구성 화면에서 아래와 같이 선택 및 입력 후 **"다음"**을 클릭합니다.
   - 네트워크 : **기존 가상 클라우드 네트워크 선택**
   - 가상클라우드 네트워크 : **my-vcn**
   - 서브넷 : **전용 서브넷-my-vcn**

   ![](/assets/img/cloudnative/2022/opensearch/opensearch-15.png " ")
6. 요약 정보를 확인 후 "생성" 버튼을 클릭하여 아래와 같이 생성 중 화면으로 이동 합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-16.png " ")
7. 클러스터 생성까지 약 20분 가량 소요되며, 생성되는 동안 아래 6번 단계 Bastion VM을 생성합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-17.png " ")

> 만약 이 단계에서 클러스터 생성이 테넌트 리소스 제한으로 생성되지 않는다면 [서비스 한도 증가 요청 가이드](/getting-started/open-support-ticket/#%EC%84%9C%EB%B9%84%EC%8A%A4-%ED%95%9C%EB%8F%84-%EC%A6%9D%EA%B0%80-%EC%9A%94%EC%B2%AD-limit-increase){:target="_blank" rel="noopener"} 의 내용을 참고하여 opensearch 서비스의 클러스터 제한 증가 요청 후 진행해야 합니다.

#### 6. Bastion VM 생성하기
OpenSearch 클러스터 생성 단계에서 언급한 내용과 같이 현재 OCI Opensearch 서비스의 경우 Private 네트워크에 프로비전 되기 때문에 Public 영역에 있는 Bastion Host, VM을 통해 서비스에 접속해야 합니다.
그렇기 때문에 OpenSearch 클러스터가 생성된 VCN의 공용 서브넷 영역에 Compute Instance를 프로비전 합니다. (이 포스팅에서는 자세한 프로비전 내용을 다루지 않습니다.)

1. 전체 메뉴에서 **"컴퓨트"** -> **"컴퓨트"** -> **"인스턴스"** 메뉴를 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-18.png " ")
2. **"인스턴스 생성"** 버튼을 클릭합니다.
3. 인스턴스 생성 화면에서 아래와 같이 입력합니다.
   - 이름 : bastionForOpensearch
   - 구획 : [VCN을 생성한 구획]
   - 이미지, Shape : **기본값을 그대로 사용합니다.**

   ![](/assets/img/cloudnative/2022/opensearch/opensearch-19.png " ")
4. 네트워크 섹션에서 아래와 같이 선택합니다.
   - 가상 클라우드 네트워크 : **my-vcn**
   - 서브넷 : **공용 서브넷-my-vcn**
   - 공용 IP 주소 : **공용 IPv4 주소 지정**

   ![](/assets/img/cloudnative/2022/opensearch/opensearch-20.png " ")
5. SSH 키 섹션에서 기존 키를 등록하거나 새로운 키를 내려받습니다.
6. 나머지 옵션은 기본값으로 인스턴스를 생성합니다.

#### 7. Sample 데이터 입력하기
Bastion 인스턴스를 생성 후 OpenSearch 클러스터가 생성되었는지 확인합니다. 생성되었다면 아래 내용을 참고하여 Sample data를 입력합니다.
![](/assets/img/cloudnative/2022/opensearch/opensearch-21.png " ")

1. OpenSearch 클러스터 생성이 완료되었는지 확인합니다.
2. 생성되었다면 Bastion VM에 접속합니다.
   - `ssh -i [키파일 경로] opc@[bastionVM PublicIP]`
3. 접속된 VM에서 Opensearch Cluster에 입력할 Sample Json파일을 다운받습니다.
   ```terminal
   $ curl -O "https://raw.githubusercontent.com/oracle-livelabs/oci/main/oci-opensearch/files/OCI_services.json"
   ```

4. 아래 명령어를 통해 다운로드 받은 샘플 데이터셋을 클러스터에 입력합니다.
   - 아래 <mark>cluster-api-end-point</mark>에 생성된 Opensearch의 API Endpoint를 복사하여 입력합니다.
   ```terminal
   $ curl -H 'Content-Type: application/x-ndjson' -XPOST "[cluster-api-end-point]/oci/_bulk?pretty" --data-binary @OCI_services.json
   ```

5. 아래 명령어를 통해 opensearch 클러스터에 indices를 확인합니다.
   - 아래 <mark>cluster-api-end-point</mark>에 생성된 Opensearch의 API Endpoint를 복사하여 입력합니다.
   ````terminal
   $ curl "[cluster-api-end-point]/_cat/indices"
   ````

   ![](/assets/img/cloudnative/2022/opensearch/opensearch-22.png " ")   

6. 아래 명령어를 통해 입력된 데이터를 간단하게 조회해 봅니다.
   - 아래 <mark>cluster-api-end-point</mark>에 생성된 Opensearch의 API Endpoint를 복사하여 입력합니다.
   ````terminal
   $ curl -X GET "[cluster-api-end-point]/oci/_search?q=title:Kubernetes&pretty"
   ````

   ![](/assets/img/cloudnative/2022/opensearch/opensearch-23.png " ")

#### 8. 로컬 PC에서 OpenSearch Dashboard 접속하기 위해 SSH 터널링 하기
앞서 설명한 내용과 같이 OpenSearch 클러스터 뿐 아니라 OpenSearch Dashboard 역시 Private 네트워크 위에 프로비전 됩니다.
로컬에서 Dashboard에 접속하려면 아래 내용을 따라 SSH 터널링 작업이 필요합니다.
1. 아래 명령어를 입력하여 터널링을 수행합니다.
   - your_opensearch_dashboards_private_IP : 클러스터 정보 화면에서 opensearch dashboard 전용(Private) IP를 복사하여 입력합니다.
   - your_instance_public_ip : Bastion VM 의 Public IP를 복사하여 입력합니다.
   - path_to_your_private_key : Bastion VM에 접속하기 위한 Key 파일의 로컬 경로를 입력합니다.
   ````terminal
     $ ssh -C -v -t -L 127.0.0.1:5601:<your_opensearch_dashboards_private_IP>:5601 opc@<your_instance_public_ip> -i <path_to_your_private_key>
   ````
   
2. 터널링 결과 예시
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-24.png " ")
3. 터널링 후 Opensearch Dashboard 접속을 위해 아래 링크로 이동합니다
   ````terminal
   https://localhost:5601
   ````
4. 만약 경고창이 뜬다면 아래와 같이 고급 옵션을 표시 후 안전하지 않은 사이트로 이동 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-25.png " ")
5. 이동 후 아래 화면에서 **"Explore on my own"** 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-26.png " ")
6. 이동 후 홈 화면에서 우측 상단 **"Manage"** 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-27.png " ")
7. Index Patterns 메뉴 클릭 후 "Create Index Pattern" 버튼을 클릭하여 인덱스 패턴을 생성합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-28.png " ")
8. 인덱스 패턴 생성 화면에서 아래와 같이 입력 후 "Next Step" 버튼을 클릭합니다.
   - Index Pattern Name : **oci***
   
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-29.png " ")
9. 다음 화면에서 Time field를 "drainTime" 으로 선택하여 "Create Index Pattern" 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-30.png " ")
10. 생성된 인덱스 패턴을 확인합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-31.png " ")
11. 다시 홈 화면으로 이동하여 "DisCover" 메뉴를 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-32.png " ")
12. 샘플로 입력한 데이터가 조회되는 것을 확인할 수 있습니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-33.png " ")