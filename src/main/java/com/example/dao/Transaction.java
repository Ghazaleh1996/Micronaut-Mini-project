package com.example.dao;
import io.micronaut.configuration.hibernate.jpa.proxy.GenerateProxy;
import io.micronaut.core.annotation.Introspected;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

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
    int points;

    @CreationTimestamp
    @Column
    LocalTime timestamp;

    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

}
