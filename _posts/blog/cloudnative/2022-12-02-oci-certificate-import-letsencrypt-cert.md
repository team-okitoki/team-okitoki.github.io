---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI Certificates - Let’s Encrypt로 생성한 인증서를 OCI 인증서 서비스에 Import 하기"
teaser: "무료로 SSL 인증서 생성이 가능한 Let's Encrypt를 활용하여 인증서를 생성하고 OCI 인증서 서비스에 Import하는 방법을 알아봅니다."
author: yhcho
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, certificates, CA, lets encrypt, certbot]
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

### Let's Encrypt 서비스란?
Let’s Encrypt는 공공의 이익을 위해 ISRG(Internet Security Research Group)에서 제공하는 무료, 자동화된 개방형 CA 서비스 입니다.
Let's Encrypt에 대해 더 자세히 알고 싶은 경우 [Let's Encrypt 소개](https://letsencrypt.org/ko/about/){:target="_blank" rel="noopener"}페이지를 방문하여 확인해보세요.

### Let's Encrypt 인증서 발급 실습 안내
이번 포스팅에서는 Certbot 플러그인을 사용하여 인증서를 발급받는 방법에 대해 소개합니다. Certbot 플러그인을 사용하면 DNS 레코드 작업을 브라우저를 통해 직접할 필요 없이 간편하게 인증서를 발급 받을 수 있습니다.

#### 사전 준비 사항
- Public 도메인
- Oracle Cloud Infrastructure 계정
- OCI Compute VM (Oracle Linux 8.x)

#### 실습 순서
1. 도메인 이름 구입/획득
2. OCI를 도메인의 DNS 서버로 설정
3. OCI CLI 설정 (Cloud Shell 사용)
4. Certbot 설치
5. certbot-dns-oci 플러그인 설치
6. certbot을 실행하여 인증서 획득
7. OCI Certificates 서비스에 인증서 등록

#### 1. 도메인 구입
실습에 사용할 도메인이 없으신 경우 국내/외 도메인 구매 사이트에서 도메인을 구입하셔야 합니다.
필자의 경우 실습용 도메인이기 때문에 저렴하게 구매하기 위해 가비아에서 도메인을 구입하여 실습을 진행했습니다. (약 3,000원 / 1년) 
도메인 구입이 필요한 경우 [가비아 도메인](https://domain.gabia.com/regist/today_domain){:target="_blank" rel="noopener"} 또는 기타 도메인 공급업체에서 구매합니다.
![](/assets/img/cloudnative/2022/certificates/letsencrypt-1.png " ")

#### 2. OCI DNS 영역을 생성하고 도메인의 DNS 서버로 설정
도메인을 구입했다면 OCI DNS 서비스에 영역(Zone)을 생성하고, 도메인을 구입한 사이트에서 DNS 서버 정보를 OCI DNS 서버로 변경합니다.
1. 전체 메뉴에서 **"네트워킹"** -> **"DNS관리"** -> **"영역"** 메뉴를 클릭합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-2.png " ")
2. **"영역생성"** 버튼을 클릭한 후 구매한 도메인과 동일하게 영역을 생성합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-3.png " ")
3. 영역생성이 완료된 후 영역상세보기 화면에서 Name Server(이름서버) 정보를 확인합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-4.png " ")
4. 도메인을 구입한 업체의 홈페이지의 도메인 관리 화면에서 DNS 정보를 변경합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-4-1.png " ")
5. 변경한 DNS 정보가 적용되었는지 dnschecker를 통해 확인합니다.
   - [https://dnschecker.org](https://dnschecker.org//){:target="_blank" rel="noopener"}
   - ![](/assets/img/cloudnative/2022/certificates/letsencrypt-4-2.png " ")

#### 3. OCI CLI 설정 (Compute Instance 사용)
이번 실습에서는 OCI에서 아래와 같은 구성으로 Compute Instance를 생성하여 인증서를 발급 받을 예정입니다. 생성한 VM에서 CLI를 사용할 수 있도록 OCI CLI설정을 진행합니다. 
Compute Instance 생성이나 접속, CLI 설정관련 자세한 내용은 아래 포스팅을 통해 확인하실 수 있으며, 이번 포스팅에서는 자세한 내용을 다루지 않습니다.

- [OCI CLI 도구 살펴보기](/getting-started/ocicli-config/){:target="_blank" rel="noopener"}
- [OCI에서 리눅스 인스턴스 생성 튜토리얼](/getting-started/launching-linux-instance/){:target="_blank" rel="noopener"}

* Compute Instance 생성정보
  * OS : **Oracle-Linux-Cloud-Developer 8.0** (※ 아래 이미지 참고)
  * Shape : **VM.Standard.E4.Flex** / 1 OCPU, 16GB Memory
  * Network / Subnet : **공용 서브넷**

   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-20.png " ")
<br>

1. OCI 콘솔의 우측 상단의 프로파일 아이콘을 클릭 후 "내 프로파일" 메뉴를 클릭합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-5.png " ")
2. **"API 키"** 메뉴에서 **"API Key 추가"** 버튼을 클릭하여 API Key를 등록합니다. (전용키, 공용키 다운로드하여 잘 보관합니다.)
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-6.png " ")
3. API 키 추가 후 추가된 키의 구성파일을 확인합니다. (복사하기)
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-7.png " ")
4. OCI 콘솔의 우측 상단 클라우드쉘 버튼을 클릭하여 클라우드쉘을 활성화 합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-8.png " ")
5. certbot 실습을 진행할 VM에 접속합니다. **(VM생성 단계에서 적용한 ssh 키파일을 Cloud Shell에 업로드 해야합니다.)**
   ```terminal
   $ ssh -i [key_file_path] opc@[public_IP_address]
   ```
6. 홈 디렉토리에서 아래 명령어를 입력하여 디렉토리 & 파일을 생성합니다.
   ```terminal
   $ mkdir ~/.oci
   $ vi ~/.oci/oci-api-key.pem
   $ vi ~/.oci/oci-api-pub.pem
   ```
7. oci-api-key.pem, oci-api-pub.pem에 각각 전용키, 공용키 내용을 입력합니다.
   - **oci-api-key.pem**
   ```config
   -----BEGIN PRIVATE KEY-----
   MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCgVVZGDQWv9ljq
   +sI5ITtfaBjRn6Ir45OFjGu2O1A..............
   ```
   - **oci-api-pub.pem**
   ```config
   -----BEGIN PUBLIC KEY-----
   MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoFVWRg0Fr/ZY6vrCOSE7
   X2gY0Z+iK+OThYxrtjtQE7w6vY..............
   ```
8. API 키 화면에서 Action 버튼을 통해 확인했던 구성 정보를 ~/.oci/config 파일로 생성해 줍니다. key_file의 경로는 업로드한 api-key 파일의 위치 및 파일명으로 지정합니다. 

   ```
   $ cd ~/.oci
   $ vi config
   ```

   ```config
   [DEFAULT]
   user=ocid1.user.oc1..aaaaaaaaeaacd7afudut..............
   fingerprint=8a:fd:9d:aa:81:37:b1:..............
   tenancy=ocid1.tenancy.oc1..aaaaaaaam3ldu4ndce..............
   region=ap-seoul-1 #만약 seoul 리전이 아닌경우 실제 실습할 리전으로 대체합니다.
   key_file=~/.oci/oci-api-key.pem # 실제 저장한 키파일의 위치 및 파일이름으로 지정합니다.
   ```
9. OCI CLI 설정이 잘 되었는지 확인하기 위해 아래와 같이 tenancy namespace 정보를 조회합니다.
   ```terminal
   $ oci os ns get
   results
   {
      "data": "axlpeslmb1ng"
   }
   ```

#### 4. Certbot 패키지 설치
클라우드쉘에는 기본적으로 Python3이 설치되어 있기 때문에 별도의 Python 설치 과정없이 바로 Certbot 패키지를 설치할 수 있습니다.
아래 명령어를 이용하여 클라우드쉘에 Certbot 패키지를 설치합니다.
   ```terminal
   $ sudo pip3 install certbot
   ```
#### 5. certbot-dns-oci 플러그인 설치
certbot 프로그램에서 OCI DNS 서비스 접근을 위한 별도의 플러그인 설치가 필요합니다.
아래 명령어를 차례로 입력하여 certbot-dns-oci 플러그인을 설치해주세요. 플러그인 관련하여 자세한 정보가 필요하신 경우 [플러그인 깃허브 레파지토리](https://github.com/therealcmj/certbot-dns-oci){:target="_blank" rel="noopener"} 페이지에서 확인하실 수 있습니다.
   ```terminal
   $ git clone https://github.com/therealcmj/certbot-dns-oci.git
   $ cd certbot-dns-oci
   $ sudo pip3 install .
   ```

#### 6. certbot을 실행하여 인증서 획득
여기까지 설정이 정상적으로 완료되었다면 이제 마지막으로 아래 certbot 명령어를 입력하여 인증서를 생성합니다.
아래 명령어를 실행하면 cloudshell의 "logs" 디렉토리에 로그를 저장하고 "work"를 작업 디렉토리로 사용하고 "config" 디렉토리에 인증서 및 기타 항목을 저장합니다.
나머지 세가지 옵션과 해당 인수는 certbot에게 챌린지 및 응답에 OCI DNS 플러그인을 사용하고 dns 관련 작업을 검증하기 위한 시간을 120초로 설정, "*.oci-younghwan.xyz"에 대한 인증서 생성을 요청합니다.
   ```terminal
   $ certbot certonly --logs-dir logs --work-dir work --config-dir config --authenticator dns-oci --dns-oci-propagation-seconds 120 -d *.oci-younghwan.xyz
   ```

- 위 명령어를 실행하면 아래와 같이 몇 단계 설정을 진행해야 합니다.
  1. Enter email address (used for urgent renewal and security notices) -> **이메일 주소 입력**
  2. Please read the Terms of Service at https://letsencrypt.org/documents/LE-SA-v1.3-September-21-2022.pdf. You must agree in order to register with the ACME server. Do you agree? -> **"Y" 입력**
  3. Would you be willing, once your first certificate is successfully issued, to share your email address with the Electronic Frontier Foundation, a founding partner of the Let's Encrypt project and the non-profit organization that develops Certbot? We'd like to send you email about our work encrypting the web, EFF news, campaigns, and ways to support digital freedom. -> **"Y" 입력**
- 설정이 완료되면 아래와 같은 화면을 확인할 수 있습니다.
  ![](/assets/img/cloudnative/2022/certificates/letsencrypt-9.png " ")
- 명령어를 실행한 위치 기준으로 /config/live 경로로 이동하면 아래와 같이 생성된 인증서를 확인할 수 있습니다.
  ![](/assets/img/cloudnative/2022/certificates/letsencrypt-10.png " ")
- 생성된 인증서 파일 설명
  - **cert.pem** : 요청한 도메인에 대한 인증서 파일 (Certificate)
  - **chain.pem** : 인증서 검증을 위한 체인 파일
  - **fullchain.pem** : cert.pem + chain.pem 두 파일을 하나로 합친 파일
  - **privkey.pem** : 생성한 인증서 파일에 대한 개인키 파일

#### 7. OCI 인증서 서비스에 인증서 등록
앞서 6번째 단계에서 생성된 인증서를 OCI 인증서 서비스에 등록합니다. 인증서 서비스에 등록할때 필요한 파일은 아래를 참고해주세요
- **cert.pem** : 요청한 도메인에 대한 인증서 파일 (Certificate)
- **chain.pem** : 인증서 검증을 위한 체인 파일
- **isrgrootx1.txt** : root_ca Let's Encrypt의 root ca 파일 [Root CA 파일 다운로드](/assets/files/cloudnative/isrgrootx1.txt){:target="_blank" rel="noopener"}
- **privkey.pem** : 생성한 인증서 파일에 대한 개인키 파일
<br>

1. 전체 메뉴에서 **"ID & 보안"** -> **"인증서"** -> **"인증서"** 메뉴를 클릭합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-11.png " ")
2. "인증서 생성" 버튼을 클릭합니다
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-12.png " ")
3. 인증서 생성화면에서 "임포트됨"을 선택하고 인증서 이름, 설명을 입력합니다. (어떤 도메인에 대한 인증서인지 식별할 수 있는 이름으로 작성합니다.)
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-13.png " ")
4. 주체 정보는 "임포트됨" 유형에서는 해당 없기 때문에 "다음" 버튼을 눌러서 다음단계로 이동합니다.
5. 인증서 생성 단계에서는 앞서 생성된 인증서 정보를 입력합니다.
   - 인증서 : cat 명령어를 통해 cert.pem의 내용을 확인 후 복사 붙여넣기 합니다.
   - 인증서 체인 : cat 명령어를 통해 chain.pem의 내용을 확인 후 복사 붙여넣고 바로 다음에 아래 Root CA 파일의 내용을 복사하여 붙여넣기 합니다.
     [Root CA 파일 다운로드](/assets/files/cloudnative/isrgrootx1.txt){:target="_blank" rel="noopener"}
   - 전용 키 : cat 명령어를 통해 privkey.pem의 내용을 확인 후 복사 붙여넣기 합니다.
   - 전용키 암호 : 입력하지 않음.
   - "다음" 버튼을 클릭합니다.
     ![](/assets/img/cloudnative/2022/certificates/letsencrypt-14.png " ")

6. 규칙 단계는 "임포트됨" 유형에서는 해당 없기 때문에 "다음" 버튼을 눌러서 다음단계로 이동합니다.
7. 입력한 내용을 검포 후 "인증서 생성"버튼을 클릭합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-15.png " ")
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-16.png " ")
8. 생성된 인증서 정보를 확인합니다.
   ![](/assets/img/cloudnative/2022/certificates/letsencrypt-17.png " ")

### 마무리 하며...
이번 포스팅에서는 certbot을 이용하여 간편하게 인증서를 발급받고 OCI 인증서 서비스에 등록하는 과정에 대해 살펴보았습니다.
다음에는 OCI 인증서 서비스를 다른 OCI 서비스 (로드밸런서, API Gateway)에 통합하는 과정도 살펴볼 예정입니다.
아래 인증서 서비스관련 포스팅의 링크를 참조하세요.

### 참고 자료
#### References
- [https://www.ateam-oracle.com/post/get-certificates-from-lets-encrypt-for-your-oci-services-the-easy-way](https://www.ateam-oracle.com/post/get-certificates-from-lets-encrypt-for-your-oci-services-the-easy-way){:target="_blank" rel="noopener"} 

#### Oracle 공식 문서
- [https://docs.oracle.com/en-us/iaas/Content/certificates/home.htm](https://docs.oracle.com/en-us/iaas/Content/certificates/home.htm){:target="_blank" rel="noopener"}
- [https://www.oracle.com/security/cloud-security/ssl-tls-certificates/](https://www.oracle.com/security/cloud-security/ssl-tls-certificates/){:target="_blank" rel="noopener"}
- [https://www.oracle.com/security/cloud-security/ssl-tls-certificates/faq/](https://www.oracle.com/security/cloud-security/ssl-tls-certificates/faq/){:target="_blank" rel="noopener"}

#### 인증서 서비스관련 포스팅
- [OCI 인증서를 Load Balancer에 적용하기](/cloudnative/oci-certificate-with-lb/){:target="_blank" rel="noopener"}
- OCI 인증서를 API Gateway에 적용하기
- OCI 인증서 서비스의 인증기관 생성 및 Load Balancer 적용하기
