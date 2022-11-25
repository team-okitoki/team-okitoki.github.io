---
layout: page-fullwidth
#
# Content
#
subheadline: "OCI Release Notes 2022"
title: "10월 OCI Cloud Native & Security 업데이트 소식"
teaser: "2022년 10월 OCI Cloud Native & Security 업데이트 소식입니다."
author: dankim
breadcrumb: true
categories:
  - release-notes-2022-cloudnative-security
tags:
  - oci-release-notes-2022
  - oct-2022
  - cloudnative
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

## Enhancements in Trace Explorer
* **Services:** Application Performance Monitoring
* **Release Date:** Oct. 6, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/e05e6075-ad83-4010-b9c8-26e652866fdd/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/e05e6075-ad83-4010-b9c8-26e652866fdd/){:target="_blank" rel="noopener"} 

### 기능 소개
#### Enhancements in Trace Explorer
* Span Details Drilldowns: 스팬 속성을 포함하는 사용자 정의 가능한 URL을 사용하여 다른 Oracle Cloud Infrastructure 서비스 또는 사용자 정의 서비스에 연결하는 기능

![](/assets/img/cloudnative-security/2022/2022-10-30-cloudnative-security-release-notes-1.png)

![](/assets/img/cloudnative-security/2022/2022-10-30-cloudnative-security-release-notes-2.png)

#### 사용 예시
* **App Server Dashboard Drilldown:**  
```text
/apm/apm-traces/dashboards?dashId=OOBD-APM-app_server_dashboard_001&activeCompartmentId=ocid1.compartment.oc1.XXXX&dashFilter.apmDomain=ocid1.apmdomain.oc1.XXXX&dashFilter.compartmentId=ocid1.compartment.oc1.XXXX&dashFilter.DisplayName=<DisplayName>&region=us-ashburn-1
```
* **Database Management Performance Hub Drilldown:**
```text
/dbmgmt-ui/perfhub?ocid=ocid1.database.oc1.XXXX&perfhubContext={"dateTime":{"period":"LAST_24_HOUR"},"viewPort":{"startDate":"<StartTimeInMs>","endDate":"<EndTimeInMs>"},"selectedTab":{"name":"activityTab","filters": [{"key":"filter_list","value":"{\"sqlid\":{\"value\":\"<DbOracleSqlId>\",\"disabled\":true}}"}]}}
```
* **Operations Insights SQL ID Drilldown:**
```text
/opsi/sql-warehouse?sqlId=<DbOracleSqlId>&region=us-ashburn-1&compartmentId=ocid1.compartment.oc1.XXXX
```
* **Jira Error Message Drilldown:**
```text
https://jira.oci.oraclecorp.com/issues/?jql=text ~ "<ErrorMessage>"
```
 
---

## Export Dashboards in Application Performance Monitoring
* **Services:** Application Performance Monitoring
* **Release Date:** Oct. 6, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/releasenotes/changes/43369fbd-26b1-4a51-b890-f9d86b520996/](https://docs.oracle.com/en-us/iaas/releasenotes/changes/43369fbd-26b1-4a51-b890-f9d86b520996/){:target="_blank" rel="noopener"} 

### 기능 소개
사용자 정의한 대시보드를 JSON 포멧으로 Export할 수 있는 기능이 추가되었습니다. 이제는 특정 테넌시에 있는 대시보드를 다른 테넌시 또는 다른 리전으로 쉽게 가져올 수 있게 됩니다.

절차는 다음과 같습니다.
1. APM Dashboards 페이지에서 Actions icon (![](https://docs.oracle.com/en-us/iaas/application-performance-monitoring/doc/img/actions.png))을 선택한 후 **Export** 클릭
2. JSON 파일(exportedDashboard.json) 확인

> 사용자 정의 대시보드만 Export가 가능하며, 기본 제공하는 대시보드는 Export 기능을 제공하지 않습니다.

---

## Filter Trace Data in Application Performance Monitoring Dashboards
* **Services:** Application Performance Monitoring
* **Release Date:** Oct. 6, 2022
* **Documentation:** [https://docs.oracle.com/en-us/iaas/application-performance-monitoring/doc/filter-trace-data-dashboard.html](https://docs.oracle.com/en-us/iaas/application-performance-monitoring/doc/filter-trace-data-dashboard.html){:target="_blank" rel="noopener"} 

### 기능 소개
APM Geomap과 APM Trace Table 위젯에 대해 다음 두 개의 기본 필터가 포함되었습니다.

* Traces Dimension Filter
* Spans Dimension Filter

#### 사용 예시
1. APM Geomap 위젯에서 두 필터를 활용하여 사용자 디바이스 유형(모바일, 데시크탑 등)에 따라 애플리케이션 사용 경험을 비교
2. APM Trace Table에서 두 필터를 활용하여 특정 지역에서의 애플리케이션 성능을 확인
