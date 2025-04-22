package com.example.dao;
import io.micronaut.configuration.hibernate.jpa.proxy.GenerateProxy;
import io.micronaut.core.annotation.Introspected;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalTime;
import java.util.List;

@Getter @Setter
@Entity
@Table(name = "transaction")
@Introspected
@GenerateProxy
@Serdeable
public class Transaction {
    @Id
    int id;

    @Column
    String name;
    @Column
    int points;
    @Column
    double amount;
    @Column
    LocalTime timestamp;

    @ManyToOne
    @JoinColumn(name = "id", nullable = false)
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "id")
    private Merchant merchant;




}
