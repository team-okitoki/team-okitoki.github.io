---
layout: page-fullwidth
#
# Content
#
subheadline: "Storage"
title: "OCI ObjectStorage 에 Java SDK를 사용하여 파일 업로드하기"
teaser: "OCI Java SDK를 이용하여 OCI ObjectStorage Bucket에 파일을 업로드하는 방법에 대해 알아봅니다."
author: "yhcho"
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, sdk, java, object storage]
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

### OCI Java SDK를 사용하기 위한 요구사항 확인하기
OCI Java SDK를 사용하기 위해서는 아래와 같이 사전에 준비해야할 사항이 있습니다.
- Oracle Cloud Infrastructure (OCI) 계정
- 테넌시 전체 또는 사용할 구획에 IAM 정책을 작성할 수 있는 권한이 있는 그룹에 속한 사용자여야 합니다.
- OCI의 사용자 프로파일에 업로드된 API 키 쌍이 필요합니다. API를 호출하기 위해 개인키를 소유해야 합니다.
- Java 8, Java 11 또는 Java 17 버전
- Visual Studio Code (실습을 위한 IDE로 사용)

#### 필요한 라이브러리
OOCI SDK를 사용하기 위해 Java Project에서 아래와 같이 라이브러리를 추가해야 합니다.

**<mark>pom.xml 작성예시...</mark>**
```<pom.xml작성예시>
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.oracle.oci.sdk</groupId>
            <artifactId>oci-java-sdk-bom</artifactId>
            <!-- replace the version below with your required version -->
            <version>1.5.2</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
<dependencies>
    <dependency>
        <groupId>com.oracle.oci.sdk</groupId>
        <artifactId>oci-java-sdk-audit</artifactId>
    </dependency>
    <dependency>
        <groupId>com.oracle.oci.sdk</groupId>
        <artifactId>oci-java-sdk-core</artifactId>
    </dependency>
    <dependency>
        <groupId>com.oracle.oci.sdk</groupId>
        <artifactId>oci-java-sdk-database</artifactId>
    </dependency>
    <!-- more dependencies if needed -->
</dependencies>
```

### 실습 순서
1. 실습 구획 및 정책 생성 - 실습 진행을 위한 구획을 생성합니다.
2. Object Storage 생성 - 파일이 업로드될 Object Storage를 생성합니다.
3. API키 쌍 생성(또는 등록) - API 호출에 사용할 API 키쌍을 생성하거나 기존에 보유하고 있는 키를 업로드 합니다.
4. 실습 소스코드 수정 및 실행 후 결과 확인하기

### 1. 실습 구획 및 정책 생성하기
실습을 진행하기 위해 새로운 구획을 생성하고 해당 구획의 bucket에 접근하기 위한 정책을 작성합니다.

#### 1-1. 구획 생성하기
1. 전체 메뉴에서 **"ID & 보안 > ID > 구획"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
   ![Compartment](/assets/img/infrastructure/2022/09/oci-compartment.png " ")
2. "구획 생성" 버튼을 클릭합니다.
   ![Compartment Screen](/assets/img/infrastructure/2022/09/oci-compartment-create-1.png " ")
3. 아래와 같이 입력 및 선택하여 구획을 생성합니다.
    - 이름 : **demo**
    - 설명 : **OCI SDK Demo 실습을 위한 구획 입니다.**
    - 상위 구획 : **루트 구획 또는 특정 구획 선택**
    - **구획 생성(Create Compartment)** 클릭
   
   ![Compartment Screen](/assets/img/infrastructure/2022/09/oci-compartment-create-2.png " ")

#### 1-2. 정책 생성하기
본 포스팅에서는 IAM 및 정책에 관련한 자세한 내용을 다루지 않습니다. 자세한 내용은 아래 포스팅을 참고해 주세요
> [OCI에서 사용자, 그룹, 정책 관리하기](/getting-started/adding-users/){:target="_blank" rel="noopener"}

1. 전체 메뉴에서 **"ID & 보안 > ID > 정책"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
   ![Create Policy](/assets/img/infrastructure/2022/09/oci-policy.png " ")
2. 좌측 하단에서 1-1 단계에서 생성한 구획이 선택되어 있는지 확인 후 "정책 생성" 버튼을 클릭합니다.
   ![Create Policy](/assets/img/infrastructure/2022/09/oci-policy-create-1.png " ")
3. 이동한 화면에서 아래와 같이 입력 및 선택하여 정책을 작성합니다.
   - 이름 : **policyForDemo**
   - 설명 : **Demo 진행을 위한 정책 입니다.**
   - 구획 : **1-1 에서 생성한 demo 구획 선택**
   - 정책 작성기 섹션에서 **수동 편집기 표시** 옵션을 클릭하여 활성화
   - 정책 작성 예시
     ```<policyExample>
       //특정 그룹에게 권한 부여 (구획 이름 또는 OCID로 정책 생성)
       allow group <group 이름> to manage object in compartment <구획 이름>
       allow group <group 이름> to manage object in compartment id <구획 OCID>
       allow group <group 이름> to manage bucket in compartment <구획 이름>
       allow group <group 이름> to manage bucket in compartment id <구획 OCID>
       
       //모든 사용자에게 권한 부여 (구획 이름 또는 OCID로 정책 생성)
       allow any-user to manage object in compartment <구획 이름>
       allow any-user to manage object in compartment id <구획 OCID>
       allow any-user to manage bucket in compartment <구획 이름>
       allow any-user to manage bucket in compartment id <구획 OCID>
     ```
   - 정책 작성 **(모든 사용자에게 demo 구획의 버킷을 사용할 수 있도록 정책 작성)**
     ```<policyExample>
       allow any-user to manage object in compartment demo
       allow any-user to manage bucket in compartment demo
     ```

   ![Create Policy](/assets/img/infrastructure/2022/09/oci-policy-create-2.png " ")

### 2. Object Storage 생성하기
파일 업로드 실습을 진행하기 위해 OCI Console에서 Object Storage를 생성합니다.
1. 전체 메뉴에서 **"스토리지 > 오브젝트 스토리지 및 아카이브 스토리지 > 버킷"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
   ![Create bucket](/assets/img/infrastructure/2022/09/oci-bucket.png " ")
2. 좌측 하단에서 1-1 단계에서 생성한 구획이 선택되어 있는지 확인 후 **"버킷 생성"** 버튼을 클릭합니다.
3. 다음과 같이 입력 및 선택하여 버킷을 생성합니다.
   - 버킷 이름 : **bucket-sdk-demo**
   - 기본 스토리지 계층 : **표준**
   - 암호화 : **오라클 관리 키를 사용하여 암호화**
   - **생성** 버튼 클릭

   ![Create bucket](/assets/img/infrastructure/2022/09/oci-bucket-create-1.png " ")
4. 생성된 버킷의 상세보기 화면에서 네임스페이스 정보를 확인합니다. (추후 소스코드에 입력 필요)
   ![Create bucket](/assets/img/infrastructure/2022/09/oci-bucket-create-2.png " ")

### 3. API키 쌍 생성
SDK 설정을 위한 API키를 생성합니다.
1. 우측 상단 사용자 프로필 아이콘을 클릭 후 "내 프로파일" 메뉴를 클릭합니다.
   ![Create API KEY](/assets/img/infrastructure/2022/09/oci-my-profile.png " ")
2. 이동한 화면에서 아래로 약간 스크롤하여 좌측 하단에서 API 키 메뉴를 클릭합니다.
3. API 등록 버튼을 클릭하여 새로운 키 쌍 등록을 선택하여 전용 키, 공용 키를 모두 다운로드 합니다.
   ![Create API KEY](/assets/img/infrastructure/2022/09/oci-api-key-create-1.png " ")
4. 생성 후 API Key 목록 우측의 메뉴에서 **"구성 파일 보기"** 메뉴를 클릭합니다.
   ![Create API KEY](/assets/img/infrastructure/2022/09/oci-api-key-create-2.png " ")
5. 구성 파일 미리보기 팝업에서 추후 SDK 설정시 필요한 정보를 확인합니다.
   ![Create API KEY](/assets/img/infrastructure/2022/09/oci-api-key-create-3.png " ")

### 4. 소스코드 수정 및 실행 후 결과 확인하기
1. VS Code 실행하기 (Visual Studio Code 프로그램이 설치되어 있지 않은 경우 [설치 파일 다운로드](https://code.visualstudio.com/download){:target="_blank" rel="noopener"}로 이동하여 설치 후 진행합니다. Java Project를 실행할 수 있는 별도 IDE가 있는 경우 해당 IDE를 사용하셔도 무관합니다.
2. [다운로드](/assets/files/infrastructure/2022/09/objectstorage.zip) 링크를 클릭하여 샘플 소스코드 다운받습니다.
3. 다운받은 소스코드의 압축을 해제 후 VSCode에서 해당 폴더를 Open 합니다.
4. 소스코드 설명
   - java/com/example/**AuthenticationProvider.java** : SDK 사용을 위한 인증을 수행하는 Class (Config 방식을 사용하면 사용하지 않습니다.)
   - java/com/example/**UploadObjectExample.java** : Config 파일을 로컬에 생성하여 인증을 수행 후 Object Storage에 파일을 업로드 하는 샘플 코드
   - java/com/example/**UploadObjectExampleWithAuthProv.java** : Class를 통해 인증을 수행 후 Object Storage에 파일을 업로드 하는 샘플 코드
   - resource/**config** : AuthenticationProvider Class 에서 사용하는 Config 파일 예시
   - resource/**config_sample** : 로컬에 .oci/config 파일에 작성하는 Config 파일 예시
   - resource/**oci_api_key.pem** : AuthenticationProvider Class 에서 사용하는 전용 키 파일 예시
5. SDK를 사용하기 위한 인증 방식
   - 로컬 경로의 .oci/config 파일을 생성하여 인증을 진행하는 방식
     - API키 추가 단계에서 확인했던 구성 파일 미리보기 정보를 로컬의 특정 경로에 저장하여 인증을 수행하는 방식
     - 일반적으로 OS별로 로그인한 사용자의 Home 디렉토리 하위에 아래와 같이 생성함
     - `<home경로>/.oci/config`
     ```<configExample>
     [DEFAULT]
     user=<구성파일 미리보기에서 확인한 사용자의 OCID>
     fingerprint=<구성파일 미리보기에서 확인한 API 키의 fingerprint>
     key_file=~/.oci/oci_api_key.pem <OS에 맞게 실제 키 파일 경로로 변경>
     tenancy=<구성파일 미리보기에서 확인한 테넌시의 OCID>
     region=ap-seoul-1 <실제 실습을 진행할 Region 선택>
     ```
   - Authentication Provider 클래스를 작성하여 인증을 진행하는 방식
     - API키 추가 단계에서 확인했던 구성 파일 미리보기 정보를 Java Project의 Resource 폴더에 저장하여 인증을 수행하는 방식
     - /resources 폴더 하위에 config 파일과 전용키 파일을 저장하여 인증을 수행합니다.
     - `<Project 경로>/src/main/resources/config`
     ```<configExample>
     [DEFAULT]
     user=<구성파일 미리보기에서 확인한 사용자의 OCID>
     fingerprint=<구성파일 미리보기에서 확인한 API 키의 fingerprint>
     tenancy=<구성파일 미리보기에서 확인한 테넌시의 OCID>
     region=ap-seoul-1 <실제 실습을 진행할 Region 선택>
     ```
6. 샘플 소스코드 수정하기
   - Config 파일 경로 및 프로파일 정보 수정하기
     - 로컬에 있는 Config 파일을 사용할 경우 `UploadObjectExample.java` 파일의 <mark>configurationFilePath</mark>,<mark>profile</mark> 변수를 각자 환경에 맞게 변경합니다.
       - configurationFilePath : config 파일의 경로 설정
       - profile : config 파일의 프로파일 선택 (하나이상의 프로파일이 있는 경우 수정 필요, 기본적으로는 DEFAULT)
      ![](/assets/img/infrastructure/2022/09/sample-code-change-1.png " ")
   - 오브젝트 스토리지 Namespace 및 버킷 정보 수정하기
     - 버킷 생성단계에서 확인했던 Object Storage 네임스페이스정보를 `UploadObjectExample.java`,`UploadObjectExampleWithAuthProv.java` 파일의 <mark>namespaceName</mark> 변수에 지정합니다.
     - 버킷 이름을 `UploadObjectExample.java`,`UploadObjectExampleWithAuthProv.java` 파일의 <mark>bucketName</mark> 변수에 지정합니다.
      ![](/assets/img/infrastructure/2022/09/oci-bucket-create-2.png " ")
      ![](/assets/img/infrastructure/2022/09/sample-code-change-2.png " ")
   - 로컬에서 업로드할 파일 정보 수정하기
     - **objectName** : 실제 OCI 오브젝트 스토리지에 업로드 될 이름
     - **contentType** : 업로드할 파일의 컨텐츠 타입
     - **body** : 로컬에 위치한 업로드할 파일의 경로
      ![](/assets/img/infrastructure/2022/09/sample-code-change-3.png " ")
7. 실행하기
   - VS Code의 우측 상단 실행 버튼을 클릭하여 샘플 코드를 실행합니다.
     ![](/assets/img/infrastructure/2022/09/objectstorage-test-code-1.png " ")
   - 실행 후 터미널에서 결과를 확인합니다.
     ![](/assets/img/infrastructure/2022/09/objectstorage-test-code-2.png " ")
   - OCI Console에 접속하여 bucket에 정상적으로 업로드 되었는지 확인합니다.
     ![](/assets/img/infrastructure/2022/09/objectstorage-test-code-3.png " ")