---
layout: page-fullwidth
#
# Content
#
subheadline: "Platform"
title: "OCI에서 플랫폼 서비스 (PaaS) 시작하기"
teaser: "예전 OCI Classic에서 제공되던 플랫폼 서비스(PaaS)를 동일하게 OCI에서도 지원하고 있습니다. OCI에서 지원하는 플랫폼 서비스(PaaS)에 대해서 간단히 알아봅니다."
author: dankim
date: 2022-06-02 00:00:02
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, paas]
#published: false

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

### OCI에서 지원하는 플랫폼 서비스(PaaS) 
1세대 오라클 클라우드 (OCI Classic)에서 제공되던 여러 PaaS가 현재 OCI에서 그대로 제공되고 있습니다. OCI에서 지원되는 PaaS는 다음과 같습니다.

* Analytics Cloud
* API Platform Cloud Service
* Autonomous Database for Analytics and Data Warehousing
* Autonomous Mobile Cloud Enterprise
* Content Management Cloud
* Data Hub Cloud Service
* Data Integration Platform Cloud
* Database Cloud Service
* Event Hub Cloud Service
* Integration Generation 2
* Java Cloud Service
* NoSQL Database Cloud Service
* Process Automation
* SOA Cloud Service
* Visual Builder

### OCI PaaS를 사용하기 위한 전제조건
OCI PaaS 중에서는 사전에 미리 OCI에 특정 리소스를 구성해야 합니다. 

사전에 OCI에 특정 리소스를 구성해야 할 필요가 있는 PaaS는 다음과 같습니다.
* Oracle Database Cloud Service
* Oracle Data Hub Cloud Service
* Oracle Event Hub Cloud Service
* Oracle Java Cloud Service
* Oracle SOA Cloud Service

위에 언급한 PaaS는 OCI에서 다음과 같은 리소스를 사전에 준비해야 합니다. 
* 리소스 생성을 위한 구획
* 하나 이상의 퍼블릭 서브넷이 있는 가상 클라우드 네트워크(VCN)
* Oracle PaaS가 VCN에 접근할 수 있도록 허용하는 IAM 정책
* 오브젝트 스토리지 버킷
* Object Storage 와 함께 사용할 자격 증명

> 일부 PaaS의 경우는 인스턴스 생성 시 이러한 리소스 중 일부를 자동으로 생성해 주기도 합니다.

> OCI 테넌시에는 기본적으로 PaaS에서 <mark>ManagedCompartmentForPaaS</mark>라는 이름의 구획과 <mark>PSM-root-policy</mark>, <mark>PSM-mgd-comp-policy</mark> 정책이 생성되는데, PaaS를 위한 필수 구성이므로 삭제하거나 변경해서는 안됩니다.

OCI PaaS에서 위에서 언급한 리소스에 접근하도록 허용하는 IAM 정책을 다음과 같이 추가할 수 있습니다. 기본으로 생성되는 정책(PSM-root-policy, PSM-mgd-comp-policy)이 아닌 별도의 추가 정책으로 생성하는 것을 권장합니다.

***특정 구획에 있는 VCN에 접근***
```
Allow service PSM to inspect vcns in compartment <compartment_name>
```

***특정 구획에 있는 서브넷에 접근***
```
Allow service PSM to use subnets in compartment <compartment_name>
```

***특정 구획에 있는 VNICs에 접근***
```
Allow service PSM to use vnics in compartment <compartment_name>
```

***특정 구획에 있는 보안 목록에 접근***
```
Allow service PSM to manage security-lists in compartment <compartment_name>
```

PaaS중에서 Oracle Java Cloud Service 인스턴스를 위해 필요한 스키마 데이터베이스로 ADW (Oracle Autonomous Database) 또는 DBCS(Database Cloud Service)를 사용한다면, 다음 정책을 추가합니다.

***ADW 접근***
```
Allow service PSM to inspect autonomous-database in compartment <compartment_name>
```

***DBCS 접근***
```
Allow service PSM to inspect database-family in compartment <compartment_name>
```

### 지원되는 PaaS에 대한 정보
제공되는 각 PaaS의 인스턴스를 프로비저닝 하는 워크플로우에 대한 정보는 다음 테이블을 참고합니다.

<summary><b>지원되는 PaaS에 대한 정보</b></summary>
<div markdown="1">
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">서비스</th>
      <th class="entry" id="About__entry__2">정보</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Analytics Cloud</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/analytics-cloud/acsgs/how-do-i-get-started.html'>Getting Started with Oracle Analytics Cloud</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">API Platform Cloud Service</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/api-platform-cloud/apfad/get-started-oracle-api-platform-cloud-service.html'>Get Started with Oracle API Platform Cloud Service</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Autonomous Data Warehouse</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/autonomous-data-warehouse-cloud/user/getting-started.html#GUID-4B91499D-7C2B-46D9-8E4D-A6ABF2093414'>Getting Started with Autonomous Data Warehouse</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Autonomous Mobile Cloud Enterprise</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/mobile-autonomous-cloud/service-administration/getting-started.html#GUID-4E78309A-5C28-4357-8CD9-72563F1B6419'>About Oracle Autonomous Mobile Cloud Enterprise</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Database Cloud Service</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='http://www.oracle.com/pls/topic/lookup?ctx=cloud&id=CSDBI-GUID-7F8F90A0-C643-4201-926C-599E3A67B30A'>About Database Deployments in Oracle Cloud Infrastructure</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Data Hub Cloud Service</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://www.oracle.com/pls/topic/lookup?ctx=cloud&id=CSDHU-GUID-C1B35496-BD51-4278-B287-F0768DF0611E'>About Oracle Data Hub Cloud Service Clusters in Oracle Cloud Infrastructure</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Data Integration Platform Cloud</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/data-integration-platform-cloud/using/get-started-data-integration-platform-cloud.html#GUID-72E6BAA9-260B-4098-90A8-D42B95FC9010'>What is Oracle Data Integration Platform Cloud</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Event Hub Cloud Service</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='http://www.oracle.com/pls/topic/lookup?ctx=cloud&id=EHDAG-GUID-6B070D54-611A-40EF-ADBD-88CB9D11CF99'>About Instances in Oracle Cloud Infrastructure</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Integration</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/integration-cloud/int-get-started/welcome-oracle-integration.html'>Getting Started with Oracle Integration Generation 2</a><br><a href='https://docs.oracle.com/pls/topic/lookup?ctx=appint&id=INTRA-GUID-3FD7D407-DA8F-42C3-89DB-6E6E105E271E'>Getting Started with Oracle Integration 3</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Java Cloud Service</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://www.oracle.com/pls/topic/lookup?ctx=cloud&id=JSCUG-GUID-1294F076-EA26-4FBD-B4E8-429959ED2706'>About Java Cloud Service Instances in Oracle Cloud Infrastructure</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">NoSQL Database Cloud Service</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/nosql-cloud/index.html'>Oracle NoSQL Database Cloud Service</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Process Automation</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/process-automation/index.html'>Oracle Cloud Infrastructure Process Automation</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">SOA Cloud Service</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='http://www.oracle.com/pls/topic/lookup?ctx=cloud&id=CSBCS-GUID-D743A05B-FD91-4356-B59A-4A0549FE976D'>About SOA Cloud Service Instances in Oracle Cloud Infrastructure Classic and Oracle Cloud Infrastructure</a></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Visual Builder</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><a href='https://docs.oracle.com/en/cloud/paas/app-builder-cloud/index.html'>Oracle Visual Builder</a></span>
      </td>
      </tr>
      </tbody>
</table>
</div>

### PaaS별 REST API 엔드포인트
PaaS에서 제공하는 REST API의 엔드포인트 정보입니다. 기본적으로 지역별로 서버의 주소가 결정되지만, <mark>account_name</mark>과 <mark>account_id</mark>를 활용한 주소를 사용하면 전 지역에서 동일한 주소로 사용할 수 있습니다.

<summary><b>지원되는 PaaS에 대한 정보</b></summary>
<div markdown="1">
<table class="table vl-table-bordered vl-table-divider-col" summary="This table summarizes basic information about each region"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">REST 서버</th>
      <th class="entry" id="About__entry__2">지역</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">psm.us.oraclecloud.com</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><ul><li>미국 동부(애쉬번)</li><li>미국 서부(피닉스)</li><li>미국 서부(산호세)</li><li>캐나다 남동부(몬트리올)</li><li>캐나다 남동부(토론토)</li></ul></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">psm.europe.oraclecloud.com</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><ul><li>프랑스 중부(파리)</li>
<li>프랑스 남부(마르세유)</li>
<li>독일 중부(프랑크푸르트)</li>
<li>이탈리아 북서부(밀라노)</li>
<li>이스라엘 중부(예루살렘)</li>
<li>네덜란드 북서부(암스테르담)</li>
<li>사우디아라비아 서부(제다)</li>
<li>남아프리카 중부(요하네스버그)</li>
<li>스페인 중부(마드리드)</li>
<li>스웨덴 중부(스톡홀름)</li>
<li>스위스 북부(취리히)</li>
<li>UAE 중부(아부다비)</li>
<li>UAE 동부(두바이)</li>
<li>영국 남부(런던)</li>
<li>영국 서부(뉴포트)</li></ul></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">psm.europe.oraclecloud.com</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><ul><li>호주 동부(시드니)</li>
<li>호주 남동부(멜버른)</li>
<li>인도 서부(뭄바이)</li>
<li>인도 남부(하이데라바드)</li>
<li>일본 중부(오사카)</li>
<li>일본 동부(도쿄)</li>
<li>싱가포르(싱가포르)</li>
<li>한국 중부(서울)</li>
<li>한국 북부(춘천)</li></ul></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">psm.aucom.oraclecloud.com</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><ul><li>호주 동부(시드니)</li>
<li>호주 남동부(멜버른)</li>
<li>인도 서부(뭄바이)</li>
<li>인도 남부(하이데라바드)</li>
<li>일본 중부(오사카)</li>
<li>일본 동부(도쿄)</li>
<li>싱가포르(싱가포르)</li>
<li>한국 중부(서울)</li>
<li>한국 북부(춘천)</li></ul></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">psm.brcom-central-1.oraclecloud.com</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph"><ul><li>브라질 동부(상파울루)</li>
<li>브라질 남동부(Vinhedo)</li>
<li>칠레(산티아고)</li>
<li>멕시코 중부(케레타로)</li></ul></span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">psm-<mark>{account_name}</mark>.console.oraclecloud.com</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">모든 지역<br><mark>{account_name}</mark> 은 테넌트 이름 또는 클라우드 계정 이름입니다.</span>
      </td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">psm-cacct-<mark>{account_id}</mark>.console.oraclecloud.com</span>
      </td>
      <td class="entry" headers="About__entry__2"><span class="ph">모든 지역<br><mark>{account_id}</mark> 은  테넌트 이름 또는 클라우드 계정의 영숫자 ID입니다.
</span>
      </td>
      </tr>
      </tbody>
</table>
</div>

> <mark>account_name</mark>과 <mark>account_id</mark>는 처음 OCI 테넌시 생성할 때 받는 웰컴 이메일 또는 프로비저닝한 PaaS 서비스에 접속하는 URL을 통해서 확인할 수 있습니다.