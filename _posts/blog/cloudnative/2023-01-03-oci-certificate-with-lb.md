---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI Certificates - OCI 인증서 서비스에 등록한 인증서를 Application Load Balancer에 적용하기"
teaser: "OCI 인증서 서비스에 등록된 인증서를 Application Load Balancer에 적용하는 방법에 대해 알아봅니다"
author: yhcho
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, certificates, load balancer, lb, application load balancer, ssl, l7, oci certificate, oci loadbalancer, loadbalancer]
#
# Styling
#
header: no
#  image:
#    title: /assets/img/cloudnative-security/2022/weblogic_oke_0.png
#     thumb: /assets/img/cloudnative-security/2022/weblogic_oke_0.png
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

### OCI Certificates 소개
OCI Certificates 서비스를 처음 접하시거나 자세한 내용이 궁금하신 경우 아래 포스팅을 통해 서비스 내용을 확인해보세요.
> [OCI Certificates 서비스 살펴보기](/cloudnative/oci-certificate-overview/){:target="_blank" rel="noopener"}

### Let's Encrypt 인증서 발급 안내
Let's Encrypt 인증서 발급 방법 및 OCI 인증서 서비스에 등록하기 위한 자세한 내용이 궁금하신 경우 아래 포스팅을 통해 서비스 내용을 확인해보세요.
> [OCI Certificates - Let’s Encrypt로 생성한 인증서를 OCI 인증서 서비스에 Import 하기](/cloudnative/oci-certificate-import-letsencrypt-cert/){:target="_blank" rel="noopener"}

### OCI 인증서를 OCI Load Balancer(Application)에 적용 실습 안내
이전 포스팅 (Let's Encrypt)의 내용을 성공적으로 진행하셨다면, 등록한 인증서를 OCI 서비스중 LB에 연결하기 위한 과정을 소개하기 위한 내용을 준비하였습니다.
일반적인 VM위에 웹서버를 설치하고 간단한 페이지를 생성한 후 LB를 생성하여 SSL 도메인 인증서를 적용하는 실습을 진행합니다.
마지막으로 http로 호출한 요청을 https로 리다이렉트하는 설정 방법을 소개 드릴 예정입니다.

#### 사전 준비 사항
- Public Domain 구입
- Let's Encrypt 인증서 발급
- OCI 인증서 서비스에 인증서 등록

#### 실습 순서
1. 실습 Compartment 생성
2. 실습 Virtual Cloud Network(VCN) 생성
3. Compute Instance 생성 및 웹서버 설치
4. Application Load Balancer 생성 및 설정하기
5. OCI DNS 서비스에서 Record 생성하기
6. 도메인을 접속 및 인증서 적용 확인
7. OCI 로드밸런서에서 http - https 리다이렉트 구성하기


#### 1. 실습 Compartment 생성
1. 좌측 상단의 **햄버거 아이콘**을 클릭하고, **ID & 보안(Identity & Security)**을 선택한 후 **구획(Compartments)**을 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-compartment.png " ")
2. 이동한 화면에서 "구획 생성" 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-compartment-create-1.png " ")
3. 다음과 같이 입력하여 실습 구획을 생성합니다.
    - Name: Enter **oci-demo**
    - Description: **OCI 실습 진행을 위한 구획입니다.**
    - Parent Compartment: **루트 구획 또는 특정 구획 선택**
    - **구획 생성(Create Compartment)** 클릭

   ![](/assets/img/cloudnative/2023/certificate-lb/oci-compartment-create-2.png " ")

#### 2. 실습 Virtual Cloud Network(VCN) 생성
1. 전체 메뉴를 클릭하여 **"네트워킹"** -> **"가상 클라우드 네트워크"** 를 클릭하여 가상 클라우드 네트워크 메뉴로 이동합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-3.png " ")
2. **"VCN 마법사 시작"** 버튼을 클릭하여 **"인터넷 접속을 통한 VCN 생성"** 을 선택 후 **"VCN 마법사 시작"** 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-4.png " ")
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-5.png " ")
3. 다음과 같이 입력하여 VCN을 생성합니다.
    - VCN 이름 : **my-vcn**
    - 구획 : 1단계에서 생성한 구획으로 지정합니다. oci-demo
    - "다음" 버튼 클릭하여 내용 확인 후 "생성" 버튼 클릭하여 VCN 생성

   ![](/assets/img/cloudnative/2022/opensearch/opensearch-6.png " ")
   ![](/assets/img/cloudnative/2022/opensearch/opensearch-7.png " ")

#### 3. Compute Instance 생성 및 웹서버 설치
##### Task 1: Compute Instance 생성
1. 좌측 상단의 **햄버거 아이콘**을 클릭하고, **컴퓨트(Compute)**을 선택한 후 **인스턴스(Instances)**를 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-compute-instance.png " ")

2. 왼쪽 하단에 구획을 확인하고 **인스턴스 생성(Create instance)**버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-compute-instance-create-1.png " ")

3. 인스턴스 이름과 구획을 선택 합니다
   - 이름: Enter **demoWebserver**
   - 구획에 생성: **oci-demo**
   - 가용성 도메인 : **AP-SEOUL-1-AD-1 (Seoul 리전 기준)**
     ![](/assets/img/cloudnative/2023/certificate-lb/oci-compute-instance-create-2.png " ")

4. 설치할 이미지와 Instance의 Shape을 선택 합니다.
   - Image : **Oracle Linux8 - 2022.12.15-0**
   - Shape : **VM.Standard.E4.Flex (1 OCPU, 16 GB Memory)**
     ![Compute Create #2](/assets/img/cloudnative/2023/certificate-lb/oci-compute-instance-create-3.png " ")

5. 네트워크 관련 옵션을 선택 합니다
   - Virtual cloud network : **my-vcn**
   - Subnet : **공용 서브넷-my-vcn**
   - Public IP address : **공용 IPv4 주소 지정**
     ![Compute Create #3](/assets/img/cloudnative/2023/certificate-lb/oci-compute-instance-create-4.png " ")

6. VM에 접속할때 사용할 SSH Keys 추가 합니다.
   - 이번 실습에서는 **자동으로 키 쌍 생성** 를 선택 후 전용 키, 공용 키를 다운받아 잘 보관 합니다.
   - Boot volume 관련 옵션은 기본 설정을 유지 합니다.
     ![Compute Create #4](/assets/img/cloudnative/2023/certificate-lb/oci-compute-instance-create-5.png " ")
7. **Create** 버튼을 클릭 후 생성
   - 생성 후 Running 상태를 확인 합니다
     ![Compute Create #6](/assets/img/cloudnative/2023/certificate-lb/oci-compute-instance-create-6.png " ")

##### Task 2: Compute Instance 접속

- Windows 사용자 (PuttyGen , Putty 사용)
   - PuTTYgen을 실행합니다
   - **Load** 를 클릭 하고 인스턴스를 생성할 때 생성된 프라이빗 키를 선택합니다. 키 파일의 확장자는 **.key**
   - **Save Private Key** 를 클릭 합니다.
   - 키파일의 이름을 지정 합니다. (개인 키의 확장자는 **.ppk**로 저장합니다)
   - **Save** 를 클릭합니다.
   - 새로운 키 파일을 이용하여 인스턴스에 접속 합니다.
   - 상세내용은 링크를 통해 확인 가능 합니다. [접속 가이드 링크](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/accessinginstance.htm#linux__putty)
- MacOS 사용자
   - 다운로드 받은 키파일의 권한을 조정합니다.
     ```terminal
        chmod 400 <private_key_file> #엑세스 하려는 키 파일의 전체 경로 와 이름을 입력합니다.
     ```
   - 다음 명령어를 입력하여 인스턴스에 접속합니다.
     ```terminal
        ssh -i <private_key_file> opc@<public-ip-address>
     ```

##### Task 3: OCI 보안목록 (Security List) 설정

1. VCN 목록에서 생성한 **my-vcn**을 클릭 상세보기 창으로 이동합니다.
   ![VCN Screen](/assets/img/cloudnative/2023/certificate-lb/oci-vcn-security-list-create-1.png " ")

2. VCN 상세보기 화면에서 하단 Subnet 목록중 **공용 서브넷-my-vcn**을 클릭 합니다.
   ![VCN Screen](/assets/img/cloudnative/2023/certificate-lb/oci-vcn-security-list-create-2.png " ")

3. Subnet 상세보기 화면에서 하단 Security Lists 목록중 **Default Security List for my-vcn**을 클릭 합니다.
   ![VCN Screen](/assets/img/cloudnative/2023/certificate-lb/oci-vcn-security-list-create-3.png " ")

4. **수신 규칙 추가** 버튼을 클릭 합니다.
   ![VCN Screen](/assets/img/cloudnative/2023/certificate-lb/oci-vcn-security-list-create-4.png " ")

5. 다음과 같이 입력:
   - Source Type : **CIDR** (기본값)
   - Source CIDR : Enter **0.0.0.0/0**
   - IP Protocol : **TCP** (기본값)
   - Destination Port Range : **80, 443**
   - Description : **httpd 실습을 위한 http, https 서비스 Port 허용 정책**
   - **수신 규칙 추가** 클릭
     ![VCN Screen](/assets/img/cloudnative/2023/certificate-lb/oci-vcn-security-list-create-5.png " ")

##### Task 4: Apache httpd 서버 설치 및 접속 확인
1. Install Apache httpd 서버
      ```terminal
         sudo yum install httpd -y
      ```

2. Apache 서버 시작 및 재부팅시 자동으로 서비스가 활성화 되도록 설정 합니다.
      ```terminal
         sudo apachectl start
         sudo systemctl enable httpd
      ```
3. Apache 설정 테스트 명령을 실행합니다.
      ```terminal
         sudo apachectl configtest
      ```

4. 아래 명령어를 입력하여 웹 브라우저에서 확인할 index.html 파일을 생성합니다.
      ```terminal
         sudo bash -c 'echo This is my Web-Server running on Oracle Cloud Infrastructure >> /var/www/html/index.html'
      ```

   ![install Apache httpd server](/assets/img/cloudnative/2023/certificate-lb/oci-compute-install-httpd.png " ")

5. OS 방화벽 사용 해제
   기본으로 OS에 적용되어 있는 방화벽을 중지 시키기 위해 아래 명령어를 순차적으로 입력 합니다.
      ```terminal
      sudo systemctl disable firewalld
      sudo systemctl stop firewalld
      ```
6. 웹서버 접속 및 응답 확인
   인스턴스의 공용 IP로 접속하여 생성한 index.html파일의 내용을 브라우저에서 확인합니다.

   ![install Apache httpd server](/assets/img/cloudnative/2023/certificate-lb/oci-compute-install-httpd-2.png " ")

#### 4. Application Load Balancer 생성 및 설정하기
1. 좌측 상단의 **햄버거 아이콘**을 클릭하고, **네트워킹(Networking)**을 선택한 후 **로드 밸런서(Load Balancer)**를 클릭합니다.
   ![Load Balancer Menu](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-1.png " ")
2. 이동한 화면에서 현재 구획을 확인 후 **로드 밸런서 생성** 버튼을 클릭합니다.
   ![Load Balancer Create - 1](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-2.png " ")
3. 로드 밸런서 유형 선택 화면에서 상단의 Layer-7 **로드 밸런서**를 선택 후 **로드 밸런서 생성** 버튼을 클릭합니다.
   ![Load Balancer Create - 2](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-3.png " ")
4. 로드 밸런서 생성 화면에서 아래와 같이 입력 및 선택 합니다.
    - 로드 밸런서 이름: **lb_demo**
    - 가시성 유형 선택: **공용**
    - 공용 IP 주소 지정 : **임시 IP 주소** / 예약된 IP 주소를 사용하려면 사전에 예약된 IP 생성 필요
      ![Load Balancer Create - 3](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-4.png " ")
5. 대역폭 구성은 기본값으로 구성합니다. 
    - **최소/최대 10Mbps**)
    - 가상 클라우드 네트워크: **vcn-oci-basic**
    - 가시성 유형 선택: **공용 서브넷-vcn-oci-basic**
    - **다음** 버튼을 클릭합니다.
      ![Load Balancer Create - 1](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-5.png " ")
6. 백엔드 선택 단계에서 아래와 같이 선택합니다.
    - 로드 밸런싱 정책 지정: **라운드 로빈(가중치 사용)**
7. **백엔드 추가** 버튼을 클릭하여 전단계에서 생성한 인스턴스를 선택합니다.
   ![Load Balancer Create - 1](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-6.png " ")
8. 건정성 검사 정책 지정 단계에서는 기본값을 그대로 사용 합니다.
   ![Load Balancer Create - 1](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-7.png " ")
9. 리스너 구성 화면에서 아래와 같이 입력 및 선택 합니다.
   - 리스너 이름: **기본값 사용**
   - 리스너가 처리하는 트래픽의 유형 지정: **HTTPS**
   - 수신 트래픽에 대해 리스너가 모니터하는 포트 지정: **443**
   - SSL 인증서 섹션
     - 인증서 리소스 : 인증서 서비스 관리 인증서
     - [구획]의 인증서 : Let's Encrypt로 생성하고 등록한 인증서 선택
   - **다음** 버튼을 클릭합니다.
     ![Load Balancer Create - 1](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-8.png " ")
10. 로깅 관리 설정 단계에서 아래와 같이 오류 & 엑세스 로그를 모두 사용함으로 설정하고 **제출** 버튼을 클릭하여 Load Balancer를 생성합니다.
    ![Load Balancer Create - 1](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-9.png " ")
11. 확인한 공용 IP로 웹브라우저를 통해 접속을 확인합니다.
    ![Load Balancer Create - 1](/assets/img/cloudnative/2023/certificate-lb/oci-loadbalancer-10.png " ")

#### 5. OCI DNS 서비스에서 Record 생성하기
1. 좌측 상단의 **햄버거 아이콘**을 클릭하고, **네트워킹(Networking)**을 선택한 후 **DNS관리**를 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-certificate-dns.png " ")
2. DNS관리에서 기존에 생성한 영역을 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-certificate-dns-1.png " ")
3. **"레코드 추가"** 버튼을 클릭합니다
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-certificate-dns-2.png " ")
4. 아래와 같이 선택 및 입력 하여 레코드를 추가합니다.
    - 레코드 유형 : **A - IPv4 주소**
    - 이름 : demosite
    - TTL : 30 , 단위 : 초
    - Rdata 모드 : 기본
    - Address(주소) : <mark>로드 밸런서의 Public IP 주소를 등록합니다.</mark> // 129.154.205.69
     ![](/assets/img/cloudnative/2023/certificate-lb/oci-certificate-dns-3.png " ")
5. **"변경사항 게시"** 버튼을 클릭하여 생성한 레코드를 게시합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-certificate-dns-4.png " ")

#### 6. 도메인을 접속 및 인증서 적용 확인
1. 생성한 레코드가 적용되기 위해 1~2분을 기다려 줍니다.
2. 생성한 도메인을 브라우저에서 입력하여 접속합니다.
3. 정상적으로 접속됨을 확인합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-certificate-dns-5.png " ")
4. 인증서도 정상적으로 적용된것을 확인할 수 있습니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-certificate-dns-6.png " ")

#### 7. OCI 로드밸런서에서 http - https 리다이렉트 구성하기

##### Task 1: OCI 로드밸런서 http 리스너 생성 및 접속 테스트
1. http 리스너를 추가로 생성하기 위해 (4) 단계에서 생성한 로드밸런서 세부정보 화면으로 이동합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-1.png " ")
2. 좌측 하단 리소스 패널에서 "리스너"를 클릭하고 "리스너 생성" 버튼을 클릭하여 아래와 같이 입력 및 선택하여 리스너를 생성합니다.
   - 이름 : **listener_http**
   - 프로토콜 : **HTTP**
   - 포트 : **80**
   - 백엔드 집합 : **기존에 생성되어 있는 백엔드 집합 선택**
   - <mark>나머지 옵션을 입력하지 않습니다.</mark>
   - **"리스너 생성"** 버튼 클릭하여 리스너를 생성합니다.

   ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-2.png " ")
3. 생성한 http 리스너로 접속하여 정상 접속 여부를 확인합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-3.png " ")

##### Task 2: OCI 로드밸런서 https 리다이렉트 규칙 집합 생성하기 (URL 재지정)
1. 로드밸런서 세부 화면에서 좌측 하단 리소스 패널에서 "규칙 집합"를 클릭하고 "규칙 집합 생성" 버튼을 클릭하여 아래와 같이 입력 및 선택하여 규칙 집합을 생성합니다
   - 이름 : **httpTohttps**
   - **URL 재지정 규칙 지정** 체크박스 선택 
   - 소스 경로 : **/**
   - 일치 유형 : **강제로 가장 긴 접두어 일치**
   - 재지정 대상 
     - 프로토콜 : **HTTPS**
     - 포트 : **443**
     - <mark>다른 설정은 기본 값을 유지합니다.</mark>
   - "생성" 버튼을 클릭하여 규칙 집합을 생성합니다.

    ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-4.png " ")

##### Task 3: OCI 로드밸런서 https 리다이렉트 규칙 적용 및 접속 테스트
1. http 리스너를 수정하기 위해 로드밸런서 세부정보 화면으로 이동합니다.
2. 좌측 하단 리소스 패널에서 "리스너"를 클릭하고 "listener_http" 리스너 우측의 "Action 버튼"을 클릭 후 "편집" 메뉴를 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-5.png " ")
3. 하단 규칙 집합 섹션에서 "추가 규칙 집합" 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-6.png " ")
4. 생성한 "httpTohttps" 규칙 집합을 선택 후 "변경사항 저장" 버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-7.png " ")
5. 설정이 적용된 후 브라우저에서 실제 redirect 과정을 확인합니다.
   - http 도메인으로 접속 후 개발자 도구에서 http 요청이 상태코드 <mark>[302 Moned Temporarily]</mark>로 리턴 받음을 확인합니다.
     ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-8.png " ")
   - OCI 로드밸런서 리스너에 지정한 규칙 집합에 의해 https로 redirect 되었고 <mark>[302 OK]</mark>로 리턴 받음을 확인합니다.
     ![](/assets/img/cloudnative/2023/certificate-lb/oci-lb-redirect-9.png " ")

### 마무리 하며...
이번 포스팅에서는 OCI 인증서 서비스에 등록된 인증서를 OCI 로드밸런서에 연결하는 실습을 진행했습니다.
OCI 인증서 서비스를 사용하면 OCI 로드밸런서, API Gateway 서비스와 인증서를 손쉽게 통합할 수 있으며 인증서의 버전관리, 갱신을 편리하게 처리할 수 있습니다.
다음에는 OCI 인증서 서비스를 OCI API Gateway 서비스에 통합하는 과정도 살펴볼 예정입니다.
아래 인증서 서비스관련 포스팅의 링크를 참조하세요.

### 참고 자료

#### 참고 블로그
- [https://blogs.oracle.com/cloud-infrastructure/post/http-url-redirect-on-oracle-cloud-infrastructure](https://blogs.oracle.com/cloud-infrastructure/post/http-url-redirect-on-oracle-cloud-infrastructure){:target="_blank" rel="noopener"}

#### Oracle 공식 문서
- [https://docs.oracle.com/en-us/iaas/Content/certificates/home.htm](https://docs.oracle.com/en-us/iaas/Content/certificates/home.htm){:target="_blank" rel="noopener"}
- [https://www.oracle.com/security/cloud-security/ssl-tls-certificates/](https://www.oracle.com/security/cloud-security/ssl-tls-certificates/){:target="_blank" rel="noopener"}
- [https://www.oracle.com/security/cloud-security/ssl-tls-certificates/faq/](https://www.oracle.com/security/cloud-security/ssl-tls-certificates/faq/){:target="_blank" rel="noopener"}

#### 인증서 서비스관련 포스팅
- [OCI Certificates - Let’s Encrypt로 생성한 인증서를 OCI 인증서 서비스에 Import 하기](/cloudnative/oci-certificate-import-letsencrypt-cert/){:target="_blank" rel="noopener"}
- OCI 인증서를 API Gateway에 적용하기
- OCI 인증서 서비스의 인증기관 생성 및 Load Balancer 적용하기
