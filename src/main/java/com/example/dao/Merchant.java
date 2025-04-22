package com.example.dao;

import io.micronaut.configuration.hibernate.jpa.proxy.GenerateProxy;
import io.micronaut.core.annotation.Introspected;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;

@Getter @Setter
@Entity
@Table(name = "merchant")
@Introspected
@GenerateProxy
@Serdeable
public class Merchant {
    @Id
    int id;

    @Column
    String name;

    @ManyToMany(mappedBy = "likedCourses")
    Set<Customer> purchases;

}
