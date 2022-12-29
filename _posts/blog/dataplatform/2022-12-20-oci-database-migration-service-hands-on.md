---
layout: page-fullwidth
#
# Content
#
subheadline: "DataPlatform"
title: "OCI Database Migration Service Hands-On"
teaser: "On-Premise 혹은 타 Cloud 에서 운영 중인 Oracle Database 를 무중단으로 OCI 로 이전할 수 있는 OCI Database Migration Service 에 대한 Hands-On 실습 가이드입니다."
author: lim
breadcrumb: true
categories:
  - dataplatform
tags:
  - [oci, oracle, migration, zerodowntime, goldengate, dbcs, replication]
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

이번 글에서는 On-premise 혹은 타 Cloud 에서 운영 중인 Oracle Database 를 서비스 중단없이 가장 간단한 방법으로 OCI DB System, Exadata Cloud Service 혹은 Autonomouse Database 로 Migration 을 수행할 수 있는 OCI Database Migration Service 에 대해서 알아보고 간편하게 Migration 하는 방법을 직접 Hands-On 을 통해 실습해 보도록 합니다.

![OCI Migration Method](/assets/img/dataplatform/2022/migration/01.oracle_database_migration_methods.png)

Oracle Database 를 Migration 할 수 있는 방법은 전통적인 Offline 기반의 Data Pump, RMAN Backup & Recovery 방법 등이 있고 무중단 Migration 을 위해서는 Online 기반의 Zero Downtime Migration (ZDM) 과 Data Guard 를 통한 Physical Migration 그외에 최근 OCI 에 추가된 OCI Database Migration Service (DMS) 등 여러 방법이 있습니다. 이중에서 최근에 나온 OCI Database Migration Service 는 GoldenGate 기술을 사용하여 Migration 을 수행함과 동시에 Source 단에서 일어나는 변경 사항들을 실시간으로 Target 에 반영할 수 있기 때문에 Near Zero Downtime 기반으로 기존 사용하는 Oracle Database 를 손쉽게 이전할 수 있는 마이그레이션 방법입니다.  <br> 

![OCI Migration](/assets/img/dataplatform/2022/migration/02.oci_database_migration_overview.png)

<br>

OCI DMS 서비스는 사용자의 테넌시 및 리소스와 별도로 관리되는 클라우드 서비스로 실행됩니다. 이 서비스는 DMS 서비스 테넌시에서 다중 테넌트 서비스로 작동하며 PE(Private Endpoint)를 사용하여 사용자의 리소스와 통신합니다. 

<br>

### 사전 준비 사항
OCI Database Migration 서비스를 이용하려면 먼저 아래와 같은 사항들이 준비되어야 합니다.
- Virtual Cloud Network (VCN) 구성 및 Security List 에 1521, 443, 3389 port 오픈
- Source Oracle DB (On-Premise DB, 타 Cloud DB, OCI DBCS) - (Oracle DB 11.2.0.4 버전 이상) - DBCS 생성 시  [DBCS 생성 퀵스타트 가이드 참고](/dataplatform/oracle-database-cloud-service-quickstart/){:target="_blank" rel="noopener"} 
- Target Oracle DB (OCI DBCS, ExaCS 혹은 ADB) - (Oracle DB 11.2.0.4 버전 이상)
- DB 연결을 위한 Windows Instance (선택 사항)
- Windows Instance 에 SQLDeveloper, Putty Software install

![DBCS Preparation](/assets/img/dataplatform/2022/migration/04.oci-dms-dbcs-preparation.png)

상기 그림과 같이 OCI DMS 핸즈온을 위해 SOURCE 와 TARGET 을 OCI의 DBCS 를 미리 구성해 놓았고 SOURCE DBCS 에서 TARGET DBCS 로 Migration을 실습하게 됩니다.
SOURCE DBCS 는 On-Premise Oracle DB 나 타 Cloud 에서 사용 중인 Oracle DB 로 생각하시고 실습하면 됩니다.
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

![SQL Developer](/assets/img/dataplatform/2022/migration/05.oci-dms-dbcs-connection-string-1.png)

![SQL Developer](/assets/img/dataplatform/2022/migration/06.oci-dms-dbcs-connection-string-2.png)

```
* DB Connection 정보  : migsrcdb.sub12150803481.pslimvcnmigrati.oraclevcn.com:1521/MIGSRCDB_MIGSRCDB.sub12150803481.pslimvcnmigrati.oraclevcn.com

상기 Connection 정보에서 SQL Developer 의 Connection 에 입력할 항목들을 추출합니다.
1. 호스트 이름 : migsrcdb.sub12150803481.pslimvcnmigrati.oraclevcn.com
2. 포트 : 1521
3. 서비스 이름 : MIGSRCDB_MIGSRCDB.sub12150803481.pslimvcnmigrati.oraclevcn.com
```


아래의 화면에 사용자 이름에 DB 생성 시 입력한 sys 사용자의 password 와 호스트 이름, 서비스 이름을 입력하고 테스트 및 저장 버튼을 클릭합니다. 여기서 반드시 사용자의 롤(Role)을 SYSDBA 로 선택해 줍니다.

![SQL Developer](/assets/img/dataplatform/2022/migration/07.oci-dms-dbcs-sqldeveloper-connection-1.png)

Target DB 에 대해서도 동일한 방식으로 sys 사용자에 대해 Connection 을 생성하여 저장해 둡니다.

![SQL Developer](/assets/img/dataplatform/2022/migration/08.oci-dms-dbcs-sqldeveloper-connection-2.png)

Connection 을 클릭하여 설정한 SOURCE DB 로 연결이 잘 되는지 확인합니다.

![SQL Developer](/assets/img/dataplatform/2022/migration/09.oci-dms-dbcs-sqldeveloper-connection-3.png)

<br>

### STEP 2 : SSH Key Open SSH 로 변환

SSH Key 를 Windows OS 에서 Putty 를 통해 Public Key 와 Private Key 를 생성한 Key 를 가지고 DB 를 생성하고 컴퓨트를 생성했다면 Putty Gen 을 통해 Open SSH Key file 로 변환을 해 주어야 합니다. 만일, Linux 기반의 ssh-keygen 을 통해 생성한 key 를 사용한다면 STEP 2를 수행하지 않으셔도 됩니다.

- 윈도우즈에서 PuttyGen 을 실행 후 "Load" 버튼을 클릭합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/10.oci-dms-putty-gen-1.png)

- Key가 Load 되었으면, 상단의 "Conversions" 메뉴 아래의 "Eport OpenSSH Key" 메뉴를 클릭합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/11.oci-dms-putty-gen-2.png)

- 아래 화면의 예처럼 OpenSSH Key 로 변환되어 저장된 Key 임을 알수 있는 이름으로 Key 를 저장 후 PuttyGen 프로그램을 종료합니다. (※ 추후, GoldenGate Migration 을 Deploy 할때 변환된 OpenSSH Key 를 사용하게 되므로 변환된 Key 를 잘 보관합니다.)

    ![PuttyGen](/assets/img/dataplatform/2022/migration/12.oci-dms-putty-gen-open-ssh.png)

<br>

### STEP 3 : Vault 생성 및 Object Storage 생성

#### 3-1. Vault 생성

이번 단계는 Vault 및 암호화 Key 를 생성하는 단계입니다. 더불어 Object Storage 용 bucket 을 생성합니다.

- OCI Console 에서 Identity & Security > Vault 메뉴를 클릭합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/13.vault-oci-menu.png)

- Compartment 를 선택 후 Create Vault 버튼을 클릭합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/14.oci-menu-vault-create-1.png)

- Create Vault dialog 창이 나타나면 dms_vault 와 같은 이름으로 Vault 를 생성합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/15.oci-menu-vault-create-2.png)

- 몇분이 지나면 생성한 Vault 가 Active 상태로 전환된 것을 확인합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/16.oci-menu-vault-create-3.png)

- 생성된 Vault 를 클릭하여 들어간 메뉴에서 새로이 Master Encryption Key 를 생성하기 위해 Create Key 버튼을 클릭합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/16.oci-menu-key-create-4.png)

- Key 생성 화면에서 Key 의 이름을 입력하고 Create 버튼하면 Key 가 생성됩니다. 생성한 Key 가 제대로 생성된 후 Active 상태로 전환되는지 확인합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/16.oci-menu-vault-create-5.png)

    ![PuttyGen](/assets/img/dataplatform/2022/migration/16.oci-menu-vault-create-6.png)

#### 3-2. Object Storage 생성

Migration 시 사용이 되는 빈 Object Storage 를 생성해 줍니다.

- OCI Console 메뉴에서 Storage > Object Storage & Archive Storage 를 클릭합니다.
    ![PuttyGen](/assets/img/dataplatform/2022/migration/17.oci-menu-object-storage.png)

- Create Bucket 버튼을 클릭하여 Bucket 생성 화면으로 이동합니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/18.oci-menu-object-storage-bucket-create.png)


- Bucket 생성 화면에서 Bucket Name 을 DMSStorage 로 입력 후, 나머지는 기본값으로 설정 후 Create 버튼을 클릭하면 버킷이 생성됩니다.

    ![PuttyGen](/assets/img/dataplatform/2022/migration/19.oci-menu-object-storage-bucket-create-2.png)


<br>

### STEP 4 : SOURCE DB 준비

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

  ![SEED User](/assets/img/dataplatform/2022/migration/20.oci-sourcedb-pdb-user-create.png)


- 생성한 SRC_OCIGGLL 사용자로 SQLDeveloper 접속을 생성합니다. (※ 생성한 SRC_OCIGGLL 사용자는 PDB 사용자로 반드시 아래의 서비스 이름에 PDB명을 입력해야 합니다. PDB명은 DB 생성 시 입력한 PDB명 입니다.)

  ![SEED User](/assets/img/dataplatform/2022/migration/21.oci-sourcedb-seed-user-connect.png)
  


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

    ![SEED User](/assets/img/dataplatform/2022/migration/22.oci-sourcedb-seed-create.png)



<br>

### STEP 5 : SOURCE DB 및 TARGET DB 에 대한 Migration 을 위한 설정

SOURCE DB 와 TARGET DB 에 Migration 을 수행하기 위한 설정을 수행합니다. Migration 설정을 위해서 GoldenGate Replication 을 위한 Supplement Logging, GoldenGate Admin 사용자 추가, GoldenGate 사용이 가능한 설정 변경등의 DBA 작업들이 있습니다. SOURCE DB 와 TARGET DB 가 Private Subnet 에 Deploy 가 되어 있기 때문에 Windows VM 에 Terminal 로 접속하여 아래 작업들을 수행합니다.

- 원격데스크탑 연결을 통한 윈도우 로그인 후 Putty 를 실행시킨 후 DBCS 의 Private IP 정보를 획득하여 연결 설정을 합니다. (※ Putty 설정 시, Private Key를 지정하여 연결 설정)

    ![Putty](/assets/img/dataplatform/2022/migration/23.oci-sourcedb-private-ip.png)

- TARGET DB 도 SOURCE DB 와 마찬가지로 동일하게 Putty 의 연결을 설정합니다.

- 연결 후 Security Alert 창의 "Accept" 버튼을 클릭하여 DB Host 로 연결을 합니다.  
    ![Putty](/assets/img/dataplatform/2022/migration/24.oci-sourcedb-putty-access.png)

- 연결된 Terminal 에서 oracle 사용자로 전환 후 dba 권한으로 sqlplus 접속을 합니다.

  ```
    [opc@migsrcdb ~]$ sudo su - oracle
    [oracle@migsrcdb ~]$ sqlplus / as sysdba
  ```
- 아래 그림처럼 TARGET DB Host 에도 Terminal 접속 후 oracle 사용자로 전환 후 dba 권한으로 sqlplus 에 접속합니다.

    ![Putty](/assets/img/dataplatform/2022/migration/25.dbhost-sqlplus.png)

- 아래의 show pdb SQL 명령으로 PDB 명을 확인합니다.

    ![Putty](/assets/img/dataplatform/2022/migration/26.dbhost-sqlplus-show-pdb.png)

- SOURCE DB 와 TARGET DB 의 PDB로 접속하여 앞단계에서 생성한 SRC_OCIGGLL 스키마에 seed data 가 존재하는지 확인합니다. 
  ```
    SQL> alter session set container=PDB1;
    SQL> select count(*) from SRC_OCIGGLL.SRC_CITY;
  ```
- 아래 화면처럼 좌측의 SOURCE DB 쪽은 이전에 단계에서 생성해 놓은 SRC_CITY, SRC_REGION 과 같은 Seed Data 가 있으나, TARGET DB 쪽은 SRC_OCIGGLL 스키마 혹은 SRC_CITY 같은 테이블이 존재하지 않는 것을 확인할 수 있습니다. 

    ![Putty](/assets/img/dataplatform/2022/migration/27.dbhost-sqlplus-schema-check.png)

- SORCE DB 의 PDB 에 생성해 놓은 SRC_OCIGGLL 스키마 데이터들을 TARGET DB 로 Migration 을 수행해 보도록 하겠습니다. 

- SOURCE DB 에 접속된 SQLPLUS Command 에서 PDB 에 접속하여 DMS Migration 을 위해 필요한 DB 사용자인 ggadmin 사용자를 아래와 같이 생성하고 권한을 부여해 줍니다. (※ "password" 는 사용할 Password 로 대체 필요)

  ```
    alter session set container=PDB1;
    create tablespace GG_DATA datafile '+DATA' size 100m autoextend on next 100m;
    create user ggadmin identified by "password" container=current; 
    grant create session to ggadmin container=current;
    grant alter any table to ggadmin container=current;
    grant resource to ggadmin container=current;
    grant dba to ggadmin container=current;
    exec dbms_goldengate_auth.grant_admin_privilege('ggadmin');
  ```
    ![Putty](/assets/img/dataplatform/2022/migration/28.dbhost-sqlplus-source-db-setting.png)


- SOURCE DB 에 접속된 SQLPLUS Command 에서 CDB 에 접속하여 DMS Migration 을 위해 필요한 DB 사용자인 c##ggadmin 사용자를 아래와 같이 생성하고 권한을 부여해 줍니다. 더불어, 제일 마지막 줄의 global_names 파라미터도 false 로 세팅해 줍니다. (※ "password" 는 사용할 Password 로 대체 필요)

  ```
    alter session set container=cdb$root;
    alter system set enable_goldengate_replication=TRUE;
    alter system set streams_pool_size=2G;
    alter database force logging;
    alter database add supplemental log data;
    archive log list;
    create tablespace GG_DATA datafile '+DATA' size 100m autoextend on next 100m;
    create user c##ggadmin identified by "password" container=all default tablespace GG_DATA temporary tablespace temp;
    grant alter system to c##ggadmin container=all;
    grant dba to c##ggadmin container=all;
    grant create session to c##ggadmin container=all;
    grant alter any table to c##ggadmin container=all;
    grant resource to c##ggadmin container=all;
    exec dbms_goldengate_auth.grant_admin_privilege('c##ggadmin',container=>'all');
    alter system set global_names=false;
  ```

    ![Putty](/assets/img/dataplatform/2022/migration/29.dbhost-sqlplus-source-db-setting-2.png)


- TARGET DB 에도 SOURCE DB 와 동일하게 접속된 SQLPLUS Command 에서 PDB 에 접속하여 DMS Migration 을 위해 필요한 DB 사용자인 ggadmin 사용자를 아래와 같이 생성하고 권한을 부여해 줍니다. (※ "password" 는 사용할 Password 로 대체 필요)

  ```
    alter session set container=PDB2;
    create user ggadmin identified by "password" container=current; 
    grant create session to ggadmin container=current;
    grant alter any table to ggadmin container=current;
    grant resource to ggadmin container=current;
    grant dba to ggadmin container=current;
    exec dbms_goldengate_auth.grant_admin_privilege('ggadmin');
  ```
    ![Putty](/assets/img/dataplatform/2022/migration/30.dbhost-sqlplus-target-db-setting-1.png)

- TARGET DB 에는 추가적으로 Vault 환경에서 GoldenGate 를 구성할 수 있는 권한을 부여해 줍니다.

  ```
    grant dv_glodengate_admin, dv_goldengate_redo_access to ggadmin container=current;
  ```
    ![Putty](/assets/img/dataplatform/2022/migration/31.dbhost-sqlplus-target-db-setting-2.png)

- TARGET DB 의 CDB 로 전환하여 global_names 를 SOURCE DB 와 마찬가지로 false 로 변경해 줍니다.

  ```
    alter session set container=CDB$ROOT;
    alter system set global_names=false;
  ```
    ![Putty](/assets/img/dataplatform/2022/migration/32.dbhost-sqlplus-target-db-setting-3.png)

<br>

### STEP 6 : GoldenGate Migration 서비스 Deploy

이 단계에서는 무중단 Migration 을 하기 위해 데이터의 복제를 담당해 주는 GoldenGate Migration 서비스를 OCI 에 Deploy 하는 단계입니다. 

- GoldenGate Migration 서비스는 Marketplace 를 통해 Deploy 를 하실 수 있습니다. OCI Console Menu 에서 Marketplace > All Applications 를 선택합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/33.oci-marketplace-menu.png)

- Marketplace 검색 창에 "GoldenGate Migration" 이라고 입력을 하면, 아래 목록에 검색 결과가 나타납니다. 목록에서 "Oracle GoldenGate - Database Migrations" 라는 Application 을 선택합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/34.oci-marketplace-search.png)

- Oracle GoldenGate - Database Migrations Applicatoin 을 Deploy 할 Compartment 와 라이센스 정책 동의를 체크 후 "Lanuch Stack" 버튼을 클릭합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/35.oci-marketplace-goldengate-launch-stack.png)

- Stack 생성 화면으로 이동됩니다. Stack 의 이름을 입력 후 "Next" 버튼을 클릭합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/36.oci-marketplace-goldengate-stack-create.png)

- Stack 생성을 위한 다양한 항목들을 입력합니다. 먼저 Display Name 및 DNS host 명은 기본으로 입력된 것을 활용하실 수도 있고 임의적으로 변경이 가능합니다. 입력 후 아래로 스크롤 다운하여 Network Settings 영역으로 이동합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/37.oci-marketplace-goldengate-stack-create-1.png)

- GoldenGate - Database Migrations 을 Deploy 할 Compartment 와 VCN, Subnet 등 네트워크 설정들을 해 줍니다. 더불어 Subnet 은 GoldenGate Web Console 을 Public IP 를 통해 조회 및 관리할 수 있도록 Public Subnet 을 선택해 주고 아래로 스크롤 다운하여 Instance Settings 영역으로 이동합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/38.oci-marketplace-goldengate-stack-create-2.png)

- Instance 가 Depoly 될 AD 를 선택해 주고 필요시 GoldenGate 가 사용할 컴퓨트 Shape 을 변경해 주고 Create OGG Deployment 영역으로 스크롤 다운합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/39.oci-marketplace-goldengate-stack-create-3.png)

- OGG Depolyment 이름과 SSH Access Key 를 입력 후 Next 버튼을 클릭합니다. Deployment 이름은 추후 DMS 서비스를 생성하고 DMS 서비스를 이용하는데 사용되므로 기억하거나 메모하여 잘 보관해 둡니다. 저는 DMSTEST 라고 입력을 하도록 하겠습니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/40.oci-marketplace-goldengate-stack-create-4.png)

- 앞화면에서 입력했던 모든 사항들을 리뷰한 후 Create 버튼을 클릭합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/41.oci-marketplace-goldengate-stack-create-5.png)

- 생성한 Stack 이 Application 생성 Job 을 시작합니다. 아래와 같이 Success 화면으로 전환이 되면 성공적으로 GoldenGate - Database Migrations Application 이 Deploy 됩니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/42.oci-marketplace-goldengate-stack-create-6.png)

- Stack 이 생성한 결과 Log의 맨 하단을 보면 Deploy 한 ogg_public_ip 라는 항목에 Public IP 가 발급된 것을 확인할 수 있습니다. 해당 IP 와 Private Key 를 Putty 에 등록하여 생성된 GoldenGate 서버에 접속합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/44.oci-marketplace-goldengate-server-putty.png)

- 접속된 서버에서 아래의 명령어를 입력하여 GoldenGate 서버의 oggadmin 사용자의 credential 정보를 확보합니다. Credential Password 정보는 추후 DMS 서비스 설정 및 GoldenGate Admin 화면 로그인 시 사용하게 되므로 잘 복사해서 보관해 둡니다.

  ```
    $ ls
    $ cat ogg-credentials.json
  ``` 
  
    ![Marketplace](/assets/img/dataplatform/2022/migration/45.oci-marketplace-goldengate-credential.png)

- 인터넷 브라우저의 주소창에 "https://GoldenGate-서버-Public-IP" 를 입력하여 GoldenGate 관리자 페이지로 액세스를 합니다. 

    ![Marketplace](/assets/img/dataplatform/2022/migration/46.oci-marketplace-goldengate-public-ip.png)

-  "고급" 버튼을 클릭하고 아래 "안전하지 않음" 을 클릭하여 GoldenGate Admin 웹화면으로 접근합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/47.oci-marketplace-goldengate-admin-web-1.png)

    ![Marketplace](/assets/img/dataplatform/2022/migration/48.oci-marketplace-goldengate-admin-web-2.png)


- "고급" 버튼을 클릭하고 아래 "안전하지 않음" 을 클릭하여 GoldenGate Admin 웹화면으로 접근합니다. GoldenGate 서비스 관리자 로그인 창에 앞단계에서 확보한 ogg-credentials.json 파일 안의 credential 정보인 username 과 credential 을 로그인 창의 Username 과 Password 항목에 입력 후 로그인합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/49.oci-marketplace-goldengate-admin-web-3.png)

- 아래 그림과 같이 제대로 로그인이 되는지 확인하고 4개의 서비스가 "실행 중" 상태인지 확인합니다.

    ![Marketplace](/assets/img/dataplatform/2022/migration/50.oci-marketplace-goldengate-admin-web-4.png)

<br>

### STEP 7 : DMS 서비스 Register Database 에 SOURCE DB, TARGET DB 등록

다음은 DMS 서비스에서 사용할 SOURCE DB 와 TARGET DB 를 등록하도록 하겠습니다.

- OCI Console Menu 의 Migration > Database Migrations > Registerd Databases 메뉴로 접근합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/51.oci-migration-registered-databases-1.png)

- Registerd Databases 목록 화면에서 선택된 Compartment 를 확인 후 Register Database 버튼을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/52.oci-migration-registered-databases-2.png)

- Database 등록 화면에서 등록하는 DB 의 이름을 입력 후 선택된 Compartment 및 Vault 와 Encryption Key 를 선택합니다. On-Premise DB 에 대해 Migration 을 위한 DB 라면 "Manual configure database" 를 입력하여 On-Premise DB 의 Host 와 Port 를 입력하여 수동 구성합니다. 

    ![REG DB](/assets/img/dataplatform/2022/migration/53.oci-migration-registered-databases-3.png)

- OCI 에 생성되어 있는 DB 를 등록할 경우 "Select database" 를 선택합니다. 저는 SOURCE DB, TARGET DB 모두 OCI 에 등록해 놓은 경우이기 때문에 "Select database" 메뉴를 선택 후 아래 화면과 같이 자동으로 Display 되는 목록에서 SOURCE DB 의 정보들을 선택합니다. Connection String 항목은 CDB 로 선택이 되기 때문에 PDB 의 Connect String 으로 바꿔주어야 하고 host 부분도 IP 로 바꿔 주어야 합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/54.oci-migration-registered-databases-4.png)

  > 중요 : Connect String 항목은 기본으로 입력되어 있는 내용을 지우고 아래와 같이 Host 부분을 IP 로 DB 서비스명 부분을 PDB 서비스 명으로 바꾸어 주어야 함 <br>
  (입력 예: 10.0.1.28:1521/PDB1.sub12150803481.pslimvcnmigrati.oraclevcn.com)


    ![REG DB](/assets/img/dataplatform/2022/migration/56.oci-migration-registered-databases-6.png)


- Connection Details 입력 화면이 나타나면 우측과 같이 Database administrator username 과 password 를 입력합니다. Oracle DB 의 super user 계정인 sys 계정은 사용할 수 없도록 되어 있어 저는 동일한 DBA 권한을 가진 system 계정으로 Connection 정보를 입력해 주도록 하겠습니다. 더불어 DB server 의 hostname 에는 DB Node 의 Private IP 정보를 입력하며 ssh private key 영역에는 이전에 Open SSH 포맷으로 변환해 놓은 ssh key 를 선택하여 입력해 줍니다. SSH username 에는 OCI 의 사용자 계정인 opc 를 입력 하고 나머지는 기본 선택 및 optional 영역은 빈칸으로 놓아 둡니다. Register 버튼을 클릭하여 DB 를 등록합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/55.oci-migration-registered-databases-5.png)

  > 중요 : ssh private key 는 반드시 Open SSH 포맷으로 변환해 놓은 ssh key 를 사용. putty 포맷의 PPK 파일 사용 시 오류 발생

- TARGET DB 도 SOURCE DB 와 마찬가지로 동일한 절차에 따라 Database 를 등록해 줍니다.

- 마이그레이션 대상 SOURCE 원본 DB 가 PDB 일 경우 SOURCE DB 의 CDB 도 Register Database 에 등록해 주어야 합니다. SOURCE DB 의 CDB 도 동일한 방법으로 DB 를 등록해 줍니다. (※ Connect String 입력 시 CDB 서비스 명 입력)

    ![REG DB](/assets/img/dataplatform/2022/migration/58.oci-migration-registered-databases-8.png)


- 최종적으로 SOURCEDB 가 PDB 일 경우는 아래와 같이 SOURCE CDB, SOURCE PDB, TARGET PDB 이렇게 세가지의 Database 들이 등록되어 있어야 합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/59.oci-migration-registered-databases-9.png)


### STEP 8 : Migration 생성

마이그레이션을 Job 을 통해 실제 마이그레이션을 제어할 수 있는 서비스를 생성하는 단계입니다. Migration 에서는 실제 Migration 을 수행하기 전에 Validation 을 수행하여 사전에 발생할 수 있는 오류들을 찾아 낼 수 있습니다.

- OCI Console Menu 에서 Migration > Database Migration > Migrations 메뉴를 선택합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/60.oci-migration-migration-menu.png)

- Migration 목록 화면에서 "Create migration" 버튼을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/61.oci-migration-create-migration-1.png)

- Migration 생성 화면에서 Migration 이름과 source db 로의 direct connection 을 선택 후 Next 버튼을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/62.oci-migration-create-migration-2.png)

- Source Database 와 Target Database 를 앞서 등록한 Regstered Database 에서 등록한 DB 명들을 Migration 할 Source 와 Target 방향에 알맞게 선택해 줍니다.
SOURCE DB 가 PDB 이기 때문에 "Database is pluggable database (PDB)" 체크 박스를 선택해 줍니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/63.oci-migration-create-migration-3.png)


- PDB 선택 사항을 체크하면 아래 화면처럼 CDB 를 선택하는 목록이 추가로 나타납니다. 목록이 나오면 이전에 등록한 SOURCE DB 의 CDB 를 아래 그림과 같이 선택 후 "Next" 버튼을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/64.oci-migration-create-migration-4.png)

- 다음은 Migration Option 을 선택해 주는 단계입니다. 초기 데이터 로드 방법을 database link 를 사용하여 직접 전송할 수도 있고, Object Storage 를 통해 로드를 할 수 있습니다. 이번 실습에서는  database link 를 이용해 직접 전송을 해 보도록 하겠습니다. GoldenGate 를 이용하여 Online Replication 을 수행할 것이기 때문에 아래 "Use online replication" 을 선택합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/65.oci-migration-create-migration-5.png)

- Use Online replication 을 선택하면 아래와 같이 GoldenGate 관련 입력 항목들이 나타납니다. 아래 그림을 참고하여 입력 항목들을 입력 후 아래쪽으로 스크롤 다운합니다.
    - GoldenGate hub URL : https://146.56.36.222 (GoldenGate Deployment Public IP)
    - GoldenGate administrator username : oggadmin
    - GoldenGate administrator password : "password" (GoldenGate 서버의 ogg-credentials.json 파일 안의 credential 에서 획득한 password 입력)
   
    ![REG DB](/assets/img/dataplatform/2022/migration/66.oci-migration-create-migration-6.png)

- Source database 영역에 다음과 같이 각 항목마다 입력 항목들을 입력 후 아래로 스크롤 다운합니다.
    - GoldenGate deployment name : DMSTEST (GoldenGate Deploy 시 입력한 Name)
    - Database username : ggadmin (STEP 5 에서 생성했던 Source DB 의 PDB 에 만들었던 GoldenGate Admin DB User)
    - Database password : password (STEP 5 에서 생성했던 Source DB 의 PDB 에 만들었던 GoldenGate Admin DB User 의 Password)
    - Container database username : c##ggadmin (STEP 5 에서 생성했던 Source DB 의 CDB 에 만들었던 GoldenGate Admin DB User)
    - Container database password : password (STEP 5 에서 생성했던 Source DB 의 CDB 에 만들었던 GoldenGate Admin DB User 의 Password)

    ![REG DB](/assets/img/dataplatform/2022/migration/67.oci-migration-create-migration-7.png)

- Target database 영역에 다음과 같이 각 항목마다 입력 항목들을 입력 후 "Create" 버튼을 클릭합니다.
    - GoldenGate deployment name : DMSTEST (GoldenGate Deploy 시 입력한 Name)
    - Database username : ggadmin (STEP 5 에서 생성했던 Target DB 의 PDB 에 만들었던 GoldenGate Admin DB User)
    - Database password : password (STEP 5 에서 생성했던 Target DB 의 PDB 에 만들었던 GoldenGate Admin DB User 의 Password)
    
    ![REG DB](/assets/img/dataplatform/2022/migration/68.oci-migration-create-migration-8.png)


- 앞서 입력했던 Migration 이름으로 Migration 이 생성됩니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/69.oci-migration-create-migration-9.png)

<br>

### STEP 9 : Migration 검증 (Validate)

실제 이관을 수행하기 전에 Validation 을 체크를 수행하는 단계입니다. 
- 생성한 Migration 의 상단 메뉴에서 Validation 을 한번도 수행하지 않은 경우 Validation 이 필요하다는 경고 문구가 나타납니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/70.oci-migration-validation-0.png)

- "Validate" 버튼을 클릭하여 사전 검증 작업을 수행합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/71.oci-migration-validation-1.png)

    ![REG DB](/assets/img/dataplatform/2022/migration/72.oci-migration-validation-2.png)

- "Validate" Job 이 시작되어 진행중으로 나타나며 해당 Job 목록을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/73.oci-migration-validation-3.png)

- Job 의 상세 화면에서는 각 단계별로 수행 단계들이 나타나며, Validation Job 이 실패한 경우 해당 단계를 클릭하여 상세 에러 내용을 볼 수 있습니다. 에러 내용을 확인하여 조치를 하실 수 있습니다. 

    ![REG DB](/assets/img/dataplatform/2022/migration/74.oci-migration-validation-4.png)

    ![REG DB](/assets/img/dataplatform/2022/migration/75.oci-migration-validation-5.png)

- 아래 에러 메시지의 Action 에서 조치 사항처럼 TARGET DB 의 Database Parameter 인 ENABLE_GOLDENGATE_REPLICATION 을 "TRUE" 로 설정합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/76.oci-migration-validation-error_action_6.png)

- TARGET DB Host 에 접속하여 sqlplus 로 로그인하여 CDB 에 Database Parameter 인 ENABLE_GOLDENGATE_REPLICATION 을 "TRUE" 로 설정합니다.

   ```
    $ sqlplus / as sysdba
    SQL> ALTER SYSTEM SET ENABLE_GOLDENGATE_REPLICATION=TRUE SCOPE=BOTH;
  ```  

    ![REG DB](/assets/img/dataplatform/2022/migration/77.oci-migration-validation-error_action_7.png)

- 에러 조치가 수행되었으면 Migration 의 Validate 을 다시 수행합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/78.oci-migration-validation-error_action_8.png)

- 에러가 났던 부분이 해결되게 다음 절차로 진행된 후 Validation 이 성공적으로 진행된 것을 확인할 수 있습니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/79.oci-migration-validation-error_action_9.png)  

    ![REG DB](/assets/img/dataplatform/2022/migration/80.oci-migration-validation-success.png)

<br>

### STEP 10 : Migration 수행 및 결과 확인

앞 단계에서 Validation 절차가 완료되면 Migration 을 수행할 준비가 완료되었습니다. 이제 Migration Details 에서 Start 버튼을 클릭하여 Migration 을 시작할 수 있습니다.

- Migration Details 화면에서 "Start" 버튼을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/81.oci-migration-migration-start.png)

- Migration 수행 시 잠시 멈출 (Pause) 단계를 기본 선택된 "Monitor replication lag" 를 선택 후 "Start" 버튼을 클릭합니다. (※ 필요시 여러 단계들 중 다른 단계로 선택할 수 있음)

    ![REG DB](/assets/img/dataplatform/2022/migration/82.oci-migration-migration-start-pause-option.png)

    ![REG DB](/assets/img/dataplatform/2022/migration/83.oci-migration-migration-start-pause-option-2.png)

- Migration 이 진행되며 Migration Job 이 생성되어 단계별 진행 상황을 조회하실 수 있습니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/84.oci-migration-migration-start-view-details.png)

    ![REG DB](/assets/img/dataplatform/2022/migration/85.oci-migration-migration-job-details.png)

    ![REG DB](/assets/img/dataplatform/2022/migration/86.oci-migration-migration-job-phases.png)

- 데이터 이관이 완료되고 Migration 의 단계 중에서 Job 을 시작할 때 Pause 단계로 선택했던 Monitor replication lag 단계를 완료 후 Job 이 WAITING 되는 것을 확인하실 수 있습니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/87.oci-migration-migration-job-phases-waiting.png)


<br>

### STEP 11 : Migration 결과 확인 및 복제 현황 조회

Monitor replication lag 단계는 SOURCE DB 로 부터 데이터를 Export 하여 TARGET DB 로 import 를 완료 후 GoldenGate 에 복제 프로세스를 구성하여 복제를 수행 중이어서 SOURCE DB 의 변경이 있어도 실시간으로 TARGET DB 로 반영이 되고 있는 단계로 보면 됩니다. 이 단계에서는 Migration 이 제대로 이루어 졌는지 결과를 확인하고 GoldenGate 의 프로세스 조회를 통해 복제 현황을 살펴보게 됩니다.

- 먼저 TARGET DB 에 SOURCE DB 의 데이터가 Migration 이 잘 되어 있는지 확인합니다.
- SOURCE DB의 PDB 에 있는 SRC_OCIGGLL 스키마의 데이터를 복제했기 때문에 해당 PDB 에 접속하여 스키마의 테이블들의 데이터 건수를 아래의 SQL 쿼리를 실행하여 비교합니다.

   ```
    $ sqlplus / as sysdba
    SQL> ALTER SESSION SET CONTAINER=PDB1;
    SQL> SELECT COUNT(*) FROM SRC_OCIGGLL.SRC_CITY;
    SQL> SELECT COUNT(*) FROM SRC_OCIGGLL.SRC_REGION;
    SQL> SELECT COUNT(*) FROM SRC_OCIGGLL.SRC_PRODUCT;
    SQL> SELECT COUNT(*) FROM SRC_OCIGGLL.SRC_CUSTOMER;
  ```  
- 아래 화면과 같이 SOURCE DB(좌측)와 TARGET DB(우측) 의 데이터 건수가 동일하게 일치하는 것을 확인할 수 있습니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/88.oci-migration-migration-result.png)

- 데이터의 실시간 복제를 담당하는 GoldenGate 서버가 잘 구동하고 있는지 확인하기 위해 GoldenGate Admin 화면으로 접근합니다. 브라우저에 GoldenGate 서버의 Public IP 를 입력하고 앞서 GoldenGate 서버 host 내 ogg-credentials.json 파일에서 확보한 사용자와 password 를 입력 후 사인인 버튼을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/89.oci-migration-goldengate-admin-login.png)

- 배치 목록들 중에서 "성능 측정항목 서비스" 의 포트를 클릭하여 성능 측정항목 서비스로 접근합니다. 팝업 윈도우로 로그인 다이얼로그가 나타나며 앞에서 동일하게 oggadmin 사용자와 password 를 입력하여 로그인합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/90.oci-migration-goldengate-admin-deployment.png)
    
- 성능 측정항목 서비스에 로그인하면 상단 탭 메뉴 중에서 "관리 서비스" 탭 메뉴를 클릭하면 현재 동작 중인 추출(Extract) 프로세스와 복제(Replicat) 프로세스가 DMS 서비스에 의해 자동 구성되어 동작 중인 것을 확인할 수 있습니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/91.oci-migration-goldengate-admin-performance-svc.png)

- 다시 상단 탭 메뉴 중에서 "성능 측정항목 서비스" 탭 메뉴를 클릭하면 현재 동작 중인 추출(Extract) 프로세스와 복제(Replicat) 프로세스들의 목록이 타일 메뉴 형태로 나타나며 "Extract 실행 중" 이라는 타일을 선택합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/92.oci-migration-goldengate-admin-performance-svc-2.png)

- 중간 탭 메뉴 중에서 "데이터베이스 통계" 탭 메뉴를 클릭하고 맨 아래 부분으로 스크롤 다운합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/93.oci-migration-goldengate-admin-performance-svc-database-stastistic-1.png)

- 추출 프로세스가 처리한 테이블과 처리 건수 현황을 나타내게 됩니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/94.oci-migration-goldengate-admin-performance-svc-database-stastistic-2.png)

- SQL Developer 를 통해 SOURCE DB 에 SRC_OCIGGLL 사용자로 PDB 에 접속하여 SQL 실행창에 아래의 Insert 쿼리를 복사 후 붙여넣기를 한 후 SCRIPT 를 실행합니다. (※ INSERT, UPDATE, DELETE 등의 SOURCE DB 변경 후 COMMIT 문 반드시 실행)

    ```sql
    
    Insert into SRC_OCIGGLL.SRC_REGION (REGION_ID,REGION,COUNTRY_ID,COUNTRY) values (1000,'Central Korea',10,'Korea');
    Insert into SRC_OCIGGLL.SRC_REGION (REGION_ID,REGION,COUNTRY_ID,COUNTRY) values (1001,'EastSouth Korea',10,'Korea');

    Insert into SRC_OCIGGLL.SRC_CITY (CITY_ID,CITY,REGION_ID,POPULATION) values (1000,'Seoul',1000,1992823);
    Insert into SRC_OCIGGLL.SRC_CITY (CITY_ID,CITY,REGION_ID,POPULATION) values (1001,'Pusan',1001,1725821);

    COMMIT;

    ```

    ![REG DB](/assets/img/dataplatform/2022/migration/95.oci-migration-sqldeveloper-1.png)

- 이전에 열어 놓은 "성능 측정항목 서비스" 의 데이터베이스 통계 부분에서 SOURCE DB  에 변경한 데이터가 추출되어 복제 처리한 건수가 표시됩니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/96.oci-migration-performance-svc-table-statistics.png)

- SOURCE DB 에 대한 변경 내용이 TARGET DB 에 제대로 반영이 되었는지 데이터 건수를 비교하여 확인합니다. 아래 화면처럼 건수가 동일하여 추출 및 복제가 제대로 잘 수행되고 있는 것을 알 수 있습니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/97.oci-migration-performance-svc-replication-result.png)

<br>

### STEP 12 : Switchover 및 Cleanup

마이그레이션을 완료하고 TARGET DB 쪽으로 Application 전환이 준비되었다면 Switchover 를 수행하여 마이그레이션을 완료합니다. Job 을 Resume 시키면 Switchover 및 마이그레이션 정리 작업을 수행하게 됩니다.

- OCI Console 의 Migration Job 화면으로 돌아가 Job 의 Resume 버튼을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/98.oci-migration-job-resume.png)

    ![REG DB](/assets/img/dataplatform/2022/migration/99.oci-migration-job-resume-2.png)
  
    ![REG DB](/assets/img/dataplatform/2022/migration/100.oci-migration-job-switchover.png)

- Switchover 를 수행하면 GoldenGate 의 Replication 이 멈추게 됨으로써 Switchover 가 완료됩니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/101.oci-migration-goldengate-switchover.png)

- 이 상태는 Application 이 TARGET DB 쪽으로 전환된 상태 및 GoldenGate 의 복제가 멈춰있는 상태이기 때문에 SOURCE DB 에 데이터가 추가되어도 TARGET DB 쪽으로 반영되지 않습니다. 아래 쿼리를 SOURCE DB 의 PDB 에 실행하여 신규 데이터를 입력합니다.

    ```sql
    ALTER SESSION SET CONTAINER='PDB1';
    Insert into SRC_OCIGGLL.SRC_REGION (REGION_ID,REGION,COUNTRY_ID,COUNTRY) values (1002,'WestSouth Korea',10,'Korea');

    COMMIT;
    ```

    ![REG DB](/assets/img/dataplatform/2022/migration/102.oci-migration-goldengate-switchover-check.png)


- SOURCE DB 와 TARGET DB 의 건수를 비교하면 SOURCE DB 에 방금 전 생성한 데이터가 TARGET DB 에 반영되지 않는 것을 확인할 수 있습니다.

    ```sql
    SELECT COUNT(*) FROM SRC_OCIGGLL.SRC_REGION;
    ```

    ![REG DB](/assets/img/dataplatform/2022/migration/103.oci-migration-goldengate-switchover-check-2.png)

- 마지막으로 Cleanup 을 수행해서 마이그레이션을 마무리합니다. Migration Job 화면으로 돌아가 Job 의 Resume 버튼을 클릭합니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/104.oci-migration-migration-job-resume-cleanup.png)

    ![REG DB](/assets/img/dataplatform/2022/migration/105.oci-migration-migration-job-resume-cleanup-2.png)

- Migration Job 의 Cleanup 단계가 마무리되면 아래와 같이 Job 의 상태가 SUCCEEDED 상태로 전환이 됩니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/106.oci-migration-migration-job-resume-cleanup-3.png)

- Cleanup 을 통해 GoldenGate 의 추출, 복제 프로세스가 정리가 되었는지 확인합니다. GoldenGate 서비스의 "성능 측정항목 서비스" 의 관리 서비스 탭을 선택하면 아래와 같이 추출, 복제 프로세스가 모두 정리된 것을 확인할 수 있습니다.

    ![REG DB](/assets/img/dataplatform/2022/migration/107.oci-migration-migration-job-resume-cleanup-4.png)

축하합니다. 이로써 마이그레이션 작업이 모두 완료가 되었습니다. 이렇듯 On-Premise, Clooud 상의 오라클 데이터베이스를 OCI 로 이전할 때 손쉽게 무료로 사용할 수 있는 서비스가 OCI Database Migration 서비스입니다. 

---

