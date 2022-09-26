---
layout: page-fullwidth
#
# Content
#
subheadline: "Support"
title: "OCI와 MOS(My Oracle Support) 계정 연동, OCI의 일반 사용자에게 지원 요청(SR) 권한 할당 방법"
teaser: "OCI를 유료로 구독하는 경우 최초 관리자(Cloud Account Admin 권한을 갖는 사용자)는 OCI Console에서 지원 요청 티켓을 생성하여 오라클로부터 다양한 지원을 받을 수 있습니다. 이번 글에서는 관리자의 OCI 계정을 MOS(My Oracle Support) 계정과 연동하는 방법과, OCI 일반 사용자에게 지원 요청(SR)을 생성할 수 있는 권한을 부여하는 방법에 대해서 설명합니다."
author: dankim
date: 2022-06-03 00:00:02
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, support]
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

### MOS (My Oracle Support) 계정 생성
OCI Tenancy를 처음 생성할 때 관리자로 지정한 사용자(Cloud Account Admin 권한을 갖는 사용자)는 기본적으로 OCI Console에서 SR을 생성할 수 있습니다. 하지만 OCI Console에서는 SR을 생성하는 것과 생성한 SR을 관리하는 것 외에는 추가적인 활동은 할 수 없습니다. MOS(My Oracle Support)는 오라클에서 제공하는 지원 포탈로 SR을 생성하고 관리하는 것 외에도 오라클 데이터베이스를 포함하여 오라클 전 제품에 대한 정보와 최신 패치등을 제공하며, 관리자외에도 OCI의 일반 사용자도 SR을 생성할 수 있도록 사용자 권한도 관리할 수도 있습니다. MOS를 이용하기 위해서는 오라클 계정을 별도로 생성하여야 하는데, 최초에 생성한 OCI 관리자 이메일과 동일한 이메일로 오라클 계정을 생성하면, 자동으로 MOS 계정과 OCI 계정이 연동됩니다.

> OCI Console의 Tenancy 상세 화면(OCI Console 오른쪽 상단 프로파일 > 테넌시 선택)에서는 CSI(Customer Support Identifier)라는 숫자를 확인할 수 있습니다. 이 숫자는 오라클 소프트웨어, 하드웨어를 구매하거나 클라우드를 구독하는 사용자에게 부여되는 번호이며, SR 생성을 위한 필수요소입니다. OCI 최초 관리자는 이 번호를 관리하는 관리자(CSI 관리자)가 되며, 일반 사용자도 관리자의 승인을 받으면 해당 CSI와 연결되어 동일하게 SR을 생성할 수 있는 권한을 갖게 됩니다.

MOS 계정을 생성하기 위해서는 오라클 계정을 생성하여야 하는데, 생성을 위해 아래 링크로 접속하여 **Register as a new user** 링크를 클릭합니다.

[My Oracle Support](http://support.oracle.com)

![](/assets/img/getting-started/2022/configuring-support-account-0.png " ")

아래와 같이 가입폼이 나오면, OCI Tenancy 생성 시 입력한 관리자 이메일 계정을 입력하여 계정을 생성합니다.
![](/assets/img/getting-started/2022/configuring-support-account-0-1.png " ")

> 오라클 계정은 SSO로 연동되어 있어서 모든 오라클사에서 제공하는 사이트(e.g. https://edelivery.oracle.com/)에서 사용할 수 있습니다.

오라클 계정을 생성하면 다음과 같이 이메일 확인을 하라는 안내 화면을 볼 수 있습니다.
![](/assets/img/getting-started/2022/configuring-support-account-1.png " ")

다음과 같은 이메일을 확인하게 되는데, 메일 본문의 **이메일 주소 확인** 버튼 혹은 링크를 클릭하여 이메일 확인을 합니다.
![](/assets/img/getting-started/2022/configuring-support-account-3.png " ")

다시 이메일 확인 안내 페이지를 새로고침 하면 다음과 같은 화면이 나옵니다. **계속** 버튼을 클릭한 후 로그인 화면에서 오라클 계정으로 로그인을 합니다.
![](/assets/img/getting-started/2022/configuring-support-account-2.png " ")

MOS(My Oracle Support)에 최초로 로그인 하면 약관을 확인하고 **Accept**를 요구합니다. 아래 **I Accept the My Oracle Support Terms of Use** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/configuring-support-account-4.png " ")

다음과 같이 My Oracle Support에서 본인 계정 정보를 확인할 수 있습니다. 관리하는 CSI번호와 해당 CSI를 위한 역할 (Admin)을 확인할 수 있습니다. (지금부터는 이 관리자를 **CSI 관리자**라고 칭하겠습니다.)
![](/assets/img/getting-started/2022/configuring-support-account-6.png " ")

### MOS (My Oracle Support) 연동 확인
OCI Console에 로그인 하여 OCI 지원 센터에서 SR을 하나 생성합니다. OCI 지원 센터는 상단 **Help** 메뉴를 클릭하고 **지원 센터 방문** 버튼을 클릭하면 바로 이동 가능합니다.
![](/assets/img/getting-started/2022/configuring-support-account-6-1.png " ")

지원 요청 생성 (Create Support Request) 버튼을 클릭한 후 간단히 내용을 입력하여 지원 요청을 생성합니다. 여기서는 테스트를 위해서 간단히 요청글을 작성하여 SR을 생성합니다. SR 생성과 관련해서 좀 더 자세한 내용은 아래 포스트를 참고하세요.

[OCI 지원 요청을 위해 지원 티켓을 오픈하여 지원받는 방법](https://team-okitoki.github.io/getting-started/open-support-ticket/)

![](/assets/img/getting-started/2022/configuring-support-account-6-2.png " ")

이제 MOS 화면에서 상단의 **Service Requests**탭을 클릭합니다. MOS에서도 동일하게 생성된 SR을 확인할 수 있습니다.
![](/assets/img/getting-started/2022/configuring-support-account-6-3.png " ")


### 일반 OCI 사용자가 SR을 생성하기 위한 방법
일반 OCI 사용자도 SR을 생성할 수 있습니다. 두 가지 방법이 제공되는데, 첫 번째는 사용자에게 SR을 신청할 수 있도록 CSI 관리자가 권한을 부여하는 것이고, 두 번째는 일반 OCI 사용자 계정을 CSI 관리자 계정과 연결하는 방법입니다.

#### 일반 OCI 사용자에게 SR을 생성할 수 있는 권한 부여하기
일반 OCI 사용자 (IDCS 또는 IAM 사용자)가 지원 센터에 접속하면 아래와 같은 화면을 볼 수 있습니다. 여기서 CSI 관리자와 마찬가지로 일반 사용자도 MOS 계정을 생성해야 합니다. 아래 화면의 **지원 계정 생성(Create a support account)**에서 생성할 MOS 계정 정보 (이름, 전화번호, 시간대)를 입력하고 **지원 계정 생성(reate support account)** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/configuring-support-account-8.png " ")

**CSI(고객 번호) 확인 보류 중**이라는 메시지를 확인할 수 있습니다. 해당 CSI를 관리하는 CSI 관리자로 부터 승인을 기다리는 상태입니다.
![](/assets/img/getting-started/2022/configuring-support-account-8-1.png " ")

요청한 사용자는 MOS에 접속하기 위해 우선 계정 설정을 할 수 있는 이메일을 수신합니다. **Set Password** 혹은 링크를 클릭합니다. 
![](/assets/img/getting-started/2022/configuring-support-account-11.png " ")

OCI에서 사용하는 이메일 주소와 MOS에 로그인하기 위한 패스워드를 입력합니다.
![](/assets/img/getting-started/2022/configuring-support-account-12.png " ")

일반 사용자도 앞서 CSI 관리자와 마찬가지로 약관 수락 화면을 볼 수 있고, 수락하면 바로 MOS 계정 정보를 볼 수 있는 화면으로 이동합니다. 하지만 아직 CSI 관리자가 MOS에서 승인을 하기 전이므로, 현재는 해당 CSI로 SR을 생성할 수는 없습니다.

CSI 관리자로 MOS에 로그인을 하고 상단의 **Settings** 탭을 클릭한 후 왼쪽 **Pending User Requests** 메뉴를 클릭하면 요청한 사용자를 확인할 수 있습니다. 해당 사용자를 선택 후 바로 위 **Approve Request**를 클릭합니다.
![](/assets/img/getting-started/2022/configuring-support-account-13.png " ")

이제 사용자의 역할과 접근 권한을 설정하고 **Approve** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/configuring-support-account-14.png " ")

이제 CSI 관리자와 마찬가지로 동일하게 SR을 생성할 수 있으며, 해당 CSI와 연관된 모든 SR을 확인할 수 있습니다.
![](/assets/img/getting-started/2022/configuring-support-account-15.png " ")

#### 일반 OCI 사용자 계정과 CSI 관리자 계정을 연결
일반 OCI 사용자도 SR을 생성할 수 있는 두 번째 방법은 일반 사용자에게 SR을 생성 시 CSI 관리자 계정으로 SR을 생성할 수 있도록 CSI 관리자 계정을 연결시켜 주는 것입니다. 이 작업은 CSI 관리자가 OCI Console에서 수행합니다.

우선 CSI 관리자는 OCI Console에 로그인 한후 메뉴에서 **ID & 보안(Identity & Security)**로 이동해서 권한을 줄 사용자를 선택합니다.

사용자 상세 화면에서 **지원 계정 링크(Link Support Account)**버튼을 클릭합니다.
![](/assets/img/getting-started/2022/configuring-support-account-16.png " ")

아래와 같이 사용자 계정이 CSI 관리자 계정과 연결되었다는 메시지를 확인할 수 있습니다.
![](/assets/img/getting-started/2022/configuring-support-account-17.png " ")

이제 이렇게 CSI 관리자 계정과 연결된 계정도 SR을 생성할 수 있게 됩니다.

### SR 생성 권한 부여와 지원 계정 링크 차이점
CSI 관리자로부터 MOS에서 권한을 부여받은 사용자와 OCI Console에서 지원 계정 링크가 된 사용자의 차이는 SR을 생성한 주체가 다르다는 점입니다. SR 생성 권한을 부여받은 사용자가 SR을 생성하면 SR을 생성한 주체는 본인이 됩니다. 자신의 이메일 계정으로 SR생성 및 업데이트와 관련된 메일을 수신받고, 자신의 계정으로 MOS에 로그인하여 SR을 확인하고 업데이트 할 수 있습니다.

만약 지원 계정 링크로 권한을 부여받은 사용자가 SR을 생성하면 주체는 CSI 관리자가 됩니다. 이 경우에는 이메일도 CSI 관리자가 받게 됩니다. MOS에도 계정이 없기 때문에 MOS에서 확인하거나 업데이트를 할 수 없습니다. 다만 OCI Console 지원 센터에서 업데이트 된 내용을 확인할 수 있고, 설명(Comments) 메뉴를 통해 업데이트가 가능합니다. OCI 사용자가 별도의 MOS 계정을 생성할 필요가 없고, 신속하게 SR을 생성할 필요가 있을 때 사용하면 좋습니다. 지원 계정 링크 해제도 지원 계정 링크 후 지원 계정 링크 해제 버튼이 활성화되는데, 이 버튼을 클릭하면 바로 해제됩니다.