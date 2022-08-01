---
#
# Use the widgets beneath and the content will be
# inserted automagically in the webpage. To make
# this work, you have to use › layout: frontpage
#
layout: frontpage
header:
  image_fullwidth: home/home_header_2_2.png
widget1:
  title: "OCI Documentation"
  url: 'https://docs.oracle.com/en-us/iaas/Content/home.htm'
  image: home/oci-documentation-home.png
  text: 'OCI Documentation Home에서는 OCI의 모든 제공 서비스에 대한 가이드 문서를 볼 수 있습니다. 각 서비스들에 대한 주요 컨셉 설명과 제공되는 튜토리얼을 통해 빠르게 서비스를 경험해 볼 수 있는 문서를 제공합니다. 또한 개발자를 위한 가이드(SDKs, CLI, Cloud Shell등) 및 다양한 참조용 아키텍처도 제공되고 있으며, 새롭게 추가된 서비스나 기능에 대한 소식도 접해볼 수 있습니다.'
widget2:
  title: "OCI Pricing"
  url: 'https://www.oracle.com/kr/cloud/price-list.html'
  image: home/oci-pricing.png
  text: 'OCI에서 제공하는 모든 서비스에 대한 가격 정보를 확인해 볼 수 있는 페이지입니다. 위 페이지에서는 실제 가격을 시뮬레이션 해 볼수 있는 <strong><em>Cost Estimator</em></strong>도 제공하고 있습니다.'
widget3:
  title: "Oracle Github"
  url: 'https://github.com/oracle'
  image: home/widget-github-303x182.jpeg
  text: 'Oracle에서 운영하는 Github Repository입니다. Oracle에서 관리하는 다양한 오픈소스 프로젝트를 만나볼 수 있으며, OCI 환경에서 개발자가 빠르게 사용할 수 있는 다양한 예제 코드를 찾아볼 수 있습니다.'
#
# Use the call for action to show a button on the frontpage
#
# To make internal links, just use a permalink like this
# url: /getting-started/
#
# To style the button in different colors, use no value
# to use the main color or success, alert or secondary.
# To change colors see sass/_01_settings_colors.scss
#
# callforaction:
#   url: https://tinyletter.com/feeling-responsive
#   text: Inform me about new updates and features ›
#   style: alert
permalink: /index.html
#
# This is a nasty hack to make the navigation highlight
# this page as active in the topbar navigation
#
homepage: true
---
