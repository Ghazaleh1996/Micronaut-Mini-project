package com.example.controllers;

import com.example.dao.Customer;
import com.example.dao.Merchant;
import com.example.dao.Transaction;
import com.example.services.CustomersService;
import com.example.services.MerchantService;
import com.example.services.TransactionService;
import io.micronaut.http.annotation.*;
import io.micronaut.http.server.cors.CrossOrigin;
import io.micronaut.security.annotation.Secured;
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
@Controller("/merchant-area")
public class MerchantAreaController {

    @Inject
    CustomersService customersService;
    @Inject
    MerchantService merchantService;

    @Inject
    TransactionService transactionService;

    @Get("/customers")
    public List<Customer> list() {
        return customersService.list();
    }
    @Secured("Merchant")
    @Get("/customers/{id}")
    public Customer find(@PathVariable int id) {
        return customersService.find(id);
    }

    @Secured("Merchant")
    @Post("/customers/{id}")
    public Customer find(@PathVariable int id, @Body CustomerInput input) {
        return customersService.update(id, input.getName(), input.getSurname());
    }
    //@Secured("Merchant")
    //Add/remove points from a customer
    @Post("/customers/{id}/points")
    public Customer update(@PathVariable int id, @Body CreateTransactionInput input) {
        return transactionService.createTx(id, input.getPoints());
    }

    //@Secured("Merchant")
    //Retrieve transaction list for a specific customer
    @Get("/customers/{id}/transactions")
    public List<Transaction> transactionList(@PathVariable Long id) {
        return transactionService.transactionList(id);
    }


    //Retrieve summary data: number of customers, total circulating points
    //@Secured("Merchant")
   @Get("/summary")
   public CustomersService.SummaryDTO getSummaryData() {
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

    @Post("/Sign-Up")
    @CrossOrigin
    @PermitAll
    public Merchant signUp(@Body @Valid MerchantInput input) {
        return customersService.signUp(
                input.getName(),
                input.getUsername(),
                input.getPassword(),
                input.getEmail()
        );
    }

    @Getter @Setter @Serdeable
    static class MerchantInput {

        @NotBlank
        @Size(min = 3, max = 50)
        String name;

        @NotBlank
        String email;
        @NotBlank
        String username;
        @NotBlank
        String password;

    }

}
