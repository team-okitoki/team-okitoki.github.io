---
layout: page-fullwidth
#
# Content
#
subheadline: "Multi Cloud"
title: "Oracle Database Service for Azure 를 통해 Oracle Autonomous Database 생성 및 관리하기"
teaser: "ODSA 서비스를 통해 Oracle Autonomous Database를 생성 및 관리하는 방법에 대해 알아봅니다"
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
서비스 소개 및 ODSA 연결에 대한 정보는 아래 포스팅에서 참고해주세요
> [Oracle Database Service for Azure 소개](/dataplatform/oracle-database-service-for-azure/)

### ODSA를 통해 Oracle ADB 생성을 위한 사전 준비사항
#### Microsoft Azure 준비사항
- 관련 리소스가 생성될 Resource Group 을 사전에 생성해야 합니다.

#### Oracle Cloud Infrastructure 준비사항
- 별도 준비 사항 없음

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

### ODSA 콘솔 확인 및 Autonomous Database 생성하기
1. ODSA 콘솔에서 Autonomous Database 버튼을 클릭합니다.
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-1.png)
2. Autonomous Database 생성화면에서 Azure 구독과 리소스 그룹을 선택하고 인스턴스 이름, 리전을 선택합니다.
   - Subscription, Resource Group, Name : 각자 계정 상황에 맞게 선택 및 입력합니다. 
     - <mark>여기서 선택한 Resource Group으로 자동으로 OCI 구획이 생성됩니다.</mark>
     - <mark>입력한 Name으로 OCI ADB 인스턴스 이름이 지정됩니다.</mark>
   - Region : **Korea Central** 을 선택합니다.
   - **"Next: Configuration"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-2.png)
3. 다음과 같이 선택 및 입력합니다.
   - Workload Type : **Data Warehouse**
   - OCPU Count : **1**
   - OCPU Auto Scaling : **Check**
   - Storage(TB) : **1**
   - License Type : **License included**
   - Database Version : **19C**
   - Database Name : **DEMODB**
   - **"Next: Networking"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-3.png)
4. 다음과 같이 선택 및 입력합니다.
   - Access Type : **Secure Access from everywhere**
     - 특정 IP 또는 IP 대역에서만 접속하게 하려면 **Secure Access from allowed IP Address**를 선택하여 허용할 IP 또는 대역을 입력합니다.
   - **"Next: Security"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-4.png)
5. 다음화면에서 관리자 비밀번호를 설정합니다. (대문자+소문자+숫자+특수문자 조합필요)
   - **"Review+Create"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-5.png)
6. 설정 정보를 확인하고 "Create" 버튼을 클릭합니다.
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-6.png)
7. 다음 화면에서 프로비전 상태를 확인합니다. (ODSA 콘솔)
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-7.png)
8. ODSA에서 프로비전하면 OCI에 자동으로 구획이 생성됩니다.
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-8.png)
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-9.png)
9. 자동으로 생성된 구획 Autonomous Database 리소스를 확인해보면 정상적으로 생성되었음을 확인할 수 있습니다.
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-10.png)
   ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-11.png)
10. ODSA 콘솔에서도 Active 상태를 확인할 수 있습니다.
    ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-12.png)
11. "Database Actions" 버튼을 클릭하여 ADW 서비스에 접속할 수 있습니다. (비밀번호는 설정한 관리자 비밀번호 활용)
    ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-13.png)
12. Oracle Database Actions 서비스 콘솔 접속 확인
    ![ODSA Link account #6](/assets/img/dataplatform/2022/oracle-odsa-service-console-14.png)

### Azure 에서 Autonomous Database 리소스 모니터링하기
1. ODSA 콘솔에서 Metric 버튼을 클릭합니다.
   ![ODSA DBCS Metrics #1](/assets/img/dataplatform/2022/oracle-odsa-adb-metrics-1.png)
2. Azure 포탈의 Application Insight 화면으로 이동 후 좌측 하단 Metrics 메뉴를 클릭합니다.
   ![ODSA DBCS Metrics #1](/assets/img/dataplatform/2022/oracle-odsa-adb-metrics-2.png)
3. 이동된 화면에서 Metric Namespace를 클릭 후 자동으로 생성된 **oracle_oci_database**를 선택합니다.
   ![ODSA DBCS Metrics #2](/assets/img/dataplatform/2022/oracle-odsa-adb-metrics-3.png)
4. 원하는 지표를 선택하여 모니터링을 수행합니다.
   ![ODSA DBCS Metrics #3](/assets/img/dataplatform/2022/oracle-odsa-adb-metrics-5.png)
   ![ODSA DBCS Metrics #3](/assets/img/dataplatform/2022/oracle-odsa-adb-metrics-4.png)

### ODSA 콘솔에서 Autonomous Database 관리하기
#### 네트워크 설정 변경하기
ODSA콘솔에서 ADB의 네트워크 설정을 변경하기 위해서 좌측 **Networking** 메뉴 클릭 후 **Edit** 버튼을 클릭하여 설정을 변경할 수 있습니다.
![ODSA DBCS Metrics #3](/assets/img/dataplatform/2022/oracle-odsa-adb-network-1.png)

#### 스케일 변경하기
ODSA콘솔의 ADB오버뷰 화면에서 Scale버튼을 클릭하여 ADB의 CPU 및 스토리지 사양을 변경할 수 있습니다.
![ODSA DBCS Metrics #3](/assets/img/dataplatform/2022/oracle-odsa-adb-scale-1.png)

#### 백업본 생성 하기
1. 백업본 생성을 위해 좌측 메뉴에서 **Backups** 메뉴를 클릭 후 **Create** 버튼을 클릭하여 백업 이름을 입력하여 백업을 생성합니다.
   ![ODSA ADB Backup #1](/assets/img/dataplatform/2022/oracle-odsa-adb-backup-1.png)

#### 백업본에서 Database 복원하기
1. 생성되어있는 백업본 리스트에서 복원할 백업을 선택하여 **Restore** 버튼을 클릭합니다.
   ![ODSA ADB Backup #1](/assets/img/dataplatform/2022/oracle-odsa-adb-backup-2.png)
2. 복원할 데이터베이스 백업본을 확인 후 **Yes** 버튼을 클릭합니다.
   ![ODSA ADB Backup #1](/assets/img/dataplatform/2022/oracle-odsa-adb-backup-3.png)
3. 데이터베이스 복원 작업이 실행됩니다.
   ![ODSA ADB Backup #1](/assets/img/dataplatform/2022/oracle-odsa-adb-backup-4.png)

#### 리소스 재시작 및 중지하기
ODSA 콘솔에서 Stop 또는 Restart 버튼을 클릭하여 서비스 중지/재시작 작업을 수행할 수 있습니다.
![ODSA ADB Backup #1](/assets/img/dataplatform/2022/oracle-odsa-adb-control.png)
