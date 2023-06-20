package com.capston.capstonelastic.controller;

import com.capston.capstonelastic.data.StockData;
import com.capston.capstonelastic.data.comPanySharedData;
import com.capston.capstonelastic.repository.StockDataRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/data")
public class StockDataController {
    private final StockDataRepository stockDataRepository;

    public StockDataController(StockDataRepository stockDataRepository) {
        this.stockDataRepository = stockDataRepository;
    }

    @GetMapping("/top3")
    public List<StockData> getTop3(@RequestParam("companyName") String companyName) {
        List<StockData> top3StockData = stockDataRepository.findTop3By종목명OrderBy거래량Desc(companyName);

        return top3StockData;
    }
}
