---
layout: page-fullwidth
#
# Content
#
subheadline: "Identity & Security"
title: "OCI IAM Identity Domain 에 대해 알아보기"
teaser: "Oracle Cloud Infrastructure (OCI) IAM Identity Domain 에 대해 알아봅니다."
author: yhcho
date: 2022-06-21 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, sign-in, identity domains, iam]
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

# -------------- 내용 필독 -------------------
# 작성할 내용은 아래부터 작성
# 작성 방법
# 각 챕터별 제목은 "###"로 시작한다.
# 하위 제목은 "####"로 시작한다.
# 이미지는 images 폴더안에 Category(getting-started, infrastructure, platform, database, aiml)에 넣고 사용 시 "../../images/카테고리명/이미지" 형태로 참조한다.
# Bold는 **글자**
# Bold + Italic은 ***글자***
# ------------------------------------------
---

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

### OCI IAM Identity Domain 등장 배경
현재의 Oracle Cloud Infrastructure가 등장하기 전 Oracle에서 제공하던 다양한 클라우드 애플리케이션의 인증 & 관리를 위해 사용하던 Oracle Identity Cloud Service(IDCS)와 
Oracle Cloud Infrastructure 서비스의 인증 & 관리를 위한 OCI IAM 서비스가 따로 관리되어 왔지만, 최근들어 기존의 Oracle Cloud Application이 점차 OCI로 이관(통합) 되면서 기존 IDCS의 기능이 OCI IAM에 통합 되었습니다.<br>
통합된 기능을 통해 OCI 고객은 OCI 및 오라클 클라우드 애플리케이션과 함께 사용할 수 있는 풍부한 엔터프라이즈급 IAM(ID 및 액세스 관리) 기능 세트를 사용할 수 있게 되었습니다.
![](/assets/img/getting-started/2022/oci-new-iam-changes.png " ")

### OCI IAM Identity Domain 이란?
OCI IAM Identity Domain에서 Domain 은 사용자 및 역할 관리, 사용자 연합 및 프로비저닝, Oracle SSO(Single Sign-On) 구성을 통한 보안 애플리케이션 통합, OAuth 관리를 위한 컨테이너입니다. 
기본으로 제공되는 Default외에 추가 Domain을 생성해서 사용자는 특정 목적 또는 환경별로 사용자를 구분하여 관리할 수 있습니다. 예를 들어 개발/운영 업무에 맞게 각각 환경에 사용자를 추가하여 관리할 수 있습니다.

#### 도메인 유형 (서비스별 제한사항 등)
- **Free identity Domain** : 각 OCI 테넌시는 OCI 리소스(네트워크, 컴퓨팅, 스토리지 등)에 대한 액세스를 관리하기 위한 프리 티어 기본 OCI IAM Identity Domain 을 포함합니다. OCI 리소스에 대한 액세스만 관리하려는 경우 포함된 기본 도메인. Oracle Cloud 리소스에 대한 액세스를 관리하기 위한 강력한 IAM 기능 세트를 제공합니다. 보안 모델 및 팀에 따라 고객은 이 도메인을 OCI 관리자용으로 예약하도록 선택할 수 있습니다.
- **Oracle Apps identity Domain** : 수많은 Oracle Cloud 애플리케이션(HCM, CRM, ERP, 산업 앱 등)에는 Oracle Apps 도메인을 통한 OCI IAM 사용이 포함될 수 있습니다. 이러한 도메인은 구독된 Oracle 애플리케이션과 함께 사용하기 위해 포함되며 Oracle Cloud 및 SaaS 서비스에 대한 액세스를 관리하기 위한 강력한 IAM 기능을 제공합니다. 고객은 이 도메인에 모든 직원을 추가하여 Oracle Cloud 애플리케이션 서비스에 대한 SSO를 활성화하고 이 도메인을 사용하여 OCI 리소스의 일부 또는 전체에 대한 액세스를 관리할 수 있습니다.
- **Oracle Apps Premium identity Domain** : SaaS 제공되지 않을 수 있는 Oracle 애플리케이션에 대한 액세스를 관리하기 위해 완전한 엔터프라이즈 기능으로 Oracle Apps 도메인을 확장하려는 경우(예: Oracle E-Business Suite 또는 Oracle Database, 온프레미스 또는 호스팅 여부) OCI에서) Oracle Apps Premium 도메인은 하이브리드 클라우드 환경에 배포될 수 있는 Oracle 대상과 함께 사용하기 위한 전체 OCI IAM 기능 세트를 제공합니다. 이것은 모든 기능을 갖추고 있지만 Oracle 대상과 함께 사용하도록 제한되는 저비용 서비스입니다.
- **External identity Domain** : 외부 Identity Domain 은 소매 사이트에 액세스하는 소비자, 시민이 액세스할 수 있는 정부 또는 비즈니스 파트너에 대한 액세스를 허용하는 기업과 같은 비직원을 위한 전체 OCI IAM 기능을 제공합니다. 대상이 될 수 있는 응용 프로그램에는 제한이 없습니다. 그러나 App Gateway 및 Provisioning Bridge와 같이 직원이 아닌 시나리오에서는 일반적으로 유용하지 않은 특정 엔터프라이즈 기능은 포함되지 않습니다. 외부 도메인에는 소셜 로그온, 자체 등록, 이용 약관 동의, 프로필/비밀번호 관리 지원이 포함됩니다.
- **Premium identity Domain** : 프리미엄 자격 증명 도메인은 대상 애플리케이션에 대한 제한 없이 전체 OCI IAM 기능을 제공합니다. 프리미엄 도메인은 클라우드 및 온프레미스 애플리케이션에서 직원 또는 인력 액세스를 관리하는 엔터프라이즈 IAM 서비스로 사용되어 보안 인증, 손쉬운 권한 관리, 최종 사용자를 위한 원활한 SSO를 지원합니다.
![](/assets/img/getting-started/2022/oci-iam-identity-domain-types.png " ")

### OCI IAM Identity Domain 에서 달라진점
OCI Native로 제공하던 IAM 서비스와 Oracle에서 PaaS 형태로 제공하던 IDCS의 기능을 통합하여 OCI Native한 새로운 IDaaS 서비스를 제공하게 되었습니다.
이로인해 기존의 OCI의 서비스 뿐만아니라 Oralce Cloud Application도 하나의 인증시스템에서 관리할 수 있게 되었습니다.

#### 기능비교
<table class="table vl-table-bordered vl-table-divider-col" summary="OCI IAM 변경사항 설명"><caption></caption><colgroup><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1" style="width:25%;">Before</th>
      <th class="entry" id="About__entry__2" style="width:25%;">After</th>
      <th class="entry" id="About__entry__3" style="width:50%;">Description</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1">OCI IAM - <b>Local Account</b></td>
      <td class="entry" headers="About__entry__2">OCI IAM Identity Domains - <b>Default Domain</b></td>
      <td class="entry" headers="About__entry__3">기존 OCI IAM의 Local Account는 신규 OCI IAM에서 Default Doamin으로 변경되었습니다.</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1">OCI IAM - <b>External IdP</b></td>
      <td class="entry" headers="About__entry__2">OCI IAM Identity Domains - <b>External IdP</b></td>
      <td class="entry" headers="About__entry__3">기능 변경사항 없음</td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1">OCI IAM - <b>IDCS Federation</b></td>
      <td class="entry" headers="About__entry__2">OCI IAM Identity Domains - <b>IDCS-Foundation</b></td>
      <td class="entry" headers="About__entry__3">기존 OCI IAM에서 IDCS 시스템과 통합하기 위한 기능인 IDCS Federation 기능이 신규 OCI IAM에서 IDCS-Foundation Type의 도메인으로 변경되었습니다.</td>
      </tr>
      </tbody>
</table>

![](/assets/img/getting-started/2022/oci-identity-domain-changes.png " ")

#### OCI Console 달라진점
새로운 기능이 추가되면서 사용자 메뉴 구성이 아래와 같이 변경 되었습니다.
![](/assets/img/getting-started/2022/oci-iam-console-changes-1.png " ")

### Identity Domain을 통해 다중 ID Domain 구성 예시
달라진 OCI IAM Identity Domain을 통해 아래와 같이 다중 ID Domain 구성을 할 수 있습니다.
  - 테넌시 생성 시 자동으로 생성되는 **Default Domain**
  - "Production" 구획을 위한 **ProductionDomain**을 추가하여 별도의 사용자,그룹,정책등을 관리할 수 있습니다.
  - "Consumer" 구획을 위한 **ConsumerDomain**을 추가하여 별도의 사용자,그룹,정책등을 관리할 수 있습니다.
![](/assets/img/getting-started/2022/oci-identity-domain-example.png " ")

### Identity Domain 을 위한 Policy 작성 예시
In the Policy Builder, select Show manual editor and enter the required policy statements.
Identity Domain의 IAM 작성 문법 및 예시 입니다. 기존의 그룹명 위치에 생성한 **[Domain이름]/[Domain내Group이름]**을 넣어서 정책을 작성할 수 있습니다.

**문법:**
 - allow group **domain-name/group_name** to verb resource-type in compartment compartment-name
 - allow group **domain-name/group_name** to verb resource-type in tenancy

**예시:**
 - allow group **admin/oci-integration-admins** to manage integration-instance in compartment OICCompartment


### OCI IAM Identity Domain 로그인 하기
1. [https://cloud.oracle.com](https://cloud.oracle.com) 링크로 접속합니다.
2. **[Cloud Account Name]** 에 생성한 **클라우드 계정 이름**을 입력 후 **Next** 버튼을 클릭 합니다.
   ![Cloud Sign-in #1](/assets/img/getting-started/2022/oci-cloud-sign-in.png " ")
3. 이동된 화면에서 로그인할 도메인을 선택한 후 **Next** 버튼을 클릭합니다.
   ![Cloud Sign-in #2](/assets/img/getting-started/2022/oci-cloud-id-sign-in.png " ")
5. 이동된 화면에서 사용자 이름 및 비밀번호를 입력하고 **사인인** 버튼을 통해 로그인합니다.
   ![Cloud Sign-in #3](/assets/img/getting-started/2022/oci-cloud-id-sign-in2.png)
