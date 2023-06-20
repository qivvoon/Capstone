# 라이브러리 불러오기
library(rvest)
library(stringr)
library(tidyverse)
library(ggplot2)
library(jsonlite)


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
basic_info <- function(base_url, page_num){
  page_url <- paste0(base_url, as.character(page_num))
  temp_html <- read_html(page_url, encoding = "euc-kr")

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

  for (i in 1:length(codes)){
    code_arr[i, 1] <- strsplit(codes[i], "code=")[[1]][2]
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

  # 종목명, 종목코드, 액면가, 상장주식수, PER, ROE만 따로 빼서 반환
  return_dataFrame <- return_dataFrame %>%
    select(종목명, 종목코드, 거래량, 등락률, 액면가, 상장주식수, PER, ROE)

  return(return_dataFrame)
}


# 해당 사이트기본 정보를 가져오는 함수
get_site_info <- function(temp_url){
  final_data <- data.frame()
  for (i in 1:get_last_page(paste0(temp_url, 1))){
    final_data <- rbind(final_data, basic_info(temp_url, i))
  }
  return(final_data)
}


# 데이터를 가져올 url 입력
kospi_url <- "https://finance.naver.com/sise/sise_market_sum.nhn?&page="
kospi_stock <- get_site_info(kospi_url)
