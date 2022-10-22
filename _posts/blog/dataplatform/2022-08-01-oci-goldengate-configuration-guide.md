---
layout: page-fullwidth
#
# Content
#
subheadline: "DataPlatform"
title: "OCI GoldenGate Capture/Replication Configuration 실습"
teaser: "OCI 의 GoldenGate 를 프로비저닝하고 Source Oracle DBCS 로부터 Traget Oracle DBCS 로 실시간 복제 구성을 실습합니다."
author: lim
breadcrumb: true
categories:
  - dataplatform
tags:
  - [oci, oracle, goldengate, dbcs, replication, cdc]
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
On-Premise 기반의 Oracle Database 간의 SOURCE DB 와 TARGET DB 간의 실시간 복제 솔루션으로 강력한 Oracle GoldenGate 라는 솔루션이 있습니다. OGG(Oracle GoldenGate)는 Source System의 Database Redo/Archive Log에 접근해, 변경 된 데이터만 추출하여 Target System Database에 데이터를 동기화 하는 CDC 솔루션을 말합니다.
OCI 에는 기존 On-Premise 기반의 Oracle GoldenGate (OGG) 솔루션이 OCI GoldenGate 라는 이름의 Managed 서비스가 추가가 되었습니다.
OCI GoldenGate 는 타 Cloud Vendor 에서는 제공하지 않는 OCI 에서만 제공하는 CDC 솔루션입니다.

![OCI GG Overview](/assets/img/dataplatform/2022/goldengate/00.oci-goldengate-overview.png)

이번 글에서는 OCI GoldenGate 서비스에 대한 DB 복제 구성을 실습해 보도록 합니다. 

<br>

### 사전 준비 사항
OCI GoldenGate 서비스를 구성하려면 먼저 아래와 같은 사항들이 준비되어야 합니다.
- DBCS 구성을 위한 Virtual Cloud Network (VCN) 구성 
- Source Oracle DB (OCI DBCS 혹은 ADB) - (Oracle DB 11.2.0.4 버전 이상, 19.0.0.0 버전만 제외) - DBCS 생성 시  [DBCS 생성 퀵스타트 가이드 참고](/dataplatform/oracle-database-cloud-service-quickstart/){:target="_blank" rel="noopener"} 
- Target Oracle DB (OCI DBCS 혹은 ADB) - (Oracle DB 11.2.0.4 버전 이상, 19.0.0.0 버전만 제외)
- SQL Developer 실행을 위한 Windows Instance (선택 사항)

![DBCS Preparation](/assets/img/dataplatform/2022/goldengate/01.oci-goldengate-dbcs-preparation.png)

상기 그림과 같이 OCI GoldenGate 구성을 위해 SOURCE 와 TARGET DBCS 를 미리 구성해 놓았고 SOURCE DBCS 에서 TARGET DBCS 로의 복제 구성을 실습하게 됩니다.
DBCS 를 일반적으로 Private Subnet 안에 구성되기 때문에 Public Subnet 을 통해 DB 접근이 가능하도록 SQL Developer 실행을 위한 Windows 서버를 추가로 구성합니다.

![Windows Preparation](/assets/img/dataplatform/2022/goldengate/02.oci-goldengate-windows-preparation.png)

<br>

### STEP 1 : 윈도우 서버 준비 - SQL Developer 연결

DB 서버 접속을 위해 상기 Provisioning 한 윈도우 서버에 원격 데스크탑 을 통해 접속합니다.

![Windows Preparation](/assets/img/dataplatform/2022/goldengate/03.oci-goldengate-windows-preparation-2.png)

접속된 윈도우 서버에서 Oracle SQL Developer (https://www.oracle.com/database/sqldeveloper/technologies/download/) 를 다운로드 받아 설치합니다. 다운받은 zip 파일을 압축만 해제하면 됩니다. 압축해제된 파일 폴더에서 sqldeveloper.exe 를 실행합니다.

![SQL Developer](/assets/img/dataplatform/2022/goldengate/04.oci-goldengate-windows-sql-developer.png)

SQL Developer 를 실행하면 아래와 같은 화면이 나타나며 상단의 새로운 DB Connection 을 생성할 수 있는 버튼을 클릭합니다.

![SQL Developer](/assets/img/dataplatform/2022/goldengate/05.oci-goldengate-windows-sql-developer-2.png)

생성된 DB 의 Connection 정보는 DBCS 의 상세화면에서 DB Connection 정보를 획득할 수 있습니다. 아래 그림과 같이 DB Connection 정보를 복사합니다.

![SQL Developer](/assets/img/dataplatform/2022/dbcs/quickstart/19.oci-dbcs-db-connection-string.png)

![SQL Developer](/assets/img/dataplatform/2022/dbcs/quickstart/20.oci-dbcs-db-connection-string-copy.png)

```text
* DB Connection 정보  : srcggdb.sub07160235111.pslimvcn2021071.oraclevcn.com:1521/SRCGGDB_SRCGGDB.sub07160235111.pslimvcn2021071.oraclevcn.com

상기 Connection 정보에서 SQL Developer 의 Connection 에 입력할 항목들을 추출합니다.
1. 호스트 이름 : srcggdb.sub07160235111.pslimvcn2021071.oraclevcn.com
2. 포트 : 1521
3. 서비스 이름 : SRCGGDB_SRCGGDB.sub07160235111.pslimvcn2021071.oraclevcn.com
```


아래의 화면에 사용자 이름에 DB 생성 시 입력한 sys 사용자의 password 와 호스트 이름, 서비스 이름을 입력하고 테스트 및 저장 버튼을 클릭합니다. 여기서 반드시 사용자의 롤(Role)을 SYSDBA 로 선택해 줍니다.

![SQL Developer](/assets/img/dataplatform/2022/goldengate/06.oci-goldengate-sql-developer-connection-sys.png)

Target DB 에 대해서도 동일한 방식으로 sys 사용자에 대해 Connection 을 생성하여 저장해 둡니다.

![SQL Developer](/assets/img/dataplatform/2022/goldengate/07.oci-goldengate-sql-developer-connection-sys-2.png)

Connection 을 클릭하여 설정한 SOURCE DB 로 연결이 잘 되는지 확인합니다.

![SQL Developer](/assets/img/dataplatform/2022/goldengate/08.oci-goldengate-sql-developer-connect-sql.png)

<br>

### STEP 2 : SOURCE DB 준비

데이터의 원천 소스 DB에 대해 테이블 스키마 구성 및 테스트용 Seed data 를 입력하여 운영 중인 실시간 복제할 테이블과 데이터를 구성해 주는 단계입니다.

#### SOURCE DB에 SEED Data 생성
- 복제를 수행할 Source 데이터베이스를 구성합니다. 먼저, Source DB 의 CDB ROOT 사용자인 sys 사용자로 Connection 을 연결 후, SRC_OCIGGLL 이라는 사용자를 생성해 줍니다. (※ password 항목은 사용할 password 로 대체 필요)

  ```sql
  ALTER SESSION SET CONTAINER=PDB1;

  CREATE USER "SRC_OCIGGLL" IDENTIFIED BY "<password>";
  GRANT CREATE SESSION TO "SRC_OCIGGLL";
  ALTER USER "SRC_OCIGGLL" ACCOUNT UNLOCK;
  GRANT CONNECT, RESOURCE TO "SRC_OCIGGLL";
  GRANT CREATE ANY TABLE TO "SRC_OCIGGLL";
  GRANT ALL PRIVILEGES TO "SRC_OCIGGLL";
  GRANT UNLIMITED TABLESPACE TO "SRC_OCIGGLL";
  ```

  ![SEED User](/assets/img/dataplatform/2022/goldengate/09.oci-goldengate-sql-developer-seed-user.png)


- 생성한 SRC_OCIGGLL 사용자로 SQLDeveloper 접속을 생성합니다. (※ 생성한 SRC_OCIGGLL 사용자는 PDB 사용자로 반드시 아래의 서비스 이름에 PDB명을 입력해야 합니다. PDB명은 DB 생성 시 입력한 PDB명 입니다.)

  ![SEED User](/assets/img/dataplatform/2022/goldengate/10.oci-goldengate-sql-developer-seed-user-connect.png)


- 상기 생성한 SRC_OCIGGLL 사용자로 SQL Developer 에 접속 후 SQL 커맨드 창에서 아래의 SEED Data Load Script 를 수행합니다. SEED Data Load Script 는 [SOURCE-SEED-DATA.SQL](/assets/files/ocigg-sql/SOURCE-SEED-DATA.SQL) 를 다운받아 생성한 SRC_OCIGGLL 사용자의 Connection 을 이용해 접속 후 SQL 실행창에 복사하여 붙여놓고 SQL 문장들을 실행합니다. (※ 아래 내용은 해당 스크립트의 일부입니다.)


  ```sql
  GRANT UNLIMITED TABLESPACE TO SRC_OCIGGLL;
  --------------------------------------------------------
  --  File created - @dsgray 3-07-2021   
  --------------------------------------------------------
  --------------------------------------------------------
  --  DDL for Table SRC_CITY
  --------------------------------------------------------

  CREATE TABLE "SRC_OCIGGLL"."SRC_CITY" 
   (	"CITY_ID" NUMBER(10,0), 
	"CITY" VARCHAR2(50 BYTE), 
	"REGION_ID" NUMBER(10,0), 
	"POPULATION" NUMBER(10,0)
   ) 
   ;

   ..... 중략

  ```
  아래 화면은 상기 SEED-DATA.SQL 스크립트를 실행한 결과입니다. SRC_OCIGGLL 스키마에 샘플테이블인 SRC_CITY, SRC_CUSTOMER, SRC_PRODUCT, SRC_REGION 등의 테이블과 데이터가 입력이 되어 있는지 확인합니다.

    ![SEED User](/assets/img/dataplatform/2022/goldengate/11.oci-goldengate-sql-developer-seed-data-result.png)


<br>

### STEP 3 : TARGET DB 준비

실시간 복제를 수행할 TARGET DB 에 대해 SOURCE DB 와 동일한 내용의 데이터를 입력하여 구성해 주는 단계입니다. SOURCE DB 에 SEED DATA 를 생성해 주는 절차와 동일하게 SQL Developer 의 Connection 을 생성하고 SEED DATA SQL 을 실행해 줍니다.

#### TARGET DB에 SEED Data 생성
- 복제가 될 Target 데이터베이스를 구성합니다. 먼저, Target DB CDB ROOT 사용자인 sys 사용자로 Connection 을 연결 후, SRCMIRROR_OCIGGLL 이라는 사용자를 생성해 줍니다. (※ password 항목은 사용할 password 로 대체 필요)

  ```sql
  ALTER SESSION SET CONTAINER=PDB1;

  CREATE USER "SRCMIRROR_OCIGGLL" IDENTIFIED BY "<password>";
  GRANT CREATE SESSION TO "SRCMIRROR_OCIGGLL";
  ALTER USER "SRCMIRROR_OCIGGLL" ACCOUNT UNLOCK;
  GRANT CONNECT, RESOURCE TO "SRCMIRROR_OCIGGLL";
  GRANT CREATE ANY TABLE TO "SRCMIRROR_OCIGGLL";
  GRANT ALL PRIVILEGES TO "SRCMIRROR_OCIGGLL";
  GRANT UNLIMITED TABLESPACE TO "SRCMIRROR_OCIGGLL";
  ```

  ![SEED User](/assets/img/dataplatform/2022/goldengate/12.oci-goldengate-sql-developer-target-user.png)


- 생성한 Target DB 의 사용자인 SRCMIRROR_OCIGGLL 사용자로 아래 그림처럼 SQLDeveloper 접속을 생성합니다. 

  ![SEED User](/assets/img/dataplatform/2022/goldengate/13.oci-goldengate-sql-developer-target-user-connect.png)

- Target DB 에도 아래의 SEED Data Load Script 를 수행합니다. SEED Data Load Script 는 [TARGET-SEED-DATA.SQL](/assets/files/ocigg-sql/TARGET-SEED-DATA.SQL) 를 다운받아 생성한 SRCMIRROR_OCIGGLL 사용자의 Connection 을 이용해 접속 후 SQL 실행창에 복사하여 붙여놓고 SQL 문장들을 실행합니다. (※ 아래 내용은 해당 스크립트의 일부입니다.)


```sql

GRANT UNLIMITED TABLESPACE TO SRCMIRROR_OCIGGLL;
--------------------------------------------------------
--  File created - @dsgray 9-22-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table SRC_CITY
--------------------------------------------------------
CREATE TABLE "SRCMIRROR_OCIGGLL"."SRC_CITY" 
(	"CITY_ID" NUMBER(10,0), 
"CITY" VARCHAR2(50 BYTE), 
"REGION_ID" NUMBER(10,0), 
"POPULATION" NUMBER(10,0)
) SEGMENT CREATION IMMEDIATE 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
;
------------
..... 중략
  
```

  아래 화면은 상기 SEED-DATA.SQL 스크립트를 실행한 결과입니다. SRCMIRROR_OCIGGLL 스키마에 SOURCE DB의 샘플테이블인 SRC_CITY, SRC_CUSTOMER, SRC_PRODUCT, SRC_REGION 등의 테이블과 데이터가  동일하게 입력이 되어 있는지 확인합니다.
    ![SEED User](/assets/img/dataplatform/2022/goldengate/14.oci-goldengate-sql-developer-target-seed-data.png)

<br>

### STEP 4 : SOURCE DB 에 SUPPLEMENT LOGGING 설정

SOURCE DB 의 SUPPLEMENT LOGGING 추가를 위해 SQL Developer 를 통해 SOURCE DB 에 sys 계정으로 로그인 합니다.

- SOURCE DB 에 sys (sysdba) 계정으로 "ARCHIVELOG" 모드로 DB 가 실행되고 있는지 확인합니다. 아래 화면과 같이 LOG_MODE 는 "ARCHIVELOG" 모드로 설정되어 있어야 합니다.
    ```sql
    SELECT log_mode FROM v$database;
    ```
    ![ARCHIVELOG CHECK](/assets/img/dataplatform/2022/goldengate/15.oci-goldengate-sql-developer-archivelog-check.png)

    ※ 만일, LOG_MODE 가 "NOARCHIVELOG" 모드로 설정이 되어 있다면 아래와 같이 SOURCE DB 인스턴스로 ssh 로그인하여 아래 절차대로 실행해 줍니다. (※ 상기 화면과 같이 "ARCHIVELOG" 모드로 설정되어 있다면 아래 SCRIPT 는 수행하지 않습니다.)

    ```terminal
    $ sqlplus / as sysdba
    SQL> SELECT log_mode FROM v$database;

    LOG_MODE
    ------------
    NOARCHIVELOG

    SQL> SHUTDOWN IMMEDIATE;
    SQL> STARTUP MOUNT;
    SQL> ALTER DATABASE ARCHIVELOG;
    SQL> ALTER DATABASE OPEN;
    ```

- SOURCE DB 의 SUPPLEMENTAL LOGGING 시작

  SOURCE DB 의 DATA Capture 를 위해서는 중요한 설정 중 하나는 SUPPLEMENTAL LOG 를 ENABLE 하는 설정입니다. 이 설정이 ENABLE 되어야 SOURCE DB 의 변경 데이터가 Capture 됩니다. SQL Developer 로 sys 계정의 CDB$ROOT 로 접속하여 아래 SQL Script 를 실행합니다.

    ```sql
    
    ALTER SESSION SET CONTAINER=CDB$ROOT;
    ALTER SYSTEM SWITCH LOGFILE;
    ALTER SYSTEM SET enable_goldengate_replication=true;
    ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
    
    ALTER SYSTEM SET STREAMS_POOL_SIZE=5000M scope=both;

    ALTER SESSION SET CONTAINER=PDB1;
    ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
    
    ```
    
    ![SUPPLEMENTAL LOGGING](/assets/img/dataplatform/2022/goldengate/16.oci-goldengate-sql-developer-supplement-logging.png)

<br>

### STEP 5 : SOURCE 와 TARGET DB 에 OCI GoldeGate Admin 사용자 생성

SOURCE DB 와 TARGET DB 에 OCI GoldenGate 가 추출 및 복제를 수행하기 위한 Admin 사용자를 CDB (Container DB) 에 생성해 줍니다.


- SOURCE DB 에 OCI GoldenGate Admin (C##GGADMIN) 계정 생성

  SOURCE DB 에 OCI GoldenGate Admin (C##GGADMIN) 계정 생성을 위해  SQL Developer 로 sys 계정의 CDB$ROOT 로 접속하여 아래 SQL SCRIPT 를 실행합니다. (※ password 항목은 사용할 password 로 대체 필요)

    ```sql
    ALTER SESSION SET CONTAINER=CDB$ROOT;
    CREATE USER C##GGADMIN IDENTIFIED BY "<password>";
    EXEC dbms_goldengate_auth.grant_admin_privilege('C##GGADMIN',container=>'ALL');
    GRANT DBA TO C##GGADMIN container=all;

    ALTER SYSTEM SET enable_goldengate_replication=true;

    ALTER USER C##GGADMIN ACCOUNT UNLOCK ;
    ALTER PROFILE DEFAULT LIMIT PASSWORD_REUSE_TIME UNLIMITED;
    ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME  UNLIMITED;
    ALTER PROFILE DEFAULT LIMIT FAILED_LOGIN_ATTEMPTS UNLIMITED;
    ```

    ![GGADMIN USER CREATE](/assets/img/dataplatform/2022/goldengate/17.oci-goldengate-sql-developer-ggadmin-user-create.png)

- TARGET DB 에  SQL Developer 로 sys 계정으로 CDB$ROOT 에 접속하여 TARGET DB 에도 위의 절차와 동일하게 동일한 SQL SCRIPT 를 실행시켜 OCI GoldenGate Admin 사용자를 생성해 줍니다.
    ![TARGET GGADMIN](/assets/img/dataplatform/2022/goldengate/18.oci-goldengate-sql-developer-ggadmin-user-create-target.png)

<br>

### STEP 6 : OCI GoldeGate 서비스 Deployment

OCI GoldenGate 서비스를 사용하기 위해 서비스를 Deploy 해야 합니다. 

- 아래의 OCI 메인 메뉴에서 GoldenGate 를 찾아 선택합니다.

    ![GG NAVIGATION MENU](/assets/img/dataplatform/2022/goldengate/19.oci-goldengate-navigation-menu.png)

- GoldenGate 의 좌측 메뉴 중에서 두번째 Deployments 메뉴를 선택 후 Compartment 를 선택합니다. 우측의 목록 상단의 "Create Deployment" 버튼을 클릭합니다.

    ![GG DEPLOYMENT MENU](/assets/img/dataplatform/2022/goldengate/20.oci-goldengate-deployment-main.png)

- 아래 화면과 같이 OCI GoldenGate Deploy 를 위한 입력 사항들을 입력해 후 Next 버튼을 클릭합니다. (※ AutoScaling 체크 시, 초기 설정한 OCPU 의 3배까지 자동 스켈링 수행)
    > 중요 : OCI GoldenGate Web Console 을 접근하기 위해서는 반드시 Public Subnet 을 선택하여 Deploy 합니다. Public Subnet 에 Deploy 를 하지만 Private IP 기반으로만 통신합니다.

    ![DEPLOYMENT INPUT](/assets/img/dataplatform/2022/goldengate/21.oci-goldengate-deployment-input-public.png)

- 다음은 OCI GoldenGate instance 명과 관리자 화면에 로그인할 사용자 및 Password 를 입력 후 Create 버튼을 클릭합니다.

    ![DEPLOY INPUT](/assets/img/dataplatform/2022/goldengate/22.oci-goldengate-deployment-input-2-public.png)

- Deploy 가 시작되면 아래와 같이 노란색 상태의 Creating 메시지가 나옵니다. (Deploy 시간 : 약 15분 소요)

    ![CREATING](/assets/img/dataplatform/2022/goldengate/23.oci-goldengate-deployment-creating-public.png)

- Deploy 가 완료되면 아래와 같이 녹색 상태로 전환이 됩니다.

    ![CREATED](/assets/img/dataplatform/2022/goldengate/24.oci-goldengate-deployment-created-public.png)



- Deploy 가 완료되면 OCI GoldenGate Admin 콘솔에 로그인하여 DB 연결 구성 및 Capture, Replication 등의 프로세스를 구성해야 합니다. 
OCI GoldenGate Admin 콘솔은 Private IP 로만 통신하도록 구성되기 때문에 위에서 생성한 Windows 인스턴스 내에서 브라우저를 통해 접근이 가능합니다.

    > 중요 : Private IP/ Private Domain Name 으로만 접근하게 되므로 반드시 STEP 1 에서 생성한 Windows 인스턴스에서 브라우저를 통해 OCI GoldenGate Admin 콘솔 접근 해야만 합니다.

- Windows Instance 에서 브라우저를 실행 후 OCI 에 로그인 후 Deploy 된 OCI GoldenGate Deployment 화면에는 생성된 OCI GoldenGate 로 로그인 할 수 있는 URL 이 생성되어 있게 됩니다. 생성된 URL 을 통해 OCI GoldenGate Admin 콘솔 Web 화면으로 접근이 가능합니다. 아래 화면에서 Launch Console 버튼을 클릭하면 생성된 URL 로 바로 접근이 됩니다.

    ![Launch Console](/assets/img/dataplatform/2022/goldengate/25.oci-goldengate-remote-launch-console.png)

    <br>

    ![Launch Console](/assets/img/dataplatform/2022/goldengate/26.oci-goldengate-remote-launch-console-2.png)
   
- OCI GoldenGate 의 Admin Service 화면이 나타나면 Deploy 생성 시 입력했던 GoldenGate Admin 사용자 (ggadmin) ID 와 Password 를 입력 후 로그인이 가능한지 확인합니다.

    ![Admin Login](/assets/img/dataplatform/2022/goldengate/27.oci-goldengate-remote-admin-login.png)


- 로그인이 되면 아래와 같은 추출 및 프로세스를 구성할 수 있는 화면이 나오게 됩니다. 추후 프로세스 구성을 위해 Console 화면을 이용하게 됩니다.

    ![Admin Main](/assets/img/dataplatform/2022/goldengate/28.oci-goldengate-remote-admin-main.png)

<br>

### STEP 7 : Register Database (OCI Console)

OCI GoldenGate 에서 캡쳐/추출 및 복제를 할 대상 Database 들에 대해 Connection 정보를 등록하고 관리하는 절차입니다. OCI 콘솔 화면에서 Database 들을 등록하면 OCI GoldenGate Admin Console 에서도 등록된 Database 들이 나타나게 됩니다.

- Register Database 메뉴 실행 후 (GoldenGate -> Register Database) Register Database 버튼을 클릭합니다.

    ![NAVI Menu](/assets/img/dataplatform/2022/goldengate/19.oci-goldengate-navigation-menu.png)

    ![REG DB-1](/assets/img/dataplatform/2022/goldengate/29.oci-goldengate-register-database-menu.png)

- 등록 버튼을 클릭하면 DB 를 등록할 수 있는 화면이 우측에 나타나며 아래 그림들을 참고하여 SOURCE DB 와 TARGET DB 의 정보와 Connection 정보를 입력합니다.

  - SOURCE DB Register 입력 화면

    ![SREG-DB-2](/assets/img/dataplatform/2022/goldengate/30.oci-goldengate-register-database-input.png)

      > 주의 : SOURCE DB 의 Connection String 입력 시 반드시 CDB 의 서비스명으로 입력을 합니다. <br> 화면 입력 예) Database Connection string : srcggdb.sub07160235111.pslimvcn2021071.oraclevcn.com:1521/SRCGGDB_SRCGGDB.sub07160235111.pslimvcn2021071.oraclevcn.com

    ![SREG-DB-3](/assets/img/dataplatform/2022/goldengate/31.oci-goldengate-register-database-input-2.png)
  
    ![SREG-DB-3](/assets/img/dataplatform/2022/goldengate/32.oci-goldengate-register-database-input-3.png)

  - TARGET DB Register 입력 화면

    > 주의 : TARGET DB 의 Connection String 은 반드시 PDB 의 서비스명으로 입력을 합니다. 화면 입력 예) trgggdb.sub07160235111.pslimvcn2021071.oraclevcn.com:1521/PDB1.sub07160235111.pslimvcn2021071.oraclevcn.com


    ![TREG-DB-1](/assets/img/dataplatform/2022/goldengate/33.oci-goldengate-register-database-target-input-1.png)

    ![TREG-DB-2](/assets/img/dataplatform/2022/goldengate/34.oci-goldengate-register-database-target-input-2.png)

    

    ![TREG-DB-3](/assets/img/dataplatform/2022/goldengate/35.oci-goldengate-register-database-target-input-3.png)

- 등록 버튼을 클릭하면 아래와 같이 Database 에 대해 등록작업이 진행되며, 등록이 완료된 Database 는 상태 정보가 "Active" 상태로 전환됩니다. 등록한 두 Database 의 상태가 "Active" 상태가 될때까지 대기 후 다음 절차를 진행합니다.

    ![REG-DB List](/assets/img/dataplatform/2022/goldengate/36.oci-goldengate-register-database-reuslt.png)

<br>

### STEP 8 : SOURCE DB 에 TRANDATA 정보 등록 (OCI GoldenGate Admin Console)

OCI Console 에서 등록한 Database 들은 OCI GoldenGate 에서 조회가 가능하며, 등록된 Connection 정보를 활용하여 Capture 및 Replication 을 수행하게 됩니다. 프로세스 설정을 하기 위해서는 SOURCE DB 에 대한 TRANDATA 정보 생성이 필요합니다.

- OCI GoldenGate Admin Console 접속 후 Configuration 메뉴로 접근합니다.

  ![Admin Login](/assets/img/dataplatform/2022/goldengate/27.oci-goldengate-remote-admin-login.png)

  ![GG Console](/assets/img/dataplatform/2022/goldengate/38.oci-goldengate-console-config.png)

- Configuration 메뉴로 접근하면 OCI Console 에서 등록했던 Database 의 Credential 정보들이 나타납니다. Credential 정보들 중에서 SOURCE DB 의 Connection 정보에 대한 Action 메뉴 중에서 빨간색으로 표시된 버튼을 클릭합니다.

  ![Config Credetial](/assets/img/dataplatform/2022/goldengate/39.oci-goldengate-console-config-credentials.png)

- 다음과 같은 TRANDATA Information 창이 나타나며 그림의 빨간색으로 표시된 "+" 버튼을 클릭합니다.

  ![TRANDATA Info](/assets/img/dataplatform/2022/goldengate/40.oci-goldengate-trandata-information.png)


- "+" 버튼을 클릭했을때, 나타나는 아래의 입력창의 Schema Name 란에 PDB1.SRC_OCIGGLL 을 입력하고 Submit 버튼을 클릭합니다.

  ![TRANDATA SUBMIT](/assets/img/dataplatform/2022/goldengate/41.oci-goldengate-trandata-add-submit.png)

- 추가한 TRANDATA 가 제대로 생성되었는지 확인하기 위해 아래 빨간색으로 표시된 입력창에 PDB1.SRC_OCIGGLL 을 입력하고 창 옆에 빨간색으로 표시된 돋보기 버튼을 클릭하면 생성된 TRANDATA 정보가 하단에 디스플레이 됩니다.

  ![TRANDATA SEARCH](/assets/img/dataplatform/2022/goldengate/42.oci-goldengate-trandata-check.png)

<br>

### STEP 9 : TARGET DB 에 Checkpoint Table 생성 (OCI GoldenGate Admin Console)

Capture / Replication 프로세스 설정을 하기 위해서는 TARGET DB 에 Checkpoint 테이블 생성이 필요합니다.

> 주의 : 앞서 TARGET DB 의 Register Database 생성 단계에서 Connection String 이 PDB 에 대한 Connection String 으로 연결을 하도록 설정하게 되어 있는지 체크합니다. 점검 방법은 Connection String 의 Service 명에 DB 데이터가 존재하는 PDB 명이 명기 되어 있는지 점검합니다. <br> 예) SERVICE_NAME=PDB1.sub07160235111.pslimvcn2021071.oraclevcn.com

- 먼저, 사전에 TARGEDB 의 SRCMIRROR_OCIGGLL 사용자로 로그인하여 해당 스키마에 Checkpoint Table 이 생성되어 있지 않음을 확인합니다. 

  ![CREDENTIALS](/assets/img/dataplatform/2022/goldengate/44.oci-goldengate-checkpoint-check.png)

- OCI GoldenGate 의 Admin Console 로 로그인 후 Configuration 메뉴로 접근하면 OCI Console 에서 등록했던 Database 의 Credential 정보들이 나타납니다. Credential 정보들 중에서 TARGET DB 의 Connection 정보에 대한 Action 메뉴 중에서 빨간색으로 표시된 버튼을 클릭합니다.

  ![TARGET Config](/assets/img/dataplatform/2022/goldengate/43.oci-goldengate-checkpoint-credential.png)

- 아래에 나타난 Checkpoint 항목에서 빨간색으로 표시된 "+" 버튼을 클릭합니다.

  ![CHECKPOINT CREATE](/assets/img/dataplatform/2022/goldengate/45.oci-goldengate-checkpoint-create.png)


- Checkpoint Table 입력창에 "SRCMIRROR_OCIGGLL"."CEHCKTABLE" 을 입력 후 Submit 버튼을 클릭합니다.

  ![CHECKPOINT CREATE-2](/assets/img/dataplatform/2022/goldengate/46.oci-goldengate-checkpoint-create-2.png)

- Submit 버튼을 클릭하면 Checkpoint table 생성을 진행 후 아래와 같이 화면 전환이 되고 생성된 Checkpoint table 이 조회됩니다.

  ![CHECKPOINT TABLE VIEW](/assets/img/dataplatform/2022/goldengate/47.oci-goldengate-checkpoint-create-result.png)

- SQL Developer 로 TARGET DB 에 접속해서 Checkpoint Table 들이 생성이 되었는지 확인합니다. (기존 Connection 이 연결되어 있는 경우, Refresh 버튼 클릭해서 확인)

  ![CHECKPOINT RESULT](/assets/img/dataplatform/2022/goldengate/48.oci-goldengate-checkpoint-create-result-sqldev.png)

<br>

### STEP 10 : EXTRACT (추출) 프로세스 추가 및 실행

OCI GoldenGate Admin 콘솔에서 EXTRACT(Capture) 프로세스를 추가하는 단계입니다. 

- OCI GoldenGate Admin 콘솔 로그인 후 Administration Service 탭의 메인 화면에서 Extracts (추출) 화면쪽의 "+" 버튼을 클릭합니다.

  ![EXTRACT ADD](/assets/img/dataplatform/2022/goldengate/49.oci-goldengate-extract-process-add.png)

- Add Extract 화면에서 Extract Type 을 "Integrated Extract" 를 선택 후 Next 버튼을 클릭합니다.

  ![INTEGRATED EXTRACT](/assets/img/dataplatform/2022/goldengate/50.oci-goldengate-extract-process-integrated-extract.png)

- Add Extract 의 두번째 화면에서는 Process Name 과 Trail File 이 저장될 Trail Name 을 아래와 같이 입력합니다.
    - Process Name : UAEXT (사용하고자 하는 프로세스 명)
    - Intent : Unidirectional 선택
    - Trail Name : E1 (반드시 2자만 입력)

  ![PROCESS NAME](/assets/img/dataplatform/2022/goldengate/51.oci-goldengate-extract-process-name-trail.png)

- Add Extract 의 두번째 화면을 아래쪽으로 스크롤 하면 DB 의 Credential 과 Managed Option 을 지정하는 화면에 아래 그림과 같이 리스트에서 지정하거나 선택 후 Next 버튼을 클릭합니다.
    - Credential Domain : OracleGoldenGate
    - Credential Alias : SRCGGDB
    - Register to PDBs : PDB1 (DBCS 생성 시 입력했던 PDB 이름)
    - Managed Option -> Critical to deployment health : Enable

  ![PROCESS CREDENTIAL](/assets/img/dataplatform/2022/goldengate/52.oci-goldengate-extract-process-credentiial-managed-option.png)


- Add Extract 세번째 화면에서는 Parameter File 을 입력하는 절차입니다. Parameter 에는 추출할 대상 스키마의 대상 테이블 정보들을 정의해 줍니다. 아래의 Parameter 내용을 복사하여 Parameter File 란에 기존 정보를 지우고 붙여넣기를 합니다. "Create and Run" 버튼을 클릭합니다. (※ 맨 아래 Parameter 항목에 Capture 할 테이블에 대한 정보가 명기되어 있는 것을 확인할 수 있습니다.)

    ```text
    
    EXTRACT UAEXT
    USERIDALIAS SRCGGDB DOMAIN OracleGoldenGate
    EXTTRAIL E1

    -- Capture DDL operations for listed schema tables
    ddl include mapped

    -- Add step-by-step history of ddl operations captured
    -- to the report file. Very useful when troubleshooting.
    ddloptions report

    -- Write capture stats per table to the report file daily.
    report at 00:01

    -- Rollover the report file weekly. Useful when IE runs
    -- without being stopped/started for long periods of time to
    -- keep the report files from becoming too large.
    reportrollover at 00:01 on Sunday

    -- Report total operations captured, and operations per second
    -- every 10 minutes.
    reportcount every 10 minutes, rate

    -- Table list for capture
    TABLE PDB1.SRC_OCIGGLL.*;

    ```

  ![PROCESS PARAMETER](/assets/img/dataplatform/2022/goldengate/53.oci-goldengate-extract-process-parameter-file.png)



- 추가한 프로세스는 아래 그림과 같이 노란 상태로 추가가 되며 프로세스가 정상적인 상태가 되면 녹색 상태로 전환됩니다.

  ![PROCESS STATUS](/assets/img/dataplatform/2022/goldengate/54.oci-goldengate-extract-process-status-yellow.png)


  ![PROCESS STATUS-2](/assets/img/dataplatform/2022/goldengate/55.oci-goldengate-extract-process-status-green.png)

<br>

### STEP 11 : REPLICAT (복제) 프로세스 추가 및 실행

다음은 OCI GoldenGate Admin 콘솔에서 REPLICAT(복제) 프로세스를 추가하는 단계입니다. 

- OCI GoldenGate Admin 콘솔 로그인 후 Administration Service 탭의 메인 화면에서 Replicats (복제) 화면쪽의 "+" 버튼을 클릭합니다.

  ![REPLICAT ADD](/assets/img/dataplatform/2022/goldengate/56.oci-goldengate-replicat-process-add.png)

- Add Replicat 화면에서 Replicat Type 을 세번째 항목인 "Nonintegrated Replicat" 을 선택 후 Next 버튼을 클릭합니다.

  ![NONINTEGRATED REPLICAT](/assets/img/dataplatform/2022/goldengate/57.oci-goldengate-replicat-process-nonintegrated.png)

- Add Replicat 화면의 Replicat Options 페이지에서 입력항목들에 아래와 같이 입력합니다.
    - Process Name : REP
    - Credential Domain : OracleGoldenGate 선택
    - Crential Alia : TRGGGDB 선택
    - Trail Nmae : E1
    - Checkpoint Table : "SRCMIRROR_OCIGGLL"."CHECKTABLE"


  ![REPLICAT OPTIONS](/assets/img/dataplatform/2022/goldengate/58.oci-goldengate-replicat-process-name.png)

- Add Replicat 의 두번째 화면을 아래쪽으로 스크롤 하면 Managed Option 을 지정하는 화면에 "Critical to deployment health" 를 Enable 로 설정 후 Next 버튼을 클릭합니다.

  ![NONINTEGRATED REPLICAT](/assets/img/dataplatform/2022/goldengate/59.oci-goldengate-replicat-process-managed-options.png)

- Add Replicat 의 세번째 화면은 Parameter File 을 입력하는 화면입니다. 
Extract 프로세스의 Parmeter 를 입력하는 방식과 동일하게 아래의 내용을 Parameter 입력란에 붙여넣기로 기존 입력 항목을 대체 후 "Create and Run" 버튼을 클릭합니다. (※ 맨 마지막에 MAP 항목은 SOURCE DB 의 테이블을 TARGET DB 로 MAPPING 을 어떻게 할 것인지 정의해 주는 항목입니다.)

    ```text
    
    REPLICAT REP
    USERIDALIAS TRGGGDB DOMAIN OracleGoldenGate

    -- Capture DDL operations for listed schema tables
    --
    ddl include mapped
    --
    -- Add step-by-step history of ddl operations captured
    -- to the report file. Very useful when troubleshooting.
    --
    ddloptions report
    --
    -- Write capture stats per table to the report file daily.
    --
    report at 00:01
    --
    -- Rollover the report file weekly. Useful when PR runs
    -- without being stopped/started for long periods of time to
    -- keep the report files from becoming too large.
    --
    reportrollover at 00:01 on Sunday
    --
    -- Report total operations captured, and operations per second
    -- every 10 minutes.
    --
    reportcount every 10 minutes, rate
    --
    -- Table map list for apply
    --
    DBOPTIONS ENABLE_INSTANTIATION_FILTERING;
    
    MAP PDB1.SRC_OCIGGLL.*, TARGET PDB1.SRCMIRROR_OCIGGLL.*;
    
    ```

  ![REPLICAT PROCESS](/assets/img/dataplatform/2022/goldengate/60.oci-goldengate-replicat-process-parameter-file.png)

- 추가한 프로세스는 아래 그림과 같이 노란 상태로 추가가 되며 프로세스가 정상적인 상태가 되면 녹색 상태로 전환됩니다.

  ![PROCESS STATUS](/assets/img/dataplatform/2022/goldengate/61.oci-goldengate-replicat-process-status-yellow.png)

  ![PROCESS STATUS](/assets/img/dataplatform/2022/goldengate/62.oci-goldengate-replicat-process-status-green.png)

- Extract(추출) 및 Replicat(복제) 프로세스가 정상적으로 동작하는지는 아래와 같이 모든 프로세스의 상태가 Green 표시로 나타나야 하며, 아래 에러메시지 창에도 붉은색 Error 메시지가 없는 상태가 정상 동작 상태입니다.

    ![PROCESS OK](/assets/img/dataplatform/2022/goldengate/72.oci-goldengate-process-ok.png)

> STEP 11번까지의 단계가 모두 성공적으로 완료되면 기본적인 OCI GoldenGate 의 Capture (추출) 및 Replicat (복제) 구성이 완료된 상태가 됩니다.

<br>

### STEP 12 : 복제 결과 확인 및 통계 확인

OCI GoldenGate 를 통해 SOURCE DB 에서 TARGET DB 로의 복제 구성이 완료되었습니다. SOURCE DB 에서의 추출 및 복제가 잘 이루어지는지 확인을 위해 해당 테이블의 통계 (TABLE STATISTICS) 를 확인하는 방법입니다.

- Perormance Metrics Service 에서는 동작하고 있는 각 프로세스의 상태 정보 및 처리 통계 정보들을 확인할 수 있습니다. OCI GoldenGate Admin 콘솔 화면에서 상단탭들 중에서 Performance Metrics Service 를 클릭하면 모든 프로세스의 동작 상태를 확인할 수 있고 그중 Extract (추출) 현황을 확인하기 위해 Extract 프로세스인 UAEXT 프로세스를 클릭합니다.

  ![PERFORMANCE METRICS](/assets/img/dataplatform/2022/goldengate/63.oci-goldengate-performance-metrics.png)

- Extract 프로세스의 동작 현황들이 나타납니다. 해당 프로세스가 사용하고 있는 CPU, Memory, I/O 등의 자원 현황들이 나타납니다. Extract 프로세스가 DB 에 처리하는 처리 건수 및 통계를 확인하기 위해서 상단 탭 메뉴들 중에서 "Database Statistics" 메뉴를 클릭합니다.

  ![PERFORMANCE CHART](/assets/img/dataplatform/2022/goldengate/64.oci-goldengate-performance-metrics-chart.png)

- Performance Metrics 의 Datatbase Statistics 에서는 OCI GoldenGate 가 처리하고 있는 DB 테이블에서 일어나고 있는 Insert, Update, Delete 등의 변경 정보들에 대한 추출 및 복제 처리 건수에 대한 통계 정보들을 확인할 수 있습니다. 해당 화면의 맨아래로 스크롤을 하면 Table Statistics 라는 항목이 나타납니다.

  ![DATABASE STATISTICS](/assets/img/dataplatform/2022/goldengate/65.oci-goldengate-performance-metrics-database-statistics.png)

- 다음 STEP 에서 OCI GoldenGate 에 대한 복제 및 추출 현황을 모니터링하기 위해 Performance Metrics 의 Database Statistics 의 Table Statistics 화면을 열어 놓은 상태에서 STEP 13 을 진행합니다.

<br>

### STEP 13 : 복제를 위해 SOURCE DB 테이블에 데이터 입력 변경

 복제가 제대로 동작하는지 SOURCE DB 의 테이블들에 데이터를 입력하여 SOURCE DB 에 변경을 진행합니다.

- 윈도우 서버에 설치한 SQL Developer 를 통해 SOURCE DB (SRC_OCIGGLL 사용자 스키마) 와 TARGET DB (SRCMIRROR_OCIGGLL 사용자 스키마) 의 SRC_CITY, SRC_REGION 테이블의 내용이 동일한지 데이터 내용 및 건수를 확인합니다.

    - SOURCE DB 의 SRC_OCIGGLL.SRC_CITY 테이블 내용 및 건수 확인
    ![SOURCEDB CITYTABLE](/assets/img/dataplatform/2022/goldengate/66.oci-goldengate-source-table-src-city.png)

    - TARGET DB 의 SRCMIRROR_OCIGGLL.SRC_CITY 테이블 내용 및 건수 확인 (※ 상기 SOURCE DB 와 내용 및 건수가 동일한지 비교 확인)
    ![TARGETDB CITYTABLE](/assets/img/dataplatform/2022/goldengate/67.oci-goldengate-target-table-src-city.png)


- SQL Developer 를 통해 SOURCE DB 에 SRC_OCIGGLL 사용자로 PDB 에 접속하여 SQL 실행창에 아래의 Insert 쿼리를 복사 후 붙여넣기를 한 후 SCRIPT 를 실행합니다. (※ INSERT, UPDATE, DELETE 등의 SOURCE DB 변경 후 COMMIT 문 반드시 실행)

    ```sql
    
    Insert into SRC_OCIGGLL.SRC_REGION (REGION_ID,REGION,COUNTRY_ID,COUNTRY) values (1000,'Central Korea',10,'Korea');
    Insert into SRC_OCIGGLL.SRC_REGION (REGION_ID,REGION,COUNTRY_ID,COUNTRY) values (1001,'EastSouth Korea',10,'Korea');

    Insert into SRC_OCIGGLL.SRC_CITY (CITY_ID,CITY,REGION_ID,POPULATION) values (1000,'Seoul',1000,1992823);
    Insert into SRC_OCIGGLL.SRC_CITY (CITY_ID,CITY,REGION_ID,POPULATION) values (1001,'Pusan',1001,1725821);

    COMMIT;

    ```

    ![INSERT QUERY](/assets/img/dataplatform/2022/goldengate/68.oci-goldengate-sourcedb-insert.png)


- 앞서 STEP 12 에서 열어 두었던 OCI GoldenGate 의 Performance Metrics 의 Database Statistics 의 Table Statistics 화면에서 테이블 건수의 변화 및 Chart 의 변화를 확인합니다. Table Statistics 건수에 앞서 Insert 를 수행했던 두개의 테이블에 각각 2건씩 Insert 가 추가된 것이 통계로 나타납니다. 또한 중간에 나타나는 진행 그래프에서 아래 그림처럼 빨간색으로 표시된 그래프처럼 그래프의 변화가 일어나면 해당 시점에서 Capture 추출 프로세스가 처리된 것을 나타냅니다.

    ![PERFORMANCE METRICS](/assets/img/dataplatform/2022/goldengate/69.oci-goldengate-table-statistics.png)

- SQL Developer 를 통해 입력한 데이터가 SOURCE DB 와 TARGET DB 에 제대로 반영이 되었는지 확인합니다. 

    - SOURCE DB 의 SRC_OCIGGLL.SRC_CITY 테이블 내용 및 건수 확인
    ![SOURCEDB INSERTCHECK](/assets/img/dataplatform/2022/goldengate/70.oci-goldengate-sourcedb-insert-check.png)

    - TARGET DB 의 SRCMIRROR_OCIGGLL.SRC_CITY 테이블 내용 및 건수 확인 (※ 상기 SOURCE DB 와 내용 및 건수가 동일한지 비교 확인)
    ![TARGETDB REPLICATCHECK](/assets/img/dataplatform/2022/goldengate/71.oci-goldengate-targetdb-replicat-check.png)

- TARGET DB 에도 SOURCE DB 에 SRC_CITY 테이블에 INSERT 했던 'Seoul', 'Pusan' 레코드가 복제된 것을 확인할 수 있습니다. SOURCE DB 의 TABLE 들에 다른 DATA 를 INSERT 하거나 UPDATE 하거나 DELETE 를 하더라도 모든 DB 테이블들의 변경들이 TARGET DB 로 복제되는 것을 확인하실 수 있게 됩니다. 수고하셨습니다.

<br>

---

