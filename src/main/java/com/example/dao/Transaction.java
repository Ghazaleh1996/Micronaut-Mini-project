package com.example.dao;
import io.micronaut.configuration.hibernate.jpa.proxy.GenerateProxy;
import io.micronaut.core.annotation.Introspected;
import io.micronaut.data.annotation.MappedEntity;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.persistence.*;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalTime;
import java.util.List;

@Getter @Setter
//@MappedEntity("transaction")
@Table(name = "transaction")
@Introspected
@GenerateProxy
@Serdeable
@Entity
public class Transaction {
    @Id
    int id;

    @Column
    @PositiveOrZero
    Integer points;

    @CreationTimestamp
    @Column
    @PastOrPresent
    LocalTime timestamp;

    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

}
