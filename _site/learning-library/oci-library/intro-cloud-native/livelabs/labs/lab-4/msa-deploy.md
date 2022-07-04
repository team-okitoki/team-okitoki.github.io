# MuShop 애플리케이션 배포

## 소개

MuShop 애플리케이션 배포 방식으로 Manual 배포(Docker)부터 자동화된 배포 (Helm), 완전 자동화 배포 (Terraform)에 이르기 까지 다양한 배포 옵션을 제공합니다.

![MuShop Deployment](images/mushop-deploy-options-helm.png)

마이크로서비스 아키텍처는 일반적으로 탁월한 서비스 분리 운영 및 개발자 독립성을 제공합니다. 분명히 많은 이점을 제공하지만, 개발 환경에 어느정도의 복잡성을 유발할 수 있습니다. 서비스들은 유연하게 운영할 수 있는 구성을 필요로 하고, 가능한 개발에서 생산까지 동일한 도구를 사용하는 것이 좋습니다.

![MuShop Deployment](images/mushop-diagram.png)  
*Note: 이 다이어그램에서는 여기서 다루지 않는 서비스도 포함됩니다.*

소요시간: 30 minutes

### 목표

* MuShop 애플리케이션 이해 
* Helm을 활용한 배포
* 애플리케이션을 외부로 서비스

### 사전 준비사항

1. 실습을 위한 노트북 (Windows, MacOS)
1. Oracle Free Tier 계정

## Task 1: MuShop 소스코드 내려받기

> **Note**: Cloud Shell이 오픈되어 있지 않다면, 우측 상단의 **Cloud Shell** 아이콘을 클릭하여 Cloud Shell을 오픈합니다.

1. Cloud Shell에서 다음 명령어로 MuShop 소스코드를 다운로드 받습니다.

    ````shell
    <copy>
    git clone https://github.com/oracle-quickstart/oci-cloudnative.git mushop
    </copy>
    ````

    Sample response:

    ````shell
    Cloning into 'mushop'...
    remote: Enumerating objects: 23028, done.
    remote: Counting objects: 100% (5596/5596), done.
    remote: Compressing objects: 100% (985/985), done.
    remote: Total 23028 (delta 4873), reused 5054 (delta 4575), pack-reused 17432
    Receiving objects: 100% (23028/23028), 27.13 MiB | 11.48 MiB/s, done.
    Resolving deltas: 100% (14065/14065), done.
    ````

1. mushop 경로로 이동합니다.

    ````shell
    <copy>
    cd mushop
    </copy>
    ````

    ![MuShop Tree](images/mushop-code.png)

    *./deploy:* 애플리케이션 배포를 위한 리소스
    *./src:* MuShop 개별 소스코드, Dockerfile등

1. **kubectl** context를 확인합니다.

    ````shell
    <copy>
    kubectl config current-context
    </copy>
    ````

    Sample response:

    ````shell
    context-c6qyoxibe4a
    ````

1. MuShop 애플리케이션을 위한 Namespace를 생성합니다.

    ````shell
    <copy>
    kubectl create namespace mushop
    </copy>
    ````

    Sample response:

    ````shell
    namespace/mushop created
    ````

1. kubectl 명령어로 위에서 생성한 Namespace에 작업을 할때마다 **--namespace=mushop** 옵션을 붙여야 합니다. 아래와 같이 context에 미리 **--namespace=mushop**을 설정하면, kubectl 명령어 실행할 때 자동으로 설정되므로, 매번 **--namespace=mushop** 옵션을 붙이지 않아도 됩니다.

    ````shell
    <copy>
    kubectl config set-context --current --namespace=mushop
    </copy>
    ````

## Task 2: Helm 사용을 위한 Cluster 셋업

MuShop 애플리케이션은 쿠버네티스 클러스터상에서 다음과 같은 3-party 애플리케이션 설치 및 통합하도록 해주는 Helm Chart를 제공합니다. 아래의 애플리케이션들은 OCI와 통합될 수 있으며, 혹은 MuShop 애플리케이션의 특정 기능을 활성화 해줍니다.

| Chart | Purpose | Option |
| --- | --- | --- |
| [Prometheus](https://github.com/helm/charts/blob/master/stable/prometheus/README.md) | Service metrics aggregation | prometheus.enabled |
| [Grafana](https://github.com/helm/charts/blob/master/stable/grafana/README.md) | Infrastructure/service visualization dashboards | grafana.enabled |
| [Metrics Server](https://github.com/helm/charts/blob/master/stable/metrics-server/README.md) | Support for Horizontal Pod Autoscaling | metrics-server.enabled |
| [Ingress Nginx](https://kubernetes.github.io/ingress-nginx/) | Ingress controller and public Load Balancer | ingress-nginx.enabled |
| [Service Catalog](https://github.com/kubernetes-sigs/service-catalog/blob/master/charts/catalog/README.md) | Service Catalog chart utilized by Oracle Service Broker | catalog.enabled |
| [Cert Manager](https://github.com/jetstack/cert-manager/blob/master/README.md) | x509 certificate management for Kubernetes | cert-manager.enabled |  

1. MuShop 3-party 애플리케이션을 위한 Namespace 생성

    ````shell
    <copy>
    kubectl create namespace mushop-utilities
    </copy>
    ````

    Sample response:

    ````shell
    namespace/mushop-utilities created
    ````

1. Helm을 사용하여 클러스터 종속성 업데이트:

    ````shell
    <copy>
    helm dependency update deploy/complete/helm-chart/setup
    </copy>
    ````

    Sample response:

    ````shell
    WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/oci_dan_ki/.kube/config
    WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/oci_dan_ki/.kube/config
    Getting updates for unmanaged Helm repositories...
    ...Successfully got an update from the "https://grafana.github.io/helm-charts" chart repository
    ...Successfully got an update from the "https://kubernetes.github.io/ingress-nginx" chart repository
    ...Successfully got an update from the "https://kubernetes-sigs.github.io/metrics-server" chart repository
    ...Successfully got an update from the "https://kubernetes-sigs.github.io/service-catalog" chart repository
    ...Successfully got an update from the "https://prometheus-community.github.io/helm-charts" chart repository
    ...Successfully got an update from the "https://charts.jetstack.io" chart repository
    ...Successfully got an update from the "https://charts.helm.sh/stable" chart repository
    Saving 7 charts
    Downloading prometheus from repo https://prometheus-community.github.io/helm-charts
    Downloading grafana from repo https://grafana.github.io/helm-charts
    Downloading metrics-server from repo https://kubernetes-sigs.github.io/metrics-server
    Downloading ingress-nginx from repo https://kubernetes.github.io/ingress-nginx
    Downloading catalog from repo https://kubernetes-sigs.github.io/service-catalog
    Downloading cert-manager from repo https://charts.jetstack.io
    Downloading jenkins from repo https://charts.helm.sh/stable
    Deleting outdated charts
    ````

1. Helm Chart를 활용하여 MuShop 3Party 애플리케이션 설치:

    ````shell
    <copy>
    helm install mushop-utils deploy/complete/helm-chart/setup --namespace mushop-utilities
    </copy>
    ````

## Task 3: Ingress IP 주소 확인

클러스터내에 Ngix의 Ingress Controller 리소스가 구성됩니다. 이 리소스는 OKE 클러스터에 매핑된 공개 IP주소와 함께 OCI 로드밸런서를 외부로 노출합니다.

기본적으로 MuShop Helm 차트는 Ingress 리소스를 생성하여 해당 IP 주소의 모든 트래픽을 svc/edge 구성 요소로 라우팅합니다.

1. Ingress Controller의 EXTERNAL-IP(공개 IP) 확인:

    ````shell
    <copy>
    kubectl get svc mushop-utils-ingress-nginx-controller --namespace mushop-utilities
    </copy>
    ````

    Sample response:

    ````shell
    NAME                                    TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)                      AGE
    mushop-utils-ingress-nginx-controller   LoadBalancer   10.96.227.233   129.xxx.xxx.xxx   80:32677/TCP,443:31606/TCP   75s
    ````

1. mushop-utilities에 배포된 전체 애플리케이션 확인:

    ````shell
    <copy>
    kubectl get deployments --namespace mushop-utilities
    </copy>
    ````

    Sample response:

    ````shell
    NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
    mushop-utils-cert-manager               1/1     1            1           9m26s
    mushop-utils-cert-manager-cainjector    1/1     1            1           9m26s
    mushop-utils-cert-manager-webhook       1/1     1            1           9m26s
    mushop-utils-grafana                    1/1     1            1           9m26s
    mushop-utils-ingress-nginx-controller   1/1     1            1           9m26s
    mushop-utils-kube-state-metrics         1/1     1            1           9m26s
    mushop-utils-metrics-server             1/1     1            1           9m26s
    mushop-utils-prometheus-alertmanager    1/1     1            1           9m26s
    mushop-utils-prometheus-pushgateway     1/1     1            1           9m26s
    mushop-utils-prometheus-server          1/1     1            1           9m26s
    ````

## Task 4: Helm을 활용하여 MuShop 애플리케이션 배포

helm이 구성 가능한 차트를 패키징하고 배포하는 방법을 제공한다는 것을 기억합니다. 다음으로 MuShop 애플리케이션의 Helm Chart에서는 **Mock Mode**를 제공합니다. MuShop 애플리케이션내의 백엔드 서비스를 모의로 작동시키는 것으로, 일반적으로 개발이나 테스트 단계에서 모의 데이터를 활용할 때 유용합니다.

1. "mock mode"로 MuShop 애플리케이션 배포

    ````shell
    <copy>
    helm install mushop deploy/complete/helm-chart/mushop --set global.mock.service="all"
    </copy>
    ````

1. 관련된 모든 서비스가 배포되는데 어느정도의 시간이 소요됩니다. 진행상황을 확인하려면 다음 명령어를 실행합니다.

    ````shell
    <copy>
    kubectl get pods --watch
    </copy>
    ````

1. 모든 서비스가 **Running** 상태가 되면 다시 한번 Ngix Ingress Controller의 **EXTERNAL-IP**를 확인합니다.

    ````shell
    <copy>
    kubectl get svc mushop-utils-ingress-nginx-controller --namespace mushop-utilities
    </copy>
    ````

1. 브라우저를 활용하여 http://< EXTERNAL-IP > 로 접속합니다.

    ![MuShop Storefront](images/mushop-storefront.png)

## Task 5: Explore the deployed app

배포를 생성할 때 애플리케이션의 컨테이너 이미지와 실행할 Replicas 수를 지정해야 합니다.

Kubernetes는 애플리케이션 인스턴스를 호스팅할 Pod를 생성했습니다. Pod는 하나 이상의 애플리케이션 컨테이너(예: Docker)와 해당 컨테이너에 대한 일부 공유 리소스 그룹을 나타내는 Kubernetes 추상화입니다. 이러한 리소스에는 다음이 포함됩니다:

* 볼륨으로 공유된 스토리지
* 고유한 클러스터 IP 주소로서의 네트워킹
* 컨테이너 이미지 버전이나 사용할 특정 포트 등 각 컨테이너를 실행하는 방법에 대한 정보

가장 일반적으로 사용되는 kubectl 실행 옵션입니다:

* **kubectl get** - 리소스 목록을 조회할 때 사용
* **kubectl describe** - 특정 리소스의 상세 정보를 확인할 때 사용
* **kubectl logs** - Pod내의 컨테이너로 부터 나오는 로그 정보
* **kubectl exec** - Pod내의 컨테이너에서 명령어 실행

이러한 명령을 사용하여 애플리케이션이 배포된 시간, 현재 상태, 실행 중인 위치 및 어떠한 구성으로 되어 있는지 확인할 수 있습니다.

1. MuShop 애플리케이션의 배포 정보 확인

    ````shell
    <copy>
    kubectl get deployments
    </copy>
    ````

1. 배포된 Pod 확인

    ````shell
    <copy>
    kubectl get pods
    </copy>
    ````

1. 마지막으로 생성된 Pod 확인

    ````shell
    <copy>
    export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'|awk '{print $1}'|tail -n 1) && \
    echo Using Pod: $POD_NAME
    </copy>
    ````

    Sample response:
    ````shell
    Using Pod: mushop-user-6557895bfb-9jzxc
    ````

1. Pod내에 어떤 컨테이너가 존재하고, 어떤 이미지가 사용되었는지 자세히 확인

    ````shell
    <copy>
    kubectl describe pod $POD_NAME
    </copy>
    ````

1. Pod내의 컨테이너를 위한 `STDOUT` 로그 확인

    ````shell
    <copy>
    kubectl logs $POD_NAME
    </copy>
    ````

1. Pod내의 컨테이너내에서 직접 명령어 실행

    ````shell
    <copy>
    kubectl exec $POD_NAME env
    </copy>
    ````

1. Pod내의 컨테이너 작업 폴더 목록:

    ````shell
    <copy>
    kubectl exec -ti $POD_NAME ls
    </copy>
    ````

[다음 랩으로 이동](#next)

## Learn More

* [MuShop Github Repo](https://github.com/oracle-quickstart/oci-cloudnative)
* [MuShop Deployment documentation](https://oracle-quickstart.github.io/oci-cloudnative/cloud/)
* [Terraform Deploymment scripts](https://github.com/oracle-quickstart/oci-cloudnative/tree/master/deploy/complete/terraform)
* Full Solution deployment with one click - launches in OCI Resource Manager directly [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://console.us-ashburn-1.oraclecloud.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-quickstart/oci-cloudnative/releases/latest/download/mushop-stack-latest.zip)  

