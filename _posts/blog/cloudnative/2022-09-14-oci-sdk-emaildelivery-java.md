---
layout: page-fullwidth
#
# Content
#
subheadline: "Cloud Native"
title: "OCI 전자메일 전송 서비스를 Java 코드를 통해 발송하기 (Javamail)"
teaser: "OCI 전자메일 전송 서비스를 Javamail 라이브러리를 통해 Java 환경에서 이메일 발송 테스트 방법에 대해 알아봅니다."
author: "yhcho"
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, sdk, java, email delivery, dns, javamail]
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
- Java 8, Java 11 또는 Java 17 버전
- Visual Studio Code (실습을 위한 IDE로 사용)
- 실습을 위한 개인 도메인

### 실습 순서
1. 실습 구획 및 정책 생성 - 실습 진행을 위한 구획을 생성합니다.
2. 전자메일 전송 도메인 생성 - 이메일 전송을 위해 전자메일 전송 서비스의 도메인을 생성합니다.
3. DNS 관리에 영역 추가 및 레코드 추가 - 이메일 발송에 사용할 도메인을 DNS 관리 영역에 추가합니다.
4. SMTP 인증을 위한 인증서 생성
5. 소스코드 다운로드 및 수정 후 실행 결과 확인

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
       allow group <group 이름> to manage email-family in compartment <구획 이름>
       allow group <group 이름> to manage email-family in compartment id <구획 OCID>
       allow group <group 이름> to manage dns in compartment <구획 이름>
       allow group <group 이름> to manage dns in compartment id <구획 OCID>
       
       //모든 사용자에게 권한 부여 (구획 이름 또는 OCID로 정책 생성)
       allow any-user to manage email-family in compartment <구획 이름>
       allow any-user to manage email-family in compartment id <구획 OCID>
       allow any-user to manage dns in compartment <구획 이름>
       allow any-user to manage dns in compartment id <구획 OCID>
     ```
   - 정책 작성 **(모든 사용자에게 demo 구획의 전자메일 전송 및 DNS 서비스를 사용할 수 있도록 정책 작성)**
     ```<policyExample>
       Allow any-user to manage email-family in compartment demo
       Allow any-user to manage dns in compartment demo
     ```

   ![Create Policy](/assets/img/infrastructure/2022/09/oci-policy-create-3.png " ")

### 2. 전자메일 전송 도메인 및 DKIM, 승인된 발신자 생성하기

#### 2-1. 전자메일 전송 도메인 생성하기
1. 전체 메뉴에서 **"개발자 서비스 > 애플리케이션 통합 > 전자메일 전송"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
   ![](/assets/img/infrastructure/2022/09/oci-emaildelivery.png " ")
2. 좌측 하단에서 1-1 단계에서 생성한 구획이 선택되어 있는지 확인 후 **"전자메일 도메인 생성"** 버튼을 클릭합니다.
3. 다음과 같이 입력 및 선택하여 전자메일 도메인을 생성합니다.
   - 전자메일 도메인 이름 : **oci-younghwan.xyz** // 개인이 소유한 도메인으로 입력합니다.
   - 구획 : **demo**
   - **전자메일 도메인 생성** 버튼 클릭

   ![](/assets/img/infrastructure/2022/09/oci-emaildelivery-create-1.png " ")
#### 2-2. DKIM 추가하기
1. 전자메일 도메인이 생성되면 좌측 메뉴에서 **DKIM**을 클릭한 후 이동한 화면에서 **"DKIM 추가"** 버튼을 클릭하여 아래와 같이 입력하여 DKIM을 추가 합니다.
    - DKIM 선택기 : **young-ap-seoul-20220914** // `<prefix>-<region short name>-<yyyymmdd> 형식으로 입력`
    - **"DKIM 레코드 생성"** 버튼을 클릭합니다.
    - 자동으로 생성된 레코드 정보 (CNAME 레코드, CNAME 값)을 복사하여 따로 저장해둡니다.
    - **DKIM 생성** 버튼을 클릭하여 DKIM을 생성합니다.

   ![](/assets/img/infrastructure/2022/09/oci-emaildelivery-create-2.png " ")

#### 2-2. 승인된 발신자 생성하기
1. DKIM 생성이 완료되면 전자메일 도메인 세부정보 화면의 좌측 하단에서 **승인된 발신자** 메뉴를 클릭하여 "승인된 발신자 생성"버튼을 클릭합니다.
   ![](/assets/img/infrastructure/2022/09/oci-emaildelivery-create-3.png " ")
2. 발신시 사용할 이메일 주소를 입력 후 "승인된 발신자 생성" 버튼을 클릭합니다.
   ![](/assets/img/infrastructure/2022/09/oci-emaildelivery-create-4.png " ")

### 3. DNS 관리 생성 및 설정하기

#### 3-1. DNS 관리에서 영역 생성하기
1. 전체 메뉴에서 **"네트워킹 > DNS관리"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
   ![](/assets/img/infrastructure/2022/09/oci-dns-management.png " ")
2. DNS 관리 화면에서 좌측 "영역" 메뉴를 클릭 합니다.
3. 좌측 하단에서 1-1 단계에서 생성한 구획이 선택되어 있는지 확인 후 **"영역 생성"** 버튼을 클릭하여 아래와 같이 입력 및 선택하여 영역을 생성 합니다.
    - 메소드 : **수동**
    - 영역 이름 : **oci-younghwan.xyz** // <mark>전자메일 전송 도메인과 동일한 도메인으로 영역을 생성합니다.</mark>
    - 구획에 생성 : **demo** // 1-1 단계에서 생성한 구획
    - **생성** 버튼을 클릭하여 DNS관리 - 영역을 생성합니다.

    ![](/assets/img/infrastructure/2022/09/oci-dns-zone-create-1.png " ")
4. 생성된 영역에서 네임서버 정보를 확인합니다.
    > 도메인을 구입한 사이트에서 해당 도메인의 네임서버 정보를 변경해주어야 합니다.
   
    ![](/assets/img/infrastructure/2022/09/oci-dns-zone-create-2.png " ")

#### 3-2. DNS관리 - 영역의 레코드 생성하기
1. 전자메일 전송 서비스 구성을 위해 DNS관리 - 영역에 레코드를 추가 합니다. (CNAME, TXT)
2. 영역 세부정보 화면 좌측의 **"레코드"** 메뉴를 클릭하여 **"레코드 추가"** 버튼을 클릭하여 아래와 같이 선택 및 입력하여 CNAME 레코드를 추가 합니다.
    - 레코드 유형 : **CNAME - CNAME**
    - 이름 : **DKIM 생성 단계에서 확인했던 CNAME 레코드 정보에서 도메인 부분을 제외하고 붙여넣기 합니다.** // 하단 그림 참조. 도메인은 고정값으로 포함되어 있기 때문에 복사하지 않습니다.
    - TTL 값 : **30** / TTL 단위 : **초**
    - Rdata 모드 : **기본**
    - Target(대상) : **DKIM 생성 단계에서 확인했던 CNAME 값 정보를 붙여넣기 합니다.**
    - **제출** 버튼을 클릭합니다.

    ![](/assets/img/infrastructure/2022/09/oci-dns-zone-record-create-1.png " ")
3. TXT 레코드 추가를 위해 SPF 정보를 확인합니다.
   - 전체 메뉴에서 **"개발자 서비스 > 애플리케이션 통합 > 전자메일 전송"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
   - 전자메일 전송 서비스의 승인된 발신자 화면에서 생성된 발신자 우측 메뉴를 클릭하여 **"SPF 보기"** 버튼을 클릭합니다.
      ![](/assets/img/infrastructure/2022/09/oci-emaildelivery-create-5.png " ")
   - 팝업에서 아시아/태평 전송위치의 SPF 레코드 값을 복사합니다.
      ![](/assets/img/infrastructure/2022/09/oci-emaildelivery-create-6.png " ")
4. 전체 메뉴에서 **"네트워킹 > DNS관리 > 영역"** 메뉴를 클릭하여 서비스 화면으로 이동합니다.
5. **DNS관리 - 영역** 세부정보 화면에서 다시 한번 **"레코드 추가"** 버튼을 클릭하여 TXT 레코드를 추가 합니다.
    - 레코드 유형 : **TXT**
    - 이름 : 입력하지 않음
    - TTL 값 : **30** / TTL 단위 : **초**
    - Rdata 모드 : **기본**
    - Text(텍스트) : **승인된 발신자 단계에서 확인한 텍스트를 붙여넣기 합니다.**
    - **제출** 버튼을 클릭합니다.

    ![](/assets/img/infrastructure/2022/09/oci-dns-zone-record-create-2.png " ")
6. 변경한 정보를 적용하기 위해 "변경사항 게시" 버튼을 클릭하여 변경사항을 게시합니다.
   ![](/assets/img/infrastructure/2022/09/oci-dns-zone-record-create-3.png " ")
7. 모든 설정이 정상적으로 적용되면 아래와 같이 DKIM이 활성화 된것을 확인할 수 있습니다. (SPF는 적용에 시간이 더 걸릴 수 있습니다.)
   ![](/assets/img/infrastructure/2022/09/oci-emaildelivery-create-7.png " ")


### 4. SMTP 인증을 위한 인증서 생성하기
1. 우측 상단 사용자 프로필 아이콘을 클릭 후 "내 프로파일" 메뉴를 클릭합니다.
   ![Create SMTP Cert](/assets/img/infrastructure/2022/09/oci-my-profile.png " ")
2. 아래로 스크롤 한 후 좌측 메뉴 중 **"SMTP 인증서"** 메뉴를 클릭하여 **"인증서 생성"** 버튼을 클릭하여 아래와 같이 입력합니다.
   - 설명 : 이메일 발송 테스트를 위한 인증서 // 인증서는 사용자 계정당 2개까지 생성이 가능합니다.
   - **"인증서 생성"** 버튼을 클릭합니다.

   ![](/assets/img/infrastructure/2022/09/oci-smtp-cert-create-1.png " ")
3. 인증서가 생성 완료되면 사용자 이름과 비밀번호 정보를 확인할 수 있습니다. <mark>이 정보는 다시 표시되지 않기때문에 별도로 잘 보관해야 합니다.</mark>
   ![](/assets/img/infrastructure/2022/09/oci-smtp-cert-create-2.png " ")

### 5. 소스코드 다운로드 및 수정 후 실행 결과 확인
1. VS Code 실행하기 (Visual Studio Code 프로그램이 설치되어 있지 않은 경우 [설치 파일 다운로드](https://code.visualstudio.com/download){:target="_blank" rel="noopener"}로 이동하여 설치 후 진행합니다. Java Project를 실행할 수 있는 별도 IDE가 있는 경우 해당 IDE를 사용하셔도 무관합니다.
2. [다운로드](/assets/files/infrastructure/2022/09/emaildelivery.zip) 링크를 클릭하여 샘플 소스코드 다운받습니다.
3. 다운받은 소스코드의 압축을 해제 후 VSCode에서 해당 폴더를 Open 합니다.
4. 소스코드 설명
   - java/com/example/**OCIemail.java** : Javamail을 라이브러리를 사용하여 OCI Email Delivery 서버를 통해 이메일을 발송하는 샘플 소스 코드 입니다.
5. pom.xml 파일에 Javamail을 사용하기 위해 dependency를 추가 합니다.
```xml
    <dependency>
        <groupId>com.sun.mail</groupId>
        <artifactId>javax.mail</artifactId>
        <version>1.6.2</version>
    </dependency>
```
6. 샘플 소스코드 수정하기
   - 발신자 정보 수정하기
     -  `OCIemail.java` 파일의 <mark>FROM</mark>,<mark>FROMNAME</mark> 변수를 각자에 맞게 변경합니다.
       - FROM : 전자메일 전송 서비스의 승인된 발신자에 생성한 발신자 이메일 주소를 입력합니다.
       - FROMNAME : 이메일을 수신했을때 수신자에게 보여질 발신자 명을 입력합니다.
      ![](/assets/img/infrastructure/2022/09/email-sample-code-change-1.png " ")
   - 수신자 정보 수정하기
      -  `OCIemail.java` 파일의 <mark>TO</mark> 변수를 각자에 맞게 변경합니다.
      - TO : 전자메일을 수신할 수신자 이메일 주소를 입력합니다.
      ![](/assets/img/infrastructure/2022/09/email-sample-code-change-2.png " ")
   - SMTP 인증정보 수정하기
      - `OCIemail.java` 파일의 <mark>SMTP_USERNAME</mark>,<mark>SMTP_PASSWORD</mark> 변수를 각자에 맞게 변경합니다.
      - SMTP_USERNAME : SMTP 인증서 생성 후 확인했던 사용자 이름 정보를 입력합니다.
      - SMTP_PASSWORD : SMTP 인증서 생성 후 확인했던 비밀번호 정보를 입력합니다.
      ![](/assets/img/infrastructure/2022/09/oci-smtp-cert-create-2.png " ")
      ![](/assets/img/infrastructure/2022/09/email-sample-code-change-3.png " ")
   - HOST 정보 수정하기
       - `OCIemail.java` 파일의 <mark>HOST</mark> 변수를 각자에 맞게 변경합니다.
       - 전자메일 전송 서비스의 **구성** 메뉴에서 확인한 Host 정보를 입력합니다.
       - HOST : **smtp.email.ap-seoul-1.oci.oraclecloud.com**
       ![](/assets/img/infrastructure/2022/09/oci-emaildelivery-configuration.png " ")  
       ![](/assets/img/infrastructure/2022/09/email-sample-code-change-4.png " ")
   - 이메일 제목 및 내용 수정하기
       - `OCIemail.java` 파일의 <mark>SUBJECT</mark>,<mark>BODY</mark> 변수를 각자에 맞게 변경합니다.
       - SUBJECT : **OCI EmailDelivery Test**
       - SUBJECT : **변경안함**
       ![](/assets/img/infrastructure/2022/09/email-sample-code-change-5.png " ")
7. 실행하기
   - VS Code의 우측 상단 실행 버튼을 클릭하여 샘플 코드를 실행합니다.
     ![](/assets/img/infrastructure/2022/09/emaildelivery-test-code-1.png " ")
   - 실행 후 터미널에서 결과를 확인합니다.
     ![](/assets/img/infrastructure/2022/09/emaildelivery-test-code-2.png " ")
   - 이메일 수신자 메일상자에서 수신된 이메일을 확인합니다.
     ![](/assets/img/infrastructure/2022/09/emaildelivery-test-code-3.png " ")
   - OCI Console의 전자메일 전송 화면에서도 전송현황을 확인할 수 있습니다.
     ![](/assets/img/infrastructure/2022/09/emaildelivery-test-code-4.png " ")