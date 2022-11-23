---
layout: page-fullwidth
#
# Content
#
subheadline: "Multi Cloud"
title: "Oracle Database Service for Azure 연결한 Multi Cloud 설정 삭제하기"
teaser: "ODSA 서비스를 통해 연결된 설정을 OCI와 Azure에서 삭제하는 방법에 대해 알아봅니다."
author: yhcho
breadcrumb: true
categories:
  - dataplatform
tags:
  - [oci, odsa, azure, interconnect, database, unlink, multicloud]
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
> [Oracle Database Service for Azure 소개](/dataflatform/oracle-database-service-for-azure/)

### ODSA를 통해 설정된 Multi Cloud 연결을 해제하기 위한 사전 준비사항
> 본 예제는 MacOS 기준으로 작성되었습니다.

#### Microsoft Azure 준비사항
- ODSA 서비스가 연결된 계정 정보

#### Oracle Cloud Infrastructure 준비사항
- OCI CLI 실행을 위한 API 키 등록
- OCI CURL 설정 진행

### OCI 사용자 상세화면에서 API 키 등록하기
1. OCI 콘솔에 접속 후 우측 상단 **"프로파일"** 아이콘을 클릭 후 **"내 프로파일"** 메뉴를 클릭합니다.
   ![Regist API Key #1](/assets/img/dataplatform/2022/odsa-regist-api-key-1.png)
2. 이동한 화면에서 좌측 하단 **"API 키"** 메뉴를 클릭 후 **"API 키 추가"** 버튼을 클릭하여 API키를 다운로드 받거나, 기존 키를 업로드 후 **"추가"** 버튼을 클릭하여 API키를 등록합니다.
   ![Regist API Key #2](/assets/img/dataplatform/2022/odsa-regist-api-key-2.png)
3. 등록 후 등록된 정보를 복사해 둡니다. `(복사한 정보는 OCI CURL 설정시 사용합니다.)`
   ![Regist API Key #3](/assets/img/dataplatform/2022/odsa-regist-api-key-3.png)

### OCI CURL 스크립트 다운로드 및 설정하기
1. [oci-curl.sh.zip](/assets/files/dataplatform/2022/oci-curl.sh.zip) 링크를 클릭하여 oci-curl.sh 압축 파일을 다운로드 하여 압축을 해제합니다.
2. <mark>oci-curl.sh</mark> 파일 상단에 아래 변수에 API 키 등록 후 확인했던 값들을 변수에 설정하여 줍니다.
   ![Setup oci-curl #1](/assets/img/dataplatform/2022/odsa-oci-curl-setup-1.png)
3. 아래 명령어를 입력 후 실행하여 줍니다. _(참고로 아래 명령어는 아무결과도 반환되지 않습니다. "invalid method"가 나오는 경우 oci-curl.sh 파일을 다시 확인해야 합니다.'오타, 등등')_
   ```
    $ cd <oci-curl.sh 파일이 위치한 경로>
    $ source oci-curl.sh
    $ bash oci-curl.sh
   ```
4. OCI 콘솔의 "ID & 보안" > "ID" > "구획" 메뉴로 이동하여 Root 구획의 OCID를 복사합니다.
   ![Setup oci-curl #2](/assets/img/dataplatform/2022/odsa-oci-curl-setup-2.png)
5. oci-curl 파일이 위치한 경로에서 아래 구조로 명령어를 조합하여 실행 후 결과를 확인합니다.<br>
   **jq가 설치되어 있지 않은 경우 마지막 '| jq' 는 생략 가능합니다.**<br>
   <mark>$ oci-curl mchub-cloud-link.ap-seoul-1.oci.oraclecloud.com get "/20220401/cloudLinks?compartmentId=<루트 구획 OCID>&lifecycleState=ACTIVE" | jq</mark>
   ![Setup oci-curl #3](/assets/img/dataplatform/2022/odsa-oci-curl-setup-3.png)
6. 위 OCI CURL을 통해 확인된 정보는 추후 cloudLink 를 삭제하는데 사용됩니다.
   
### ODSA 서비스 연결 해제하기
#### Azure 리소스 삭제하기
1. Azure Portal로 이동하여 Enterprise applications 서비스로 이동합니다.
   ![ODSA Unlink Multicloud #1](/assets/img/dataplatform/2022/oracle-odsa-unlink-multicloud-1.png)
2. Application 목록에서 `Oracle Database Service`를 클릭합니다.
   ![ODSA Unlink Multicloud #2](/assets/img/dataplatform/2022/oracle-odsa-unlink-multicloud-2.png)
3. 하단의 What's New 섹션에서 **"Delete Application has moved to Properties"** 의 **"View Properties"** 링크를 클릭합니다.
   ![ODSA Unlink Multicloud #3](/assets/img/dataplatform/2022/oracle-odsa-unlink-multicloud-3.png)
4. 이동 화면 상단의 **"Delete"** 버튼을 클릭하여 리소스를 삭제합니다.
   ![ODSA Unlink Multicloud #4](/assets/img/dataplatform/2022/oracle-odsa-unlink-multicloud-4.png)
5. Azure에서 ODSA 서비스 연결은 삭제 완료되었습니다.

#### OCI 리소스 삭제하기
위 OCI CURL 설정이 정상적으로 완료되었다면, cloudlink에 대한 ID를 확인할 수 있습니다. 그 정보를 이용하여 아래와 같이 명령어를 조합 하여 cloudlink 리소스를 삭제할 수 있습니다.<br>
<mark>$ oci-curl mchub-cloud-link.ap-seoul-1.oci.oraclecloud.com delete "/20220401/cloudLinks/<CloudLink ID를 입력합니다.>" | jq</mark>
- 삭제 명령 실행 후 조회를 다시한번 수행해보면 정상적으로 삭제된 것을 확인할 수 있습니다.
  ![ODSA Unlink Multicloud #5](/assets/img/dataplatform/2022/oracle-odsa-unlink-multicloud-5.png)

