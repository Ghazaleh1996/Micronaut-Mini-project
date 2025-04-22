package com.example.controllers;
import com.example.dao.Merchant;
import com.example.services.CustomersService;
import com.example.services.MerchantService;
import io.micronaut.http.annotation.*;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@PermitAll
@Controller
public class CustomerAreaController {
    @Inject
    MerchantService merchantService;
    CustomersService customersService;





    @Getter @Setter @Serdeable
    static class MerchantInput {
        String name;
    }
}
