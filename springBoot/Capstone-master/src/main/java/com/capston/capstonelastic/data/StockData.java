package com.capston.capstonelastic.data;

import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import javax.persistence.*;

@Document(indexName = "data")
@Getter
public class StockData {
    @Id
    private String id;

    @Field(type = FieldType.Text)
    private String 종목명;

    @Field(type = FieldType.Keyword)
    private String 종목코드;

    private int 거래량;

    @Field(type = FieldType.Double)
    private double 등락률;

    private int 액면가;

    private int 상장주식수;

    private double PER;

    private double ROE;
}
