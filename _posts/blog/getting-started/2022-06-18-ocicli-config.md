---
layout: page-fullwidth
#
# Content
#
subheadline: "Compute"
title: "OCICLI 도구 설정하기"
teaser: "OCI CLI 도구나 SDK를 활용하여 Oracle Cloud Infrastructure (OCI)를 제어하기 위해서는 OCI API를 사용하기 위한 기본 설정을 하여야 합니다. 이번 포스팅에서는 OCI CLI도구를 활용하여 OCI 연동하는 방법에 대해서 설명합니다."
author: dankim
date: 2022-06-18 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, cli]
#published: false

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

### OCI CLI 설치
OCI CLI설치를 위한 오라클사의 공식 가이드는 [https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) 링크를 참고합니다. 해당 가이드에는 여러 운영체에에서 OCICLI를 설치하는 가이드가 포함되어 있는데 여기서는 MacOS를 기준으로 설명합니다.

MacOS에서는 다음곽 같이 HomeBrew를 통해서 설치할 수 있습니다.
```terminal
$ brew update && brew install oci-cli
```

설치 후 다음과 같이 버전을 확인합니다.
```terminal
$ oci --version
```

### OCI CLI 구성
OCI CLI를 구성하기 위해서는 사전에 다음과 같은 정보가 준비되어야 합니다.
* Tenancy OCID 
    ![](/assets/img/getting-started/2022/oci-cli-1.png " ")
* User OCID
    ![](/assets/img/getting-started/2022/oci-cli-2.png " ")

다음 명령어를 실행합니다.
```terminal
$ oci setup config

Enter a location for your config [/Users/username/.oci/config]: 기본선택
Enter a user OCID: <위에서 확인한 User OCID>
Enter a tenancy OCID:: <위에서 확인한 Tenancy OCID>
Enter a region by index or name: <Region> ---> 리전 목록이 같이 보여집니다. OCICLI 접속을 위한 리전을 입력합니다. (e.g. ap-seoul-1)
Do you want to generate a new API Signing RSA key pair? (If you decline you will be asked to supply the path to an existing key.) [Y/n]: Y ---> OCI와 연동하기 위해서 필요한 PEM 키를 생성합니다.
```

생성된 PEM키와 대응되는 공용키, config 파일이 위에서 지정한 경로에 생성됩니다. 생성된 PEM 공용키 등록을 위하여 오른쪽 상단의 **사용자 프로파일**을 클릭한 후 왼쪽 **API 키 > API 키 추가**를 순서대로 클릭합니다. 다음 화면과 같이 생성된 PEM 공용키를 선택하고 **추가**를 클릭합니다.

![](/assets/img/getting-started/2022/oci-cli-3.png " ")

### OCI CLI 연결 확인
다음 명령어는 OCI의 Object Storage의 Namespace 값을 가져오는 OCICLI 명령입니다. 실행했을 때 오류 없이 다음과 비슷한 결과가 나오면 성공입니다. 
```terminal
$ oci os ns get
{
  "data": "cnrgtqg..."
}
```