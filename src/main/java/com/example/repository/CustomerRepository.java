package com.example.repository;
import com.example.dao.Customer;
import io.micronaut.data.annotation.Repository;
import io.micronaut.data.repository.CrudRepository;

@Repository
public interface CustomerRepository extends CrudRepository<Customer, Long> {

}

