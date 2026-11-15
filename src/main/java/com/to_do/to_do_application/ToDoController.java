package com.to_do.to_do_application;
import java.util.Map;
import java.util.List;

import jakarta.servlet.http.HttpSession;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ToDoController {

    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    String sql;
    public ToDoController(JdbcTemplate jdbcTemplate, PasswordEncoder passwordEncoder){
        this.jdbcTemplate=jdbcTemplate;
        this.passwordEncoder=passwordEncoder;
    }
    @RequestMapping({"/", "home"})
    public String home(){
        System.out.println("Inside the home function");
        return "home";
    }

    @RequestMapping("signup")
    public String signup(@RequestParam String name,@RequestParam String email, @RequestParam String password, RedirectAttributes redirectAttributes){
        email=email.trim();

        if (email.isEmpty() || password.length()<8){
            redirectAttributes.addFlashAttribute("errorMessage", "Please enter a valid email address and password of atleast 8 characters.");
            return "redirect:/home";
        }
        try{
             String encodedPassword=passwordEncoder.encode(password);
             sql="INSERT INTO app_users (name, email, password_hash) VALUES (?,?,?)";
             jdbcTemplate.update(sql, name, email, encodedPassword);
             redirectAttributes.addFlashAttribute("successMessage", "Signup successful! You account has been created");
        }catch(DuplicateKeyException e){
            redirectAttributes.addFlashAttribute("errorMessage", "Email address already used.");
        }
        return "redirect:/home";
    }
    @PostMapping("login")
    public String login(@RequestParam String email, @RequestParam String password, HttpSession httpSession, RedirectAttributes redirectAttributes){
        email=email.trim();
        if(email.isEmpty() || password.length()<8){
            redirectAttributes.addFlashAttribute("errorMessage", "Email is empty or password less than 8 characters");
            return "redirect:/home";
        }
        sql="SELECT * FROM APP_USERS WHERE EMAIL=?";
        List<Map<String, Object>> users=jdbcTemplate.queryForList(sql,email);
        if(users.isEmpty()){
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid email address or password");
            return "redirect:/home";
        }
        Map<String, Object> user=users.get(0);
        String storedPassword=(String)user.get("password_hash");
        if(passwordEncoder.matches(password, storedPassword)){
            httpSession.setAttribute("userId", user.get("user_id"));
            httpSession.setAttribute("userEmail", email);
            httpSession.setAttribute("name", user.get("name"));
            redirectAttributes.addFlashAttribute("successMessage", "Login successful! Login successful");
        }else{
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid email address or password");
        }
        return "redirect:/home";
    }
}
