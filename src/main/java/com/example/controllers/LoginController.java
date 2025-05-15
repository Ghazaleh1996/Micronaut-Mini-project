package com.example.controllers;

import com.example.dao.Customer;
import com.example.dao.Merchant;
import com.example.services.CustomersService;
import com.example.services.MerchantService;
import io.micronaut.http.HttpRequest;
import io.micronaut.http.annotation.Body;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Post;
import io.micronaut.security.annotation.Secured;
import io.micronaut.security.authentication.Authentication;
import io.micronaut.security.authentication.AuthenticationResponse;
import io.micronaut.security.authentication.UsernamePasswordCredentials;
import io.micronaut.security.handlers.LoginHandler;
import io.micronaut.security.rules.SecurityRule;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;

import java.util.List;

@Controller
public class LoginController {

    @Inject
    LoginHandler loginHandler;
    @Inject
    MerchantService merchantService;

    @Inject
    CustomersService customersService;

    @PermitAll
    @Post("/login2")
    public Object login(@Body UsernamePasswordCredentials creds, HttpRequest<?> request) {
        var resp = authenticate(creds);
        if (resp.isAuthenticated()) {
            return loginHandler.loginSuccess(resp.getAuthentication().get(), request);
        } else {
            return loginHandler.loginFailed(resp, request);
        }
    }

    @PermitAll
    @Get("/whoami")
    public String whoami(Authentication auth) {
        return auth.getName();
    }

    private AuthenticationResponse authenticate(@Body UsernamePasswordCredentials creds) {
        Customer customer = customersService.findByUsername(creds.getUsername());
        if (customer != null && customer.getPassword().equals(creds.getPassword())) {
            return AuthenticationResponse.success(customer.getUsername(), List.of("ROLE_CUSTOMER"));
        }

        Merchant merchant = merchantService.findByUsername(creds.getUsername());
        if (merchant != null && merchant.getPassword().equals(creds.getPassword())) {
            return AuthenticationResponse.success(merchant.getUsername(), List.of("ROLE_MERCHANT"));
        }

        return AuthenticationResponse.failure("Invalid credentials");
    }
}

