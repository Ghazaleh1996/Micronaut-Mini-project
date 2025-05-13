package com.example.services;
import com.example.dao.Customer;
import com.example.dao.Transaction;
import io.micronaut.cache.annotation.CacheConfig;
import io.micronaut.cache.annotation.CachePut;
import io.micronaut.cache.annotation.Cacheable;
import jakarta.inject.Singleton;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Singleton
@Slf4j

public class MerchantService {
    @PersistenceContext
    EntityManager em;
    //Retrieve point balance and personal data
    @Transactional

    public Customer getCustomerInfo(int customerId) {
        return em
                .createQuery("SELECT c FROM Customer c WHERE c.id = :customerId", Customer.class)
                .setParameter("customerId", customerId)
                .getSingleResult();
    }
    //Retrieve transaction history
    @Transactional

    public List<Transaction> historyList(){
            List<Transaction> transactionHistory =em.createQuery("Select t From Transaction t",Transaction.class)
                    .getResultList();
            return transactionHistory;
    }
    //Edit personal data
    @Transactional

    public Customer editPersonalData(int customerId, String name, String surname) {
        var customer = em.find(Customer.class, customerId);
        customer.setName(name);
        customer.setSurname(surname);
        em.merge(customer);
        log.debug("updated", customerId);
        return customer;
    }

    //Sign up
    @Transactional

    public Customer signUp(String name, String surname) {
        var customer = new Customer();
        customer.setName(name);
        customer.setSurname(surname);
        customer.setPoints(0);
        em.persist(customer);
        return customer;
    }
}
