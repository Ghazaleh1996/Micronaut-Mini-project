package com.example.controllers;

import io.micronaut.security.annotation.Secured;
import io.micronaut.security.rules.SecurityRule;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.HttpResponse;
import io.micronaut.security.authentication.Authentication;

import java.util.Map;

@Controller("/api")
public class SecureController {

    @Secured(SecurityRule.IS_AUTHENTICATED)
    @Get("/user-info")
    public HttpResponse<?> getUserInfo(Authentication authentication) {
        return HttpResponse.ok(Map.of(
                "username", authentication.getName(),
                "roles", authentication.getRoles()
        ));
    }
}
