---
layout: page-fullwidth
#
# Content
#
subheadline: "Networking"
title: "OCI 로드 밸런서 사용해보기"
teaser: "Oracle Cloud Infrastructure (OCI)에서 윈도우즈 인스턴스를 생성하는 과정을 설명합니다."
author: dankim
date: 2022-06-23 00:00:02
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, networking, loadbalancer]
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

### 로드 밸런싱 시작하기
OCI Load Balancing 서비스를 사용하면 VCN 내에서 고가용성의 Load Balancer를 생성할 수 있습니다. 생성된 Load Balancer에는 기본적으로 대역폭과 공용 또는 사설 IP주소가 할당됩니다.

이번 튜토리얼에서는 공용 Load Balancer를 생성하여 두 개의 인스턴스에서 운영되는 웹 애플리케이션간의 트래픽 분산하는 과정을 보여줍니다.

### 구획 (Compartment) 생성
모든 리소스들을 특정 구획에 생성할 것입니다. 우선 **Sandbox**라는 이름의 구획을 생성해 보도록 하겠습니다. 메뉴에서 **ID & 보안 (Identity & Security) > 구획(Compartment)**를 선택합니다.

![](/assets/img/getting-started/2022/oci-iam-7.png " ")

**구획 생성** 버튼을 클릭하고, 입력창에 다음과 같이 입력합니다.
* 구획명: Sandbox
* 설명: Sandbox 사용자를 위한 구획

![](/assets/img/getting-started/2022/oci-iam-8.png " ")

### Virtual Cloud Network 생성
먼저 Virtual Cloud Network (이하 VCN)을 생성합니다. VCN 생성은 아래 링크를 참고하여 생성합니다.

> [OCI에서 VCN Wizard를 활용하여 빠르게 VCN 생성하기](https://team-okitoki.github.io/getting-started/create-vcn/)

VCN을 생성할 때 앞서 생성한 구획인 SandBox를 선택하여야 합니다.
![](/assets/img/getting-started/2022/oci-lanunch-linux-instance-1.png " ")

### 두 개의 인스턴스 생성
두 개의 인스턴스를 생성해야 합니다. 인스턴스 생성은 아래 링크를 참고합니다.

[OCI에서 리눅스 인스턴스 생성 튜토리얼](https://team-okitoki.github.io/getting-started/launching-linux-instance/)

인스턴스를 생성할 때 인스턴스 이름은 다음과 같이 정의합니다.

* **인스턴스 1:** Webserver1
* **인스턴스 2:** Webserver2

인스턴스를 생성할 때 지정하는 VCN과 Subnet은 앞서 생성한 **my_vcn**과 **Public Subnet**으로 지정합니다.

> 실제 운영환경이라면 각 인스턴스는 **Private Subnet**에 구성하는 것이 일반적일 것입니다. 다만 여기서는 인스턴스에 대한 추가 구성이 필요하여 쉽게 SSH 접속을 하기 위해서 **Public Subnet**에 배치하였습니다.

![](/assets/img/getting-started/2022/loadbalancing-1.png " ")

### 각 인스턴스에 웹 애플리케이션 설치 및 시작
1. 인스턴스에 접속합니다.
  ```
  $ ssh -i <private_key_file> <username>@<public-ip-address>
  ```

2. yum 업데이트를 실행합니다.
  ```
  $ sudo yum update
  ```

3. Apache HTTP 서버를 설치합니다.
  ```
  $ sudo yum -y install httpd
  ```

4. 방화벽에서 HTTP(80), HTTPS(443) 포트 허용합니다.
  ```
  $ sudo firewall-cmd --permanent --add-port=80/tcp
  $ sudo firewall-cmd --permanent --add-port=443/tcp
  ```


5. 방화벽을 다시 로드 합니다.
  ```
  $ sudo firewall-cmd --reload
  ```

6. 웹서버 시작:
  ```
  $ sudo systemctl start httpd
  ```

7. 서버가 어떤 서버인지 보여주는 index.htm 파일을 각 서버에 추가합니다.  
  * **Webserver1**
  ```
  $ sudo su
  $ echo 'WebServer1' >/var/www/html/index.html
  ```
  * **Webserver2**
  ```
  $ sudo su
  $ echo 'WebServer2' >/var/www/html/index.html
  ```


### Load Balancer 생성
Load Balancer를 생성합니다. 메뉴에서 **네트워킹(Networking) > 로드 밸런서(Load Balancer)**를 차례로 클릭합니다.

![](/assets/img/getting-started/2022/loadbalancing-2.png " ")

**로드 밸런서 생성** 버튼 선택, **로드 밸런서 탭** 선택 후 **로드 밸런서 생성** 버튼을 클릭합니다.
![](/assets/img/getting-started/2022/loadbalancing-3.png " ")

다음과 같이 입력합니다.
* **로드 밸런서 이름(Load Balancer Name):** my_lb
* **가시성 유형 선택(Choose visibility type):** 공용(Public)
* **공용 IP 주소 지정(Assign a public IP address):** 임시 IP 주소(Ephemeral IP Address)
* **대역폭(Bandwidth):** 
  * **최소 대역폭 선택(Choose the minimum bandwidth):** 10Mbps
  * **최대 대역폭 선택(Choose the maximum bandwidth):** 100Mbps
  * 대역폭은 Flex Shape으로 사용자가 임의로 최소 및 최대 대역폭을 지정할 수 있습니다.
* **네트워킹 선택:**

**네트워킹**에서는 앞서 생성한 VCN과 공용 서브넷(Public Subnet)을 선택합니다.

![](/assets/img/getting-started/2022/loadbalancing-4.png " ")
![](/assets/img/getting-started/2022/loadbalancing-5.png " ")

#### 백앤드 선택
Load Balancer가 분배할 서버 인스턴스를 선택합니다. 여기서는 Load Balancing 정책과 Backend 서버 추가, Health Check 정책을 지정할 수 있습니다.

* **Load Balancing 정책 지정(Specify a Load Balancing Policy):** 가중치 라운드 로빈 (Weighted Round Robin)
* **백엔드 서버 선택:** **백엔드 추가** 버튼을 클릭하여 앞서 생성한 인스턴스를 추가합니다.
  ![](/assets/img/getting-started/2022/loadbalancing-6.png " ")

#### 건전성 검사 정책 지정(Specify Health Check Policy)
건전성 검사 정책은 백엔드 서버의 Health를 체크하여 Load Balancer의 상태를 보여주기 위한 부분입니다. 다음과 같이 설정합니다.

* **프로토콜(Protocol):** HTTP
* **포트(Port):** 80
* **간격(밀리초)(Interval in milliseconds):** 10000
* **시간 초과(밀리초)(Timeout in milliseconds):** 3000
* **재시도 횟수(Number of Retries):** 3
* **상태 코드(Status Code):** 200
* **URL 경로(URI)(URL Path)(URI):** /

![](/assets/img/getting-started/2022/loadbalancing-15.png " ")

#### 리스너 구성
리스너는 Load Balancer에 지정된 IP 주소로 트래픽을 수신하는 논리적인 요소라고 보면 됩니다. 기본적으로 TCP, HTTP 및 HTTPS 트래픽을 처리하려면 각 트래픽 유형당 하나 이상의 리스너를 구성해야 합니다. 여기서는 HTTP 리스너를 하나 추가합니다.

* **리스터 이름(Listener Name):** my_listener
* **리스너가 처리하는 트래픽의 유형 지정(Specify the type of traffic your listener handles):** HTTP
* **수신 트래픽에 대해 리스너가 모니터하는 포트 지정(Specify the port your listener monitors for ingress traffic):** 80

![](/assets/img/getting-started/2022/loadbalancing-7.png " ")

#### 로깅 관리
Load Balancer에서 처리하는 모든 트래픽에 대한 로그를 활성화 하여 OCI 로깅 서비스에서 볼 수 있습니다. 기본 오류 로그만 활성화 하여 **제출(Submit)** 합니다.

![](/assets/img/getting-started/2022/loadbalancing-8.png " ")

### 보안 목록 (Security List)에 80 포트 허용
생성한 Load Balancer를 선택하고 가상 클라우드 네트워크(VCN)을 선택합니다.

![](/assets/img/getting-started/2022/loadbalancing-9.png " ")

Load Balancer에서 사용하는 Public Subnet을 선택합니다.
![](/assets/img/getting-started/2022/loadbalancing-10.png " ")

기본 보안 목록(Security List)을 선택합니다.
![](/assets/img/getting-started/2022/loadbalancing-11.png " ")

**수신 규칙 추가** 버튼을 클릭하고 다음과 같이 입력한 후 추가합니다.
* **소스 CIDR:** 0.0.0.0/0
* **대상 포트 범위:** 80

![](/assets/img/getting-started/2022/loadbalancing-12.png " ")

### Load Balancer 확인
웹 브라우저를 열고 Load Balancer의 Public IP를 입력합니다. 다음과 같이 Webserver1로 접속된 것을 확인할 수 있습니다.

![](/assets/img/getting-started/2022/loadbalancing-13.png " ")

웹 페이지를 새로 로드하면, 트래픽이 Webserver2로 이동한 것을 확인합니다.
![](/assets/img/getting-started/2022/loadbalancing-14.png " ")

> Load Balancing 정책 지정(Specify a Load Balancing Policy)을 라운드 로빈으로 구성했으므로 페이지를 새로 고치면 두 웹 서버 간에 번갈아 나타납니다.