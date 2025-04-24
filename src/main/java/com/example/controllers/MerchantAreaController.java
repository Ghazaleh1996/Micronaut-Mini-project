package com.example.controllers;

import com.example.dao.Customer;
import com.example.dao.Transaction;
import com.example.services.CustomersService;
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
public class MerchantAreaController {

    @Inject
    CustomersService customersService;

    @Inject
    TransactionService transactionService;

    @Get("/merchant-area/customers")
    public List<Customer> list() {
        return customersService.list();
    }

    @Get("/merchant-area/customers/{id}")
    public Customer find(@PathVariable int id) {
        return customersService.find(id);
    }

    @Post("/merchant-area/customers/{id}")
    public Customer find(@PathVariable int id, @Body CustomerInput input) {
        return customersService.update(id, input.getName(), input.getSurname());
    }
    @Post("/merchant-area/customers/{id}/points")
    public Customer update(@PathVariable int id, @Body CreateTransactionInput input) {
        return transactionService.createTx(id, input.getPoints());
    }

    //Retrieve transaction list for a specific customer
    @Get("/merchant-area/customers/{id}/transactions")
    public List<Transaction> transactionList(@PathVariable Long id) {
        return transactionService.transactionList(id);
    }

    //Retrieve summary data: number of customers, total circulating points
   @Get("/merchant-area/summary:/")
   public Map<String, Integer> getSummaryMap() {
       return customersService.getSummaryData();
   }

    @Getter @Setter @Serdeable
    static class CustomerInput {
        String name;
        String surname;
    }

    // @Get("/merchant-area/transactions")
    //    public List<Transaction> generallist() {
    //        return transactionService.list();
    //    }
    @Getter @Setter @Serdeable
    static class CreateTransactionInput {
        int points;
    }
}
