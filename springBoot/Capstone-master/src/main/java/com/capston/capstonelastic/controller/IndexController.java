package com.capston.capstonelastic.controller;
import com.capston.capstonelastic.data.comPanySharedData;
import com.capston.capstonelastic.service.StockDataService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@Controller
//@RequestMapping("/index")
public class IndexController {

    private final StockDataService stockDataService;

    public IndexController(StockDataService stockDataService){
        this.stockDataService = stockDataService;
    }

    @GetMapping("/index")
    public String getProduct(String product, Model model) {
        if (product != null) {
            System.out.println(product);

            String calcResult = stockDataService.getTop3Difference(product);
            model.addAttribute("result", calcResult);
        } else {
            model.addAttribute("result", "종목명이 아직 입력되지 않았습니다.");
        }

        return "index";
    }
}