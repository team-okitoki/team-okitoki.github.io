---
layout: page-fullwidth
#
# Content
#
subheadline: "Compute"
title: "OCI AutoScale (Scaling & Start/Stop) 스크립트"
teaser: "Richard Garsthagen이라는 분이 만든 OCI AutoScale Script입니다. OCI에서 운영중인 여러 리소스들에 대해서 스케쥴링에 의한 시작/정지 기능뿐만 아니라 오토스케일링 기능도 지원합니다. 본 스크립트를 사용하는 방법에 대해서 간략히 설명합니다."
author: dankim
date: 2022-07-15 00:00:00
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, oci-autoscaler, python_script]
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

### 스크립트 다운로드 받을 수 있는 Github Repository
스크립트는 아래 Github Repository에서 확인할 수 있습니다.  
[https://github.com/AnykeyNL/OCI-AutoScale](https://github.com/AnykeyNL/OCI-AutoScale)

> Richard Garsthagen이라는 분이 운영중인 [레파지토리](https://github.com/AnykeyNL/)에는 여기서 소개하는 OCI-AutoScale 스크립트 뿐만 아니라 OCI에 도움되는 다양한 스크립트들을 확인할 수 있습니다.

### 지원되는 서비스
아직 모든 서비스를 지원하고 있지는 않습니다. 현재 지원되는 서비스 목록은 다음과 같습니다.

* Compute VMs: On/Off
* Instance Pools: On/Off and Scaling (# of instances)
* Database VMs: On/Off
* Database Baremetal Servers: Scaling (# of CPUs)
* Database Exadata CS: Scaling (# of CPUs)*
* Autonomous Databases: On/Off and Scaling (# of CPUs)
* Oracle Digital Assistant: On/Off
* Oracle Analytics Cloud: On/Off and Scaling (between 2-8 oCPU and 10-12 oCPU)
* Oracle Integration Service: On/Off
* Load Balancer: Scaling (between 10, 100, 400, 8000 Mbps)**
* MySQL Service: On/Off***
* GoldenGate: On/Off
* Data Integration Workspaces: On/Off
* Visual Builder (v2 Native OCI version): On/Off

### 스크립트 설치 및 동작을 위한 인스턴스 생성
OCI 인스턴스를 하나 생성해서 스크립트를 설치하도록 하겠습니다. 우선 **컴퓨트 (Compute) > 인스턴스 (Instances)** 메뉴를 순서대로 클릭한 후 **인스턴스 생성** 버튼을 클릭합니다. 인스턴스 생성 대화창에서 다음과 같이 선택합니다.

* 이름: auto-scaler
* 이미지: Oracle Autonomous Linux
* SSH 키 추가: SSH로 접속하기 위한 키

![](/assets/img/infrastructure/2022/oci-autoscaler-1.png)

나머지는 기본 옵션으로 선택하고 **생성** 버튼을 클릭하여 인스턴스를 생성합니다.

> Virtual Cloud Network (VCN)은 사전에 준비되어 있어야 합니다.

### 다이나믹 그룹 및 권한 정책 설정
생성된 인스턴스를 포함하는 다이나믹 그룹을 생성하고 해당 그룹에 있는 인스턴스에서 모든 리소스에 접근할 수 있는 정책을 생성하여 부여합니다. 먼저 생성한 인스턴스의 OCID를 확인하고 복사합니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-2.png)

메뉴에서 **ID & 보안 (Identity & Security) > 다이나믹 그룹 (Dynamic Groups)**를 순서대로 선택합니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-3.png)

 **동적 그룹 생성 (Create Dynamic Group)** 버튼을 클릭하고 다음과 같이 입력합니다.

* 이름: Autoscaling
* 설명: Autoscaling를 위한 다이나믹 그룹
* 규칙 1: ANY {instance.id = 'ocid1.instance.oc1.ap-seoul-1.anuwgljr4ef4r3qccjt4tpmb4y.....'}
  * instance.id 값으로 위에서 복사한 인스턴스의 OCID를 입력합니다.

**생성**을 클릭하여 다이나믹 그룹을 생성합니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-4.png)

이번엔 정책을 생성합니다. **ID (Identity)** 메뉴에서 **정책 (Policies)**를 선택하고, **정책 생성 (Create Policy)** 버튼을 클릭합니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-5.png)

정책 생성 대화창에서 다음과 같이 입력합니다.
* 이름: Autoscaling-Policy
* 설명: Autoscaling을 위한 정책
* 구획: 테넌시이름(루트)
  * 반드시 최상위 루트 테넌시에 생성하여야 합니다.
* 정책 작성기
  * 수동 편집기 표시: ON
  * 정책: allow dynamic-group Autoscaling to manage all-resources in tenancy

![](/assets/img/infrastructure/2022/oci-autoscaler-6.png)

### 생성한 인스턴스(auto-scaler)에 OCI Config 구성
위에서 생성한 인스턴스(auto-scaler)에서 OCI Python SDK를 사용하기 위해서는 OCI Config가 구성되어 있어야 합니다. 먼저 SSH로 해당 인스턴스에 접속합니다.

```
$ ssh -i <private_key_file> opc@<public-ip-address>
```

OCI CLI 구성을 합니다. 참고로 인스턴스 생성 시 사용한 이미지 (Oracle Autonomous Linux)에는 이미 ocicli 도구가 설치되어 제공됩니다. 따라서 설치 이후 구성하는 과정만 진행하면 됩니다. 구성은 다음 링크를 참고합니다.

> [OCICLI 도구 설정하기](http://localhost:4000//getting-started/ocicli-config/)

### 생성한 인스턴스(auto-scaler)에 스크립트 설치
위에서 생성한 인스턴스에 다음과 같이 SSH키로 접속합니다.

```
$ ssh -i <private_key_file> opc@<public-ip-address>
```

다음 명령어로 install.sh 파일을 다운로드 받습니다.
```
$ wget https://raw.githubusercontent.com/AnykeyNL/OCI-AutoScale/master/install.sh
```

다음 명령어로 install.sh 파일을 실행하여 스크립트를 실행합니다.
```
$ bash install.sh
```

마지막으로 인스턴스의 Time Zone을 한국으로 설정합니다.
```
$ sudo timedatectl set-timezone Asia/Seoul
```


### AutoScale 스크립트에서 사용하는 태그 네임스페이스 생성
SSH로 접속한 후에 다음과 같이 Python 스크립트를 실행하여 AutoScale에서 사용하는 태그 네임스페이스를 생성합니다.

```
$ cd OCI-AutoScale/

$ python3 CreateNameSpaces.py -ip
Starts at 2022-07-15 08:20:52

Connecting to Identity Service...

Tenant Name   : ocidan
Tenant Id     : ocid1.tenancy.oc1..aaaaaaaageqr7ftqfi2r6pxtsyxj5ugkctmiftytf6rr73isnige67xgtj7q
Home Region   : ap-seoul-1
Creating Namespace Schedule
Creating keys Schedule
Key AnyDay is created
Key WeekDay is created
Key Weekend is created
Key Monday is created
Key Tuesday is created
Key Wednesday is created
Key Thursday is created
Key Friday is created
Key Saturday is created
Key Sunday is created
Key DayOfMonth is created

Namespace and keys for scheduling have been created
```

생성된 태그 네임스페이스를 확인합니다. OCI 메뉴에서 **거버넌스 & 관리 (Governance & Administration) > 태그 네임스페이스 (Tag Namespaces)**를 순서대로 선택합니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-7.png)

왼쪽 구획 (Compartment)는 가장 상위 루트 구획을 선택합니다. 다음과 같이 Schedule 이라는 태그 네임스페이스가 생성된 것을 확인할 수 있습니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-8.png)

다음과 같이 태그 네임스페이스내의 태그 키가 생성된 것을 확인할 수 있습니다.
![](/assets/img/infrastructure/2022/oci-autoscaler-9.png)

### 태그 네임스페이스와 태그 키란?
태그 네임스페이스와 태그 키는 OCI 리소스에 태깅을 할 때 사용합니다. 태깅이 되는 구성은 기본적으로 **{태그 네임스페이스}.{태그 키}.{태그 값}** 형태로 리소스에 태깅할 수 있습니다. 다음은 하나의 리눅스 인스턴스에 태깅을 하는 과정입니다. 우선 태깅을 위한 인스턴스를 하나 선택한 후 **작업 더 보기 > 태그 추가**를 순서대로 선택합니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-10.png)

다음과 같이 **태그 네임스페이스**, **태그 키**, **태그 값**을 입력하여 리소스에 태깅이 가능합니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-11.png)

추가된 태그는 다음과 같이 **태그** 탭에서 확인할 수 있습니다.
![](/assets/img/infrastructure/2022/oci-autoscaler-12.png)

### 스케쥴 태그 값 설정하기 
스케쥴 태그 키는 AnyDay, Weekday, Weekend, Day of week(Monday, Tuesday, Wednesday, Thursday, Friday, Saturday,Sunday), DayOfMonth로 제공되는데, 값 설정의 경우 DayOfMonth만 제외하고 모두 동일합니다.

#### AnyDay, Weekday, Weekend, Day of week 태그 값 설정
Schedule 태그 네임스페이스와 태그 키를 활용하여 인스턴스 Stop/Start 혹은 AutoScale 스케쥴링을 리소스에 적용할 수 있습니다. 태그 값은 콤마로 구분되는 총 24자리 숫자 혹은 wildcards (*)로 구분되는데, 각 위치는 하루 24시간을 의미합니다. 즉 가장 첫번째 숫자는 0시를 의미하고, 마지막 숫자는 23시를 의미합니다. 그리고 해당 위치에 0 혹은 1 이상, * 값을 줄 수 있습니다. 1 이상을 설정한 경우에는 설정한 숫자로 인스턴스 스케일 (지원되는 리소스에 한해서)이 증가합니다. 아래는 예시입니다.

> 태그는 여러 개를 설정하여 조합하여 구성할 수 있습니다.

<table class="table vl-table-bordered vl-table-divider-col" summary="스케쥴 태그 설명"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">태그 네임스페이스</th>
      <th class="entry" id="About__entry__2">태그 키</th>
      <th class="entry" id="About__entry__3">태그 값</th>
      <th class="entry" id="About__entry__4">설명</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Schedule</span></td>
      <td class="entry" headers="About__entry__2"><span class="ph">AnyDay</span></td>
      <td class="entry" headers="About__entry__3">*,0,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,1</td>
      <td class="entry" headers="About__entry__4"><span class="ph">매일 1시에 인스턴스를 정지, 24시에 인스턴스 가동</span></td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Schedule</span></td>
      <td class="entry" headers="About__entry__2"><span class="ph">Monday</span></td>
      <td class="entry" headers="About__entry__3">*,*,*,*,*,*,*,*,1,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*</td>
      <td class="entry" headers="About__entry__4"><span class="ph">월요일 8시에 인스턴스를 가동</span></td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Schedule</span></td>
      <td class="entry" headers="About__entry__2"><span class="ph">Friday</span></td>
      <td class="entry" headers="About__entry__3">*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,0,*,*,*,*</td>
      <td class="entry" headers="About__entry__4"><span class="ph">금요일 저녁 7시에 인스턴스를 중지</span></td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Schedule</span></td>
      <td class="entry" headers="About__entry__2"><span class="ph">WeekDay</span></td>
      <td class="entry" headers="About__entry__3">*,*,*,*,*,*,*,*,1,*,*,*,*,*,*,*,*,*,*,0,*,*,*,*</td>
      <td class="entry" headers="About__entry__4"><span class="ph">주중 8시에 인스턴스를 가동, 19시에 인스턴스 정지</span></td>
      </tr>
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Schedule</span></td>
      <td class="entry" headers="About__entry__2"><span class="ph">Weekend</span></td>
      <td class="entry" headers="About__entry__3">*,1,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*</td>
      <td class="entry" headers="About__entry__4"><span class="ph">주말 새벽 1시에 인스턴스를 중지</span></td>
      </tr>
      </tbody>
</table>

### 스케쥴 태그 값 설정하기 (DayOfMonth)
DayOfMonth 태그 키는 매달 특정 일자를 지정하여 태그 값을 지정합니다. 지정 방법은 **{날짜}:{리소스 개수}** 형태로 지정하며, 지정 시 매달 지정된 날짜에 개수가 조정됩니다. 개수를 0으로 하는 경우 리소스가 정지됩니다. 아래는 예시입니다.

<table class="table vl-table-bordered vl-table-divider-col" summary="스케쥴 태그 설명"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">태그 네임스페이스</th>
      <th class="entry" id="About__entry__2">태그 키</th>
      <th class="entry" id="About__entry__3">태그 값</th>
      <th class="entry" id="About__entry__4">설명</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Schedule</span></td>
      <td class="entry" headers="About__entry__2"><span class="ph">DayOfMonth</span></td>
      <td class="entry" headers="About__entry__3">1:4,3:2,28:4</td>
      <td class="entry" headers="About__entry__4"><span class="ph">매월 1일은 인스턴스 개수를 4개, 3일은 2개, 28일은 다시 4개로 스케링일</span></td>
      </tr>
      </tbody>
</table>

### 매달 N 번째 특정 요일로 설정
예를 들면 매달 두 번째 월요일, 혹은 세 번째 토요일과 같이 지정이 필요하면, 기존 태그 네임스페이스에 추가로 태그 키를 생성하여 정의할 수 있습니다. 태그 키 생성할 경우에는 다음과 같이 Monday2, Saturday3와 같이 태그를 추가하여 지정합니다. 태그 값은 위에서 설명한 24자리 숫자를 활용하여 지정합니다.

![](/assets/img/infrastructure/2022/oci-autoscaler-13.png)

### 인스턴스에 스케쥴 태깅 및 매뉴얼로 스크립트 실행
테스트를 위한 인스턴스를 생성한 후에 다음과 같이 태그를 지정합니다.

<table class="table vl-table-bordered vl-table-divider-col" summary="스케쥴 태그 설명"><caption></caption><colgroup><col><col><col><col><col><col></colgroup><thead class="thead">
      <tr class="row">
      <th class="entry" id="About__entry__1">태그 네임스페이스</th>
      <th class="entry" id="About__entry__2">태그 키</th>
      <th class="entry" id="About__entry__3">태그 값</th>
      <th class="entry" id="About__entry__4">설명</th>
      </tr>
      </thead><tbody class="tbody">
      <tr class="row">
      <td class="entry" headers="About__entry__1"><span class="ph">Schedule</span></td>
      <td class="entry" headers="About__entry__2"><span class="ph">AnyDay</span></td>
      <td class="entry" headers="About__entry__3">*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,0,*,*,*,*,*,*,*</td>
      <td class="entry" headers="About__entry__4"><span class="ph">오후 4시대 (4시~5시 사이)에 인스턴스 중지</span></td>
      </tr>
      </tbody>
</table>

![](/assets/img/infrastructure/2022/oci-autoscaler-14.png)

스크립트가 설치된 인스턴스에서 다음과 같이 실행합니다. -rg 옵션으로 리전을 지정할 수 있습니다.

```
$ python3 AutoScaleALL.py -ip -rg ap-seoul-1
```

테스트용 인스턴스가 중지되는 것을 확인할 수 있습니다.
![](/assets/img/infrastructure/2022/oci-autoscaler-14.png)

### crontab에 OCI-AutoScale 등록
crontab에 스크립트를 등록하여 스케쥴링을 걸 수 있습니다. 다음은 매 시간 1분에 스크립트를 실행하도록 crontab에 스크립트를 등록하는 예제입니다.

```
$ crontab -e

1 * * * * python3 /home/opc/OCI-AutoScale/AutoScaleALL.py -ip
```

### 스크립트 실행 시 사용할 수 있는 옵션
스크립트 실행 시 사용할 수 있는 옵션은 다음과 같습니다.
```
   -t config  - Config file section to use (tenancy profile)
   -ip        - Use Instance Principals for Authentication
   -dt        - Use Instance Principals with delegation token for cloud shell
   -a         - Action - All,Up,Down (Default All)
   -tag       - Tag to use (Default Schedule)
   -rg        - Filter on Region
   -ic        - include compartment ocid
   -ec        - exclude compartment ocid
   -ignrtime  - ignore region time zone (Use host time)
   -printocid - print ocid of resource
   -topic     - topic OCID to sent summary (in home region)
   -h         - help
```