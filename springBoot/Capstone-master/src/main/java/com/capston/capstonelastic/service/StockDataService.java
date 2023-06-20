package com.capston.capstonelastic.service;

import com.capston.capstonelastic.data.StockData;
import com.capston.capstonelastic.repository.StockDataRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StockDataService {

    private final StockDataRepository stockDataRepository;

    public StockDataService(StockDataRepository stockDataRepository) {
        this.stockDataRepository = stockDataRepository;
    }

    public String getTop3Difference(String companyName) {
        List<StockData> top3StockData = stockDataRepository.findTop3By종목명OrderBy거래량Desc(companyName);

        if (top3StockData.size() >= 3) {
            int 거래량1 = top3StockData.get(0).get거래량();
            int 거래량2 = top3StockData.get(1).get거래량();
            int 거래량3 = top3StockData.get(2).get거래량();

           if((거래량1 - 거래량2) >= (거래량2 - 거래량3) * 5){
               if ((거래량2 - 거래량3) == 0) {
                   System.out.println(거래량1 - 거래량2);
                   System.out.println(거래량2 - 거래량3);
                   return companyName + "의 거래량은 " + (거래량1 - 거래량2) + "입니다.";
               }else {
                   return companyName + "의 거래량이 급격히 증가했습니다. 거래량은 " + (거래량1 - 거래량2) + "입니다.";
               }
           }else{
               if(거래량1 == 거래량2) return companyName + "의 거래량이 변하지 않았습니다.";
               else return companyName + "의 거래량은 " + (거래량1 - 거래량2) + "입니다.";
           }
        }else{
            return "거래량 데이터가 부족합니다.";
        }
    }

}

