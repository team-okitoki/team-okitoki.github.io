---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "IaC 도구인 Terraform 소개 (Feat. OCI)"
teaser: "테라폼(Terraform)은 Hashicorp에서 개발한 인프라스트럭처 관리를 위한 오픈소스 소프트웨어로 인프라스트럭처를 코드로서 관리 및 프로비저닝하는 개념인 Ifrastructure as Code (IaC)를 지향하는 도구입니다. AWS, Azure, GCP, OCI(Oracle Cloud Infrastructure)와 같은 다양한 클라우드 프로바이더를 지원하고 있는데, 그중에서 OCI 환경에서 테라폼을 사용하는 방법을 설명합니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, terraform, resource manager]
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

### Infrastructure as Code?
클라우드상의 네트워크나 컴퓨트, 스토리지와 같은 리소스들은 각 클라우드 벤더에서 제공하는 GUI를 통해 클릭과 같은 수작업을 통해 생성할 수 있습니다. **Infrastructure as Code**는 이와 같이 단순히 GUI 혹은 수작업 방식으로 관리하던 방식이 아닌 코드(구성 파일과 스크립트를 활용)를 통해 인프라를 관리하는 개념입니다. 보통 간단한 리소스 관리는 GUI를 통해 충분히 쉽게 구성 가능하겠지만, 인프라의 환경이 복잡해지면 휴먼 에러도 발생할 수 있고, 관리에 많은 시간적 비용이 발생하기 때문에 이러한 인프라 자동화 기법이 생기게 된 것입니다. 인프라 사용자들, 특히 개발자들에게 익숙한 코드를 사용하기 때문에, 직접 필요한 리소스들을 한번에 빠르게 구성, 운영, 파기할 수 있어서 DevOps에 있어서 꼭 필요한 요소라 볼 수 있습니다. Infrastructure as Code를 지향하는 여러 관점의 다양한 도구들이 있는데, 그 중 리소스 관리 및 프로비저닝에 특화된 도구로 테라폼을 들 수 있습니다.

### 테라폼은?
테라폼은 Hashicorp사에서 개발한 인프라스트럭처 관리용 오픈소스 소프트웨어로, 인프라스트럭처를 코드로서 관리 및 프로비저닝하는 개념인 Ifrastructure as Code (IaC)를 지향하는 도구입니다. Terraform에서는 HCL(Hachicorp Configuration Language)이라는 설정 언어를 이용해서 인프라스트럭처를 정의합니다.

테라폼에서는 AWS, Azure, GCP와 같은 다양한 클라우드 프로바이더를 지원하고 있는데, 프로바이더 목록은 아래 페이지에서 확인할 수 있습니다.
> https://www.terraform.io/docs/providers

테라폼을 사용하기 위해서는 테라폼과 관련된 요소나 용어를 이해해야 합니다. 사용 자체는 어렵지 않지만, 이러한 개념이나 용어들이 생소한 이유로, 처음 시작할 때 어느정도 진입장벽이 있습니다.

### HCL(Hachicorp Configuration Language)
먼저 리소스 구성을 정의하기 위한 HCL(Hachicorp Configuration Language)이라는 것이 있습니다. 일종의 설정 언어로 대부분의 작업이 이 HCL을 통해 구성 파일을 만드는 작업이라고 보면 됩니다. JSON 형식도 지원히지만, 일반적으로 JSON보다는 HCL을 더 선호하는 편인거 같습니다. 테라폼은 각 클라우드 벤더와 협업해서 제공하는 프로바이더 플러그인(golang으로 개발)을 통해 이러한 구성 파일을 검증하고 실행합니다.

#### Resources and Modules
HCL에서는 생성할 자원들을 Resource라는 개념으로 정의하며, 이러한 Resource들을 그룹으로 묶어서 관리하는 Module이라는 개념이 있습니다. Module은 의무적으로 사용할 필요는 없고 특정 Resource들을 그룹으로 묶어서 관리하고자 할 경우 사용합니다. 

#### Blocks
HCL에서는 하나의 문장 단위를 Block이라 부릅니다. Block은 Block Type, Block Lable, Block Body (Identifier, Argument, expression)등으로 이뤄지는데, 보통 아래와 같이 작성합니다. 아래 예제는 OCI에서 Compute Instance를 생성하는 간단한 resource block입니다.

```terraform
resource "oci_core_instance" "test_instance" {
  availability_domain = var.instance_availability_domain
}

<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```

위에서 Block Type은 해당 Block이 어떤 역할을 하는지 구분해주는 것으로 블록의 역할에 따라 provider, resource, data, variable, output등 여러가지가 있습니다. expression은 해당 블록에 전달하기 위한 Argument를 표현하며, 다양한 수식과 문법, 타입을 제공합니다. Expression에 대한 자세한 내용은 아래 가이드를 참조하면 좋습니다. 다 알고 시작해야 하나 싶겠지만, 복잡한 코딩이 아니라서 하나하나 해보다 보면 금방 익숙해질 수 있습니다.

[https://www.terraform.io/docs/configuration/expressions.html](https://www.terraform.io/docs/configuration/expressions.html)

### .tfstate
테라폼을 실행하면 인프라에 여러가지 리소스가 생성되는데, 이때 Terraform은 .tfstate 파일(테라폼 상태 파일)을 로컬에 생성합니다. 이 파일은 JSON 포멧으로 작성되어 있는데, 사용자가 작성한 테라폼 구성 내용을 실행해서 생성된 인프라의 리소스의 상태가 기록되어 있습니다. 테라폼을 실행할때마다 프로바이더의 최신 인프라 상태를 조회해서 .tfstate 파일을 업데이트 합니다. 이 상태 파일을 보면 특정 시점에서의 인프라의 상태를 알수 있습니다.

### Terraform Remote State
보통은 여러 사용자 혹은 여러 팀들이 각자의 로컬에서 테라폼을 실행하기 때문에 이러한 상태 파일을 각자의 로컬에 가지고 있게 되는데, 이러한 경우 자신이 반영한 상태만 알수 있기 때문에 전체 인프라의 상태를 알기가 쉽지 않아 효율적인 관리가 이뤄지기 쉽지 않습니다. 또한 개인 혹은 한팀에서 상태 파일을 관리하면, 하나의 상태 파일에 모든 내용이 기술되기 때문에 파일의 크기가 커지게 되고, 결국 테라폼 실행 속도에 영향을 받게 됩니다. 따라서, 개인 혹은 팀별로 테라폼을 적용할 때마다 매번 상태 파일을 원격 스토리지에 올려놓고 이를 공유해서 사용하는 방식을 테라폼팀에서 권장하고 있으며, 이를 Remote State라는 기능으로 제공하고 있습니다. 이 기능을 사용하면 상태 파일을 원격 저장소에 저장하여 관리할 수 있으며, 다른 사람이 생성한 리소스(예: 특정 Virtual Cloud Network)를 참조하여 Resource를 구성하고자 할 때에도 이 기능을 사용하여 해당 리소스의 데이터를 참조할 수 있습니다.

> 테라폼은 하나의 폴더에 구성할 리소스를 HCL로 정의한 .tf 파일들을 실행하는데, 다른 폴더 혹은 다른 시점에 생성한 리소스를 참조하기 어렵습니다. 물론 해당 리소스의 고유 아이디(OCI OCID, AWS arn등)를 직접 콘솔에서 찾아서 지정하면 되지만, 상당히 번거롭습니다. 하지만 이 Remote State를 사용하면, 다른 사람이 구성한 리소스의 고유값 가져와서 이를 참조할 수 있습니다.

### Workspace
테라폼에서는 여러개의 서로 다른 환경별로 코드를 공유해서 사용할 수 있는 Workspace라는 기능을 제공합니다. 이 기능은 테라폼을 실행하고 나오는 결과인 상태 파일을 각 환경별로 구분해서 관리해줍니다. 이 기능을 잘 활용하면 여러 클라우드 환경에 동시에 프로비저닝할 수 있게도 구성할 수 있습니다. (쉘등을 활용, 뒤에서 간단히 소개)

### 테라폼 설치
그럼, 먼저 설치를 해보도록 합니다. macOS에서는 간단히 Homebrew를 사용해서 설치할 수 있습니다.
```terminal
$ brew install terraform
```

Windows에서의 설치는 아래 잘 정리된 블로그 페이지를 참조합니다. (내용이 길어서 여기선 링크로 대체)

[https://www.vasos-koupparis.com/terraform-getting-started-install/](https://www.vasos-koupparis.com/terraform-getting-started-install/)

### 테라폼 프로바이더와 환경 설정
먼저 아무 위치에 폴더를 하나 생성 (예: erraform_test)하고, provider.tf 파일을 하나 만든 후 다음과 같이 가장 기본이 되는 Block Type인 provider를 정의합니다. 각 벤더별로 프로바이더 구성 방법이 다른데 자세한 내용은 아래 페이지를 참조합니다.

[https://www.terraform.io/docs/providers/index.html](https://www.terraform.io/docs/providers/index.html)

> 프로바이더 정의라고 해서 꼭 provider.tf라고 이름을 지을 필요는 없습니다. 테라폼은 파일내에 정의된 Block Type을 사용하지 파일의 이름을 가지고 구성 내용을 판단하지 않습니다. 하지만 파일의 확장자는 .tf로 지정해야 하고, 가시성을 위해서 어떤 동작을 하는지 알 수 있도록 파일 이름을 지정하는 것이 좋습니다.

**provider.tf**
```terraform
provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "${var.region}"
}
```

여기선 oci provider를 정의했는데, 5개의 변수를 사용하고 있습니다. OCI Terraform Provider를 위해 필요한 값을 얻는 방법은 아래 포스트에서 확인할 수 있습니다.

[OCICLI 도구 설정하기](https://team-okitoki.github.io/getting-started/ocicli-config/)

각 변수 선언은 variable 이라는 Block Type을 사용해서 작성합니다. 파일 이름은 vars.tf로 만들어서 provider.tf와 같은 폴더 위치(프로젝트 폴더, 여기서는 terraform_test)에 저장합니다.
> 테라폼은 특정 디렉토리에 있는 모든 .tf 파일을 읽어서 리소스를 생성, 수정, 삭제 작업을 진행합니다. 여러개의 .tf 파일이 존재하더라도 실행 순서를 따로 정의하지 않는데, 각 정의된 리소스가 서로 간접적으로 의존관계가 생기고, 이런 의존 관계를 바탕으로 실행 순서를 결정하게 됩니다.

```terraform
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
```

프로바이더에서 사용할 변수가 선언되어 있는데, 각 편수에 기본값을 직접 할당할 수도 있지만, 보통 환경 변수를 활용하거나, .tfvars 파일을 만들어서 관리할 수 있습니다. 환경 변수로 설정할 경우는 아래 내용을 ~/.bash_profile에 다음과 같이 설정하고 다시 적용하면 됩니다.

```terminal
export TF_VAR_tenancy_ocid=<value>
export TF_VAR_user_ocid=<value>
export TF_VAR_fingerprint=<value>
export TF_VAR_private_key_path=<value>
export TF_VAR_region=<value>
```

```
$ source ~/.bas_profile
```

.tfvars 라는 파일을 이용할수도 있는데 사용법은 다음과 같다. 우선 vars.tfvars 파일을 만든 후 다음과 같이 추가합니다.

```terminal
tenancy_ocid     = <value>
user_ocid        = <value>
fingerprint      = <value>
private_key_path = <value>
region           = <value>
```

테라폼에서 .tfvars를 사용할 경우 실행 시 다음과 같이 옵션을 지정합니다. 아래는 plan을 실행할 때 vars.tfvars 환경 변수 파일을 사용한 예시입니다.
```terminal
$ terraform plan -var-file=vars.tfvars
```

### 테라폼 초기화 (Terraform Init)
프로바이더와 변수 설정이 완료되면 테라폼 초기화를 하는데, 구성한 Provider 설정으로 관련 플러그인을 .terraform 경로에 다운로드 받게 됩니다. Module 혹은 Workspace를 사용한 경우에도 관련된 필요한 파일을 .terraform 폴더에 생성합니다. 즉, Module이나 Workspace 관련 구성을 변경할 때마다 초기화를 해줘야 합니다. 초기화는 .tf 파일들이 있는 폴더에서 다음 명령어를 실행합니다.

```terminal
$ terraform init
```

명령어를 실행하면 해당 폴더에 .terraform 폴더가 생성되며, plugins 폴더가 생성됩니다. terraform-provider-oci_v3.54.0_x4 즉 oci terraform plugin 버전이 3.54.0 인 것을 알수 있습니다.

```terminal
drwxr-xr-x  3 DonghuKim  staff        96 12  4 18:31 ..
-rwxr-xr-x  1 DonghuKim  staff  79132160 12  4 18:31 terraform-provider-oci_v3.54.0_x4
-rwxr-xr-x  1 DonghuKim  staff  25457368 12  4 18:31 terraform-provider-random_v2.2.1_x4
drwxr-xr-x  6 DonghuKim  staff       192 12 12 16:51 .
-rwxr-xr-x  1 DonghuKim  staff  23091640 12 12 16:51 terraform-provider-null_v2.1.2_x4
-rwxr-xr-x  1 DonghuKim  staff       237 12 12 16:51 lock.json
```

### 테라폼 계획 (Terraform plan)
plan 명령어는 현재 정의되어있는 리소스들을 해당 프로바이더에 적용했을 때 테라폼에 의해서 수행될 작업에 대한 계획을 보여줍니다. .tf의 내용을 기반으로 구성 내용에 대한 유효성 검사및 리소스 생성, 수정, 삭제할 리소스들이 잘 반여될 수 있는지를 현재의 인프라 상태와 비교해서 보여주는데, plan을 통해서 실제 인프라에 영향을 주지 않으면서, 어떤 내용들이 변화되고 영향을 받는지 알 수 있습니다.
실행 명령은 다음과 같습니다.

```terminal
$ terraform plan

$ terraform plan -var-file=vars.tfvars # tfvars 파일을 사용한 경우
```

### 테라폼 적용 (Terraform apply)
plan을 통해서 예상한 plan 결과를 확인하게 되면, 실제 반영을 해서 인프라의 정보를 구성 파일(.tf)의 정보와 일치되도록 실제 인프라에 반영하는데 이 과정이 apply 다. 실행 명령은 다음과 같습니다. apply를 실행하면 중간에 approve 하는 과정이 있는데, apply를 실행한 후에 plan 결과를 먼저 보여준 후 그 결과에 대해 승인(yes)해야 apply를 진행하게 됩니다.

```terminal
$ terraform apply

$ terraform apply -var-file=vars.tfvars # tfvars 파일을 사용한 경우
```

> 참고로 apply를 실행할 때 다음 옵션을 통해 auto approve를 할 수 있습니다.  
> ```terminal
> $ terraform apply --auto-approve
> ```


### workspace 생성/선택/삭제
앞서 설명한 workspace를 생성, 목록, 선택, 삭제하는 명령어입니다. new 명령어로 프로젝트 폴더에서 workspace를 생성하면 **terraform.tfstate.d** 폴더가 자동으로 생성되며, 하위에 workspace 이름으로 폴더가 생성됩니다. 각 workspace 폴더안에 .tfstate 파일이 생성됩니다.

```terminal
$ terraform workspace new <workspace 이름> # workspace 생성

$ terraform workspace list # workspace 목록

$ terraform workspace select <workspace 이름> # workspace 선택

$ terraform workspace delete <workspace 이름> # workspace 삭제

$ terraform workspace show # 현재 선택된 workspace 보기
```

실제 테라폼 코드를 사용하여 OCI에 리소스를 프로비저닝하는 과정은 다음 포스트를 참고합니다.

[Terraform을 활용하여 OCI 리소스 프로비저닝 방법](https://team-okitoki.github.io/cloudnative/oci-terraform-2/)


