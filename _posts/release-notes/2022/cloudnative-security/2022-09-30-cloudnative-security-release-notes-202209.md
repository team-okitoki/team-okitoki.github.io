---
layout: page-fullwidth
#
# Content
#
subheadline: "OCI Release Notes 2022"
title: "9월 OCI Cloud Native & Security 업데이트 소식"
teaser: "2022년 9월 OCI Cloud Native & Security 업데이트 소식입니다."
author: dankim
breadcrumb: true
categories:
  - release-notes-2022-cloudnative-security
tags:
  - oci-release-notes-2022
  - sep-2022
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

## Support for multiple authentication servers for the same API deployment
* **Services:** API Gateway
* **Release Date:** Sept. 14, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/API/Concepts/code_editor_intro.htm](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/code_editor_intro.htm){:target="_blank" rel="noopener"} 

### 기능 소개
동일한 API 배포에 대해 여러개의 인증 서버를 적용하여 클라이언트 요청에 따라 런타임에 적절한 IDP(Identity Provider)를 선택할 수 있는 기능입니다.

기본적으로는 하나의 IDP의 공개 서명 인증서를 사용하거나 토큰의 유효성을 검사하기 위해 IDP의 자체 검사를 위한 엔드포인트를 호출하여 IDP로 수신된 토큰의 유효성을 검사합니다. 또한 각 API 배포는 서로 다른 IDP로 구성할 수 있습니다. 이번에 추가된 기능은 하나의 API 배포에 여러개의 IDP를 적용하는 기능으로 아래 그림과 같이 다중 테넌트에 구성된 IDP를 활용하여 클라이언트별로 선택적으로 IDP를 선택하게 구성할 수 있습니다. 

다중 인증은 다음 단계로 실행됩니다.
1. 클라이언트가 선택한 IDP로 인증하고 토큰을 받습니다.
2. 클라이언트가 성공적으로 토큰을 얻으면 해당 토큰을 사용하여 API를 호출합니다.
3. 게이트웨이는 토큰과 함께 요청을 수신하고 런타임시에 사용할 IDP를 결정하기 위해 요청 요소(x-tenant-id와 같은 요청 header, query parameter, host, subdomain, path parameter, authorization claim)를 기반으로 IDP를 선택합니다.
4. 인증이 성공되면 게이트웨이는 요청을 백엔드로 라우팅하고 클라이언트에 응답을 반환합니다.

![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONT17032CCFD0DB449086A523F55C3D7736/Medium?cb=_cache_ad89&format=jpg&channelToken=f7814d202b7d468686f50574164024ec)

다중 인증은 오픈 API 서비스를 하는 경우 사용자 유형(개발자, 트라이얼 사용자, 유료 사용자등)에 따라서 IDP를 다중/동적으로 구성해야 하는 경우에도 사용할 수 있습니다.

---

## Support for multiple back ends, and dynamic back end selection
* **Services:** API Gateway
* **Release Date:** Sept. 14, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/APIGateway/Tasks/apigatewaydynamicroutingbasedonrequest_topic.htm](https://docs.oracle.com/en-us/iaas/Content/APIGateway/Tasks/apigatewaydynamicroutingbasedonrequest_topic.htm){:target="_blank" rel="noopener"} 

### 기능 소개
일반적으로는 API 게이트웨이로 전송된 요청에 대해 각 API 경로별로 매핑된 단일 백엔드로 라우팅합니다. 만일 하나의 API 경로를 활용하여 서로 다른 백엔드로 라우팅해야 할 필요가 있을때 이 기능을 사용할 수 있습니다. 이제 하나의 API 경로는 여러개의 백엔드를 가질 수 있으며, 클라이언트 요청에 따라서 적절한 백엔드를 선택할 수 있습니다.

다중 라우팅 실행의 경우 1~3 단계 까지는 **다중 인증**에서의 단계와 동일합니다. 4단계에서 게이트웨이는 "/pet"와 같은 클라이언트가 요청한 경로를 기반으로 실행되지만, 백엔드가 여러개이므로 여러개의 백엔드에서 적절한 백엔드를 선택하기 위한 선택기를 통해 요청을 추가로 확인하게 됩니다. 선택기는 header, query parameter, host, subdomain, path parameter, authorization claim, 또는 usage plan을 기반으로 정의할 수 있습니다.

![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONT36E995344A2D4DD596E8839E0B4566E9/Medium?cb=_cache_ad89&format=jpg&channelToken=f7814d202b7d468686f50574164024ec)

이 기능을 활용하면 API 개발자는 헤더 기반 라우팅, 사용량 계획 기반 라우팅, 테넌트 기반 라우팅등을 정의할 수있습니다.

---

## Support for multi-argument authorizer functions and access tokens
* **Services:** API Gateway
* **Release Date:** Sept. 14, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/APIGateway/Tasks/apigatewayusingauthorizerfunction.htm](https://docs.oracle.com/en-us/iaas/Content/APIGateway/Tasks/apigatewayusingauthorizerfunction.htm){:target="_blank" rel="noopener"} 

### 기능 소개
API 게이트웨이는 모든 OAuth 2.0 호환 토큰에 대한 JWT 유효성 검사를 지원하고 있습니다. 여기에 권한 부여 기능을 더 확장할 수 있도록 OCI Functions를 활용하여 권한 부여자 함수(Authorizer functions)를 지원합니다. 권한 부여자 함수를 사용하면 path, headers, query parameters, host, body, 심지어 mTLS를 사용하는 클라이언트 인증서도 권한 부여자 함수에 포함될 수 있습니다.

![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONT20AB8154E42D4C7FB1E8A30D7B449C88/Medium?cb=_cache_ad89&format=jpg&channelToken=f7814d202b7d468686f50574164024ec)

---

## DevOps Integration with Visual Builder Studio
* **Services:** DevOps
* **Release Date:** Sept. 20, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/Content/devops/using/create_connection.htm](https://docs.oracle.com/en-us/iaas/Content/devops/using/create_connection.htm){:target="_blank" rel="noopener"} 

### 기능 소개
OCI DevOps 서비스는 외부 코드 저장소로 GitHub, GitLab, Bitbucket Cloud, Bitbucket Server, GitLab Server를 지원하였으며, 이번에 Visual Studio Builder Studio를 추가로 지원하게 되었습니다.

![](/assets/img/cloudnative-security/2022/oci-cloudnative-security-release-notes-09-1.png)