package com.example.dao;

import com.fasterxml.jackson.annotation.JsonIgnore;
import io.micronaut.configuration.hibernate.jpa.proxy.GenerateProxy;
import io.micronaut.core.annotation.Introspected;
import io.micronaut.data.annotation.MappedEntity;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Getter @Setter
//@MappedEntity("customer")
@Table(name = "customer")
@Introspected
@GenerateProxy
@Serdeable
@Entity
public class Customer {
    @Id
            @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column
    @NotNull(message="name can not be null")
    String name;

    @Column
    @NotNull
    String surname;

    @Column
    private LocalDate birthday;

    @Column
    Integer points;

    @Column
    String username;

    @Column
    String password;

    @Serdeable.Serializable
    @JsonIgnore
    @ManyToMany
    @JoinTable(
            name = "customer_merchant",
            joinColumns = @JoinColumn(name = "customer_id"),
            inverseJoinColumns = @JoinColumn(name = "merchant_id")
    )
    Set<Merchant> purchasedmerchants;


    @Serdeable.Serializable
    @JsonIgnore
    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL)
    private List<Transaction> transactions = new ArrayList<>();

}
