# ELK를 이용한 주식데이터 분석

## 프로젝트 소개
## 기술 스택
<img src="https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white"/> <img src="https://img.shields.io/badge/elasticsearch-005571?style=flat&logo=elasticsearch&logoColor=white"/> <img src="https://img.shields.io/badge/logstash-005571?style=flat&logo=logstash&logoColor=white"/> <img src="https://img.shields.io/badge/kibana-005571?style=flat&logo=kibana&logoColor=white"/>
## 구조
#### 1. 네이버 증권 스크래핑
* R 이용
* 네이버 증권의 주식데이터를 9:00 ~ 15:00 동안 10초 간격으로 스크래핑
* 아래의 네이버 주식 페이지에서 스크래핑을 진행
* // 네이버 증권 홈페이지 이미지 넣기
* 스크래핑한 데이터를 엘라스틱 서치와 연동하여 실시간으로 저장
#### 2. 로그스태시를 이용한 로그데이터 정제
* 로그스태시를 이용하여 R에서 제공한 데이터프레임을 엘라스틱서치 Document형식에 맞게 정제
* 로그스태시를 거친 후에 엘라스틱서치에 실시간 주식 데이터를 저장
  
#### 3. 키바나를 이용한 시각화
* Elasticsearch, kibana 이용
* 키바나로 실시간 거래량이 변화하는 것을 확인할 수 있다.
* // 거래량 시각화 이미지 첨부
* 이전 시간대의 거래량과 비교하여 각 종목마다 거래량의 변화를 시각적으로 확인할 수 있다.
* // 거래량 변화 시각화 이미지 첨부
  
#### 4. 스프링부트를 이용하여 클라이언트에게 실시간 종목 거래량 제공
* 스프링부트 서버를 엘라스틱 서버와 연동한다.
* 클라이언트가 원하는 종목을 입력하면 스프링부트 서버가 실시간 거래량을 제공한다.
* // 실시간 거래량 클라이언트 입장에서 이미지 첨부
* 만약 거래량이 급격히 증가하는 경우 클라이언트는 급격한 변화량을 확인할 수 있다. 

#### 
