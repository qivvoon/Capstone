package com.capston.capstonelastic.repository;

import com.capston.capstonelastic.data.StockData;
import org.springframework.data.elasticsearch.annotations.Query;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import java.util.List;

public interface StockDataRepository extends ElasticsearchRepository<StockData, String> {

    List<StockData> findTop3By종목명OrderBy거래량Desc(String 종목명);

}

