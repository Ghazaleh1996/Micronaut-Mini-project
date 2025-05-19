package com.example.controllers;
import com.example.dao.Customer;
import com.example.dao.Merchant;
import com.example.dao.Transaction;
import com.example.services.CustomersService;
import com.example.services.MerchantService;
import com.example.services.TransactionService;
import io.micronaut.http.HttpRequest;
import io.micronaut.http.annotation.*;
import io.micronaut.http.server.cors.CrossOrigin;
import io.micronaut.security.annotation.Secured;
import io.micronaut.security.authentication.AuthenticationResponse;
import io.micronaut.security.authentication.ServerAuthentication;
import io.micronaut.security.rules.SecurityRule;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;


@PermitAll
@Controller("/customer-area")
public class CustomerAreaController {
    @Inject
    MerchantService merchantService;
    @Inject
    CustomersService customersService;
    @Inject
    TransactionService transactionService;

    //Retrieve point balance and personal data
    @Secured(SecurityRule.IS_AUTHENTICATED)
    @Get("/customer-info")
    public Customer getCustomerMap(HttpRequest request) {
        var username = ((ServerAuthentication) request.getUserPrincipal().get()).getName();
        var customer = customersService.findByUsername(username);
        //return merchantService.getCustomerInfo(customer.getId());
        return customer;
    }

    //Retrieve transaction history
    @Secured(SecurityRule.IS_AUTHENTICATED)
    @Get("/history")
    public List<Transaction> historyList(HttpRequest<?> request) {
        var username = ((ServerAuthentication) request.getUserPrincipal().get()).getName();
        var customer = customersService.findByUsername(username);
        return transactionService.transactionList((long) customer.getId());
    }

    //Edit personal data
    @Secured(SecurityRule.IS_AUTHENTICATED)
    @Post("/customer/editPersonal")
    public Customer editPersonalData(HttpRequest<?> request, @Body CustomerInput input) {
        var username = ((ServerAuthentication) request.getUserPrincipal().get()).getName();
        var customer = customersService.findByUsername(username);
        return customersService.update(customer.getId(), input.getName(), input.getUsername());
    }

    //Sign up
    @Post("/Sign-Up")
    @CrossOrigin
    @Secured(SecurityRule.IS_ANONYMOUS)
    public Customer signUp(@Body @Valid CustomerInput input) {
        return merchantService.signUp(
                input.getName(),
                input.getSurname(),
                input.getEmail(),
                input.getPassword(),
                input.getUsername()
        );
    }



    @Getter @Setter @Serdeable
    static class MerchantInput {
        String name;
    }
    @Getter @Setter @Serdeable
    static class CustomerInput {
        @NotBlank @Size(min = 3, max = 50)
        String name;

        @NotBlank
        String surname;

        @NotBlank
        String email;
        @NotBlank
        String username;
        @NotBlank
        String password;

    }
}
