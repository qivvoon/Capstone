package com.capston.capstonelastic;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@SpringBootApplication
@EnableElasticsearchRepositories(basePackages = "com.capston.capstonelastic")
@EnableWebMvc
public class CapstonElasticApplication {

    public static void main(String[] args) {
        SpringApplication.run(CapstonElasticApplication.class, args);
    }

}
