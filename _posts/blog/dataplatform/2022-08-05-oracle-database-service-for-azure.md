---
layout: page-fullwidth
#
# Content
#
subheadline: "DataPlatform"
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

### 서비스 소개
Oracle Database Service for Microsoft Azure( 이하 'ODSA' )를 사용하면 Oracle Cloud Infrastructure 의 데이터베이스 서비스를 Azure 클라우드 환경 에 쉽게 통합할 수 있습니다. 
ODSA 는 서비스 기반 접근 방식을 사용하여 기존의 복잡한 클라우드간 수동 배포를 통해 리소스를 생성하는 작업을 대체할 수 있는 편리한 대안입니다.

Case 1. Azure만 사용하는 고객이 Oracle Database 사용?
   - OCI 사용자 계정 생성 (ODSA 콘솔에서 계정 연동 과정에서 생성 가능 / PAYG or Free trial) 계정 생성링크
Case 2. Azure만 사용하는 고객이 OCI UC 계약을 하는 경우?
   - UC계약 하고 테넌시 생성 후 ODSA 콘솔 접속하여 계정 연동
Case 3. Azure를 사용하는 고객 중 OCI 계정이 있는 경우?
   - OCI 계정이 IDCS 기반이 아닌 Identity Domain 적용되어 있는 계정만 연동 가능함. (만약 IDCS 기반인 경우 새로운 OCI 계정 생성 필요)

#### 사용 가능한 Oracle 데이터베이스 시스템
Azure용 Oracle Database Service 는 다음 제품을 제공합니다.

- **Oracle Exadata Database** : 프로비저닝 후 언제든지 시스템에 데이터베이스 컴퓨팅 서버 및 스토리지 서버를 추가할 수 있는 유연한 Exadata 시스템을 프로비저닝할 수 있습니다.
- **Shared Exadata Infra 의 Autonomous Database** : Autonomous Database 는 탄력적으로 확장되고 빠른 쿼리 성능을 제공하며 데이터베이스 관리가 필요 없는 사용하기 쉽고 완전 자율적인 데이터베이스를 제공합니다.
- **기본 데이터베이스** : ODSA 를 사용하여 가상 머신 DB 시스템에 Oracle Enterprise Edition 또는 Oracle Standard Edition 2 데이터베이스를 배포할 수 있습니다. 단일 노드 시스템 또는 2노드 RAC 시스템을 배포할 수 있습니다.

### 사전 요구 사항
ODSA를 이용하려면 먼저 Microsoft Azure 계정이 필요합니다. 계정 생성 후 Azure Active Directory 에서 자체 도메인 사용자를 생성하고, 해당 사용자에게 권한을 부여하여 ODSA 서비스를 사용할 수 있습니다.
- Microsoft Azure 계정
- Oracle OCI 계정 (계정이 없는 경우 진행과정에서 신규로 생성이 가능합니다)
git
#### Azure 도메인 사용자 생성 및 권한 부여
1. Azure Active Directory 메뉴 이동 후 "User(사용자)" 메뉴를 클릭합니다.
   ![Create User #1](/assets/img/dataplatform/azure-ad-create-user-1.png)
2. 이동된 화면에서 "New User" -> "Create New User" 버튼을 차례로 클릭합니다.
   ![Create User #2](/assets/img/dataplatform/azure-ad-create-user-2.png)
3. 사용자 생성화면에서 정보를 입력후 사용자를 생성합니다.
   ![Create User #3](/assets/img/dataplatform/azure-ad-create-user-3.png)
4. 생성된 사용자의 세부사항을 확인하기 위해 사용자를 클릭합니다.
   ![Create User #4](/assets/img/dataplatform/azure-ad-create-user-4.png)
5. Assigned Roles를 클릭하여 권한을 새로운 권한을 부여하기 위해 "Add assignments" 버튼을 클릭합니다.
   ![Create User #5](/assets/img/dataplatform/azure-ad-create-user-5.png)
6. 우측 화면에서 "global(전역)" 을 입력하여 "global administrator(전역 관리자)" 권한을 선택 및 추가 합니다.
   ![Create User #6](/assets/img/dataplatform/azure-ad-create-user-6.png)
7. Azure 구독 (Subscription) 화면으로 이동하여 ODSA를 설정할 구독의 세부화면으로 이동합니다.
8. 이동한 화면에서 "Access Control(IAM)" -> "Add" -> "Add co-administrator" 버튼을 차례로 클릭하여 해당 구독의 공동 관리자를 등록합니다.
   ![Create User #7](/assets/img/dataplatform/azure-ad-create-user-7.png)
9. 우측 화면에서 새로 생성한 계정을 선택 후 추가하여 공동 관리자 등록을 완료합니다.
   ![Create User #8](/assets/img/dataplatform/azure-ad-create-user-8.png)

### ODSA 포탈 접속 및 로그인
ODSA 서비스를 사용하기 위해 [https://signup.multicloud.oracle.com/azure](https://signup.multicloud.oracle.com/azure) 링크를 클릭하여 접속 합니다.
로그인시 사용할 ID는 전 단계에서 생성한 Azure 자체 도메인 사용자 계정 및 비밀번호를 입력합니다.
1. Azure Portal에서 사용자 정보를 복사합니다.
   ![Signin to ODSA Console #1](/assets/img/dataplatform/oracle-odsa-signin-1.png)
2. 로그인 화면에서 복사한 정보를 붙여넣기 합니다.
   ![Signin to ODSA Console #2](/assets/img/dataplatform/oracle-odsa-signin-2.png)
3. 암호를 입력합니다
   ![Signin to ODSA Console #3](/assets/img/dataplatform/oracle-odsa-signin-3.png)
4. ODSA 콘솔에 로그인 되었습니다.
   ![Signin to ODSA Console #4](/assets/img/dataplatform/oracle-odsa-signin-4.png)

### ODSA 에서 Azure 계정과 OCI 계정 연동하기
1. ODSA 콘솔에서 "Start fully automated configuration" 버튼을 클릭합니다.
   ![ODSA Link account #1](/assets/img/dataplatform/oracle-odsa-link-account-0.png)
2. Azure의 Subscription(구독)을 선택하는 화면에서 연동할 구독을 선택하고 "Continue(계속)" 버튼을 클릭합니다.
   ![ODSA Link account #2](/assets/img/dataplatform/oracle-odsa-link-account-1.png)
3. 연동할 OCI 계정의 테넌시 정보를 입력합니다.(Identity Domain이 적용된 테넌시만 연동 가능)
   ![ODSA Link account #3](/assets/img/dataplatform/oracle-odsa-link-account-2.png)
4. 이동된 화면에서 해당 테넌시의 관리자 계정으로 로그인합니다.
   ![ODSA Link account #4](/assets/img/dataplatform/oracle-odsa-link-account-3.png)
5. 연동할 리전을 선택합니다. (한국의 경우 Seoul 리전이 Azure와 인터커넥트로 연결되어 있기 때문에 서울을 선택합니다.)
   ![ODSA Link account #5](/assets/img/dataplatform/oracle-odsa-link-account-5.png)
6. 선택 후 문제가 없다면 약 5분정도 기다린 후에 설정이 완료됩니다.
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-link-account-6.png)

### ODSA 콘솔 확인 및 Autonomous Database 생성하기
1. ODSA 콘솔에서 Autonomous Database 버튼을 클릭합니다.
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-1.png)
2. Autonomous Database 생성화면에서 Azure 구독과 리소스 그룹을 선택하고 인스턴스 이름, 리전을 선택합니다.
   - Subscription, Resource Group, Name : 각자 계정 상황에 맞게 선택 및 입력합니다.
   - Region : **Korea Central** 을 선택합니다.
   - **"Next: Configuration"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-2.png)
3. 다음과 같이 선택 및 입력합니다.
   - Workload Type : **Data Warehouse**
   - OCPU Count : **1**
   - OCPU Auto Scaling : **Check**
   - Storage(TB) : **1**
   - License Type : **License included**
   - Database Version : **19C**
   - Database Name : **DEMODB**
   - **"Next: Networking"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-3.png)
4. 다음과 같이 선택 및 입력합니다.
   - Access Type : **Secure Access from everywhere**
   - **"Next: Security"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-4.png)
5. 다음화면에서 관리자 비밀번호를 설정합니다. (대문자+소문자+숫자+특수문자 조합필요)
   - **"Review+Create"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-5.png)
6. 설정 정보를 확인하고 "Create" 버튼을 클릭합니다.
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-6.png)
7. 다음 화면에서 프로비전 상태를 확인합니다. (ODSA 콘솔)
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-7.png)
8. ODSA에서 프로비전하면 OCI에 자동으로 구획이 생성됩니다.
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-8.png)
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-9.png)
9. 자동으로 생성된 구획 Autonomous Database 리소스를 확인해보면 정상적으로 생성되었음을 확인할 수 있습니다.
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-10.png)
   ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-11.png)
10. ODSA 콘솔에서도 Active 상태를 확인할 수 있습니다.
    ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-12.png)
11. "Database Actions" 버튼을 클릭하여 ADW 서비스에 접속할 수 있습니다. (비밀번호는 설정한 관리자 비밀번호 활용)
    ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-13.png)
12. Oracle Database Actions 서비스 콘솔 접속 확인
    ![ODSA Link account #6](/assets/img/dataplatform/oracle-odsa-service-console-14.png)

### Azure에서 로그 및 모니터링 하기 (확인중)