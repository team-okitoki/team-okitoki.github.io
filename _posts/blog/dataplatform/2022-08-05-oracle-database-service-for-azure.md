---
layout: page-fullwidth
#
# Content
#
subheadline: "Multi Cloud"
title: "Oracle Database Service for Azure 소개"
teaser: "Microsoft Azure 에서 Oracle Database를 쉽게 활용할 수 있도록 구성된 Oracle Database Service for Azure에 대해 알아봅니다."
author: yhcho
breadcrumb: true
categories:
  - dataplatform
tags:
  - [oci, odsa, azure, interconnect, database]
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

### 서비스 소개
Oracle Database Service for Microsoft Azure( 이하 'ODSA' )를 사용하면 Oracle Cloud Infrastructure 의 데이터베이스 서비스를 Azure 클라우드 환경 에 쉽게 통합할 수 있습니다. 
ODSA 는 서비스 기반 접근 방식을 사용하여 기존의 복잡한 클라우드간 수동 배포를 통해 리소스를 생성하는 작업을 대체할 수 있는 편리한 대안입니다.

#### 예상 Case 별 OCI 계정 생성 및 주의사항 예시

**Case 1. Azure만 사용하는 고객이 Oracle Database 사용하려고 한다면?**
- OCI 사용자 계정 생성이 필요합니다. (ODSA 콘솔에서 계정 연동 과정에서 생성 가능 / PAYG or Free trial)
- OCI 무료 계정 생성은 [OCI 무료 계정 생성 및 관리하기](/getting-started/free-oci-promotions/){:target="_blank" rel="noopener"} 에서 확인 가능합니다.

**Case 2. Azure만 사용하는 고객이 OCI UC 계약을 하는 경우에는?**
- 영업 담당자와 별도의 UC 계약을 체결 하고 테넌시 생성 후 ODSA 콘솔 접속하여 계정을 연동합니다.

**Case 3. Azure를 사용하는 고객 중 OCI 계정이 있는 경우에는?**
- OCI 계정은 <mark>IDCS</mark> 기반이 아닌 <mark>Identity Domain</mark> 적용되어 있는 계정만 연동 가능함. (만약 IDCS 기반인 경우 새로운 OCI 계정 생성이 필요합니다.)
  ![Diff IDCS vs Identity Domain #4](/assets/img/dataplatform/2022/oci-idcs-identity-domain-ui-diff.png)

#### 사용 가능한 Oracle 데이터베이스 시스템
Azure용 Oracle Database Service 는 다음 제품을 제공합니다.
- **Oracle Exadata Database** : 프로비저닝 후 언제든지 시스템에 데이터베이스 컴퓨팅 서버 및 스토리지 서버를 추가할 수 있는 유연한 Exadata 시스템을 프로비저닝할 수 있습니다.
- **Shared Exadata Infra 의 Autonomous Database** : Autonomous Database 는 탄력적으로 확장되고 빠른 쿼리 성능을 제공하며 데이터베이스 관리가 필요 없는 사용하기 쉽고 완전 자율적인 데이터베이스를 제공합니다.
- **기본 데이터베이스** : ODSA 를 사용하여 가상 머신 DB 시스템에 Oracle Enterprise Edition 또는 Oracle Standard Edition 데이터베이스를 배포할 수 있습니다.<br> 
(<mark>※ RAC 를 이용하여 2 node 데이터베이스를 구성하는 경우, Enterise Edition Extreme Performance 버전만 지원</mark>)

#### Azure용 Database Service(ODSA)와 OCI-Azure Interconnect의 차이점?

| 항목 | Oracle Database Service for Azure (ODSA) | OCI-Azure interconnect    |
|-----|--|----|
| **기본 용도** | Azure 리소스를 OCI의 Oracle Databases에 연결하려는 Azure 고객 | 맞춤형 양방향 시나리오. 모든 OCI 및 Azure 리소스에서 사용할 수 있습니다. |
| **서비스 요약** | 안내식으로 계정 연결, 사용자 자격을 자동화 및 간소화하고 Azure에 대한 포털을 제공하여 Azure 사용자에게 친숙한 UX 경험으로 OCI 데이터베이스 서비스를 관리할 수 있습니다. | Oracle FastConnect 및 Azure ExpressRoute에 구축된 OCI와 Azure 간의 직접 연결을 통해 Azure 및 OCI 간 통합 ID 및 액세스 관리를 활용하여 11개 지역에서 낮은 대기 시간, 높은 처리량 및 이중 연결을 생성합니다. |
| **지원** | 협업 지원 모델(상호 연결과 동일) | 협업 지원 모델 |
| **네트워크 비용** | 상호 연결 포트 요금이 부과되지 않습니다. OCI 데이터 수신/송신 요금 없음 | 상호 접속 포트(FastConnect 및 ExpressRoute) 데이터 수신/송신 비용 없음  |
| **네트워크 확장** | 완전 관리형 | 고객 관리형 |
| **모니터링** | Azure App Insights 및 Azure Log Analytics에서 소비되는 통합 측정 지표 및 이벤트 | 고객 관리형 |
| **가격 책정** | <mark>Azure용 Oracle Database Service에는 비용이 들지 않습니다. 사용된 Azure 및 OCI 서비스에 대해서만 비용을 지불합니다.</mark> | 상호 연결 포트(FastConnect 및 ExpressRoute) 및 Azure 및 OCI 서비스 사용 |

### ODSA를 사용하기 위한 전제조건
ODSA를 이용하려면 먼저 Microsoft Azure 와 Oracle Cloud Infrastructure의 계정이 필요합니다.

#### Microsoft Azure 준비사항
- Microsoft Azure 계정
- OCI 에 연결하려는 Azure 구독의 관리 권한 및 소유권이 있는 Azure 사용자 계정
- OCI 에 연결하여는 Azure 계정에 Global Administrator(전역 관리자) 역할이 부여되어 있어야 함
- ODSA 관련 리소스가 생성될 Resource Group
- OCI이 VCN과 연결될 Azure Virtual Network 

#### Oracle Cloud Infrastructure 준비사항
- Oracle OCI 계정 (계정이 없는 경우 진행과정에서 신규로 생성이 가능합니다)
- **OCI 계정의 Home Region이 Microsoft Azure와 Inter-connect된 계정**
- **Identity Domain이 적용된 OCI Account**
- Cloud 관리 권한 및 연결해야 하는 도메인에 관리 권한을 가지고 있는 OCI 사용자 계정

#### 사용가능한 OCI 및 Azure 데이터센터 지역
ODSA 서비스는 OCI 와 Azure의 데이터센터가 Interconnect 되어있는 지역에서 지원하고 있습니다.
한국에서는 현재 OCI South Korea Central(서울) 과 Azure Seoul 에서 ODSA를 사용하실 수 있습니다.<br>
아래 내용은 [OCI 공식문서 페이지](https://docs.oracle.com/en-us/iaas/Content/multicloud/regions.htm){:target="_blank" rel="noopener"}에서도 확인할 수 있습니다.

<section class="section">
    <h4 class="title sectiontitle vl-no-in-page-toc">Asia Pacific (APAC)</h4>
    <div class="uk-overflow-auto">
        <table class="table vl-table-bordered vl-table-divider-col" summary="This table lists all pairs of Oracle and Azure regional locations in the Asia
                    Pacific (APAC) market that share a cross cloud connection.">
            <caption><span class="title"></span></caption>
            <colgroup>
                <col>
                <col>
            </colgroup>
            <thead class="thead">
                <tr class="row">
                    <th class="entry" id="regional_availability__entry__1"><span class="ph">OCI</span> location</th>
                    <th class="entry" id="regional_availability__entry__2">Azure location</th>
                </tr>
            </thead>
            <tbody class="tbody">
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__1"><span class="ph">OCI</span>
                        <span class="ph">Japan East (Tokyo)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__2">Azure Tokyo</td>
                </tr>
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__1"><span class="ph">OCI</span>
                        <span class="ph">Singapore (Singapore)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__2">Azure Singapore</td>
                </tr>
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__1"><span class="ph">OCI</span>
                        <span class="ph">South Korea Central (Seoul)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__2">Azure Seoul</td>
                </tr>
            </tbody>
        </table>
    </div>
</section>

<section class="section">
    <h4 class="title sectiontitle vl-no-in-page-toc">Europe, Middle East, Africa (EMEA)</h4>
    <div class="uk-overflow-auto">
        <table class="table vl-table-bordered vl-table-divider-col" summary="This table lists all pairs of Oracle and Azure regional locations in the
                    Europe, Middle East, Africa (EMEA) market that share a cross cloud
                    connection.">
            <caption><span class="title"></span></caption>
            <colgroup>
                <col>
                <col>
            </colgroup>
            <thead class="thead">
                <tr class="row">
                    <th class="entry" id="regional_availability__entry__9"><span class="ph">OCI</span> location</th>
                    <th class="entry" id="regional_availability__entry__10">Azure location</th>
                </tr>
            </thead>
            <tbody class="tbody">
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__9"><span class="ph">OCI</span>
                        <span class="ph">Germany Central (Frankfurt)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__10">Azure Frankfurt and Frankfurt2</td>
                </tr>
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__9"><span class="ph">OCI</span>
                        <span class="ph">Netherlands Northwest (Amsterdam)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__10">Azure Amersterdam2</td>
                </tr>
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__9"><span class="ph">OCI</span>
                        <span class="ph">UK South (London)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__10">Azure London</td>
                </tr>
            </tbody>
        </table>
    </div>
</section>
<section class="section">
    <h4 class="title sectiontitle vl-no-in-page-toc">Latin America (LATAM)</h4>
    <div class="uk-overflow-auto">
        <table class="table vl-table-bordered vl-table-divider-col" summary="This table lists all pairs of Oracle and Azure regional locations in the Latin
                        America (LATAM) market that share a cross cloud connection.">
            <caption><span class="title"></span></caption>
            <colgroup>
                <col>
                <col>
            </colgroup>
            <thead class="thead">
                <tr class="row">
                    <th class="entry" id="regional_availability__entry__17"><span class="ph">OCI</span> location</th>
                    <th class="entry" id="regional_availability__entry__18">Azure location</th>
                </tr>
            </thead>
            <tbody class="tbody">
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__17"><span class="ph">OCI</span>
                        <span class="ph">Brazil Southeast (Vinhedo)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__18">Azure Campinas</td>
                </tr>
            </tbody>
        </table>
    </div>
</section>

<section class="section">
    <h4 class="title sectiontitle vl-no-in-page-toc">North America (NA)</h4>
    <div class="uk-overflow-auto">
        <table class="table vl-table-bordered vl-table-divider-col" summary="This table lists all pairs of Oracle and Azure regional locations in the North
                            America (NA) market that share a cross cloud connection.">
            <caption><span class="title"></span></caption>
            <colgroup>
                <col>
                <col>
            </colgroup>
            <thead class="thead">
                <tr class="row">
                    <th class="entry" id="regional_availability__entry__21"><span class="ph">OCI</span> location</th>
                    <th class="entry" id="regional_availability__entry__22">Azure location</th>
                </tr>
            </thead>
            <tbody class="tbody">
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__21"><span class="ph">OCI</span>
                        <span class="ph">Canada Southeast (Toronto)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__22">Azure Canada Central</td>
                </tr>
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__21"><span class="ph">OCI</span>
                        <span class="ph">US East (Ashburn)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__22">Azure Washington DC and Washington DC2
                    </td>
                </tr>
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__21"><span class="ph">OCI</span>
                        <span class="ph">US West (Phoenix)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__22">Azure Phoenix</td>
                </tr>
                <tr class="row">
                    <td class="entry" headers="regional_availability__entry__21"><span class="ph">OCI</span>
                        <span class="ph">US West (San Jose)</span>
                    </td>
                    <td class="entry" headers="regional_availability__entry__22">Azure Silicon Valley</td>
                </tr>
            </tbody>
        </table>
    </div>
</section>

### Azure 도메인 사용자 생성 및 권한 부여하기
1. Azure Active Directory 메뉴 이동 후 "User(사용자)" 메뉴를 클릭합니다.
   ![Create User #1](/assets/img/dataplatform/2022/azure-ad-create-user-1.png)
2. 이동된 화면에서 "New User" -> "Create New User" 버튼을 차례로 클릭합니다.
   ![Create User #2](/assets/img/dataplatform/2022/azure-ad-create-user-2.png)
3. 사용자 생성화면에서 정보를 입력후 사용자를 생성합니다.
   ![Create User #3](/assets/img/dataplatform/2022/azure-ad-create-user-3.png)
4. 생성된 사용자의 세부사항을 확인하기 위해 사용자를 클릭합니다.
   ![Create User #4](/assets/img/dataplatform/2022/azure-ad-create-user-4.png)
5. Assigned Roles를 클릭하여 권한을 새로운 권한을 부여하기 위해 "Add assignments" 버튼을 클릭합니다.
   ![Create User #5](/assets/img/dataplatform/2022/azure-ad-create-user-5.png)
6. 우측 화면에서 "global(전역)" 을 입력하여 "global administrator(전역 관리자)" 권한을 선택 및 추가 합니다.
   ![Create User #6](/assets/img/dataplatform/2022/azure-ad-create-user-6.png)
7. Azure 구독 (Subscription) 화면으로 이동하여 ODSA를 설정할 구독의 세부화면으로 이동합니다.
8. 이동한 화면에서 "Access Control(IAM)" -> "Add" -> "Add co-administrator" 버튼을 차례로 클릭하여 해당 구독의 공동 관리자를 등록합니다.
   ![Create User #7](/assets/img/dataplatform/2022/azure-ad-create-user-7.png)
9. 우측 화면에서 새로 생성한 계정을 선택 후 추가하여 공동 관리자 등록을 완료합니다.
   ![Create User #8](/assets/img/dataplatform/2022/azure-ad-create-user-8.png)

### ODSA 연결을 위한 포탈 접속 및 로그인
ODSA 서비스를 사용하기 위해 [https://signup.multicloud.oracle.com/azure](https://signup.multicloud.oracle.com/azure){:target="_blank" rel="noopener"} 링크를 클릭하여 접속 합니다.
로그인시 사용할 ID는 전 단계에서 생성한 Azure 자체 도메인 사용자 계정 및 비밀번호를 입력합니다.
1. Azure Portal에서 사용자 정보를 복사합니다.
   ![Signin to ODSA Console #1](/assets/img/dataplatform/2022/oracle-odsa-signin-1.png)
2. 로그인 화면에서 복사한 정보를 붙여넣기 합니다.
   ![Signin to ODSA Console #2](/assets/img/dataplatform/2022/oracle-odsa-signin-2.png)
3. 암호를 입력합니다
   ![Signin to ODSA Console #3](/assets/img/dataplatform/2022/oracle-odsa-signin-3.png)
4. ODSA 설정을 위한 콘솔에 로그인 되었습니다.
   ![Signin to ODSA Console #4](/assets/img/dataplatform/2022/oracle-odsa-signin-4.png)

### ODSA 에서 Azure 계정과 OCI 계정 연동하기
1. ODSA 콘솔에서 "Start fully automated configuration" 버튼을 클릭합니다.
   ![ODSA Link account #1](/assets/img/dataplatform/2022/oracle-odsa-link-account-0.png)
2. Azure의 Subscription(구독)을 선택하는 화면에서 연동할 구독을 선택하고 "Continue(계속)" 버튼을 클릭합니다.
   ![ODSA Link account #2](/assets/img/dataplatform/2022/oracle-odsa-link-account-1.png)
3. 연동할 OCI 계정의 테넌시 정보를 입력합니다.(Identity Domain이 적용된 테넌시만 연동 가능)
   ![ODSA Link account #3](/assets/img/dataplatform/2022/oracle-odsa-link-account-2.png)
4. 이동된 화면에서 해당 테넌시의 관리자 계정으로 로그인합니다.
   ![ODSA Link account #4](/assets/img/dataplatform/2022/oracle-odsa-link-account-3.png)
5. 연동할 리전을 선택합니다. (한국의 경우 Seoul 리전이 Azure와 인터커넥트로 연결되어 있기 때문에 서울을 선택합니다.)
   ![ODSA Link account #5](/assets/img/dataplatform/2022/oracle-odsa-link-account-5.png)
6. 선택 후 문제가 없다면 약 5분정도 기다린 후에 설정이 완료됩니다.
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-link-account-6.png)

### ODSA 콘솔 접속하기
ODSA 서비스를 사용하기 위해 [https://console.multicloud.oracle.com/azure](https://console.multicloud.oracle.com/azure){:target="_blank" rel="noopener"} 링크를 클릭하여 콘솔에 접속 합니다.
로그인시 사용할 ID는 전 단계에서 생성한 Azure 자체 도메인 사용자 계정 및 비밀번호를 입력합니다.
1. Azure Portal에서 사용자 정보를 복사합니다.
   ![Signin to ODSA Console #1](/assets/img/dataplatform/2022/oracle-odsa-signin-1.png)
2. 로그인 화면에서 복사한 정보를 붙여넣기 합니다.
   ![Signin to ODSA Console #2](/assets/img/dataplatform/2022/oracle-odsa-signin-2.png)
3. 암호를 입력합니다
   ![Signin to ODSA Console #3](/assets/img/dataplatform/2022/oracle-odsa-signin-3.png)
4. ODSA 콘솔에 접속되었습니다.
   ![Signin to ODSA Console #3](/assets/img/dataplatform/2022/oracle-odsa-signin-5.png)
