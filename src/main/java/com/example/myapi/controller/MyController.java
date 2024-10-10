package com.example.myapi.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
public class MyController {

    @GetMapping("/")
    public String index(@AuthenticationPrincipal Jwt jwt) {
        if (jwt == null) {
            return "Hello, Guest! You are accessing the site without authentication.";
        }
        return String.format("Hello, %s! You are authenticated.", jwt.getClaimAsString("preferred_username"));
    }

    @GetMapping("/protected/premium")
    public String premium(@AuthenticationPrincipal Jwt jwt) {
        if (jwt == null) {
            return "Access denied. You are not authenticated.";
        }

        Map<String, Object> realmAccess = jwt.getClaim("realm_access");
        List<String> roles = (List<String>) realmAccess.get("roles");
        String roleList = roles != null ? String.join(", ", roles) : "No roles assigned";

        return String.format("Hello, %s! You are authenticated. Your roles: %s", 
                             jwt.getClaimAsString("preferred_username"), 
                             roleList);
    }

    @GetMapping("/protected/users")
    public String users(@AuthenticationPrincipal Jwt jwt) {
        if (jwt == null) {
            return "Access denied. You are not authenticated.";
        }

        return String.format("Hello, %s! You have access to the protected users endpoint.", 
                             jwt.getClaimAsString("preferred_username"));
    }
}
