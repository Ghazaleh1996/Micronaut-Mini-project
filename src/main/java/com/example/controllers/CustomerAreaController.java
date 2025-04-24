package com.example.controllers;
import com.example.dao.Customer;
import com.example.dao.Merchant;
import com.example.dao.Transaction;
import com.example.services.CustomersService;
import com.example.services.MerchantService;
import com.example.services.TransactionService;
import io.micronaut.http.annotation.*;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;


@PermitAll
@Controller
public class CustomerAreaController {
    @Inject
    MerchantService merchantService;
    @Inject
    CustomersService customersService;
    @Inject
    TransactionService transactionService;

    //Retrieve point balance and personal data
    @Get("/customer-area/customer-info")
    public Map<String, Integer> getCustomerMap() {
        return merchantService.getCustomerInfo();
    }

    //Retrieve transaction history
    @Get("/customer-area/history")
    public List<Transaction> historyList() {
        return transactionService.list();
    }



    //Edit personal data
    @Post("/customer-area/edit-personal-data")
    public Customer editPersonalData(@PathVariable int id, @Body CustomerInput input) {
        return customersService.update(id, input.getName(), input.getSurname());
    }

    //Sign up
    @Post("/customer-area/Sign-Up")
    public Customer signUp(@PathVariable int id, @Body CustomerInput input) {
        return customersService.update(id, input.getName(), input.getSurname());
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
