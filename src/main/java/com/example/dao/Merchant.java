package com.example.dao;

import io.micronaut.configuration.hibernate.jpa.proxy.GenerateProxy;
import io.micronaut.core.annotation.Introspected;
import io.micronaut.data.annotation.MappedEntity;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;

@Getter @Setter
//@MappedEntity("merchant")
@Table(name = "merchant")
@Introspected
@GenerateProxy
@Serdeable
@Entity
public class Merchant {
    @Id
    int id;

    @Column
    @NotNull
    String name;
    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;


    @ManyToMany(mappedBy = "purchasedmerchants")
    Set<Customer> purchases;

}
