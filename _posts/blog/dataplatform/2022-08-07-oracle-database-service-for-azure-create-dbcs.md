---
layout: page-fullwidth
#
# Content
#
subheadline: "Multi Cloud"
title: "Oracle Database Service for Azure 를 통해 Oracle Database Cloud Service(DBCS) 생성 및 관리하기"
teaser: "ODSA 서비스를 통해 Oracle Database Cloud Service(DBCS)를 생성 및 관리하는 방법에 대해 알아봅니다"
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

### ODSA를 통해 Oracle DBCS 생성을 위한 사전 준비사항
#### Microsoft Azure 준비사항
- 관련 리소스가 생성될 Resource Group 을 사전에 생성해야 합니다.
- OCI VCN과 연결될 Virtual Network 를 사전에 생성해야 합니다.

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

### ODSA 콘솔 확인 및 Oracle Database Cloud Service(DBCS) 생성하기
1. ODSA 콘솔에서 Base Database 버튼을 클릭합니다.
   ![ODSA DBCS Create #1](/assets/img/dataplatform/2022/odsa-dbcs-create-1.png)
2. Base Database 화면에서 **Create(생성)** 버튼을 클릭합니다.
   ![ODSA DBCS Create #2](/assets/img/dataplatform/2022/odsa-dbcs-create-2.png)
3. Autonomous Database 생성화면에서 Azure 구독과 리소스 그룹을 선택하고 인스턴스 이름, 리전을 선택합니다.
   - Subscription, Resource Group, Name : 각자 계정 상황에 맞게 선택 및 입력합니다.
      - <mark>여기서 선택한 Resource Group으로 자동으로 OCI 구획이 생성됩니다.</mark>
      - <mark>입력한 Name으로 OCI ADB 인스턴스 이름이 지정됩니다.</mark>
   - Region : **Korea Central** 을 선택합니다.
   - **"Next: Configuration"** 클릭
   ![ODSA DBCS Create #1](/assets/img/dataplatform/2022/odsa-dbcs-create-3.png)
4. 다음과 같이 선택 및 입력합니다.
   - VM Shape : **VM.Standard.E4.Flex**
   - OCPU Count per Node : **1**
   - **"OK"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/2022/odsa-dbcs-create-4.png)
5. 다음과 같이 선택 및 입력합니다.
   - Total Node Count : **1** <mark>OCI 무료체험 계정에서는 1개 이상 생성되지 않습니다.</mark>
   - Available data storage(GB) : **256** / 기본값
   - Software Edition : **Standard Edition**
   - License Type : **License included**
   - Database Version : **19.15.0.0** / 원하는 버전을 자유롭게 선택합니다.
   - Database Name : **DEMODB**
   - Pluggable Database Name : **PDB1**
   - **"Next: Networking"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/2022/odsa-dbcs-create-5.png)
   ![ODSA Link account #6](/assets/img/dataplatform/2022/odsa-dbcs-create-6.png)
6. 다음과 같이 선택 및 입력합니다.
   - Hostname Prefix : **DEMODB** / 일반적으로 Database 이름과 동일하게 입력합니다.
   - Virtual Networks : **사전에 생성한 Azure의 VN을 선택합니다.**
   - OCI CIDRs : Azure Virtual Networks와 겹치지 않은 대역으로 입력합니다. (16비트)
   - **"Next: Security"** 클릭
   ![ODSA Link account #6](/assets/img/dataplatform/2022/odsa-dbcs-create-7.png)
7. 다음 화면에서 인스턴스에 접속하기 위한 키파일 생성 및 관리자 비밀번호를 설정합니다. (대문자+소문자+숫자+특수문자 조합필요)
   ![ODSA Link account #6](/assets/img/dataplatform/2022/odsa-dbcs-create-8.png)
8. 다음 화면에서 백업은 선택 해제 합니다. (실제 구성시 필요한 경우 선택하여 백업을 설정합니다.)
   ![ODSA Link account #6](/assets/img/dataplatform/2022/odsa-dbcs-create-9.png)
9. 입력한 설정정보로 배포작업이 실행됩니다.
   ![ODSA Link account #6](/assets/img/dataplatform/2022/odsa-dbcs-create-10.png)
10. 배포 작업이 완료되면 아래와 같이 DBCS 정보를 확인할 수 있습니다.
   ![ODSA Link account #6](/assets/img/dataplatform/2022/odsa-dbcs-create-11.png)

### Azure 에서 DBCS 리소스 모니터링하기 
1. ODSA 콘솔에서 Metric 버튼을 클릭합니다.
   ![ODSA DBCS Metrics #1](/assets/img/dataplatform/2022/odsa-dbcs-metrics-0.png)
2. Azure 포탈의 Application Insight 화면으로 이동 후 좌측 하단 Metrics 메뉴를 클릭합니다. 
   ![ODSA DBCS Metrics #1](/assets/img/dataplatform/2022/odsa-dbcs-metrics-1.png)
3. 이동된 화면에서 Metric Namespace를 클릭 후 자동으로 생성된 **oracle_oci_database**를 선택합니다.
   ![ODSA DBCS Metrics #2](/assets/img/dataplatform/2022/odsa-dbcs-metrics-2.png)
4. 원하는 지표를 선택하여 모니터링을 수행합니다.
   ![ODSA DBCS Metrics #3](/assets/img/dataplatform/2022/odsa-dbcs-metrics-3.png)
