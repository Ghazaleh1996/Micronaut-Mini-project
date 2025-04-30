package com.example.controllers;
import com.example.dao.Customer;
import com.example.dao.Merchant;
import com.example.dao.Transaction;
import com.example.services.CustomersService;
import com.example.services.MerchantService;
import com.example.services.TransactionService;
import io.micronaut.http.HttpRequest;
import io.micronaut.http.annotation.*;
import io.micronaut.security.annotation.Secured;
import io.micronaut.security.authentication.AuthenticationResponse;
import io.micronaut.security.authentication.ServerAuthentication;
import io.micronaut.security.rules.SecurityRule;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
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
    //@Secured(SecurityRule.IS_AUTHENTICATED)
    @Get("/customer-info")
    public Customer getCustomerMap(HttpRequest request) {
        var username = ((ServerAuthentication) request.getUserPrincipal().get()).getName();
        var customer = customersService.findByUsername(username);
        //return merchantService.getCustomerInfo(customer.getId());
        return customer;
    }

    //Retrieve transaction history
    //@Secured(SecurityRule.IS_AUTHENTICATED)
    @Get("/history")
    public List<Transaction> historyList(HttpRequest<?> request) {
        var username = ((ServerAuthentication) request.getUserPrincipal().get()).getName();
        var customer = customersService.findByUsername(username);
        return transactionService.list(customer.getId());
    }

    //Edit personal data
   // @Secured(SecurityRule.IS_AUTHENTICATED)
    @Post("/customer/editPersonal")
    public Customer editPersonalData(HttpRequest<?> request, @Body CustomerInput input) {
        var username = ((ServerAuthentication) request.getUserPrincipal().get()).getName();
        var customer = customersService.findByUsername(username);
        return customersService.update(customer.getId(), input.getName(), input.getSurname());
    }

    //Sign up
    @Post("/Sign-Up")
    public Customer signUp(@Body CustomerInput input) {
        return merchantService.signUp(input.getName(), input.getSurname());
    }


    @Getter @Setter @Serdeable
    static class MerchantInput {
        String name;
    }
    @Getter @Setter @Serdeable
    static class CustomerInput {
        String name;
        String surname;
    }
}
