---
layout: page-fullwidth
#
# Content
#
subheadline: "Compute"
title: "OCI Compute Instance SSH Key 복구 방법"
teaser: "OCI Compute Instance에서 SSH키 분실등의 이슈로 접속이 불가능한 상태에서 추가로 공개키를 등록하는 방법에 대해서 설명합니다."
author: dankim
date: 2022-07-09 00:00:00
breadcrumb: true
categories:
  - infrastructure
tags:
  - [oci, compute, sshkey_recovery]
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

### 실습을 위한 인스턴스 생성
아래 가이드를 참고하여 OCI Compute Linux Instance를 하나 생성합니다.  
[https://docs.oracle.com/en-us/iaas/Content/GSG/Reference/overviewworkflow.htm](https://docs.oracle.com/en-us/iaas/Content/GSG/Reference/overviewworkflow.htm)

생성 과정에서 SSH Key를 등록하는 부분이 있는데, **No SSH Keys**를 선택합니다.
![](/assets/img/infrastructure/2022/oci-recovery-sshkey-1.png)

### 콘솔 접속 실행 (Console Connection)
생성된 인스턴스 상세 화면 좌측 **리소스(Resources)** 메뉴에서 **콘솔 접속(Console Connection)**을 선택합니다. **콘솔 접속(Console Connection)** 화면에서 **로컬 접속 생성(Create local connection)** 버튼을 클릭한 후 팝업창에서 **전용 키 저장**을 클릭하여 저장합니다. 그리고 **콘솔 접속 생성(Create console connection)** 버튼을 클릭하여 **로컬 접속**을 생성합니다.
![](/assets/img/infrastructure/2022/oci-recovery-sshkey-2.png)

다운로드 받은 ssh의 Permission을 변경합니다.
```
$ chmod 400 ssh-key-2022-07-09.key
```

생성된 **로컬 접속** 우측 아이콘을 클릭하여 접속을 복사 합니다. 여기서는 **Linux/Mac용 직렬 콘솔 접속 복사 (Copy serial console connection for Linux/Mac**를 선택하여 복사하였습니다. 

![](/assets/img/infrastructure/2022/oci-recovery-sshkey-3.png)

다음과 같이 복사된 명령어를 터미널에서 실행하여 인스턴스 콘솔에 접속합니다. 주의할 부분은 앞서 다운로드 받은 sshkey 선택 옵션을 다음과 같이 추가해줘야 합니다.

> ssh -i /{path}/{ssh_key} -o ProxyCommand='ssh -i /{path}/{ssh_key} -W %h:%p -p 443..

아래는 예시입니다.
```
ssh -i ~/Downloads/ssh-key-2022-07-09.key -o ProxyCommand='ssh -i ~/Downloads/ssh-key-2022-07-09.key -W %h:%p -p 443 ocid1.instanceconsoleconnection.oc1.ap-seoul-1.anuwgljrvsea7yi...............@instance-console.ap-seoul-1.oci.oraclecloud.com' ocid1.instance.oc1.ap-seoul-1.anuwgljrvsea7yi...............
```

접속하면 다음과 같은 아웃풋을 볼 수 있습니다.
```
=================================================
IMPORTANT: Use a console connection to troubleshoot a malfunctioning instance. For normal operations, you should connect to the instance using a Secure Shell (SSH) or Remote Desktop connection. For steps, see https://docs.cloud.oracle.com/iaas/Content/Compute/Tasks/accessinginstance.htm

For more information about troubleshooting your instance using a console connection, see the documentation: https://docs.cloud.oracle.com/en-us/iaas/Content/Compute/References/serialconsole.htm#four
=================================================
```

### 인스턴스 재부팅 및 Boot Manager 진입
인스턴스 상세 화면에서 **인스턴스 재부팅 (Reboot)**을 클릭하여 재부팅 합니다.
![](/assets/img/infrastructure/2022/oci-recovery-sshkey-4.png)

> Oracle Autonomous Linux 7.x 또는 Oracle Linux 7.x에서는 재부팅을 하면 바로 Boot Menu를 확인 가능하지만, 이 외 버전에서는 Boot Manager로 진입한 후 UEFI Oracle BlockVolume을 선택하여 Boot Menu로 이동합니다. 여기서는 Oracle Linux 8버전을 사용하였기 때문에 Boot Manager로 접속하는 방법으로 진행합니다. Oracle Autonomous Linux 7.x 또는 Oracle Linux 7.x인 경우에는 아래 <strong>"Boot Menu에서 Boot 엔트리 수정"</strong> 단계부터 진행합니다.

재부팅을 하면 **콘솔 접속**한 터미널 화면에서 **Power Down**이라는 메세지가 보이는데, 이 때부터 **ESC키** 혹은 **F5키**를 연속으로 클릭합니다.
![](/assets/img/infrastructure/2022/oci-recovery-sshkey-3-1.png)

이제 다음과 같이 **Boot Manager** UI를 볼 수 있습니다. 
![](/assets/img/infrastructure/2022/oci-recovery-sshkey-5.png)

> Boot Manager 화면에 접속한 상태에서 OCI Console을 통해 인스턴스를 재시작 하는 경우 인스턴스가 영구적으로 멈출 수 있습니다. 이 경우 별도로 오라클의 서포트를 받아야 할 수 있으니, OCI Console에서 인스턴스 재부팅을 할 경우에는 반드시 Boot Manager를 빠져나온 후 재부팅을 하여야 합니다.

Boot Manager 메뉴에서 **UEFI Oracle BlockVolume**을 선택하고 **엔터**를 클릭한 후 바로 **ESC키** 혹은 **F5키**키(바로 입력하여야 합니다.)를 연속으로 클릭하면 다음과 같은 **Boot Menu**를 볼 수 있습니다.

![](/assets/img/infrastructure/2022/oci-recovery-sshkey-6.png)

### Boot Menu에서 Boot 엔트리 수정
여기서 바로 **e** 키를 선택하여 **부트 엔트리 수정** 화면으로 이동합니다.

![](/assets/img/infrastructure/2022/oci-recovery-sshkey-7.png)

### 부트 엔트리 수정 후 재부팅
커서를 이동하여 아래 내용을 스크린샷과 같이 마지막 라인에 추가합니다.
```
init=/bin/bash
```

![](/assets/img/infrastructure/2022/oci-recovery-sshkey-8.png)

**CTRL+X**를 입력하여 인스턴스를 재부팅하면, 다음과 같이 **Bash 쉘 커맨드 라인**을 볼 수 있습니다.
![](/assets/img/infrastructure/2022/oci-recovery-sshkey-9.png)

### SSH 키 추가 혹은 재설정
SSH 키 추가 혹은 재설정을 위해서 다음 명령어들을 순서대로 실행합니다. 우선 SElinux 정책을 로드합니다.

```
$ /usr/sbin/load_policy -i
```

Root 파티션에 대한 Read/Write 권한으로 리마운트 하기 위해 다음 명령어를 실행합니다.
```
$ /bin/mount -o remount, rw /
```

opc 사용자의 SSH Key 디렉토리로 변경합니다.
```
$ cd ~opc/.ssh
```

기존 **authorized_keys**키를 백업합니다.
```
$ mv authorized_keys authorized_keys.old
```

추가하기 위한 SSH Public Key를 새로운 **authorized_keys**에 추가합니다.
```
$ echo '<contents of public key file>' >> authorized_keys
```

아래는 예시입니다.
```
$ echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnV1Flgu2pg4Uwn3b+eonrAvJBLeQV1lSwkrUa2TEnH9KNajvJ/HJsGme96zSlCzA28VN5HX1EAdM3FS5ik7w2QQLtWzZ40qYmsFn+lvQw1+Dy0usTuHSOoTVb732xiMZkSYu+gV45xhbZOlWGuwQqn7hb4mH2jXjMclrh0vRKoZZgzws+2OFVQ/J+WjHCVxtX1sEQTNRYtNlE/ADfhlh7ODGcl1U7zFU0JDtPhf0Vy731fqL9+hLH96YcUag7lrAM9XmQGyiZZbDvwWklM+M15yUWjJ............' >> authorized_keys
```

authorized_keys의 권한을 변경합니다.
```
$ chmod 600 authorized_keys
```

소유자와 그룹도 변경해줍니다.
```
$ chown -R opc:opc authorized_keys
```

리부팅 합니다.
```
$ /usr/sbin/reboot -f
```

### SSH 전용 키를 이용하여 인스턴스 접속 확인
등록한 SSH Public Key에 대응되는 Private Key를 활용하여 인스턴스에 정상적으로 접속이 되는지 확인합니다.

```
$ ssh -i ~/.ssh/id_rsa opc@{public_ip}
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Sat Jul  9 07:26:50 2022 from xxx.xxx.xxx.xxx
[opc@instance-20220709-1530 ~]$
```