package com.capston.capstonelastic.data;

import org.springframework.stereotype.Component;

@Component
public class comPanySharedData {
    private String sharedString;

    public String getSharedString(){
        return sharedString;
    }
    public void setSharedString(String sharedString){
        this.sharedString = sharedString;
    }
}
