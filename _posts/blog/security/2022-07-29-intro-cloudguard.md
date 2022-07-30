---
layout: page-fullwidth
#
# Content
#
subheadline: "Security"
title: "OCI Cloud Guard 소개"
teaser: "OCI Native로 제공하는 보안관제 서비스인 Cloud Guard에 대해 소개합니다."
author: dankim
breadcrumb: true
categories:
  - security
tags:
  - [oci, security, cloudguard]
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

### Cloud Guard란
퍼블릭 클라우드 환경에서 보안은 상당히 민감한 이슈입니다. 특히 클라우드 사용자가 보안에 취약한 구성이나 행위를 함으로써 발생되는 보안 문제점들은 클라우드 사용자에게 직접적인 책임이 있는 경우가 많아서 더 세심하게 관리를 해야 합니다. 이러한 사용자의 보안 취약한 행위를 예방할 수 있게 도와주는 서비스가 OCI의 Cloud Guard라는 서비스입니다. Cloud Guard는 OCI내의 Compartment라 불리는 특정 구역에 대한 보안 상태를 통합적으로 모니터링하고, 문제를 감지하여 제안 및 조치를 취할 수 있도록 해주는 무료 서비스입니다.

### Cloud Guard Concepts
Cloud Guard를 사용하기 위해서는 우선 아래 구성과 4개의 용어를 기억해 둘 필요가 있습니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-1.png)

#### TARGET
Cloud Guard에서 모니터링 할 범위를 TARGET이라고 부릅니다. Oracle Cloud에서는 Compartment라고 부르는 여러 OCI의 리소스에 대한 그룹핑 및 접근관리등을 할 수있는 논리적인 개념의 구역이 존재하는데, 보통 Cloud Guard에서의 TARGET으로 특정 Compartment를 지정합니다.

#### DETECTORS
Detector는 TARGET의 특정 리소스 및 활동을 감지하기 위한 규칙의 모음(여기서는 이를 Recipe라고 부른다)이라고 보면 됩니다. Detector로 정의된 규칙에 의해 TARGET에서 발생할 수 있는 잠재적인 보안 문제를 감지하게 됩니다.

Detector는 OCI에서 기본적으로 제공하는 Recipe인 Oracle-managed detector recipe가 있고, 사용자가 직접 정의할 수 있는 User-managed detector recipe가 있는데, 보통은 Oracle-managed detector recipe를 활용하고, 이를 클론하여 사용자가 원하는 방향으로 수정하여 사용하는 것이 일반적입니다.

Detector는 두 가지 유형의 Recipe가 존재하는데, OCI 구성에 대한 보안 문제를 감지하는 Configuration Detector recipe가 있고, 보안 문제를 야기하는 특정 행위를 감지하는 Activity Detector recipe가 있습니다.

Configuration Detector 예로 "Object Storage 의 Public Bucket 생성 불허용"과 같은 케이스가 있을 수 있습니다.

Activity Detector의 경우에는 "Database 인스턴스 삭제 불허용"을 예로 들 수 있습니다.

#### PROBLEM
Detector에서 감지된 결과, 즉 보안 문제들을 Problem이라고 합니다. Problem 목록을 통해서 어떤 Problem들이 발생했는지 확인을 할 수 있으며, Problem 유형에 따라 관리자가 자동 혹은 수동으로 특정 액션을 수행할 수 있습니다.

#### RESPONDER
마지막으로 Responder는 Problem에 따라서 자동 혹은 수동으로 수행하는 규칙들의 모음(Recipe)을 의미합니다. Detector와 마찬가지로 Oracle-managed와 User-managed recipe를 제공합니다.

### Cloud Guard 활성화
기본은 비활성화 되어 있습니다. Cloud Guard를 활성화 하기 위해서는 OCI Console > Identity & Security > Cloud Guard 로 이동한 후 Enable 버튼을 클릭하여 활성화 하여야 합니다. (기본으로 제공하는 무료 크래딧 300$로 체험할 수 있습니다. 단 Always Free에서는 사용할 수 없으며, 300$ 소진 후에는 유료 계정으로 업그레이드 해야 합니다.)

![](/assets/img/cloudnative-security/2022/oci-cloudguard-2.png)

Cloud Guard에서 여러 OCI 리소스에 접근을 허락해줘야 하기 때문에 기본적으로 필요한 Policy를 추가해 줘야 하는데, 활성화 과정에서 친절하게 한번에 추가할 수 있는 기능을 제공합니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-3.png)

Cloud Guard에서 모니터링 할 TARGET을 지정합니다. Detector recipe의 경우에는 이 단계에서 선택해줘도 되지만, 활성화 한 이후에 따로 지정해줘도 상관 없습니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-4.png)

활성화 되면 다음과 같은 Cloud Guard 대시보드를 볼 수 있습니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-5.png)

### User-managed detector, resopnder recipe
기본은 아래와 같이 Oracle-managed recipe를 사용하지만, 수정이 불가능하기 때문에, Clone 버튼을 활용하여 해당 Recipe를 클론한 후에 사용합니다. 클론한 Recipe의 경우 사용자가 해당 규칙을 수정할 수 있게 됩니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-6.png)

아래 그림은 Configuration detect recipe 목록으로, 현재 37개의 Rule을 제공하고 있습니다. 클론한 경우 Status(Disble, Enable), Risk Level (Minor, Low, Medium, High, Critical), Condition (발생 조건)등을 수정할 수 있습니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-7.png)

Responder recipe rule의 경우 아래와 같이 제공되는데, 클론을 하게 되면 사용자가 내용을 수정할 수 있습니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-8.png)

Responder Rule의 경우 Type이 NOTIFICATION과 REMEDIATION 2 가지 유형이 보이는데, NOTIFICATION의 경우 발생한 Problem에 대한 알림이 OCI Event와 Notification 서비스를 통해서 이메일이나 OCI Function등과 연동할 수 있는 유형이며, REMEDIATION은 Problem을 자동 혹은 관리자에 의해 문제를 보정할 수 있도록 해주는 유형입니다.  
Responder Rules에 있는 내용에 따라서 관련 유형의 Respoder가 동작하게 됩니다.

NOTIFICATION 유형은 현재 Cloud Event Rule만 대상이며, 사용을 위해서는 OCI Event와 Notification 서비스를 구성하여 사용할 수 있습니다.  
관련 가이드는 아래 링크에서 확인해볼 수 있습니다.

> https://docs.oracle.com/en-us/iaas/cloud-guard/using/export-notifs-config.htm

각 Responder Rule에는 Rule Trigger를 설정할 수 있는데, "Ask me before executing rule"의 경우 관리자가 Problem에서 내용을 확인 한 후 액션을 취할 수 있으며, "Execute automatically" 관리자 개입 없이 시스템이 자동으로 보정처리 하게 됩니다. 예를 들면 Private Bucket만 허용하는데, Public Bucket으로 생성하게 되면 자동으로 Private Bucket으로 변경이 됩니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-9.png)

### 예시 - Cloud Guard 대상 (TARGET)에서 Public Bucket 생성
간단히 Cloud Guard가 적요된 대상에서 Public Bucket을 하나 생성해 보도록 하겠습니다. 아래와 같이 Object Storage에서 Bucket 생성 후 Visibility를 Public으로 변경합니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-10.png)

Cloud Guard 대시보드에서 Critical을 포함하여 Problem이 4개 생성된 것을 확인할 수 있습니다. Responder Status에도 1개의 Pending이 걸려 있는데, 앞서 관련된 Responder Rule의 Rule Trigger를 "Ask me before executing rule"로 설정해 놨기 때문에 관리자 액션이 있어야 하므로, Pending이 된 것입니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-11.png)

Responder Activity 메뉴에서 Private 으로 변경에 대한 확인 요청이 생성 된 것을 볼 수 있습니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-12.png)

Skip Execute 를 선택 하면 해당 Remediation 은 취소 되는데,Execute 를 클릭 해봅니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-13.png)

Bucket의 Visibility가 다시 Private으로 변경된 것을 확인할 수 있습니다.
![](/assets/img/cloudnative-security/2022/oci-cloudguard-14.png)

### 참고
* https://docs.oracle.com/en-us/iaas/cloud-guard/using/index.htm





















   ![](/assets/img/security/2022/oci-policy-menu.png)
2. 이동한 화면에서 "정책생성" 버튼을 클릭하여 정책 생성 화면으로 이동합니다.
   ![](/assets/img/security/2022/oci-policy-create.png)
3. 다음과 같이 입력 후 "**수동 편집기 표시**" 옵션을 활성화 합니다.
   - 이름 : **billing-policy**
   - 설명 : **빌링 메뉴 접근을 위한 정책 입니다.**
   - 구획 : **전체 테넌시에 적용하기 위해서 root compartment에 정책을 생성합니다.**
   ![](/assets/img/security/2022/oci-policy-billing-create.png)
4. 수동 편집기에 아래와 같이 입력합니다.
   - 특정 그룹에 대한 정책 생성 
    ```
    Allow group <group> to manage accountmanagement-family in tenancy
    ```
5. "**생성**" 버튼을 클릭하여 정책을 생성을 마무리 합니다.
6. 정책을 생성한 그룹의 사용자로 로그인 후 적용 여부를 확인합니다.