package com.to_do.to_do_application;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ToDoController {

    @RequestMapping({"/", "home"})
    public String home(){
        System.out.println("Inside the home function");
        return "home";
    }
}
