package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import java.util.HashMap;
import java.util.Map;

public class HelloWorld {
    public String handleRequest(Map<String, String> event, Context context) {
        System.out.println("Received event: " + event);
        return "Hello from Java Lambda!";
    }

    public static void main(String[] args) {
        HelloWorld handler = new HelloWorld();
        Map<String, String> event = new HashMap<>();
        event.put("key1", "value1");
        System.out.println(handler.handleRequest(event, null));
    }
}
