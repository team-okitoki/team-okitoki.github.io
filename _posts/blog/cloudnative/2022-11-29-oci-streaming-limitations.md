---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "OCI Streaming Service 제약 사항"
teaser: "OCI Streaming Service의 제약 사항에 대해서 알아봅니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, streaming, kafka]
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

### OCI Streaming Service
OCI Streaming Service는 OCI에서 제공하는 관리형 Apache Kafka 호환 이벤트 스트리밍 서비스로 다음과 같은 장점을 제공합니다.

* 탄력적이고 확장성이 뛰어난 플랫폼으로 프로비저닝, 확장, 보안 패치를 포함하여 이벤트 스트리밍을 위한 모든 인프라 및 플랫폼을 OCI 환경에서 관리할 수 있습니다.
* 내구성 및 내결함성이 보장된 견고한 구성으로 엔터프라이즈 수준의 높은 안정성을 제공합니다.
* Kafka 호환 API를 제공하여 특정 벤더에 대한 종속성을 제거할 수 있습니다.
* 프로비저닝된 용량에 대한 비용은 무료이며, 사용한 만큼만 지불하는 간소화된 가격 정책을 제공합니다.
* OCI 자체 서비스나 타사 솔루션과의 Out of box 통합을 지원합니다. (GoldenGate, Object Storage, JDBC, OIC, Splunk 등)

![](/assets/img/cloudnative-security/2022/oci-streaming-limitations-1.png " ")

### OCI Streaming Service 제약 사항
OCI Streaming Service를 사용하기 위해서는 기본적인 제약 사항에 대해서 알고 있어야 합니다. 제약 사항에 대해서 자세히 알아 보도록 합니다.

1. Stream내의 메시지 보관 기간은 최소 <mark>24시간</mark>, 최대 <mark>7일</mark>입니다. 지정된 보관 기간을 초과하면 메시지는 자동으로 삭제됩니다.
   * 보관 기간은 Stream을 생성할 때 지정할 수 있으며 한번 생성된 Stream에 대한 보관 기간은 변경할 수 없습니다.
2. Tenancy의 기본 Partition개수는 <mark>5개</mark> 입니다. (Monthly Universal Credit인 경우이며 PAYG인 경우 제공되지 않습니다.) 
   * 제약이 있지만, Partition이 더 필요한 경우에는 OCI Console에서 Limit Increase 요청을 통해서 늘릴수 있습니다.
3. Stream을 한번 생성한 후에는 Partition의 수를 조정할 수 없습니다.
   * Stream을 생성할 때 애플리케이션의 처리량 요구 사항을 미리 산정하여 Partition수를 지정하여야 합니다. 
   * 추가 용량이 필요한 경우에는 Stream Pool에 Stream을 추가하는 방법으로 확장하여야 합니다.
   * 현재는 제공되지 않고 있지만, 동적으로 Partition이 스케일 되는 기능이 추후에 제공될 예정이라고 합니다.
4. 각 Partition에 대한 데이터 쓰기 속도는 <mark>초당 1MB</mark>까지 지원하며, PUT 요청 수는 <mark>초당 1000개</mark> 까지 가능합니다.
   * Producer가 Stream에 게시할 수 있는 고유 메시지의 최대 크기는 1MB(Base64 디코딩된 후 키와 메시지 합계)입니다.
   * Partition의 수를 늘리게 되면 처리량도 증가합니다. 예를 들어, 10개의 Partition을 가지는 Stream인 경우라면 10MB/s의 쓰기 속도로 데이터를 전송할 수 있으며 초당 10,000개까지 쓸 수 있습니다.
   * 만일 SDK를 사용하여 위 제한을 초과하는 요청이 전송되는 경우 다음과 같은 오류 메시지가 반환됩니다.  
      <mark>exception is org.apache.kafka.common.errors.RecordBatchTooLargeException: The request included message batch larger than the configured segment size on the server.</mark>
5. 각 Partition은 <mark>초당 2MB</mark>까지 읽기 속도를 지원합니다.
   * Partition의 수를 늘리게 되면 처리량도 증가합니다. 예를 들어, 10개의 Partition을 가지는 Stream인 경우라면 20MB/s의 읽기 속도를 지원합니다.
   * 만일 SDK를 사용하여 위 제한을 초과하는 요청이 전송되는 경우 다음과 같은 오류 메시지가 반환됩니다.  
      <mark>exception is org.apache.kafka.common.errors.RecordBatchTooLargeException: The request included message batch larger than the configured segment size on the server.</mark>
6. Stream에서 Partition Cursor (Consumer Group을 사용하지 않는 경우) 혹은 하나의 Consumer Group Cursor(Consumer Group을 사용하는 경우)에서는 <mark>초당 5개의 요청(GET)</mark>까지 지원합니다.
   * 일반적으로 Partition Cursor는 한번 만들면 계속 재사용 가능하지만, 메시지 소비가 5분이상 중지되면 커서를 다시 생성해야 합니다.
7. Stream당 Consumer Group은 최대 <mark>50개</mark>까지 생성할 수 있습니다.
   * Consumer Group을 50개 이상 생성하려고 하는 경우 다음과 같은 오류가 발생합니다.  
      <mark>com.oracle.bmc.model.BmcException: (400, InvalidParameter, false) Too many groups created on stream.</mark>
8. Consumer Group을 사용하는 경우 하나의 Partition은 <mark>초당 최대 250개의 요청(GET)</mark>을 지원합니다.
   * Consumer Group당 초당 5개의 요청(GET)이 가능하고, 하나의 Stream에서는 최대 50개의 Consumer Group을 지원합니다. 또한 각 Partition은 Consumer Group의 최대 하나의 멤버(인스턴스)가 할당(Partition당 50개의 멤버가 할당될 수 있음)될 수 있으므로 최대 250개까지 요청(GET)을 지원하게 됩니다. 
   * Stream에서 지원하는 최대 요청(GET) 개수가 250개 이므로, Partition을 늘려도 요청(GET)수를 늘릴 수 없습니다. (Stream당 Consumer Group수는 50개로 제한이 걸려 있기 때문)
9. 하나의 요청(GET)은 기본적으로 가능한 많은 메시지를 반환하지만, <mark>최대 10,000</mark>까지 메시지 수를 제한할 수 있습니다.
   * OCI Streaming SDK의 get 메소드(Java SDK의 경우 GetMessagesRequest Class의 getLimit 메소드)에 적용
10. Consumer Group은 Stream에 구성된 보전 기간동안 사용하지 않으면 삭제되며, Consumer Group 멤버(인스턴스)가 <mark>30초</mark> 이상 메시지 소비를 중지하면 Consumer Group에서 삭제됩니다.
   * 삭제된 멤버(인스턴스)와 기존에 연결되어 있던 Partition의 경우 다른 인스턴스에 재할당 됩니다. 이것을 <mark>Rebalancing</mark> 이라고 합니다.
      ![](/assets/img/cloudnative-security/2022/oci-streaming-limitations-2.png " ")

### 참고
[https://www.oracle.com/kr/cloud/cloud-native/streaming/faq/](https://www.oracle.com/kr/cloud/cloud-native/streaming/faq/)