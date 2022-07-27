---
layout: page-fullwidth
#
# Content
#
subheadline: "Identity & Security"
title: "OCI에서 사용자, 그룹, 정책 관리하기"
teaser: "Oracle Cloud Infrastructure (OCI)에서의 사용자, 그룹, 정책을 생성하고 관리하는 방법에 대해서 알아봅니다."
author: dankim
date: 2022-06-19 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, users, group, policy]
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

### OCI에서의 사용자(Users), 그룹(Groups), 정책(Policies)
OCI 관리자(처음 OCI 계정을 생성할 때 등록한 사용자)는 기본적으로 OCI Administrator 그룹에 속하며, 이 권한을 사용하여 추가로 OCI 사용자를 추가할 수 있습니다. 추가된 사용자는 별도 정의된 그룹의 구성원이 될 수 있으며, 해당 그룹에 대한 권한은 정책을 통해서 정의됩니다. 정책에서는 그룹의 구성원이 수행할 수 있는 작업의 범위와 어떤 구획에서 권한을 수행할 수 있는지를 정의할 수 있습니다. 이렇게 정의하면 사용자는 자신이 속한 그룹에 설정된 정책을 기반으로 작업을 수행할 수 있게됩니다.

![](/assets/img/getting-started/2022/iam-model-png.png " ")

### Oracle Identity Cloud Service Federeated Users란?
OCI에서는 인증과 액세스 제어 관리를 위해 PaaS 서비스인 Oracle IDCS(Identity Cloud Service)와 OCI 자체(Native 형태)서비스인 OCI IAM 두 가지 서비스를 제공하고 있습니다. 현재는 [OCI IAM Identity Domain](https://docs.oracle.com/en-us/iaas/Content/Identity/home.htm)으로 통합되어 복잡성이 줄어들었지만, 아직 일부 Free Tier는 IDCS와 IAM 두 인증 체계로 나눠져 제공됩니다. 여기서 IDCS와 IAM간의 관계에 대해서 살펴보고, IDCS의 사용자와 그룹을 어떻게 OCI에서 활용할 수 있는지 살펴보도록 합니다.

> IDCS는 OCI 이전에 오라클에서 서비스하던 여러 PaaS 서비스(현재 OCI로 점차 흡수되고 있음)에 대한 인증/권한 관리를 위해 사용해 왔으며, OCI에서도 계속해서 PaaS 서비스 이어가도록 OCI IAM과 페더레이션(통합)되어 사용되도록 구성되어 있습니다. PaaS 서비스들이 OCI Native 서비스로 이동하면서, 현재는 IDCS와 IAM이 통합이 되어 제공되고 있지만, 일부 Free Tier 계정의 경우 아직 IDCS와 IAM이 분리되어 제공됩니다. 

처음 OCI 어카운트를 생성하면 자동으로 인증 제공자로서 Oracle IDCS(Identity Cloud Service)가 프로비저닝 되며, IDCS와 IAM에 각각 한개 씩 총 두 개의 계정이 생성됩니다. OCI Console의 사용자 목록에도 두 개의 사용자 아이디가 보이는데, **oracleidentitycloudservice**라 붙은 아이디가 IDCS에서 관리하는 사용자 아이디입니다.
![](/assets/img/getting-started/2022/oci-iam-1.png " ")

인증하는 서비스가 다르기 때문에 OCI에 로그인 하는 방식도 두 가지 방식으로 나눠져 있습니다. IDCS 인증은 SSO 방식의 인증을 사용하고, IAM 인증은 OCI에 직접 인증하는 방식입니다.

![](/assets/img/getting-started/2022/oci-iam-2.png " ")

OCI Console에서 IDCS의 사용자 아이디가 보이는 이유가 IDCS 사용자가 자동으로 OCI IAM으로 페더레이션(통합)이 되기 때문입니다. 즉 IDCS에서 사용자를 생성하면, OCI IAM으로 연합되어 OCI IAM에서도 보입니다. 하지만 반대로 OCI IAM에서 생성한 사용자는 IDCS로 페더레이션(통합)되지 않기 때문에 IDCS 사용자 목록에는 보이지 않습니다.

사용자 생성이나 그룹은 IDCS 혹은 IAM 둘 다 가능하지만, OCI 서비스나 리소스에 대한 권한 관리를 위해서는 IAM에서 생성한 그룹과 정책을 활용하여야 합니다. 만약 IDCS에서 생성한 사용자(**oracleidentitycloudservice**가 포함된 아이디)와 그룹을 사용하고자 한다면, OCI IAM에 IDCS에서 생성한 그룹과 매핑이 되는 그룹을 하나 생성해서 매핑을 해야 합니다.

### IDCS 사용자에게 특정 구획(Compartment)에 접근할 수 있는 권한 추가
IDCS 사용자에게 필요한 액세스 권한을 설정하는 방법을 이해하는데 도움이 되도록, 다음과 같은 시나리오로 구성해보도록 하겠습니다.
1. 사용자는 IAM이 아닌 IDCS에서만 생성하고 관리합니다.
2. IDCS에서 생성한 사용자에게 IDCS에서 생성한 **IDCS_SandboxGroup** 을 할당합니다.
3. OCI에서 **IDCS_SandboxGroup**과 매핑하기 위한 IAM 그룹으로 **SandboxGroup** 그룹을 생성합니다.
4. **IDCS_SandboxGroup** 그룹과 **SandboxGroup** 그룹을 매핑합니다.
5. OCI 정책을 생성하여 **SandboxGroup** 그룹에 특정 구획(Compartment)에만 접근할 수 있는 정책을 부여합니다.

#### 구획 (Compartment) 생성
우선 OCI에 **Sandbox**라는 구획을 생성하고, 사용자에게 이 구획에만 접근 가능하도록 구성해보겠습니다. 우선 위에서 **Sandbox**라는 구획을 생성합니다. 메뉴에서 **ID & 보안 (Identity & Security) > 구획(Compartment)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-iam-7.png " ")

**구획 생성** 버튼을 클릭하고, 입력창에 다음과 같이 입력합니다.
* 구획명: Sandbox
* 설명: Sandbox 사용자를 위한 구획

![](/assets/img/getting-started/2022/oci-iam-8.png " ")

#### IDCS에 사용자 추가
두 번째로 IDCS에 사용자를 추가합니다. 메뉴에서 **ID & 보안 (Identity & Security) > 통합(Fedeation)**을 선택합니다. 

![](/assets/img/getting-started/2022/oci-iam-3.png " ")

ID 제공자(Identity Provider)로 기본으로 포함되어 있는 IDCS Provider인 **OracleIdentityCloudService**을 선택합니다.

![](/assets/img/getting-started/2022/oci-iam-4.png " ")

**사용자 생성**를 클릭합니다.
![](/assets/img/getting-started/2022/oci-iam-5.png " ")

**사용자 생성 대화상자**에서 다음을 입력합니다.  
* 사용자 이름 : 사용자의 고유한 이름 또는 이메일 주소를 입력합니다. 테넌시내에서 고유한 값이어야 하며, 로그인 시 사용됩니다.
* 이메일 : 사용자의 이메일 주소를 입력합니다. 초기 인증을 위한 이메일이 이 주소로 전송됩니다.
* 이름: 사용자의 이름을 입력합니다.
* 성: 사용자의 성을 입력합니다.
* 전화번호: (선택) 전화번호를 입력합니다.
* 그룹: (선택) 아직 그룹이 생성되어 있지 않기 때문에 그룹은 선택하지 않습니다. (관리자로 추가할 경우 OCI_Administrators와 같은 그룹을 선택합니다.)

![](/assets/img/getting-started/2022/oci-iam-6.png " ")

> 추가된 사용자는 패스워드 재설정을 위한 이메일을 전달받게 됩니다. 이메일 본문에 있는 링크를 클릭하여 패스워드를 재설정할 수 있습니다.

#### IDCS에서 그룹 생성
OCI IAM 그룹 생성을 위해서 메뉴에서 **ID & 보안 (Identity & Security) > 통합(Fedeation)**을 선택합니다. 

![](/assets/img/getting-started/2022/oci-iam-3.png " ")

**그룹 생성**을 클릭하고, 다음과 같이 입력한 후 생성을 클릭합니다.
* 그룹명: IDCS_SandboxGroup
* 설명: Sandbox 구획을 사용하기 위한 그룹
* 사용자: 위에서 추가한 IDCS 사용자
![](/assets/img/getting-started/2022/oci-iam-11.png " ")

#### OCI IAM에서 그룹 생성
앞에서 생성한 IDCS 그룹과 매핑하기 위한 IAM 그룹을 생성합니다. OCI IAM 그룹 생성을 위해서 **ID & 보안 (Identity & Security) > 그룹(Groups)**를 선택합니다.
![](/assets/img/getting-started/2022/oci-iam-9.png " ")

**그룹 생성**을 클릭하고, 다음과 같이 입력하고 생성을 클릭합니다.
* 그룹명: SandboxGroup
* 설명: Sandbox 구획을 사용하기 위한 그룹
![](/assets/img/getting-started/2022/oci-iam-10.png " ")

#### IDCS그룹을 IAM그룹에 매핑
이제 IDCS에서 생성한 그룹을 IAM 그룹과 매핑하여야 합니다. 매핑을 통해서 IDCS 그룹의 구성원에게 OCI 그룹에 부여하는 정책을 적용할 수 있습니다.
메뉴에서 **ID & 보안 (Identity & Security) > 통합(Fedeation)**을 선택합니다. 

![](/assets/img/getting-started/2022/oci-iam-3.png " ")

ID 제공자(Identity Provider)로 기본으로 포함되어 있는 IDCS Provider인 **OracleIdentityCloudService**을 선택합니다.

![](/assets/img/getting-started/2022/oci-iam-4.png " ")

좌측 메뉴에서 **그룹 매핑**을 선택하고, **매핑 추가** 버튼을 클릭한 후, 다음과 같이 선택하고, **매핑 추가** 버튼을 클릭합니다.

![](/assets/img/getting-started/2022/oci-iam-12.png " ")

#### IAM 그룹에 정책 (Policy) 설정
이제 **Sandbox** 구획에 대한 **SandboxGroup** 그룹에 권한을 부여하기 위한 정책을 생성합니다. 메뉴에서 **ID & 보안 (Identity & Security) > 정책(Policy)**을 선택합니다. 

![](/assets/img/getting-started/2022/oci-iam-13.png " ")

**정책 생성** 버튼을 클릭한 후 다음과 같이 입력합니다.
* 이름: SandboxPolicy
* 설명: 사용자에게 Sandbox 구획에 대한 모든 권한 부여
* 수동 편집기 표시 (Off) -> 직접 정책을 입력
* 정책 작성기에 다음 구문 입력
  * Allow group SandboxGroup to manage all-resources in compartment Sandbox
  * **Sandbox** 구획에 모든 리소스를 관리할 수 있는 권한을 **SandboxGroup** 그룹에 할당하는 정책 구문

![](/assets/img/getting-started/2022/oci-iam-14.png " ")

#### 요약
OCI내에 IDCS라는 PaaS형 IAM 서비스와 OCI 자체 IAM 서비스가 혼재되어 있어서, IDCS를 활용하여 사용자 관리를 위해서는 이와 같이 두 서비스에 생성한 그룹을 매핑하는 작업이 선행되어야 합니다. 간단히 도식하면 다음과 같습니다.

> **사용자 추가 (IDCS 사용자)** ----> **IDCS_SandboxGroup (IDCS 그룹)** <-----매핑-----> **SandboxGroup (OCI 그룹)** <--- **정책 부여 (OCI 정책)**

현재는 IDCS와 IAM이 통합된 OCI IAM Identity Domain이라는 OCI 자체 서비스가 출시되었고, 점차 모든 리전과 무료 계정에도 적용되고 있으니, 앞으로는 OCI에서의 IAM 관리가 보다 심플해질 것이라 생각됩니다.
