package com.example.controllers;

import com.example.dao.Customer;
import com.example.services.CustomersService;
import io.micronaut.http.HttpRequest;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.annotation.Body;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Post;
import io.micronaut.security.authentication.AuthenticationResponse;
import io.micronaut.security.authentication.UsernamePasswordCredentials;
import io.micronaut.security.handlers.LoginHandler;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;

import java.util.List;

@Controller
public class LoginController {
    @Inject
    LoginHandler loginHandler;

    @PermitAll
    @Post("/login2")
    public Object login(@Body UsernamePasswordCredentials creds, HttpRequest<?> request) {
        var resp = authenticate(creds);
        if(resp.isAuthenticated()) {
            return loginHandler.loginSuccess(resp.getAuthentication().get(), request);
        }
        else {
            return loginHandler.loginFailed(resp, request);
        }
    }

    @PermitAll
    @Get("/whoami")
    public Object whoami(HttpRequest<?> request) {
        if(request.getUserPrincipal().isPresent()) {
            return request.getUserPrincipal().get().getName();
        }
        else {
            return null;
        }

    }

    @Inject
    CustomersService customersService;

    private AuthenticationResponse authenticate(@Body UsernamePasswordCredentials creds) {
        Customer customer = customersService.findByUsername(creds.getUsername());
        if (customer != null && customer.getPassword().equals(creds.getPassword())) {
            return AuthenticationResponse.success(customer.getUsername(),List.of("ROLE_CUSTOMER"));
        }
        return AuthenticationResponse.failure("Error");
    }
}
