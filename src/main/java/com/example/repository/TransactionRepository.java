package com.example.repository;
import com.example.dao.Transaction;
import io.micronaut.data.annotation.Repository;
import io.micronaut.data.repository.CrudRepository;

@Repository
public interface TransactionRepository extends CrudRepository<Transaction, Long> {

}

