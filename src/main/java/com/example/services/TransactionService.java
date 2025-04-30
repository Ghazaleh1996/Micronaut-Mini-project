package com.example.services;

import com.example.dao.Customer;
import com.example.dao.Merchant;
import com.example.dao.Transaction;
import jakarta.inject.Singleton;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

@Singleton
@Slf4j
public class TransactionService {
    @PersistenceContext
    EntityManager em;

    @Transactional
    public List<Transaction> list(int customerId) {
        return em
                .createQuery("SELECT t FROM Transaction t", Transaction.class)
                .getResultList();
    }
    //Retrieve transaction list for a specific customer
    @Transactional
    public List<Transaction> transactionList(Long customerId) {
        return em.createQuery(
                        "SELECT t FROM Transaction t WHERE t.customer.id = :customerId", Transaction.class)
                .setParameter("customerId", customerId)
                .getResultList();
    }

    @Transactional
    public Customer createTx(int customerId, int points) {
        var customer=em.find(Customer.class, customerId);
        int newPoints= customer.getPoints()+points;
        customer.setPoints(newPoints);
        em.merge(customer);
        var tx = new Transaction();
        tx.setCustomer(customer);
        tx.setPoints(points);
        em.persist(tx);
        log.debug("updated customer points {}",customerId);
        return customer;
    }

}