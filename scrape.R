# 라이브러리 불러오기
library(rvest)
library(stringr)
library(tidyverse)
library(ggplot2)
library(jsonlite)
library(elastic)
library(httr)

# 마지막 페이지를 구하는 함수
get_last_page <- function(input_url){
  html <- read_html(input_url, encoding ="euc-kr")
  sise <- html %>% html_nodes(".pgRR") %>%
    html_nodes("a") %>% html_attr("href") %>%
    str_split(., pattern = "page=")
  
  last_page <- sise[[1]][2]
  return(last_page)
}

# 페이지와 기본 url을 받아 기본정보 데이터 프레임을 반환해주는 함수
basic_info <- function(base_url, page_num, temp_index, current_korea_time){
  page_url <- paste0(base_url, as.character(page_num))
  temp_html <- read_html(page_url, encoding = "euc-kr")
  
  # 시간 변환
  datatime <- as.POSIXct(current_korea_time, format = "%Y-%m-%d %H:%M:%S")
  iso8601 <- format(datatime,  "%Y-%m-%dT%H:%M:%S")
  
  # 숫자형 데이터 리스트 만들기
  number_data <- temp_html %>% html_nodes(".number") %>% html_text() %>%
    parse_number(na="N/A")
  
  # 종목명 데이터 리스트 만들기
  Name_jongmok <- temp_html %>%
    html_nodes(".tltle") %>%
    html_text()
  
  # 각 종목별 코드 가져오기
  codes <- temp_html %>% html_nodes("td") %>%
    html_nodes("a") %>% html_attr("href")
  codes <- codes[grepl("main", codes)]
  code_arr <- array(NA, dim=c(length(codes), 1))
  time_arr <- array(NA, dim=c(length(codes), 1))
  index_arr <- array(NA, dim=c(length(codes), 1))
  
  for (i in 1:length(codes)){
    code_arr[i, 1] <- strsplit(codes[i], "code=")[[1]][2]
    time_arr[i, 1] <- iso8601
    index_arr[i, 1] <- temp_index
  }
  
  # 각 카테고리 명 가져오기
  category <- temp_html %>% html_nodes("th") %>% html_text()
  category <- category[3:12]
  
  # 기본 정보 데이터 프레임 만들고 반환하기
  return_dataFrame <- data.frame(matrix(number_data, ncol=length(category),
                                        byrow = T))
  names(return_dataFrame) <- category
  return_dataFrame$종목명 <- Name_jongmok
  return_dataFrame$종목코드 <- code_arr[,1]
  return_dataFrame$한국시간 <- time_arr[,1]
  return_dataFrame$인덱스 <- index_arr[,1]
  
  # 종목명, 종목코드, 액면가, 상장주식수, PER, ROE만 따로 빼서 반환
  return_dataFrame <- return_dataFrame %>%
    select(인덱스, 종목명, 종목코드, 거래량, 등락률, 액면가, 상장주식수, PER, ROE, 한국시간)
  
  return(return_dataFrame)
}


# 해당 사이트기본 정보를 가져오는 함수
get_site_info <- function(temp_url, temp_index, current_korea_time){
  final_data <- data.frame()
  for (i in 1:get_last_page(paste0(temp_url, 1))){
    final_data <- rbind(final_data, basic_info(temp_url, i, temp_index, current_korea_time))
  }
  return(final_data)
}


# 데이터를 가져올 url 입력
kospi_url <- "https://finance.naver.com/sise/sise_market_sum.nhn?&page="
#kospi_stock <- get_site_info(kospi_url)



es <- connect(host = "localhost", port = 9200)
index_create(es, index = "test") # 인덱스 생성

url <- "http://localhost:9200/_index_template/kospi_template"

while (TRUE) {
  current_time <- Sys.time()
  current_time_korea <- as.POSIXct(format(current_time, tz = "Asia/Seoul"))
  current_date <- format(current_time_korea, "%Y-%m-%d")
  
  
  if (
    ((format(current_time_korea, "%u") %in% c("6", "7")) && format(current_time_korea, "%H:%M") >= "13:00" && format(current_time_korea, "%H:%M") <= "17:00") ||
    (!(format(current_time_korea, "%u") %in% c("6", "7")) && format(current_time_korea, "%H:%M") >= "09:30" && format(current_time_korea, "%H:%M") <= "15:00")
  ){
    kospi_stock <- get_site_info(kospi_url, temp_index, as.character(current_time_korea))
    
    # 데이터프레임을 ElasticSearch에 저장
    
    write.table(kospi_stock, "kospi_stock.csv", append=TRUE, sep = ",", col.names = !file.exists("kospi_stock.csv"), row.names = FALSE)
    print("good")
  } else{
    print("개장시간이 아닙니다.")
  }
  
  Sys.sleep(10)  # 10초 대기 후 다음 스크래핑 시도
}




