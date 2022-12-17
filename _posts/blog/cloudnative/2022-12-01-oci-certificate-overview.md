---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI Certificates 서비스 살펴보기"
teaser: "Cloud 서비스 운영에 필요한 인증서를 쉽고 편하게 관리할 수 있는 OCI Certificates 서비스에 대해 알아봅니다"
author: yhcho
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, certificates, CA]
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

### OCI Certificates 소개
OCI Certificates 서비스는 OCI 테넌시에서 SSL/TLS 인증서가 필요한 서비스와 원활하게 연결하기 위한 기능을 제공합니다. 
테넌시에서 사용할 수 있는 자체 인증기관 및 인증서를 생성, 발급할 수 있으며, 이미 사용중인 다른 인증 기관 (CA)의 인증서를 Import 하여 사용할 수도 있습니다. 
OCI Certificates 서비스를 사용하여 고객은 손쉽게 TLS 인증서의 버전 및 배포, 갱신을 관리할 수 있습니다.

#### OCI Certificates 서비스란?
개인 정보 보호 및 데이터 보안을 강화하기 위해 컴퓨터 시스템(예: 서버, 웹 애플리케이션, 이메일 등)은 TLS를 사용하여 데이터 전송 과정에서 내용을 암호화해야 합니다. 
TLS를 적용하려면 SSL 인증서라고 하는 TLS 인증서를 사용해야 합니다. 물론 이러한 인증서를 관리하는 것은 번거롭고 어려운 일이지만 매우 중요한 작업입니다.<br>
운영중인 시스템에 인증서를 적용하고 관리해보셨다면 모두 알고 계시겠지만, 기존 인증서 관리와 관련된 가장 큰 문제점들은 **1) 개인 키 및 이를 사용하여 생성된 인증서 관리, 2) 인증서 인벤토리 추적, 3) 서비스 중단을 방지하기 위한 인증서 만료 전 갱신**입니다.<br>
특히 서비스 중단을 방지하려면 인증서의 만료 날짜를 모니터링하고 만료되기 전에 갱신해야 합니다. 단순히 인증서 몇 개를 사용하더라도 번거로운 프로세스 때문에 시간이 많이 소요되는데, 수천 개의 인증서를 사용하는 대기업의 경우 이러한 인증서를 관리하는 것은 대규모 작업으로 여러 사람이 필요한 작업이 될 수 있습니다.<br>
**OCI 인증서 서비스는 클라우드기반으로 설계된 X.509 인증서 서비스로, 이러한 인증서의 관리를 불편함, 어려움을 간소화하고 쉽게 관리할 수 있는 관리 기능을 제공합니다.**

#### OCI 인증서 관리 기능 소개
- **유연한 개인 Certificate Authority 계증 구현** - 손쉽게 개인 root CA 와 subordinate CA를 생성 가능
  - 최대 10개 단계 깊이까지 생성 가능한 CA 계층의 Trust Chain을 통해 유연성과 보안을 확보할 수 있습니다.
  - ![](/assets/img/cloudnative/2022/certificates/certificates-1.png " ")
- **유연한 인증서 생성** - 인증서 자동 배포 기능
  - 내부 CA를 사용하여 인증서를 쉽게 생성하고 배포하거나, CSR(인증서 서명 요청)을 인증서 서비스로 가져오거나 기존에 타 기관에서 발급받은 인증서를 업로드하여 통합 서비스에 자동 배포할 수 있습니다.
  - ![](/assets/img/cloudnative/2022/certificates/certificates-2.png " ")
- **손쉬운 OCI 서비스 통합** - OCI Load balancer 또는 API Gateway와 간편한 서비스 통합 기능
  - OCI 인증서를 로드 밸런서 또는 API 게이트웨이와 쉽게 통합할 수 있습니다. Oracle Cloud Infrastructure Certificates는 인증서 모니터링, 배포 및 자동 갱신기능을 제공하기 때문에 만료된 사용자가 인증서 만료를 걱정을 덜 수 있습니다.
  - ![](/assets/img/cloudnative/2022/certificates/certificates-3.png " ")

#### OCI 인증서 리소스를 통합할 수 있는 OCI 서비스 
아래 내용은 2022년 12월을 기준으로 작성되었습니다.
- **OCI Load Balancer**
  - 백엔드 집합에 SSL 인증서 적용 : OCI 인증서 서비스의 인증기관, CA번들 적용 가능
  - 리스너에 SSL 인증서 적용 : OCI 인증서 서비스의 인증서 적용 가능
- **API Gateway**
  - API Gateway 인증서 적용 : OCI 인증서 서비스의 인증서 적용 가능
  - API Gateway 인증기관 적용 : OCI 인증서 서비스의 인증기관, CA번들 적용 가능

#### OCI 인증서 서비스의 제한
<table class="table vl-table-bordered vl-table-divider-col" summary="This table shows Certificates service limits by
                resource for Pre-Paid Credit customers and Pay-as-You-Go customers"><caption></caption><colgroup><col><col><col></colgroup><thead class="thead">
<tr class="row">
<th class="entry align-center" id="servicelimits_topic_Certificates_Limits__entry__1">
<p class="p">Resource</p>
</th>
<th class="entry align-center" id="servicelimits_topic_Certificates_Limits__entry__2">
<p class="p">Monthly or Annual Universal Credits</p>
</th>
<th class="entry align-center" id="servicelimits_topic_Certificates_Limits__entry__3">
<p class="p">Pay-as-You-Go or Promo</p>
</th>
</tr>
</thead><tbody class="tbody">
<tr class="row">
<th class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__1" id="servicelimits_topic_Certificates_Limits__entry__4" scope="row">Certificate authorities in a tenancy</th>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__4 servicelimits_topic_Certificates_Limits__entry__2"><p class="p">100</p></td>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__4 servicelimits_topic_Certificates_Limits__entry__3"><p class="p">100</p></td>
</tr>
<tr class="row">
<th class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__1" id="servicelimits_topic_Certificates_Limits__entry__7" scope="row">Certificates in a tenancy</th>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__7 servicelimits_topic_Certificates_Limits__entry__2">
<p class="p">5000</p>
</td>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__7 servicelimits_topic_Certificates_Limits__entry__3">
<p class="p">5000</p>
</td>
</tr>
<tr class="row">
<th class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__1" id="servicelimits_topic_Certificates_Limits__entry__10" scope="row">CA bundles in a tenancy</th>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__10 servicelimits_topic_Certificates_Limits__entry__2">
<p class="p">25</p>
</td>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__10 servicelimits_topic_Certificates_Limits__entry__3">
<p class="p">25</p>
</td>
</tr>
<tr class="row">
<th class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__1" id="servicelimits_topic_Certificates_Limits__entry__13" scope="row">Certificate versions in a certificate</th>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__13 servicelimits_topic_Certificates_Limits__entry__2"><p class="p">30</p></td>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__13 servicelimits_topic_Certificates_Limits__entry__3"><p class="p">30</p></td>
</tr>
<tr class="row">
<th class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__1" id="servicelimits_topic_Certificates_Limits__entry__16" scope="row">Certificate versions scheduled for deletion (for a given certificate)</th>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__16 servicelimits_topic_Certificates_Limits__entry__2"><p class="p">30</p></td>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__16 servicelimits_topic_Certificates_Limits__entry__3"><p class="p">30</p></td>
</tr>
<tr class="row">
<th class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__1" id="servicelimits_topic_Certificates_Limits__entry__19" scope="row">Associations for a given certificate</th>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__19 servicelimits_topic_Certificates_Limits__entry__2"><p class="p">30</p></td>
<td class="entry align-center" headers="servicelimits_topic_Certificates_Limits__entry__19 servicelimits_topic_Certificates_Limits__entry__3"><p class="p">30</p></td>
</tr>
</tbody></table>

#### OCI 인증서 서비스 비용
<mark>OCI 인증서 서비스는 무료로 제공됩니다.</mark>

#### 타사 유사 서비스
<table><caption></caption><colgroup><col><col><col><col></colgroup><thead class="thead">
<tr>
<th id="h_oci"><p style="text-align: center">OCI</p></th>
<th id="h_aws"><p style="text-align: center">AWS</p></th>
<th id="h_azure"><p style="text-align: center">Azure</p></th>
<th id="h_gcp"><p style="text-align: center">GCP</p></th>
</tr>
</thead><tbody>
<tr>
<td headers="h_oci">OCI Certificates</td>
<td headers="h_aws">AWS Certificate Manager</td>
<td headers="h_azure">App Service Certificates</td>
<td headers="h_gcp">Google Cloud CA Service</td>
</tr>
</tbody>
</table>

### 인증서 서비스 컨셉 및 주요 용어 안내
#### CERTIFICATES (인증서)
인증서는 인증서의 공개 키 소유자임을 확인하는 디지털 문서입니다. 인증서는 최종 엔티티 또는 리프 인증서라고도 합니다. 최종 엔티티 인증서는 다른 인증서 서명에 사용할 수 없는 인증서입니다. 예를 들어, TLS/SSL 서버 및 클라이언트 인증서, 전자 메일 인증서, 코드 서명 인증서 및 자격 있는 인증서는 모두 최종 엔티티 인증서입니다.

#### CERTIFICATE AUTHORITIES (인증 기관)
CA(인증 기관)는 인증서 및 하위 CA를 발행합니다. CA는 지정된 인증서에서 공개 키의 소유권을 인증하기 위해 존재합니다. CA 인증서는 CA가 발행하는 인증서에서 CA 서명을 인증합니다. CA는 맨 위의 CA를 루트 CA라고 하며 계층 내에 있는 CA가 하위 CA.A CA 계층인 계층에 존재합니다. CA 계층은 각 엔티티가 체인에서 엔티티 아래에 서명하는 신뢰(또는 인증 경로) 체인을 설정합니다. 루트 CA는 자체 서명됩니다. 인증서를 신뢰할 수 있으려면 검증을 수행하는 끝점에 따라 루트 CA가 신뢰할 수 있는 루트 CA여야 합니다.

#### CA BUNDLES (CA 번들)
번들에는 루트 및 중간 인증서(번들 내용이라고도 함), 인증서 속성(및 인증서 버전) 및 사용자가 제공한 인증서 컨텍스트 메타데이터가 포함됩니다. CA 번들에는 인증서 서비스에서 관리되지 않는 CA를 포함하여 단일 CA 또는 다중 CA가 포함될 수 있습니다. 인증서 서비스는 PEM 형식의 인증서 콘텐츠를 지원합니다.

#### CERTIFICATE CHAINS (인증체인)
인증서 체인은 최종 엔티티 인증서에서 루트 인증서로의 인증서 목록입니다. 이 서비스는 인증서가 다른 키 알고리즘 제품군을 사용하는 혼합 인증서 체인을 지원하지 않습니다(예: 일부 인증서의 RSA 키 및 다른 인증서의 ECDSA 키 사용). 키 알고리즘 계열마다 서로 다른 CA 체인을 사용하는 것이 좋습니다.

#### CERTIFICATE REVOCATION LISTS (인증서 해지 목록)
CRL(인증서 해지 목록)은 CA에서 발행하며 발행 CA가 만료 날짜 이전에 해지한 모든 CA 및 인증서를 포함합니다. 취소하면 더 이상 신뢰할 수 없는 인증서가 무효화됩니다.

### 참고 자료
#### Oracle 공식 문서
- [https://docs.oracle.com/en-us/iaas/Content/certificates/home.htm](https://docs.oracle.com/en-us/iaas/Content/certificates/home.htm){:target="_blank" rel="noopener"}
- [https://www.oracle.com/security/cloud-security/ssl-tls-certificates/](https://www.oracle.com/security/cloud-security/ssl-tls-certificates/){:target="_blank" rel="noopener"}
- [https://www.oracle.com/security/cloud-security/ssl-tls-certificates/faq/](https://www.oracle.com/security/cloud-security/ssl-tls-certificates/faq/){:target="_blank" rel="noopener"}

#### 인증서 서비스관련 포스팅
- [Let’s Encrypt로 생성한 인증서를 OCI 인증서 서비스에 Import 하기](/cloudnative/oci-certificate-import-letsencrypt-cert/){:target="_blank" rel="noopener"}
- OCI 인증서를 Load Balancer에 적용하기
- OCI 인증서를 API Gateway에 적용하기
- OCI 인증서 서비스의 인증기관 생성 및 Load Balancer 적용하기
