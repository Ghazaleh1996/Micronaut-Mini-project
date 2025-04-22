package com.example.dao;

import io.micronaut.configuration.hibernate.jpa.proxy.GenerateProxy;
import io.micronaut.core.annotation.Introspected;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Getter @Setter
@Entity
@Table(name = "customer")
@Introspected
@GenerateProxy
@Serdeable
public class Customer {
    @Id
    int id;

    @Column
    String name;

    @Column
    String surname;
    @Column
    int points;

    @ManyToMany
    Set<Merchant> purchasedmerchants;

    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL)
    private List<Transaction> transactions = new ArrayList<>();

}
