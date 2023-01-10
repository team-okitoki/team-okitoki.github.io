---
layout: page-fullwidth
#
# Content
#
subheadline: "CLOUD API"
title: "OCI 커맨드라인 인터페이스 시작하기"
teaser: "Oracle Cloud Infrastructure (OCI) Command Line Interface(CLI) 구성 및 사용 방법에 대해 알아봅니다."
author: yhcho
date: 2022-06-02 00:00:00
breadcrumb: true
categories:
  - getting-started
tags:
  - [oci, api, cli, oci-cli, command line interface]
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

# -------------- 내용 필독 -------------------
# 작성할 내용은 아래부터 작성
# 작성 방법
# 각 챕터별 제목은 "###"로 시작한다.
# 하위 제목은 "####"로 시작한다.
# 이미지는 images 폴더안에 Category(getting-started, infrastructure, platform, database, aiml)에 넣고 사용 시 "../../images/카테고리명/이미지" 형태로 참조한다.
# Bold는 **글자**
# Bold + Italic은 ***글자***
# ------------------------------------------
---

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

### OCI CLI(Command Line Interface) 시작하기
이번 포스팅에서는 OCI CLI를 통해 Linux 인스턴스 및 Windows 인스턴스를 프로비전하기 위해서 구획, 가상 클라우드 네트워크 및 인스턴스 생성을 위한 Command 명령에 대해서 단계별로 설명할 예정입니다.
이번 포스팅에서 사용할 OCI CLI 버전은 3.22.0 입니다. (2023-01-05 기준 최신버전)

### OCI CLI란?
OCI CLI는 Oracle Cloud Infrastructure 콘솔에서 사용 가능한 대부분의 서비스로 작업할 수 있게 해주는 도구입니다. 
CLI는 콘솔 과 동일한 핵심 기능 과 추가 명령을 제공합니다. 만약 OCI CLI 도구가 설치되어 있지 않은 경우 OCI 콘솔에서 제공되는 Cloud Shell을 사용하거나, 아래 포스팅을 참고하여 설정 후 이번 실습을 진행해야 합니다. 
> [OCI CLI 도구 설정하기](/getting-started/ocicli-config/){:target="_blank" rel="noopener"}


### Command Line Interface (CLI) 정보

#### 명령어에 대한 도움말 확인하기
OCI CLI 명령어의 도움말이 필요한 경우 명령어 뒤에 `--help` 또는 `-h , -?` 를 붙여서 아래와 같이 명령어의 도움말을 확인할 수 있습니다.
모든 CLI 명령의 도움말은 [링크](https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.22.0/oci_cli_docs/){:target="_blank" rel="noopener"}에서 확인할 수 있습니다.
```terminal
$ oci --help
```
```terminal
$ oci bc volume -h
```
```terminal
$ oci os bucket create -?
```
### OCI CLI를 사용하여 OCI 리소스 생성하기
이번 포스팅에서는 OCI CLI를 활용하여 OCI Compute Instance를 프로비전하는 과정을 안내할 예정입니다. 
OCI CLI에 사용되는 파라미터를 매번 입력하기 번거롭기 때문에 자주 사용하는 변수는 환경변수로 등록하여 진행할 예정입니다.

- 환경변수 설정 명령어 샘플 (리눅스 계열)
```terminal
export compartment_id=ocid1.tenancy.oc1..aaaaaaaal1fvgn0h9njji5u6ldrwb4l6aay2x87qatw2wte30f714lal9oom
```

- 환경변수 설정 명령어 샘플 (윈도우 계열)
```terminal
$Env:compartment_id = "ocid1.tenancy.oc1..aaaaaaaal1fvgn0h9njji5u6ldrwb4l6aay2x87qatw2wte30f714lal9oom"
```

- 리소스 생성 명령어를 실행 후 리소스가 특정 상태가 되기 까지 기다리기 위해서는 아래 파라미터와 함께 CLI 명령어를 실행합니다.
  - 파라미터 : `--wait-for-state [text]`
  - 파라미터 허용 값 :
    ```text
    AVAILABLE, PROVISIONING, TERMINATED, TERMINATING, UPDATING
    ```

**진행 순서**
1. 구획(Compartments) 생성
2. 가상클라우드 네트워크(VCN) 생성
   - 가상클라우드 네트워크(VCN) 생성
   - 보안목록(Security List) 생성(Ingress Rule 포함)
   - 서브넷(Subnet) 생성
   - 인터넷 게이트웨이(Internet Gateway) 생성
   - 라우트 테이블(Route Table) 생성 및 룰 적용
3. 인스턴스(Instance) 생성하기
   - 인스턴스 생성 준비하기
   - Linux 인스턴스 시작하기
   - Windows 인스턴스 시작하기
   - 인스턴스에 연결하기
4. 실습 자원 정리하기

#### 구획(Compartments) 선택하기 (조회 및 생성)
##### 1. 구획 조회하기
- 도움말 보기 : `oci iam compartment list -h`
- **tenancy_id** : 테넌시의 OCID 또는 조회하고 싶은 상위 구획의 OCID를 복사하여 입력합니다.
![](/assets/img/getting-started/2022/oci-cli-1.png " ")
   
   ```terminal
   $ oci iam compartment list -c <tenancy_id>
   ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>구획 조회하기 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci iam compartment list -c $compartment_id
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> oci iam compartment list -c $Env:compartment_id
```
- 결과 샘플
```json
  {
   "data": [
     {
        "compartment-id": "ocid1.tenancy.oc1..aaaaaaaal1fvgn0h9njji5u6ldrwb4l6aay2x87qatw2wte30f714lal9oom",
        "description": "For testing CLI features",
        "id": "ocid1.tenancy.oc1..aaaaaaaal1fvgn0h9njji5u6ldrwb4l6aay2x87qatw2wte30f714lal9oom",
        "inactive-status": null,
        "lifecycle-state": "ACTIVE",
        "name": "CLIsandbox",
        "time-created": "2017-06-27T18:52:52.214000+00:00"
     },
     {
        "compartment-id": "ocid1.tenancy.oc1..aaaaaaaal1fvgn0h9njji5u6ldrwb4l6aay2x87qatw2wte30f714lal9oom",
        "description": "for testing",
        "id": "ocid1.compartment.oc1..aaaaaaaasqn3hj6e5tq6slj4rpdqqja7qsyuqipmu4sv5ucmyp3rkmrhuv2q",
        "inactive-status": null,
        "lifecycle-state": "ACTIVE",
        "name": "CLISandbox",
        "time-created": "2017-05-12T21:31:27.709000+00:00"
     }
     ],
     "opc-next-page": "   AAAAAAAAAAGLB28zJTjPUeNvgmLxg9QuJdAAZrl10FfKymIMh4ylXItQkO_Xk6RXbGxCn8hgkYm_pRpf1v6hVoxrYTQsaoveGMkX6iwwwPY5dptL8AKlyogYSs7F3G92KG2EhrI7j4NoUBtJ4-PTB53F2TZ31dReLsbzxBa3ljbwqQgwzQsUPYROLXA40EIJFdr2oYp67AzozSW8jt8MWFC8y19PsHEEEBW1jw8TT7Lq8XL_7mo5avasfsIYS7-VgP3ZFu6Y-Rab-gPNtjsT4pLh91BkDKWzbyHr0OmH4W1rhTJ5HfZ8YGpA0Ntm7_rOyNBd06qeBU496AQHk24-U_l9p4NvAvHuJ_fR-Z6ahgvWPlZQc1iCTRlJ6leM7ED3JNehIV0onOVQvGquJpF2WeEWFPcioQaqf4iScqHEchV--3Mn2k1yP_-b4AsVtSPRFYG8UuiRACPzg6ENVFjyeGOk3rrHjLR3j7s61pdgqtMOKZ1WtbOV8AcNON8ac1xJPN7O2YmjO3D0H4JmzXh_GxRskTpkl1D9En9zJXn99oWsNBOYgQQmv7s_7j82ZrXGoyOME-iT"
  }
```

</details>
{::options parse_block_html="false" /}


##### 2. 구획 생성하기
- 도움말 보기 : `oci iam compartment create -h`
- **compartment_name** : 생성할 구획의 이름을 입력합니다.
- **root_compartment_id** : 구획이 생성될 상위 구획의 OCID를 복사하여 입력합니다.
- **description** : 구획의 설명을 입력합니다.
   
   ```terminal
   $ oci iam compartment create --name <compartment_name> -c <root_compartment_id> --description "<description>"
   ```
{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>구획 생성하기 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci iam compartment create --name CLIsandbox -c $compartment_id --description "For testing CLI features"
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> oci iam compartment create --name CLIsandbox -c $Env:compartment_id --description "For testing CLI features"
```

- 결과 샘플
```json
  {
   "data": {
        "compartment-id": "ocid1.tenancy.oc1..aaaaaaaawuu4tdkysd2ups5fsclgm5ksfjwmx6mwem5sbjyw5ob5ojq2vkxa",
        "description": "For testing CLI features",
        "id": "ocid1.compartment.oc1..aaaaaaaalkqnr7pfd92rdrwo5fm6fcoufoih1vd4ls4j9jjpge16vfyxrc1l",
        "inactive-status": null,
        "lifecycle-state": "ACTIVE",
        "name": "CLIsandbox",
        "time-created": "2017-06-27T18:52:52.214000+00:00"
        },
   "etag": "24a4737ede9d34eae934c93e9549ee684a15efc8"
  }
```

</details>
{::options parse_block_html="false" /}

#### 가상클라우드 네트워크(VCN) 생성하기

##### 1. VCN 생성하기
- 도움말 보기 : `oci network vcn create -h`
- OCI CLI를 이용하여 VCN을 생성할 경우, VCN, 기본 DHCP 옵션, 기본 경로 테이블(Route Table), 기본 보안 목록(Security List)이 자동으로 함께 생성됩니다. <mark><b>그 외의 리소스가 필요한 경우 직접 생성해야 합니다.</b></mark>
- **compartment_id** : 위에서 생성한 구획의 OCID를 입력합니다.
- **display_name** : VCN의 이름을 지정합니다. 예) my-vcn-cli
- **dns_name** : VCN의 이름을 소문자, 특수문자를 제외하고 입력합니다. 예) myvcncli
- **cidr_block** : VCN의 CIDR 대역을 입력합니다. 예) 10.0.0.0/16

   ```terminal
   $ oci network vcn create --compartment-id <compartment_id> --display-name "<display_name>" --dns-label <dns_name> --cidr-block "<cidr_block>"
   ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>VCN 생성 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci network vcn create --compartment-id $compartment_id --display-name "my-vcn-cli" --dns-label myvcncli --cidr-block "10.0.0.0/16"
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> oci network vcn create --compartment-id $Env:compartment_id --display-name "my-vcn-cli" --dns-label myvcncli --cidr-block "10.0.0.0/16"
```

- 결과 샘플
```json
{
  "data": {
    "byoipv6-cidr-blocks": null,
    "cidr-block": "10.0.0.0/16",
    "cidr-blocks": [
      "10.0.0.0/16"
    ],
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "default-dhcp-options-id": "ocid1.dhcpoptions.oc1.ap-seoul-1.aaaaaaaa5nmat2a7c4zp3hv32xsy6su2lhgnum6ojqiey6ntjf42ao4ggmga",
    "default-route-table-id": "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq",
    "default-security-list-id": "ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaailwqlrxddecwjvsopvdmuhoksnyadk6oj4ayn2fbm6uzydx2gkma",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-05T04:16:47.157Z"
      }
    },
    "display-name": "my-vcn-cli",
    "dns-label": "myvcncli",
    "freeform-tags": {},
    "id": "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq",
    "ipv6-cidr-blocks": null,
    "ipv6-private-cidr-blocks": null,
    "lifecycle-state": "AVAILABLE",
    "time-created": "2023-01-05T04:16:47.267000+00:00",
    "vcn-domain-name": "myvcncli.oraclevcn.com"
  },
  "etag": "14208a0a"
}
```

- 생성된 리소스 OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-1.png " ")
</details>
{::options parse_block_html="false" /}

##### 2. VCN 리스트 조회하기
- **compartment_id** : 조회하고 싶은 구획의 OCID를 입력합니다.

   ```terminal
   $ oci network vcn list -c <compartment_id>
   ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>VCN 리스트 조회 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci network vcn list -c $compartment_id 
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> oci network vcn list -c $Env:compartment_id 
```

- 결과 샘플
```json
{
  "data": [
    {
      "byoipv6-cidr-blocks": null,
      "cidr-block": "10.0.0.0/16",
      "cidr-blocks": [
        "10.0.0.0/16"
      ],
      "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
      "default-dhcp-options-id": "ocid1.dhcpoptions.oc1.ap-seoul-1.aaaaaaaa5nmat2a7c4zp3hv32xsy6su2lhgnum6ojqiey6ntjf42ao4ggmga",
      "default-route-table-id": "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq",
      "default-security-list-id": "ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaailwqlrxddecwjvsopvdmuhoksnyadk6oj4ayn2fbm6uzydx2gkma",
      "defined-tags": {
        "Oracle-Tags": {
          "CreatedBy": "default/young.hwan.cho@oracle.com",
          "CreatedOn": "2023-01-05T04:16:47.157Z"
        }
      },
      "display-name": "my-vcn-cli",
      "dns-label": "myvcncli",
      "freeform-tags": {},
      "id": "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq",
      "ipv6-cidr-blocks": null,
      "ipv6-private-cidr-blocks": null,
      "lifecycle-state": "AVAILABLE",
      "time-created": "2023-01-05T04:16:47.267000+00:00",
      "vcn-domain-name": "myvcncli.oraclevcn.com"
    }
  ]
}
```

</details>
{::options parse_block_html="false" /}

##### 3. 보안목록(Security List) 생성(Rule 포함)
- 도움말 보기 : `oci network security-list create -h`
- 보안 목록 생성 단계에서는 **구획 OCID, VCN의 OCID**가 필요합니다. 보안목록 생성 시 Rule을 포함하여 생성하기 위해 나머지 파라미터를 설정하여 생성합니다.
- **compartment_id** : 서브넷을 생성할 대상 구획의 OCID를 입력합니다.
- **vcn_id** : 위에서 생성한 VCN의 OCID를 입력합니다.
- **securitylist_name** : 생성할 보안목록의 이름을 입력합니다.
- **egress_desc** : 보안 목록에서 허용할 송신(Egress) 트래픽 대상 IP 또는 CIDR Block을 입력합니다. 모든 트래픽을 허용할 경우 `0.0.0.0/0` 으로 입력합니다.
- **egress_desc_protocol** : 보안 목록에서 허용할 송신(Egress) 트래픽의 Protocol 번호를 입력합니다. 번호는 [IANA의 프로토콜 번호](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml){:target="_blank" rel="noopener"}를 참고하여 입력합니다. _예) "6" = TCP Protocol_
- **egress_desc_port** : 보안 목록에서 허용할 송신(Egress) 트래픽의 목적지 Port를 입력합니다. 모든 Port를 허용할 경우 `null`로 입력합니다.
- **egress_src_port** : 보안 목록에서 허용할 송신(Egress) 트래픽의 소스 Port를 입력합니다. 모든 Port를 허용할 경우 `null`로 입력합니다.
- **ingress_src** : 보안 목록에서 허용할 수신(Ingress) 트래픽 대상 IP 또는 CIDR Block을 입력합니다. 모든 트래픽을 허용할 경우 `0.0.0.0/0` 으로 입력합니다.
- **ingress_src_protocol** : 보안 목록에서 허용할 수신(Ingress) 트래픽의 Protocol 번호를 입력합니다. 번호는 [IANA의 프로토콜 번호](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml){:target="_blank" rel="noopener"}를 참고하여 입력합니다. _예) "6" = TCP Protocol_
- **ingress_desc_port** : 보안 목록에서 대상 Port를 범위로 허용하고 싶은 경우 `{"min": min_value, "max": max_value}` 의 형태로 입력합니다.
- **ingress_desc_port_max** : 보안 목록에서 허용할 Port를 범위로 입력하는 경우에 서브넷 내부의 대상 Port의 범위 중 max 값을 입력합니다. 이 실습에서는 윈도우 인스턴스 프로비전 및 접속 테스트를 진행할 예정이기 때문에 `3389` Port를 허용합니다.
- **ingress_desc_port_min** : 보안 목록에서 허용할 Port를 범위로 입력하는 경우에 서브넷 내부의 대상 Port의 범위 중 min 값을 입력합니다. 이 실습에서는 윈도우 인스턴스 프로비전 및 접속 테스트를 진행할 예정이기 때문에 `3389` Port를 허용합니다.
- **ingress_src_port** : 수신(Ingress) 트래픽의 Source Port를 입력합니다. 모든 Port를 허용할 경우 `null`로 입력합니다.
    
    ```terminal
$ oci network security-list create -c <compartment_id> 
            --egress-security-rules '[{"destination": "<egress_desc>", "protocol": "<egress_desc_protocol>", "isStateless": true, 
                "tcpOptions": {"destinationPortRange": <egress_desc_port>, "sourcePortRange": <egress_src_port>}}]'
            --ingress-security-rules '[{"source": "<ingress_src>", "protocol": "<ingress_src_protocol>", "isStateless": false, 
                "tcpOptions": {"destinationPortRange": {"max": <ingress_desc_port_max>, "min": <ingress_desc_port_min>}, "sourcePortRange": <ingress_src_port>}}]' 
            --vcn-id <vcn_id> --display-name <securitylist_name>
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>보안목록 생성 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ export vcn_id=ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq
$ oci network security-list create -c $compartment_id --vcn-id $vcn_id --egress-security-rules '[{"destination": "0.0.0.0/0", "protocol": "6", "isStateless": true, "tcpOptions": {"destinationPortRange": null, "sourcePortRange": null}}]' --ingress-security-rules '[{"source": "0.0.0.0/0", "protocol": "6", "isStateless": false, "tcpOptions": {"destinationPortRange": {"max": 3389, "min": 3389}, "sourcePortRange": null}}]' --display-name port3389rule
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> $Env:vcn_id = "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
C:\> oci network security-list create -c $Env:compartment_id  --vcn-id $Env:vcn_id  --egress-security-rules '[{"destination": "0.0.0.0/0", "protocol": "6", "isStateless": true, "tcpOptions": {"destinationPortRange": null, "sourcePortRange": null}}]' --ingress-security-rules '[{"source": "0.0.0.0/0", "protocol": "6", "isStateless": false, "tcpOptions": {"destinationPortRange": {"max": 3389, "min": 3389}, "sourcePortRange": null}}]' --display-name port3389rule
```

- 결과 샘플
```json
{
  "data": {
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-05T04:43:06.542Z"
      }
    },
    "display-name": "port3389rule",
    "egress-security-rules": [
      {
        "description": null,
        "destination": "0.0.0.0/0",
        "destination-type": "CIDR_BLOCK",
        "icmp-options": null,
        "is-stateless": true,
        "protocol": "6",
        "tcp-options": {
          "destination-port-range": null,
          "source-port-range": null
        },
        "udp-options": null
      }
    ],
    "freeform-tags": {},
    "id": "ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaamusjdk4mb5snn4wodziugvthz6dpzccbps2gooohseklngot3bsq",
    "ingress-security-rules": [
      {
        "description": null,
        "icmp-options": null,
        "is-stateless": false,
        "protocol": "6",
        "source": "0.0.0.0/0",
        "source-type": "CIDR_BLOCK",
        "tcp-options": {
          "destination-port-range": {
            "max": 3389,
            "min": 3389
          },
          "source-port-range": null
        },
        "udp-options": null
      }
    ],
    "lifecycle-state": "AVAILABLE",
    "time-created": "2023-01-05T04:43:06.566000+00:00",
    "vcn-id": "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
  },
  "etag": "d35d818d"
}
```

</details>
{::options parse_block_html="false" /}

##### 4. 서브넷(Subnet) 생성하기
- 도움말 보기 : `oci iam availability-domain list -h`, `oci network subnet create -h`
- 서브넷을 생성하기 위해서 가용성 도메인에 대한 정보를 확인해야 합니다. 가용성 도메인 정보를 확인하기 위해 아래 명령어에 "Compartment ID"를 입력하여 실행합니다.
- **compartment_id** : 조회하고 싶은 구획의 OCID를 입력합니다.

    ```terminal
    $ oci iam availability-domain list -c <compartment_id>
    ```
{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>가용성 도메인 조회 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci iam availability-domain list -c  $compartment_id
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> oci iam availability-domain list -c $Env:compartment_id
```

- 결과 샘플
```json
{
  "data": [
    {
      "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
      "id": "ocid1.availabilitydomain.oc1..aaaaaaaaiewapowmrwt3u3bwrtixouwohf6cvenkslrz7lnoes3f4ns4skha",
      "name": "wXsg:AP-SEOUL-1-AD-1"
    }
  ]
}
```

</details>
{::options parse_block_html="false" /}
<br>
- 가용성 도메인을 확인 후 아래와 같이 명령어를 작성 및 입력하여 서브넷을 생성합니다. CLI로 생성하는 서브넷은 기본적으로 "공용 서브넷"으로 생성됩니다.
- **vcn_id** : 위에서 생성한 VCN의 OCID를 입력합니다.
- **compartment_id** : 서브넷을 생성할 대상 구획의 OCID를 입력합니다.
- **availability_domain_name** : (옵션) 서브넷 유형을 가용성 도메인별로 관리되는 서브넷으로 생성하기 위해 옵션을 지정합니다. 파라미터 입력 값은 위에서 확인한 가용성 도메인(availability_domain) 이름을 입력합니다. 예) `wXsg:AP-SEOUL-1-AD-1`
- **display_name** : 서브넷의 이름을 지정합니다. 예) my-subnet
- **dns_name** : 서브넷 이름을 영문과 숫자를 조합하여 입력합니다. 예) mysubnet
- **cidr_block** : 서브넷의 CIDR 대역을 입력합니다. 예) 10.0.0.0/24
- **default_security_list_id** : VCN을 생성할 때 리턴받은 정보 중 기본 보안목록의 OCID를 입력합니다.
- **new_security_list_id** : 위 3단계에서 보안목록을 생성 후 리턴받은 정보 중 보안목록의 OCID를 입력합니다. 이 외에도 추가로 보안목록을 추가하고 싶은 경우에는 보안목록의 OCID를 추가로 작성하면 서브넷 생성단계에서 적용 가능합니다.
    ```terminal
    $ oci network subnet create 
        --vcn-id <vcn_id> -c <compartment_id>  
        --availability-domain "<availability_domain_name>" 
        --display-name <display_name> --dns-label "<dns_label>" 
        --cidr-block "<cidr_block>" --security-list-ids '["<default_security_list_id>","<new_security_list_id>"]'
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>서브넷 생성 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ export vcn_id=ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq
$ export default_sec_list_id=ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaailwqlrxddecwjvsopvdmuhoksnyadk6oj4ayn2fbm6uzydx2gkma
$ export new_sec_list_id=ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaamusjdk4mb5snn4wodziugvthz6dpzccbps2gooohseklngot3bsq
$ oci network subnet create --vcn-id $vcn_id -c $compartment_id --availability-domain "wXsg:AP-SEOUL-1-AD-1" --display-name "myvcncli-subnet" --dns-label "mysubnet" --cidr-block "10.0.0.0/24" --security-list-ids '[$default_sec_list_id,$new_sec_list_id]'
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> $Env:vcn_id = "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
C:\> $Env:default_sec_list_id = "ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaailwqlrxddecwjvsopvdmuhoksnyadk6oj4ayn2fbm6uzydx2gkma"
C:\> $Env:new_sec_list_id = "ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaamusjdk4mb5snn4wodziugvthz6dpzccbps2gooohseklngot3bsq"
C:\> oci network subnet create --vcn-id $Env:vcn_id -c $Env:compartment_id --availability-domain "wXsg:AP-SEOUL-1-AD-1" --display-name "myvcncli-subnet" --dns-label "mysubnet" --cidr-block "10.0.0.0/24" --security-list-ids '[$Env:default_sec_list_id,$Env:new_sec_list_id]'
```

- 결과 샘플
```json
{
  "data": {
    "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
    "cidr-block": "10.0.0.0/24",
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-05T04:45:34.745Z"
      }
    },
    "dhcp-options-id": "ocid1.dhcpoptions.oc1.ap-seoul-1.aaaaaaaa5nmat2a7c4zp3hv32xsy6su2lhgnum6ojqiey6ntjf42ao4ggmga",
    "display-name": "myvcncli-subnet",
    "dns-label": "mysubnet",
    "freeform-tags": {},
    "id": "ocid1.subnet.oc1.ap-seoul-1.aaaaaaaazx7qo5s7dvisukrim475sxwvmauvilpzwu3pilbiph3li7cuipma",
    "ipv6-cidr-block": null,
    "ipv6-cidr-blocks": null,
    "ipv6-virtual-router-ip": null,
    "lifecycle-state": "PROVISIONING",
    "prohibit-internet-ingress": false,
    "prohibit-public-ip-on-vnic": false,
    "route-table-id": "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq",
    "security-list-ids": [
      "ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaailwqlrxddecwjvsopvdmuhoksnyadk6oj4ayn2fbm6uzydx2gkma",
      "ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaamusjdk4mb5snn4wodziugvthz6dpzccbps2gooohseklngot3bsq"
    ],
    "subnet-domain-name": "mysubnet.myvcncli.oraclevcn.com",
    "time-created": "2023-01-05T04:45:34.791000+00:00",
    "vcn-id": "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq",
    "virtual-router-ip": "10.0.0.1",
    "virtual-router-mac": "00:00:17:A8:A1:D0"
  },
  "etag": "8a633259"
}
```

- 생성된 리소스 OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-2.png " ")
</details>
{::options parse_block_html="false" /}

##### 5. 인터넷 게이트웨이(Internet Gateway) 생성하기
- 도움말 보기 : `oci network internet-gateway create -h`
- 공용 IP를 보유하고 있는 리소스가 인터넷과 통신하기 위한 인터넷 게이트웨이를 생성하기 위해 아래와 같은 파라미터를 확인하고 CLI 명령어를 입력하여 
- **vcn_id** : 위에서 생성한 VCN의 OCID를 입력합니다.
- **compartment_id** : 서브넷을 생성할 대상 구획의 OCID를 입력합니다.
- **gateway_display_name** : 인터넷 게이트웨이의 이름을 지정합니다. 예) ig-myvcncli
    ```terminal
    $ oci network internet-gateway create --is-enabled true --vcn-id <vcn_id> -c <compartment_id> --display-name <gateway_display_name>
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">-<b>인터넷 게이트웨이 생성 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ export vcn_id=ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq
$ oci network internet-gateway create --is-enabled true --vcn-id $vcn_id -c $compartment_id --display-name ig-myvcncli
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> $Env:vcn_id = "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
C:\> oci network internet-gateway create --is-enabled true --vcn-id $Env:vcn_id -c $Env:compartment_id --display-name ig-myvcncli
```

- 결과 샘플
```json
{
  "data": {
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-05T06:30:52.013Z"
      }
    },
    "display-name": "ig-myvcncli",
    "freeform-tags": {},
    "id": "ocid1.internetgateway.oc1.ap-seoul-1.aaaaaaaani5rdna3vlikdchufhiqbpogqggh6ehnctmfoiu5c5etteh2mxna",
    "is-enabled": true,
    "lifecycle-state": "AVAILABLE",
    "route-table-id": null,
    "time-created": "2023-01-05T06:30:52.054000+00:00",
    "vcn-id": "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
  },
  "etag": "9eee4535"
}
```

- 생성된 리소스 OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-3.png " ")

</details>
{::options parse_block_html="false" /}


##### 6. 경로 테이블(Route Table) 생성하기
- 도움말 보기 : `oci network route-table list -h`, `oci network route-table update -h`
- 먼저 경로 테이블에 룰을 추가하기 위해 VCN의 경로테이블을 조회합니다.
    ```terminal
    $ oci network route-table list -c <compartment_id> --vcn-id <vcn_id>
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>경로 테이블 리스트 조회 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ export vcn_id=ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq
$ oci network route-table list --vcn-id $vcn_id -c $compartment_id
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> $Env:vcn_id = "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
C:\> oci network route-table list --vcn-id $Env:vcn_id -c $Env:compartment_id
```

- 결과 샘플
```json
{
  "data": [
    {
      "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
      "defined-tags": {
        "Oracle-Tags": {
          "CreatedBy": "default/young.hwan.cho@oracle.com",
          "CreatedOn": "2023-01-05T04:16:47.157Z"
        }
      },
      "display-name": "Default Route Table for my-vcn-cli",
      "freeform-tags": {},
      "id": "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq",
      "lifecycle-state": "AVAILABLE",
      "route-rules": [],
      "time-created": "2023-01-05T04:16:47.267000+00:00",
      "vcn-id": "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
    }
  ]
}
```

</details>
{::options parse_block_html="false" /}
<br>
- 조회한 경로테이블의 ID를 이용하 경로 테이블에 인터넷 게이트웨이와 통신을 위한 규칙을 추가합니다.
- **route_table_id** : 위에서 조회한 VCN의 경로 테이블의 ID를 입력합니다.
- **cidr_block** : 추가할 라우팅 규칙의 대상 CIDR_BLOCK을 입력합니다. 여기서는 인터넷 통신과 관련된 룰을 추가하기위해 **`0.0.0.0/0`**으로 입력해 줍니다.
- **internet_gateway_id** : 5 단계에서 생성한 인터넷 게이트웨이의 ID를 입력합니다.
    ```terminal
    $ oci network route-table update --rt-id <route_table_id> --route-rules '[{"cidrBlock":"<cidr_block>","networkEntityId":"<internet_gateway_id>"}]'
    ```
- 아래와 같은 경고 메시지가 나오면 "Y"를 입력해 줍니다.
- `WARNING: Updates to route-rules will replace any existing values. Are you sure you want to continue? [y/N]:` **Y**


{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>경로 테이블 규칙 추가 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export route_table_id=ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq
$ oci network route-table update --rt-id $route_table_id --route-rules '[{"cidrBlock":"0.0.0.0/0","networkEntityId":"ocid1.internetgateway.oc1.ap-seoul-1.aaaaaaaani5rdna3vlikdchufhiqbpogqggh6ehnctmfoiu5c5etteh2mxna"}]'
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:route_table_id = "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq"
C:\> oci network route-table update --rt-id $Env:route_table_id --route-rules '[{"cidrBlock":"0.0.0.0/0","networkEntityId":"ocid1.internetgateway.oc1.ap-seoul-1.aaaaaaaani5rdna3vlikdchufhiqbpogqggh6ehnctmfoiu5c5etteh2mxna"}]'
```

- 결과 샘플
```json
{
  "data": {
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-05T04:16:47.157Z"
      }
    },
    "display-name": "Default Route Table for my-vcn-cli",
    "freeform-tags": {},
    "id": "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq",
    "lifecycle-state": "AVAILABLE",
    "route-rules": [
      {
        "cidr-block": "0.0.0.0/0",
        "description": null,
        "destination": "0.0.0.0/0",
        "destination-type": "CIDR_BLOCK",
        "network-entity-id": "ocid1.internetgateway.oc1.ap-seoul-1.aaaaaaaani5rdna3vlikdchufhiqbpogqggh6ehnctmfoiu5c5etteh2mxna",
        "route-type": "STATIC"
      }
    ],
    "time-created": "2023-01-05T04:16:47.267000+00:00",
    "vcn-id": "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
  },
  "etag": "db55458c"
}
```

- 생성된 경로 규칙 OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-4.png " ")
</details>
{::options parse_block_html="false" /}

#### 인스턴스를 시작하기 위한 준비하기
##### 1. 이미지 ID 확인하기
- 도움말 보기 : `oci compute image list -h`
- Linux 인스턴스, Winodws 인스턴스를 프로비전하기 위한 이미지의 OCID를 확인하기 위해서 아래 명령어를 입력하여 이미지 리스트를 확인 합니다.
    ```terminal
    $ oci compute image list -c <compartment_id> --all
    ```
- 인스턴스를 시작하기 위한 이미지는 Linux, Windows 각각 아래 ID로 지정하여 진행 하겠습니다.
  - Linux : **Oracle-Linux-8.6-2022.12.15-0**
    ```text
    ocid1.image.oc1.ap-seoul-1.aaaaaaaaipgkmhwis7wmcc4rcrunq254nkhouw36dbujnpkvcupswag5ckiq
    ```
  - Windows : **Windows-Server-2022-Standard-Edition-VM-2022.09.06-0**
    ```text
    ocid1.image.oc1.ap-seoul-1.aaaaaaaanqhp46r4rbyz2gvt5zfdkjv5om4bfo6kvcn6hi6isgx44hsmaeya
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>컴퓨트 이미지 리스트 조회 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci compute image list -c $compartment_id --all
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:route_table_id = "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq"
C:\> oci compute image list -c $Env:compartment_id --all
```

- 결과 샘플 (Oracle Linux 8)
```json
{
  "agent-features": null,
  "base-image-id": null,
  "billable-size-in-gbs": 6,
  "compartment-id": null,
  "create-image-allowed": true,
  "defined-tags": {},
  "display-name": "Oracle-Linux-8.6-2022.12.15-0",
  "freeform-tags": {},
  "id": "ocid1.image.oc1.ap-seoul-1.aaaaaaaaipgkmhwis7wmcc4rcrunq254nkhouw36dbujnpkvcupswag5ckiq",
  "launch-mode": "NATIVE",
  "launch-options": {
    "boot-volume-type": "PARAVIRTUALIZED",
    "firmware": "UEFI_64",
    "is-consistent-volume-naming-enabled": true,
    "is-pv-encryption-in-transit-enabled": true,
    "network-type": "PARAVIRTUALIZED",
    "remote-data-volume-type": "PARAVIRTUALIZED"
  },
  "lifecycle-state": "AVAILABLE",
  "listing-type": null,
  "operating-system": "Oracle Linux",
  "operating-system-version": "8",
  "size-in-mbs": 47694,
  "time-created": "2022-12-20T15:42:53.222000+00:00"
}
```

- 결과 샘플 (Windows Server 2022)
```json
{
  "agent-features": null,
  "base-image-id": null,
  "billable-size-in-gbs": 15,
  "compartment-id": null,
  "create-image-allowed": true,
  "defined-tags": {},
  "display-name": "Windows-Server-2022-Standard-Edition-VM-2022.09.06-0",
  "freeform-tags": {},
  "id": "ocid1.image.oc1.ap-seoul-1.aaaaaaaanqhp46r4rbyz2gvt5zfdkjv5om4bfo6kvcn6hi6isgx44hsmaeya",
  "launch-mode": "CUSTOM",
  "launch-options": {
    "boot-volume-type": "PARAVIRTUALIZED",
    "firmware": "UEFI_64",
    "is-consistent-volume-naming-enabled": false,
    "is-pv-encryption-in-transit-enabled": true,
    "network-type": "PARAVIRTUALIZED",
    "remote-data-volume-type": "PARAVIRTUALIZED"
  },
  "lifecycle-state": "AVAILABLE",
  "listing-type": null,
  "operating-system": "Windows",
  "operating-system-version": "Server 2022 Standard",
  "size-in-mbs": 48128,
  "time-created": "2022-09-12T17:00:42.839000+00:00"
}
```
</details>
{::options parse_block_html="false" /}

##### 2. 인스턴스 Shape 확인하기
- 도움말 보기 : `oci compute shape list -h`
- Linux 인스턴스, Winodws 인스턴스를 프로비전하기 위한 이미지의 OCID를 확인하기 위해서 아래 명령어를 입력하여 이미지 리스트를 확인 합니다.
    ```terminal
    $ oci compute shape list -c <compartment_id> --availability-domain "<availability_domain_name>"
    ```
- Shape은 편의상 AMD 계열의 `VM.Standard.E4.Flex`을 이용하도록 하겠습니다.

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>컴퓨트 인스턴스 Shape 리스트 조회 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (유닉스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci compute shape list -c $compartment_id --availability-domain "wXsg:AP-SEOUL-1-AD-1"
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:route_table_id = "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq"
C:\> oci compute shape list -c $Env:compartment_id --availability-domain "wXsg:AP-SEOUL-1-AD-1"
```

- 결과 샘플 
```json
{
  "data": [
    {
      "shape": "BM.Standard1.36"
    },
    {
      "shape": "VM.Standard1.1"
    },
    {
      "shape": "VM.Standard1.2"
    },
    {
      "shape": "VM.Standard1.4"
    },
    {
      "shape": "VM.Standard1.8"
    },
    {
      "shape": "VM.Standard1.16"
    },
    {
      "shape": "VM.DenseIO1.4"
    }
  ]
}
```

</details>
{::options parse_block_html="false" /}

##### 3. Key Pair 준비하기
- Linux 인스턴스를 시작할때 사용하기 위해 SSH Key Pair를 미리 생성하여 준비합니다.
- 인스턴스에 SSH 접속을 위한 SSH 키 쌍 생성 (리눅스, 유닉스)
  - `ssh-keygen -b 2048 -t rsa` 명령어를 터미널에 입력 합니다.
    ```terminal
    ssh-keygen -b 2048 -t rsa
    ```
  - 키파일 저장 위치를 물어보면 기본 설정에서 **"Enter"**키를 입력합니다. _예) /home/user_name/.ssh/id_rsa_
  - 혹시 동일한 경로에 이미 같은 이름의 파일이 존재하는 경우 덮어 씌울지 확인하는데, **Y**를 입력하고 **"Enter"**키를 입력합니다.
  - passphrase는 별도로 입력하지 않고 **"Enter"**키를 입력합니다.
  - 생성된 키 파일을 확인합니다.
- Putty Key Generator를 활용하여 SSH 키 생성
  - 만일 클라이언트가 OpenSSH가 없는 윈도우 환경이라면, **Putty**를 활용하여 접속하는 경우가 많은데 이 경우에는 **Putty Key Generator**를 다운로드 받아서 Putty에서 사용하는 SSH키로 생성하여야 합니다. **Putty Key Generator**를 활용하면 기존에 사용중이던 [SSH-2 RSA 키 쌍](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#Instance)를 Putty 전용 SSH 키로 변환도 가능합니다.
  - 먼저 [https://www.puttygen.com/](https://www.puttygen.com/)에서 **PuTTYgen**을 다운로드 받고 설치합니다. **puttygen.exe**을 클릭하여 프로그램을 오픈합니다. 
  - 다음과 같이 **SSH-2 RSA**를 선택하고 **키 사이즈**를 **2048**로 입력한 후 **Generate** 버튼을 클릭합니다.
    ![](/assets/img/getting-started/2022/oci-create-sshkey-1.png " ")

  - 생성되는 과정에서 빈 공간을 마우스를 움직이면 키가 랜덤하게 생성됩니다.
    ![](/assets/img/getting-started/2022/oci-create-sshkey-2.png " ")

  - **Save private key**를 클릭하여 전용 키를 다운로드 받습니다. 공개키의 경우 **Public key for pasting into OpenSSH authorized_keys file**의 내용을 다운로드 받은 Private Key 이름에 **.pub**라는 파일 확장자를 추가해서 복사 & 붙여넣기 하여 생성합니다. <br>예시) Private Key: mykey, Public Key: mykey.pub
  > 키 코멘트, passphrase (키를 암호화)는 이 단계에서 건너뜁니다.

    ![](/assets/img/getting-started/2022/oci-create-sshkey-3.png " ")

#### CLI를 이용하여 Linux 인스턴스를 시작하기
여기까지 잘 진행하셨으면 이제 인스턴스를 시작하기 위한 준비는 모두 완료되었습니다. 이제 아래 남은 절차를 따라 진행하면서 인스턴스를 시작해보겠습니다!

##### 1. Linux 인스턴스 시작하기
- 도움말 보기 : `oci compute instance launch -h`
- 인스턴스를 시작하기 위한 CLI 명령어는 아래 여러가지 파라미터의 값을 설정하여 실행합니다.
    ```terminal
    $ oci compute instance launch --availability-domain "<availability_domain_name>" 
      -c <compartment_id> --subnet-id  <subnet_id> --display-name "<display_name>" 
      --shape "<shape_name>" --shape-config '{"ocpus": 1, "memoryInGBs": 16}'    
      --image-id <image_id> --ssh-authorized-keys-file "<path_to_authorized_keys_file>" 
    ```

- **availability_domain_name** : 인스턴스를 시작할 대상 AD의 이름을 입력합니다. 서울 리전의 경우 `wXsg:AP-SEOUL-1-AD-1`를 입력합니다.
- **compartment_id** : 인스턴스를 시작할 대상 구획의 OCID를 입력합니다.
- **subnet_id** : 위에서 생성한 서브넷의 OCID를 입력합니다.
- **display_name** : 인스턴스의 이름을 지정합니다. 예) `my-linux`
- **shape_name** : 인스턴스의 Shape 이름을 지정합니다. 이번 실습에서는 `VM.Standard.E4.Flex`를 사용합니다.
  - 인스턴스의 shape을 Flex로 설정할 경우 shape-config 설정을 통해 원하는 ocpu, memory 값을 추가로 지정해야 합니다.
    ```json
    { "ocpus": 1, "memoryInGBs": 16 }    
    ```

- **image_id** : 인스턴스를 시작할때 사용할 이미지의 ID를 입력합니다. 실습에서는 Oracle Linux 8 이미지를 사용합니다. 
  - Linux : **Oracle-Linux-8.6-2022.12.15-0**
  ```text
  ocid1.image.oc1.ap-seoul-1.aaaaaaaaipgkmhwis7wmcc4rcrunq254nkhouw36dbujnpkvcupswag5ckiq
  ```

- **path_to_authorized_keys_file** : 앞단계 에서 생성한 키파일의 경로를 입력합니다.
  - Linux 예시 : `~/.ssh/id_rsa.pub`
  - Winodws 예시 : `C:\Users\testuser\.oci\linux_key.pem`

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>컴퓨트 인스턴스 생성 명령어(Linux)</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ export subnet_id=ocid1.subnet.oc1.ap-seoul-1.aaaaaaaazx7qo5s7dvisukrim475sxwvmauvilpzwu3pilbiph3li7cuipma
$ export linux_image_id=ocid1.image.oc1.ap-seoul-1.aaaaaaaaipgkmhwis7wmcc4rcrunq254nkhouw36dbujnpkvcupswag5ckiq
$ export path_to_authorized_keys_file=~/.ssh/id_rsa.pub
$ oci compute instance launch --availability-domain "wXsg:AP-SEOUL-1-AD-1" -c $compartment_id --subnet-id  $subnet_id --display-name "my-linux" --shape "VM.Standard.E4.Flex" --shape-config '{"ocpus": 1, "memoryInGBs": 16}' --image-id $linux_image_id --ssh-authorized-keys-file $path_to_authorized_keys_file
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> $Env:subnet_id = "ocid1.subnet.oc1.ap-seoul-1.aaaaaaaazx7qo5s7dvisukrim475sxwvmauvilpzwu3pilbiph3li7cuipma"
C:\> $Env:linux_image_id = "ocid1.image.oc1.ap-seoul-1.aaaaaaaaipgkmhwis7wmcc4rcrunq254nkhouw36dbujnpkvcupswag5ckiq"
C:\> $Env:path_to_authorized_keys_file= "C:\Users\testuser\.oci\linux_key.pem"
C:\> oci compute instance launch --availability-domain "wXsg:AP-SEOUL-1-AD-1" -c $Env:compartment_id --subnet-id  $Env:subnet_id --display-name "my-linux" --shape "VM.Standard.E4.Flex" --shape-config '{"ocpus": 1, "memoryInGBs": 16}' --image-id $Env:linux_image_id --ssh-authorized-keys-file $Env:path_to_authorized_keys_file
```

- 결과 샘플
```json
{
  "data": {
    "agent-config": {
      "are-all-plugins-disabled": false,
      "is-management-disabled": false,
      "is-monitoring-disabled": false,
      "plugins-config": null
    },
    "availability-config": {
      "is-live-migration-preferred": null,
      "recovery-action": "RESTORE_INSTANCE"
    },
    "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
    "capacity-reservation-id": null,
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "dedicated-vm-host-id": null,
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-06T04:54:25.189Z"
      }
    },
    "display-name": "my-linux",
    "extended-metadata": {},
    "fault-domain": "FAULT-DOMAIN-3",
    "freeform-tags": {},
    "id": "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsacp6yojrw4o6hkoenx56lilfn2jzrfjpcmpvtfqtxfybgq",
    "image-id": "ocid1.image.oc1.ap-seoul-1.aaaaaaaaipgkmhwis7wmcc4rcrunq254nkhouw36dbujnpkvcupswag5ckiq",
    "instance-options": {
      "are-legacy-imds-endpoints-disabled": false
    },
    "ipxe-script": null,
    "launch-mode": "PARAVIRTUALIZED",
    "launch-options": {
      "boot-volume-type": "PARAVIRTUALIZED",
      "firmware": "UEFI_64",
      "is-consistent-volume-naming-enabled": true,
      "is-pv-encryption-in-transit-enabled": false,
      "network-type": "PARAVIRTUALIZED",
      "remote-data-volume-type": "PARAVIRTUALIZED"
    },
    "lifecycle-state": "PROVISIONING",
    "metadata": {
      "ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDwPjWOVhBuC91ta7pHVOytniPrhrYx5xtXCtCBmyRCNXxmI22fQv5GuljjRWJBNiSuuqaB5orRUPq0APNrdQ61rHxGfIFs1sO9HN+H+m1JKWZ+b3r9Li3MGYrkYoq3XnQ6wxwfRYrj0MtCb+BwXjsFlgK5KvirZh2RJ4DprGBl2KpyMyDBAnD0yT2hzx9SFcUeddlk62hRhgtlGi56HT2hmWC4JWolWJ/teY9C2tbBAoW2CwzTZldqbaOEGU/MTkGRDFEy+7rGCMReJyL7bkyqdye6Nks1ZKSInfWPGjL9yasfNUbXServAMt++AelXBz1HDiM6Mzxe5xghKM/th9t yh@MacBookPro\n"
    },
    "platform-config": null,
    "preemptible-instance-config": null,
    "region": "ap-seoul-1",
    "shape": "VM.Standard.E4.Flex",
    "shape-config": {
      "baseline-ocpu-utilization": null,
      "gpu-description": null,
      "gpus": 0,
      "local-disk-description": null,
      "local-disks": 0,
      "local-disks-total-size-in-gbs": null,
      "max-vnic-attachments": 2,
      "memory-in-gbs": 16.0,
      "networking-bandwidth-in-gbps": 1.0,
      "ocpus": 1.0,
      "processor-description": "2.55 GHz AMD EPYC\u2122 7J13 (Milan)"
    },
    "source-details": {
      "boot-volume-size-in-gbs": null,
      "boot-volume-vpus-per-gb": null,
      "image-id": "ocid1.image.oc1.ap-seoul-1.aaaaaaaaipgkmhwis7wmcc4rcrunq254nkhouw36dbujnpkvcupswag5ckiq",
      "kms-key-id": null,
      "source-type": "image"
    },
    "system-tags": {},
    "time-created": "2023-01-06T04:54:25.624000+00:00",
    "time-maintenance-reboot-due": null
  },
  "etag": "d7594c56439d46369fd0f3c36a9a768f2346cbf3fc9c5b2d4d6d9a1d3356da8a",
  "opc-work-request-id": "ocid1.coreservicesworkrequest.oc1.ap-seoul-1.abuwgljrnb4gikbuzfucsjcpouoshw4yesgom6sdpb3raog6io6kdvjdixlq"
}
```

- 생성된 인스턴스OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-7.png " ")
</details>
{::options parse_block_html="false" /}

##### 2. 블록 볼륨 생성하기
- 도움말 보기 : `oci bv volume create -h`
- 블록 볼륨을 생성하기 위해서 다음과 같이 파라미터를 설정하여 명령어를 실행해야 합니다.
- **availability_domain_name** : 서울리전의 AD 이름을 입력합니다. 예) `wXsg:AP-SEOUL-1-AD-1`
- **compartment_id** : 실습을 진행하고 있는 구획의 ID를 입력합니다.
- **size_in_mbs** : 생성할 블록볼륨의 사이즈를 입력합니다. 실습에서는 50GB로 설정하여 생성하겠습니다. 예) `51200`
- **display_name** : 생성할 블록볼륨의 이름을 입력합니다. 예) `my-bv`
    ```terminal
    $ oci bv volume create --availability-domain "<availability_domain_name>" -c <compartment_id> --size-in-mbs <size_in_mbs> --display-name <display_name>
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>블록볼륨 생성 명령어(Linux)</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci bv volume create --availability-domain "wXsg:AP-SEOUL-1-AD-1" -c $compartment_id --size-in-mbs 51200 --display-name my-bv
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> oci bv volume create --availability-domain "wXsg:AP-SEOUL-1-AD-1" -c $Env:compartment_id --size-in-mbs 51200 --display-name my-bv
```

- 결과 샘플
```json
{
  "data": {
    "auto-tuned-vpus-per-gb": 10,
    "autotune-policies": [
      {
        "autotune-type": "DETACHED_VOLUME"
      }
    ],
    "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
    "block-volume-replicas": null,
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-09T04:00:28.057Z"
      }
    },
    "display-name": "my-bv",
    "freeform-tags": {},
    "id": "ocid1.volume.oc1.ap-seoul-1.abuwgljrupnwlpq2tx7bhodmwd6q2xhgjpc62cm5lr2mg3gnyjmobdwjtp5q",
    "is-auto-tune-enabled": true,
    "is-hydrated": null,
    "kms-key-id": null,
    "lifecycle-state": "PROVISIONING",
    "size-in-gbs": 50,
    "size-in-mbs": 51200,
    "source-details": null,
    "system-tags": {},
    "time-created": "2023-01-09T04:00:28.084000+00:00",
    "volume-group-id": null,
    "vpus-per-gb": 10
  },
  "etag": "e002e9a86c8f02f3e48e34d7b0a2772d"
}
```

- 생성된 스토리지를 OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-5.png " ")
</details>
{::options parse_block_html="false" /}

##### 3. 블록 볼륨 연결하기
- 도움말 보기 : `oci compute volume-attachment attach -h`
- 생성한 블록볼륨을 연결하기 위해서 아래와 같이 파라미터를 설정하여 명령어를 실행합니다.
- **instance_id** : 블록볼륨을 연결할 Compute Instance의 ID를 입력합니다.
- **type** : 블록볼륨을 연결할 때 사용할 연결 방식을 입력합니다. 실습에서는 **iscsi**로 설정하여 진행하겠습니다. 예) `iscsi`
- **volume_id** : 위 단계에서 생성한 블록볼륨의 ID를 입력합니다.
    ```terminal
    $ oci compute volume-attachment attach --instance-id <instance_id> --type <iscsi> --volume-id <volume_id>
    ```


{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>블록볼륨 연결 명령어(Linux)</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export instance_id=ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsacp6yojrw4o6hkoenx56lilfn2jzrfjpcmpvtfqtxfybgq
$ export volume_id=ocid1.volume.oc1.ap-seoul-1.abuwgljrupnwlpq2tx7bhodmwd6q2xhgjpc62cm5lr2mg3gnyjmobdwjtp5q
$ oci compute volume-attachment attach --instance-id $instance_id --type iscsi --volume-id $volume_id
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:instance_id = "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsacp6yojrw4o6hkoenx56lilfn2jzrfjpcmpvtfqtxfybgq"
C:\> $Env:volume_id = "ocid1.volume.oc1.ap-seoul-1.abuwgljrupnwlpq2tx7bhodmwd6q2xhgjpc62cm5lr2mg3gnyjmobdwjtp5q"
C:\> oci compute volume-attachment attach --instance-id $Env:instance_id --type iscsi --volume-id $Env:volume_id
```

- 결과 샘플
```json
{
  "data": {
    "attachment-type": "iscsi",
    "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
    "chap-secret": null,
    "chap-username": null,
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "device": null,
    "display-name": "volumeattachment20230109041009",
    "encryption-in-transit-type": "NONE",
    "id": "ocid1.volumeattachment.oc1.ap-seoul-1.anuwgljrkv6tzsacyd23s7rrmbuw4y3d7pavkpewoniaaio4nfipdfgtirwq",
    "instance-id": "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsacp6yojrw4o6hkoenx56lilfn2jzrfjpcmpvtfqtxfybgq",
    "ipv4": null,
    "iqn": null,
    "is-agent-auto-iscsi-login-enabled": null,
    "is-multipath": null,
    "is-pv-encryption-in-transit-enabled": false,
    "is-read-only": false,
    "is-shareable": false,
    "iscsi-login-state": null,
    "lifecycle-state": "ATTACHING",
    "multipath-devices": null,
    "port": null,
    "time-created": "2023-01-09T04:10:09.319000+00:00",
    "volume-id": "ocid1.volume.oc1.ap-seoul-1.abuwgljrupnwlpq2tx7bhodmwd6q2xhgjpc62cm5lr2mg3gnyjmobdwjtp5q"
  },
  "etag": "e60335171e4a32cd62648e2e74149d5b7f9f00dca3c5b384fbacae0807cfb36c"
}
```

- 스토리지가 인스턴스에 연결되었음을 OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-6.png " ")
</details>
{::options parse_block_html="false" /}


#### CLI를 이용하여 Windows 인스턴스를 시작하기
Windows 인스턴스를 시작하는 방법은 Linux 인스턴스를 시작하는 방법과 거의 유사하지만 Image의 ID, 그리고 키 파일을 별도로 지정하지 않는다는 차이점이 존재합니다.
그럼 지금부터 Windows 인스턴스를 시작해보겠습니다.

##### 1. Windows 인스턴스 시작하기
- 도움말 보기 : `oci compute instance launch -h`
- 인스턴스를 시작하기 위한 CLI 명령어는 아래 여러가지 파라미터의 값을 설정하여 실행합니다.
    ```terminal
    $ oci compute instance launch --availability-domain "<availability_domain_name>" 
      -c <compartment_id> --subnet-id  <subnet_id> --display-name "<display_name>" 
      --shape "<shape_name>" --shape-config '{"ocpus": 1, "memoryInGBs": 16}'    
      --image-id <image_id>  
    ```

- **availability_domain_name** : 인스턴스를 시작할 대상 AD의 이름을 입력합니다. 서울 리전의 경우 `wXsg:AP-SEOUL-1-AD-1`를 입력합니다.
- **compartment_id** : 인스턴스를 시작할 대상 구획의 OCID를 입력합니다.
- **subnet_id** : 위에서 생성한 서브넷의 OCID를 입력합니다.
- **display_name** : 인스턴스의 이름을 지정합니다. 예) `my-windows`
- **shape_name** : 인스턴스의 Shape 이름을 지정합니다. 이번 실습에서는 `VM.Standard.E4.Flex`를 사용합니다.
    - 인스턴스의 shape을 Flex로 설정할 경우 shape-config 설정을 통해 원하는 ocpu, memory 값을 추가로 지정해야 합니다.
      ```json
      { "ocpus": 1, "memoryInGBs": 16 }    
      ```

- **image_id** : 인스턴스를 시작할때 사용할 이미지의 ID를 입력합니다. 실습에서는 Oracle Linux 8 이미지를 사용합니다.
    - Windows : **Windows-Server-2022-Standard-Edition-VM-2022.09.06-0**
  ```text
  ocid1.image.oc1.ap-seoul-1.aaaaaaaanqhp46r4rbyz2gvt5zfdkjv5om4bfo6kvcn6hi6isgx44hsmaeya
  ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>컴퓨트 인스턴스 생성 명령어(Windows)</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ export subnet_id=ocid1.subnet.oc1.ap-seoul-1.aaaaaaaazx7qo5s7dvisukrim475sxwvmauvilpzwu3pilbiph3li7cuipma
$ export windows_image_id=ocid1.image.oc1.ap-seoul-1.aaaaaaaanqhp46r4rbyz2gvt5zfdkjv5om4bfo6kvcn6hi6isgx44hsmaeya
$ oci compute instance launch --availability-domain "wXsg:AP-SEOUL-1-AD-1" -c $compartment_id --subnet-id  $subnet_id --display-name "my-windows" --shape "VM.Standard.E4.Flex" --shape-config '{"ocpus": 1, "memoryInGBs": 16}' --image-id $windows_image_id 
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> $Env:subnet_id = "ocid1.subnet.oc1.ap-seoul-1.aaaaaaaazx7qo5s7dvisukrim475sxwvmauvilpzwu3pilbiph3li7cuipma"
C:\> $Env:windows_image_id = "ocid1.image.oc1.ap-seoul-1.aaaaaaaanqhp46r4rbyz2gvt5zfdkjv5om4bfo6kvcn6hi6isgx44hsmaeya"
C:\> oci compute instance launch --availability-domain "wXsg:AP-SEOUL-1-AD-1" -c $Env:compartment_id --subnet-id  $Env:subnet_id --display-name "my-linux" --shape "VM.Standard.E4.Flex" --shape-config '{"ocpus": 1, "memoryInGBs": 16}' --image-id $Env:windows_image_id
```


- 결과 샘플
```json
{
  "data": {
    "agent-config": {
      "are-all-plugins-disabled": false,
      "is-management-disabled": false,
      "is-monitoring-disabled": false,
      "plugins-config": null
    },
    "availability-config": {
      "is-live-migration-preferred": null,
      "recovery-action": "RESTORE_INSTANCE"
    },
    "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
    "capacity-reservation-id": null,
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "dedicated-vm-host-id": null,
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-09T04:28:54.145Z"
      }
    },
    "display-name": "my-windows",
    "extended-metadata": {},
    "fault-domain": "FAULT-DOMAIN-1",
    "freeform-tags": {},
    "id": "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q",
    "image-id": "ocid1.image.oc1.ap-seoul-1.aaaaaaaanqhp46r4rbyz2gvt5zfdkjv5om4bfo6kvcn6hi6isgx44hsmaeya",
    "instance-options": {
      "are-legacy-imds-endpoints-disabled": false
    },
    "ipxe-script": null,
    "launch-mode": "NATIVE",
    "launch-options": {
      "boot-volume-type": "PARAVIRTUALIZED",
      "firmware": "UEFI_64",
      "is-consistent-volume-naming-enabled": false,
      "is-pv-encryption-in-transit-enabled": false,
      "network-type": "VFIO",
      "remote-data-volume-type": "PARAVIRTUALIZED"
    },
    "lifecycle-state": "PROVISIONING",
    "metadata": {},
    "platform-config": null,
    "preemptible-instance-config": null,
    "region": "ap-seoul-1",
    "shape": "VM.Standard.E4.Flex",
    "shape-config": {
      "baseline-ocpu-utilization": null,
      "gpu-description": null,
      "gpus": 0,
      "local-disk-description": null,
      "local-disks": 0,
      "local-disks-total-size-in-gbs": null,
      "max-vnic-attachments": 2,
      "memory-in-gbs": 16.0,
      "networking-bandwidth-in-gbps": 1.0,
      "ocpus": 1.0,
      "processor-description": "2.55 GHz AMD EPYC\u2122 7J13 (Milan)"
    },
    "source-details": {
      "boot-volume-size-in-gbs": null,
      "boot-volume-vpus-per-gb": null,
      "image-id": "ocid1.image.oc1.ap-seoul-1.aaaaaaaanqhp46r4rbyz2gvt5zfdkjv5om4bfo6kvcn6hi6isgx44hsmaeya",
      "kms-key-id": null,
      "source-type": "image"
    },
    "system-tags": {},
    "time-created": "2023-01-09T04:28:57.114000+00:00",
    "time-maintenance-reboot-due": null
  },
  "etag": "e80a24eae106e180869dac9748ec95f74649d7dd818cba9530602e66be9fcc5a",
  "opc-work-request-id": "ocid1.coreservicesworkrequest.oc1.ap-seoul-1.abuwgljrdkew53kl75ajdpo3rma4l2phdp3ldnoc2yjaa43gtbhhbqbi3xea"
}
```

- 생성된 인스턴스OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-8.png " ")
</details>
{::options parse_block_html="false" /}


##### 2. 블록 볼륨 생성하기
- 도움말 보기 : `oci bv volume create -h`
- 블록 볼륨을 생성하기 위해서 다음과 같이 파라미터를 설정하여 명령어를 실행해야 합니다.
- **availability_domain_name** : 서울리전의 AD 이름을 입력합니다. 예) `wXsg:AP-SEOUL-1-AD-1`
- **compartment_id** : 실습을 진행하고 있는 구획의 ID를 입력합니다.
- **size_in_mbs** : 생성할 블록볼륨의 사이즈를 입력합니다. 실습에서는 50GB로 설정하여 생성하겠습니다. 예) `51200`
- **display_name** : 생성할 블록볼륨의 이름을 입력합니다. 예) `my-bv-windows`
    ```terminal
    $ oci bv volume create --availability-domain "<availability_domain_name>" -c <compartment_id> --size-in-mbs <size_in_mbs> --display-name <display_name>
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>블록볼륨 생성 명령어(Windows)</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
$ oci bv volume create --availability-domain "wXsg:AP-SEOUL-1-AD-1" -c $compartment_id --size-in-mbs 51200 --display-name my-bv-windows
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
C:\> oci bv volume create --availability-domain "wXsg:AP-SEOUL-1-AD-1" -c $Env:compartment_id --size-in-mbs 51200 --display-name my-bv-windows
```

- 결과 샘플
```json
{
  "data": {
    "auto-tuned-vpus-per-gb": 10,
    "autotune-policies": [
      {
        "autotune-type": "DETACHED_VOLUME"
      }
    ],
    "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
    "block-volume-replicas": null,
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-09T04:37:52.584Z"
      }
    },
    "display-name": "my-bv-windows",
    "freeform-tags": {},
    "id": "ocid1.volume.oc1.ap-seoul-1.abuwgljrgy2kdpauvhrsr4liqwfpzgrcqxfqgz27w6uvkaupzpq2xnbqc6fq",
    "is-auto-tune-enabled": true,
    "is-hydrated": null,
    "kms-key-id": null,
    "lifecycle-state": "PROVISIONING",
    "size-in-gbs": 50,
    "size-in-mbs": 51200,
    "source-details": null,
    "system-tags": {},
    "time-created": "2023-01-09T04:37:52.591000+00:00",
    "volume-group-id": null,
    "vpus-per-gb": 10
  },
  "etag": "0539e4f97ebf6c1473bdd7d2b93c4544"
}
```

- 생성된 스토리지를 OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-9.png " ")
</details>
{::options parse_block_html="false" /}

##### 3. 블록 볼륨 연결하기
- 도움말 보기 : `oci compute volume-attachment attach -h`
- 생성한 블록볼륨을 연결하기 위해서 아래와 같이 파라미터를 설정하여 명령어를 실행합니다.
- **instance_id** : 블록볼륨을 연결할 Windows Compute Instance의 ID를 입력합니다.
- **type** : 블록볼륨을 연결할 때 사용할 연결 방식을 입력합니다. 실습에서는 **iscsi**로 설정하여 진행하겠습니다. 예) `iscsi`
- **volume_id** : 위 단계에서 생성한 Windows의 블록볼륨의 ID를 입력합니다.
    ```terminal
    $ oci compute volume-attachment attach --instance-id <instance_id> --type <iscsi> --volume-id <volume_id>
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>블록볼륨 연결 명령어(Linux)</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export instance_id=ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q
$ export volume_id=ocid1.volume.oc1.ap-seoul-1.abuwgljrgy2kdpauvhrsr4liqwfpzgrcqxfqgz27w6uvkaupzpq2xnbqc6fq
$ oci compute volume-attachment attach --instance-id $instance_id --type iscsi --volume-id $volume_id
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:instance_id = "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q"
C:\> $Env:volume_id = "ocid1.volume.oc1.ap-seoul-1.abuwgljrgy2kdpauvhrsr4liqwfpzgrcqxfqgz27w6uvkaupzpq2xnbqc6fq"
C:\> oci compute volume-attachment attach --instance-id $Env:instance_id --type iscsi --volume-id $Env:volume_id
```

- 결과 샘플
```json
{
  "data": {
    "attachment-type": "iscsi",
    "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
    "chap-secret": null,
    "chap-username": null,
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
    "device": null,
    "display-name": "volumeattachment20230109044147",
    "encryption-in-transit-type": "NONE",
    "id": "ocid1.volumeattachment.oc1.ap-seoul-1.anuwgljrkv6tzsacwmf343afvcp6yr7ycglna2rr5zqwwpyfuguel5aocjya",
    "instance-id": "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q",
    "ipv4": null,
    "iqn": null,
    "is-agent-auto-iscsi-login-enabled": null,
    "is-multipath": null,
    "is-pv-encryption-in-transit-enabled": false,
    "is-read-only": false,
    "is-shareable": false,
    "iscsi-login-state": null,
    "lifecycle-state": "ATTACHING",
    "multipath-devices": null,
    "port": null,
    "time-created": "2023-01-09T04:41:47.781000+00:00",
    "volume-id": "ocid1.volume.oc1.ap-seoul-1.abuwgljrgy2kdpauvhrsr4liqwfpzgrcqxfqgz27w6uvkaupzpq2xnbqc6fq"
  },
  "etag": "593e062dcecc4aaa2d13d2944a7e03061d09b123504b7653f6bcac6248ea5b60"
}
```

- 스토리지가 인스턴스에 연결되었음을 OCI 콘솔에서 확인
  ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-10.png " ")
</details>
{::options parse_block_html="false" /}

#### 생성한 인스턴스에 접속하기
여기까지 잘 진행되셨다면 Linux 인스턴스와 Windows 인스턴스가 각각 1개씩 생성되었을 겁니다.
이제 인스턴스에 접속하기 위해서 Linux 인스턴스는 Public IP를 확인해 보고, Windows 인스턴스는 Public IP와 Initial credentials을 확인해보겠습니다.

##### 1. Linux & Windows 인스턴스에 접속하기 위한 Public IP 확인하기
- 도움말 보기 : `oci compute instance list-vnics -h`
- 인스턴스에 접속하기 위한 Public IP를 확인하기 위해 아래 파라미터와 함께 명령어를 입력합니다.
- - **instance_id** : 블록볼륨을 연결할 Windows Compute Instance의 ID를 입력합니다.
    ```terminal
    oci compute instance list-vnics --instance-id <instance_id>
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>인스턴스 접속 정보(VNIC) 조회</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export instance_id=ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q
$ oci compute instance list-vnics --instance-id $instance_id
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:instance_id = "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q"
C:\> oci compute instance list-vnics --instance-id $Env:instance_id
```

- 결과 샘플
```json
{
  "data": [
    {
      "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
      "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
      "defined-tags": {
        "Oracle-Tags": {
          "CreatedBy": "default/young.hwan.cho@oracle.com",
          "CreatedOn": "2023-01-09T04:28:56.594Z"
        }
      },
      "display-name": "my-windows",
      "freeform-tags": {},
      "hostname-label": "my-windows",
      "id": "ocid1.vnic.oc1.ap-seoul-1.abuwgljruxlwkpwgayit7oxuufhmby2mcf5dti6bgtnu5ak63y5b72eba75q",
      "is-primary": true,
      "lifecycle-state": "AVAILABLE",
      "mac-address": "02:00:17:01:2C:3B",
      "nsg-ids": [],
      "private-ip": "10.0.0.11",
      "public-ip": "140.238.31.181",
      "skip-source-dest-check": false,
      "subnet-id": "ocid1.subnet.oc1.ap-seoul-1.aaaaaaaazx7qo5s7dvisukrim475sxwvmauvilpzwu3pilbiph3li7cuipma",
      "time-created": "2023-01-09T04:29:00.497000+00:00",
      "vlan-id": null
    }
  ]
}
```

</details>
{::options parse_block_html="false" /}

##### 2. Winodws 인스턴스에 접속하기 위한 초기 인증정보 확인하기
- 도움말 보기 : `oci compute instance get-windows-initial-creds -h`
- 인스턴스에 접속하기 위한 Public IP를 확인하기 위해 아래 파라미터와 함께 명령어를 입력합니다.
- **instance_id** : 블록볼륨을 연결할 Windows Compute Instance의 ID를 입력합니다.
    ```terminal
    oci compute instance get-windows-initial-creds --instance-id  <instance_id>
    ```

{::options parse_block_html="true" /}
<details><summary><h5 style="color:cornflowerblue;">- <b>초기 인증 정보(Windows) 조회</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>
- <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

- 명령어 샘플 (리눅스 계열)
```terminal
$ export instance_id=ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q
$ oci compute instance get-windows-initial-creds --instance-id $instance_id
```

- 명령어 샘플 (윈도우 계열)
```terminal
C:\> $Env:instance_id = "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q"
C:\> oci compute instance get-windows-initial-creds --instance-id $Env:instance_id
```

- 결과 샘플
```json
{
    "data": {
      "password": "36R3EnmKaWxbK",
      "username": "opc"
    }
}
```

</details>
{::options parse_block_html="false" /}

##### 3. 인스턴스에 접속하기 (링크)
- 리눅스 인스턴스 접속 방법 : [리눅스 인스턴스 접속 방법](/getting-started/launching-linux-instance/#리눅스-인스턴스-접속을-위한-준비){:target="_blank" rel="noopener"}의 내용을 따라 접속합니다.
- 윈도우 인스턴스 접속 방법 : [윈도우 인스턴스 접속 방법](/getting-started/launching-windows-instance/#윈도우즈-인스턴스-접속을-위한-준비){:target="_blank" rel="noopener"}의 내용을 따라 접속합니다.

#### 실습 리소스 정리하기
여기까지 모두 진행 후 실습에서 사용한 리소스를 종료하길 원하신다면 아래 절차에 따라 생성한 리소스를 종료해주세요.

##### 1. 블록 볼륨 연결 해제 및 삭제 하기
- 블록볼륨을 삭제하기 위해서는 먼저 연결된 블록볼륨 리스트를 조회하고, 연결된 블록볼륨은 인스턴스에서 연결 해제합니다. 그 이후 연결 해제된 블록볼륨을 삭제합니다.
  1. 블록 볼륨이 연결된 리스트 조회하기
      - 도움말 보기 : `oci compute volume-attachment list -h`
      - 블록 볼륨이 연결된 리스트를 조회하기 위해서 아래 파라미터와 같이 명령어를 실행합니다.
      - **compartment_id** : 블록볼륨이 연결된 내역을 조회할 구획의 ID를 입력합니다.
          ```terminal
          oci compute volume-attachment list -c <compartment_id>
          ```
        {::options parse_block_html="true" /}
        <details><summary><h5 style="color:cornflowerblue;">- <b>연결된 블록볼륨 리스트 조회</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

          - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>
    
          - 명령어 샘플 (리눅스 계열)
        ```terminal
        $ export compartment_id=ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka
        $ oci compute volume-attachment list -c $compartment_id
        ```

          - 명령어 샘플 (윈도우 계열)
        ```terminal
        C:\> $Env:compartment_id = "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka"
        C:\> oci compute volume-attachment list -c $Env:compartment_id
        ```

          - 결과 샘플
        ```json
        {
          "data": [
            {
              "attachment-type": "iscsi",
              "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
              "chap-secret": null,
              "chap-username": null,
              "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
              "device": null,
              "display-name": "volumeattachment20230109044147",
              "encryption-in-transit-type": "NONE",
              "id": "ocid1.volumeattachment.oc1.ap-seoul-1.anuwgljrkv6tzsacwmf343afvcp6yr7ycglna2rr5zqwwpyfuguel5aocjya",
              "instance-id": "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q",
              "ipv4": "169.254.2.2",
              "iqn": "iqn.2015-12.com.oracleiaas:9ac8f33d-bbf6-4466-85bf-0f2f90b21c8a",
              "is-agent-auto-iscsi-login-enabled": null,
              "is-multipath": null,
              "is-pv-encryption-in-transit-enabled": false,
              "is-read-only": false,
              "is-shareable": false,
              "iscsi-login-state": null,
              "lifecycle-state": "ATTACHED",
              "multipath-devices": null,
              "port": 3260,
              "time-created": "2023-01-09T04:41:47.781000+00:00",
              "volume-id": "ocid1.volume.oc1.ap-seoul-1.abuwgljrgy2kdpauvhrsr4liqwfpzgrcqxfqgz27w6uvkaupzpq2xnbqc6fq"
            },
            {
              "attachment-type": "iscsi",
              "availability-domain": "wXsg:AP-SEOUL-1-AD-1",
              "chap-secret": null,
              "chap-username": null,
              "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
              "device": null,
              "display-name": "volumeattachment20230109041009",
              "encryption-in-transit-type": "NONE",
              "id": "ocid1.volumeattachment.oc1.ap-seoul-1.anuwgljrkv6tzsacyd23s7rrmbuw4y3d7pavkpewoniaaio4nfipdfgtirwq",
              "instance-id": "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsacp6yojrw4o6hkoenx56lilfn2jzrfjpcmpvtfqtxfybgq",
              "ipv4": "169.254.2.2",
              "iqn": "iqn.2015-12.com.oracleiaas:4f29ec30-4458-4f5a-86c8-28f45f71583e",
              "is-agent-auto-iscsi-login-enabled": null,
              "is-multipath": null,
              "is-pv-encryption-in-transit-enabled": false,
              "is-read-only": false,
              "is-shareable": false,
              "iscsi-login-state": null,
              "lifecycle-state": "ATTACHED",
              "multipath-devices": null,
              "port": 3260,
              "time-created": "2023-01-09T04:10:09.319000+00:00",
              "volume-id": "ocid1.volume.oc1.ap-seoul-1.abuwgljrupnwlpq2tx7bhodmwd6q2xhgjpc62cm5lr2mg3gnyjmobdwjtp5q"
            }
          ]
        }
        ```

        </details>
        {::options parse_block_html="false" /}
        
      
        
  2. 연결된 블록볼륨 해제하기
      - 도움말 보기 : `oci compute volume-attachment detach -h`
      - 블록 볼륨이 연결된 리스트를 조회하기 위해서 아래 파라미터와 같이 명령어를 실행합니다.
      - **volume_attachment_id** : 위 단계에서 조회한 해제할 블록볼륨 연결의 ID를 입력합니다.
          ```terminal
          oci compute volume-attachment detach --volume-attachment-id <volume_attachment_id>
          ```
        {::options parse_block_html="true" /}
        <details><summary><h5 style="color:cornflowerblue;">- <b>연결된 블록볼륨 해제하기</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

          - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>
    
          - 명령어 샘플 (리눅스 계열)
        ```terminal
        $ export volume_attachment_id=ocid1.volumeattachment.oc1.ap-seoul-1.anuwgljrkv6tzsacwmf343afvcp6yr7ycglna2rr5zqwwpyfuguel5aocjya
        $ oci compute volume-attachment detach --volume-attachment-id $volume_attachment_id
        ```

          - 명령어 샘플 (윈도우 계열)
        ```terminal
        C:\> $Env:volume_attachment_id = "ocid1.volumeattachment.oc1.ap-seoul-1.anuwgljrkv6tzsacwmf343afvcp6yr7ycglna2rr5zqwwpyfuguel5aocjya"
        C:\> oci compute volume-attachment detach --volume-attachment-id $Env:volume_attachment_id
        ```

          - 결과 샘플
        ```text
        결과 없음
        ```

        </details>
        {::options parse_block_html="false" /}
  3. 블록볼륨 삭제하기
      - 도움말 보기 : `oci bv volume delete -h`
      - 블록 볼륨이 연결된 리스트를 조회하기 위해서 아래 파라미터와 같이 명령어를 실행합니다.
      - **volume_id** : 위 단계에서 조회한 해제할 블록볼륨 연결의 ID를 입력합니다.
          ```terminal
          oci bv volume delete --volume-id <volume_id> --force
          ```
        {::options parse_block_html="true" /}
        <details><summary><h5 style="color:cornflowerblue;">- <b>블록볼륨 삭제하기</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

          - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>
        
          - 명령어 샘플 (리눅스 계열)
        ```terminal
        $ export volume_id=ocid1.volume.oc1.ap-seoul-1.abuwgljrgy2kdpauvhrsr4liqwfpzgrcqxfqgz27w6uvkaupzpq2xnbqc6fq
        $ oci bv volume delete --volume-id $volume_id --force
        ```

          - 명령어 샘플 (윈도우 계열)
        ```terminal
        C:\> $Env:volume_attachment_id = "ocid1.volume.oc1.ap-seoul-1.abuwgljrgy2kdpauvhrsr4liqwfpzgrcqxfqgz27w6uvkaupzpq2xnbqc6fq"
        C:\> oci bv volume delete --volume-id $Env:volume_id --force
        ```

          - 결과 샘플
        ```text
        결과 없음
        ```
        
        - 스토리지가 삭제되었음을 OCI 콘솔에서 확인
        ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-11.png " ")
        </details>
        {::options parse_block_html="false" /}


##### 2. 인스턴스 종료하기
- 도움말 보기 : `oci compute instance terminate -h`
- 생성한 인스턴스를 종료하기 위해 아래 파라미터와 같이 명령어를 실행합니다.
- **instance_id** : 위 단계에서 조회한 해제할 블록볼륨 연결의 ID를 입력합니다.
    ```terminal
    oci compute instance terminate --instance-id <instance_id>
    ```
  {::options parse_block_html="true" /}
  <details><summary><h5 style="color:cornflowerblue;">- <b>인스턴스 종료 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

    - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>
  
    - 명령어 샘플 (리눅스 계열)
  ```terminal
  $ export instance_id=ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsacp6yojrw4o6hkoenx56lilfn2jzrfjpcmpvtfqtxfybgq
  $ oci compute instance terminate --instance-id $instance_id
  ```
  ```text
  Are you sure you want to delete this resource? [y/N]:
  ```

    - 명령어 샘플 (윈도우 계열)
  ```terminal
  C:\> $Env:instance_id = "ocid1.instance.oc1.ap-seoul-1.anuwgljrkv6tzsac4v6ylilhsp363nmiripsyyfqag5qh2rpl3rrzzjqok4q"
  C:\> oci compute instance terminate --instance-id $Env:instance_id
  ```
  ```text
  Are you sure you want to delete this resource? [y/N]:
  ```

    - 결과 샘플
  ```text
  결과 없음
  ```
  
  - 인스턴스가 종료 중 또는 종료되었음을 OCI 콘솔에서 확인합니다.
    ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-12.png " ")
  </details>
  {::options parse_block_html="false" /}


##### 3. 가상 클라우드 네트워크 리소스 삭제하기
- 가상 클라우드 네트워크 리소스 삭제 하려면 2단계로 구분하여 리소스를 삭제합니다. 먼저 서브넷을 삭제한 후 인터넷 게이트웨이를 삭제하기 위해 경로테이블의 규칙을 삭제한 후 마지막으로 VCN을 삭제합니다.
  1. 서브넷 삭제하기 
        - 도움말 보기 : `oci network subnet delete -h`
        - 실습에 사용한 VCN의 서브넷을 삭제하기 위해 아래 파라미터와 함께 명령어를 실행합니다.
        - **subnet_id** : 삭제할 서브넷의 ID를 입력합니다.
            ```terminal
             oci network subnet delete --subnet-id <subnet_id> --force
            ```
          {::options parse_block_html="true" /}
          <details><summary><h5 style="color:cornflowerblue;">- <b>VCN의 서브넷 삭제 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

            - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>

            - 명령어 샘플 (리눅스 계열)
          ```terminal
          $ export subnet_id=ocid1.subnet.oc1.ap-seoul-1.aaaaaaaazx7qo5s7dvisukrim475sxwvmauvilpzwu3pilbiph3li7cuipma
          $ oci network subnet delete --subnet-id $subnet_id --force
          ```

            - 명령어 샘플 (윈도우 계열)
          ```terminal
          C:\> $Env:subnet_id = "ocid1.subnet.oc1.ap-seoul-1.aaaaaaaazx7qo5s7dvisukrim475sxwvmauvilpzwu3pilbiph3li7cuipma"
          C:\> oci network subnet delete --subnet-id $Env:subnet_id --force
          ```

            - 결과 샘플
          ```text
          결과 없음
          ```
          
          - 서브넷이 삭제되었음을 OCI 콘솔에서 확인합니다.
            ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-13.png " ")
          </details>
          {::options parse_block_html="false" /}
  2. 경로 테이블(Route Table) 규칙 삭제하기
      - 도움말 보기 : `oci network route-table update -h`
      - 실습에 사용한 VCN의 서브넷을 삭제하기 위해 아래 파라미터와 함께 명령어를 실행합니다.
      - **route_table_id** : 삭제할 인터넷 게이트웨이의 ID를 입력합니다.
          ```terminal
             $ oci network route-table update --rt-id <route_table_id> --route-rules '[]'
          ```
        {::options parse_block_html="true" /}
        <details><summary><h5 style="color:cornflowerblue;">- <b>경로 테이블 규칙 삭제 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

          - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>
        
          - 명령어 샘플 (리눅스 계열)
        ```terminal
        $ export route_table_id=ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq
        $ oci network route-table update --rt-id $route_table_id --route-rules '[]'
        ```
        ```text
        WARNING: Updates to defined-tags and freeform-tags and route-rules will replace any existing values. Are you sure you want to continue? [y/N]: y
        ```
          - 명령어 샘플 (윈도우 계열)
        ```terminal
        C:\> $Env:route_table_id = "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq"
        C:\> oci network route-table update --rt-id $Env:route_table_id --route-rules '[]'
        ```
        ```text
        WARNING: Updates to defined-tags and freeform-tags and route-rules will replace any existing values. Are you sure you want to continue? [y/N]: y
        ```

          - 결과 샘플
        ```json
        {
        "data": {
        "compartment-id": "ocid1.compartment.oc1..aaaaaaaawpaqdecuuohlray2q6i7mlbubfdgqfvdpmvgry2zonx37wy3f3ka",
        "defined-tags": {
        "Oracle-Tags": {
        "CreatedBy": "default/young.hwan.cho@oracle.com",
        "CreatedOn": "2023-01-05T04:16:47.157Z"
        }
        },
        "display-name": "Default Route Table for my-vcn-cli",
        "freeform-tags": {},
        "id": "ocid1.routetable.oc1.ap-seoul-1.aaaaaaaaqs3rjpcru35ysm5jyvi3v2vziqf4l5fyaa3425zu4nr6y6eoymiq",
        "lifecycle-state": "AVAILABLE",
        "route-rules": [],
        "time-created": "2023-01-05T04:16:47.267000+00:00",
        "vcn-id": "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
        },
        "etag": "fd31827e"
        }
        ```

        </details>
        {::options parse_block_html="false" /}
  3. 인터넷 게이트웨이 삭제하기
      - 도움말 보기 : `oci network internet-gateway delete -h`
      - 실습에 사용한 VCN의 서브넷을 삭제하기 위해 아래 파라미터와 함께 명령어를 실행합니다.
      - **ig_id** : 삭제할 인터넷 게이트웨이의 ID를 입력합니다.
          ```terminal
           oci network internet-gateway delete --ig-id <ig_id> --force
          ```
        {::options parse_block_html="true" /}
        <details><summary><h5 style="color:cornflowerblue;">- <b>인터넷 게이트웨이 삭제 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

          - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>
        
          - 명령어 샘플 (리눅스 계열)
        ```terminal
        $ export ig_id=ocid1.internetgateway.oc1.ap-seoul-1.aaaaaaaani5rdna3vlikdchufhiqbpogqggh6ehnctmfoiu5c5etteh2mxna
        $ oci network internet-gateway delete --ig-id $ig_id --force
        ```

          - 명령어 샘플 (윈도우 계열)
        ```terminal
        C:\> $Env:ig_id = "ocid1.internetgateway.oc1.ap-seoul-1.aaaaaaaani5rdna3vlikdchufhiqbpogqggh6ehnctmfoiu5c5etteh2mxna"
        C:\> oci network internet-gateway delete --ig-id $ig_id --force
        ```

          - 결과 샘플
        ```text
        결과 없음
        ```

          - 인터넷 게이트웨이가 삭제되었음을 OCI 콘솔에서 확인합니다.
            ![](/assets/img/getting-started/2022/cli/oci-getting-start-cli-14.png " ")
        </details>
        {::options parse_block_html="false" /}
  4. 보안목록 삭제하기
      - 도움말 보기 : `oci network security-list delete -h`
      - VCN을 삭제하기 위해 추가로 생성하였던 보안목록을 아래 파라미터와 함께 명령어를 실행하여 삭제합니다.
      - **security_list_id** : 위 단계에서 조회한 해제할 블록볼륨 연결의 ID를 입력합니다.
          ```terminal
          oci network security-list delete --security-list-id  <security_list_id> --force
          ```
        {::options parse_block_html="true" /}
        <details><summary><h5 style="color:cornflowerblue;">- <b>보안목록 삭제 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

          - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>
        
          - 명령어 샘플 (리눅스 계열)
        ```terminal
        $ export security_list_id=ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaamusjdk4mb5snn4wodziugvthz6dpzccbps2gooohseklngot3bsq
        $ oci network security-list delete --ecurity-list-id $security_list_id --force
        ```

          - 명령어 샘플 (윈도우 계열)
        ```terminal
        C:\> $Env:security_list_id = "ocid1.securitylist.oc1.ap-seoul-1.aaaaaaaamusjdk4mb5snn4wodziugvthz6dpzccbps2gooohseklngot3bsq"
        C:\> oci network security-list delete --vcn-id $Env:security_list_id --force
        ```

          - 결과 샘플
        ```text
        결과 없음
        ```

        </details>
        {::options parse_block_html="false" /}
  5. 가상 클라우드 네트워크 삭제하기
      - 도움말 보기 : `oci network vcn delete -h`
      - 마지막으로 가상 클라우드 네트워크를 삭제하기 위해 파라미터와 함께 명령어를 실행합니다.
      - **vcn_id** : 삭제할 VCN의 ID를 입력합니다.
          ```terminal
          oci network vcn delete --vcn-id  <vcn_id> --force
          ```
        {::options parse_block_html="true" /}
        <details><summary><h5 style="color:cornflowerblue;">- <b>가상클라우드 네트워크 삭제 명령어</b> 예제 및 결과예시 (클릭하여 보기)</h5></summary>

          - <mark><b>명령어 샘플의 환경변수에 대입된 각 리소스 ID는 실제 본인의 환경에 맞는 값으로 교체하여 실행해야 합니다. 아래 값은 샘플 입니다.</b></mark>
        
          - 명령어 샘플 (리눅스 계열)
        ```terminal
        $ export vcn_id=ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq
        $ oci network vcn delete --vcn-id $vcn_id --force
        ```

          - 명령어 샘플 (윈도우 계열)
        ```terminal
        C:\> $Env:vcn_id = "ocid1.vcn.oc1.ap-seoul-1.amaaaaaakv6tzsaasylnws5ppr76r3wwkqnccwn4msbrd2tuktiaqtuv4fmq"
        C:\> oci network vcn delete --vcn-id $Env:vcn_id --force
        ```

          - 결과 샘플
        ```text
        결과 없음
        ```

        </details>
        {::options parse_block_html="false" /}


### 마무리하며...
이번 포스팅에서는 OCI의 서비스의 리소스를 Command Line Interface(CLI)를 통해 조회, 생성, 삭제하는 실습을 진행해보았습니다.
실습을 통해 OCI 콘솔이 아닌 CLI를 통해 OCI 리소스를 관리하는 방법이 조금이나마 친숙해 지셨기를 바라겠습니다.

### 참고 자료
- [Get Started with the Command Line Interface](https://docs.oracle.com/en-us/iaas/Content/GSG/Tasks/gettingstartedwiththeCLI.htm)
- [Oracle Cloud Infrastructure CLI Command Reference](https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.22.0/oci_cli_docs/index.html)